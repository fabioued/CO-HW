//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
		rst_n
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_n;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire  [31:0]  mux_if_o;
wire  [31:0]  pc_o;
wire  [31:0]  adder_if_o;
wire  [31:0]  im_o;
  
/**** ID stage ****/
wire  [63:0]  if_id;
wire  [31:0]  rfs_o;
wire  [31:0]  rft_o;
wire  [31:0]  se_o;
//control signal
wire          regwrite_o;   //WB
wire  [1:0]   mem2reg_o;
wire          branch_o;     //M
wire          memread_o;
wire          memwrite_o;
wire  [2:0]   aluop_o;      //EX
wire          alusrc_o;
wire          regdst_o;
wire          extend_o;

/**** EX stage ****/
wire  [148:0] id_ex;
wire  [31:0]  shift_o;
wire  [31:0]  adder_ex;
wire  [31:0]  mux_ex_alu;
wire  [4:0]   mux_ex_2;
wire  [31:0]  alu_result_o;
wire			       alu_zero_o;
wire				      alu_cout_o;
wire				      alu_overflow_o;
wire  [1:0]   branchtype_o;   //useless
wire          jump_o;         //useless
//control signal
wire  [3:0]   alu_ctrl_o;

/**** MEM stage ****/
wire  [107:0] ex_mem;
wire  [31:0]  dm_o;
//control signal
wire          pcsrc_o;

/**** WB stage ****/
wire  [71:0]  mem_wb;
wire  [31:0]  mux_wb;
//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
ProgramCounter PC(
			.clk_i(clk_i),      
			.rst_n (rst_n),     
			.pc_in_i(mux_if_o),   
			.pc_out_o(pc_o)  
      );

Instr_Memory IM(
			.pc_addr_i(pc_o),  
			.instr_o(im_o)  
	    );
			
Adder Add_pc(
			.src1_i(32'd4),     
			.src2_i(pc_o),     
			.sum_o(adder_if_o) 
		);

MUX_2to1 #(.size(32)) Mux_IF(
			.data0_i(adder_if_o),
			.data1_i(ex_mem[101:70]),
			.select_i(pcsrc_o),          //testing pcsrc_o
			.data_o(mux_if_o)
    );
		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output  //"first 32 and second 32"
      .rst_i(rst_n),
			.clk_i(clk_i),
			.branchrst_i(pcsrc_o),
			.data_i({adder_if_o, im_o}),
			.data_o(if_id)
		);
		
//Instantiate the components in ID stage
Reg_File RF(
			.clk_i(clk_i),      
			.rst_n(rst_n),     
			.RSaddr_i(if_id[25:21]),  
			.RTaddr_i(if_id[20:16]),  
			.RDaddr_i(mem_wb[4:0]),  
			.RDdata_i(mux_wb), 
			.RegWrite_i(mem_wb[71]),
			.RSdata_o(rfs_o),  
			.RTdata_o(rft_o) 
		);

Decoder Control(          
			.instr_op_i(if_id[31:26]), 
			.RegWrite_o(regwrite_o),
			.Mem2Reg_o(mem2reg_o),
			
			.Branch_o(branch_o),
			.MemRead_o(memread_o),
			.MemWrite_o(memwrite_o),
			
			.RegDst_o(regdst_o),
			.ALU_op_o(aluop_o),   
			.ALUSrc_o(alusrc_o),
			
			.extend_o(extend_o),
			.BranchType_o(branchtype_o),
			.Jump_o(jump_o)
		);

Sign_Extend Sign_Extend(
			.extend_i(extend_o),
			.data_i(if_id[15:0]),
			.data_o(se_o)
		);	

Pipe_Reg #(.size(149)) ID_EX(
      .rst_i(rst_n),
			.clk_i(clk_i),   
			.data_i({regwrite_o, mem2reg_o, branch_o, memread_o, memwrite_o,regdst_o, aluop_o, alusrc_o, 
			         if_id[63:32], rfs_o, rft_o, se_o, if_id[20:11]}),
			.branchrst_i(pcsrc_o),
			/*1 2 1 1 1 1 3 1 32 32 32 32 10
			148 147~146|145 144 143| 142 141~139 138|137~106 105~74 73~42 41~10| 9~0 	*/           
			.data_o(id_ex)
		);
		
//Instantiate the components in EX stage	   
alu ALU(
			.rst_n(rst_n),
			.src1(id_ex[105:74]),    //rfs_o
			.src2(mux_ex_alu),
			.ALU_control(alu_ctrl_o),
			.bonus_control(3'b000),  
			.result(alu_result_o),
			.zero(alu_zero_o),
			.cout(alu_cout_o),
			.overflow(alu_overflow_o)
		);
		
ALU_Ctrl ALU_Control(
			.funct_i(id_ex[15:10]),  //se_o 
			.ALUOp_i(id_ex[141:139]),//aluop_o
			.ALUCtrl_o(alu_ctrl_o) 
		);

MUX_2to1 #(.size(32)) Mux_EX1(
			.data0_i(id_ex[73:42]),  //rft_o
			.data1_i(id_ex[41:10]),  //se_o
			.select_i(id_ex[138]),   //alusrc_o
			.data_o(mux_ex_alu)
    );
		
MUX_2to1 #(.size(5)) Mux_EX2(
			.data0_i(id_ex[9:5]),    //if_id[20:11]
			.data1_i(id_ex[4:0]),    //if_id[20:11]
			.select_i(id_ex[142]),   //regdst_o
			.data_o(mux_ex_2)
    );

Adder Adder_EX(
			.src1_i(id_ex[137:106]), //if_id[63:32]  
			.src2_i(shift_o),     
			.sum_o(adder_ex)      
		);
			
Shift_Left_Two_32 Shifter(
			.data_i(id_ex[41:10]),   //se_o
			.data_o(shift_o)
		); 	

Pipe_Reg #(.size(108)) EX_MEM(
      .rst_i(rst_n),
			.clk_i(clk_i),
			.branchrst_i(pcsrc_o),
			.data_i({id_ex[148:143], adder_ex, alu_zero_o, alu_result_o, id_ex[73:42], mux_ex_2}),
			/*1 2 1 1 1 | 32 1 32 32 5*/
			/*107 106~105 104 103 102|101~70 69 68~37 36~5 4~0*/
			.data_o(ex_mem)
		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
			.clk_i(clk_i),
			.addr_i(ex_mem[68:37]),  //alu_result_o
			.data_i(ex_mem[36:5]),   //rft_o
			.MemRead_i(ex_mem[103]),
			.MemWrite_i(ex_mem[102]),
			.data_o(dm_o)
	    );

and branch (pcsrc_o, ex_mem[104], ex_mem[69]);// branch_o alu_zero_o

Pipe_Reg #(.size(72)) MEM_WB(
      .rst_i(rst_n),
			.clk_i(clk_i),
			.branchrst_i(pcsrc_o),
			.data_i({ex_mem[107:105], dm_o, ex_mem[68:37], ex_mem[4:0]}),
			/*1 2 |32 32 5*/
			/*71 70~69| 68~37 36~5 4~0*/
			.data_o(mem_wb)        
		);

//Instantiate the components in WB stage      //change 3to1 to 4to1
MUX_4to1 #(.size(32)) Mux_wb(
			.data0_i(mem_wb[68:37]),                //exchange 1 and 0
			.data1_i(dm_o),                         //due to lab3's control
			.data2_i(32'd0),
			.data3_i(32'd0),
			.select_i(mem_wb[70:69]),
			.data_o(mux_wb)
        );

/****************************************
signal assignment
****************************************/	
endmodule

