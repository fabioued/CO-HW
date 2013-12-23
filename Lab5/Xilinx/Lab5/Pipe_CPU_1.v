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
wire    [31:0]  mux_if_o;
wire    [31:0]  pc_o;
wire    [31:0]  adder_if_o;
wire    [31:0]  im_o;

/**** ID stage ****/
wire    [63:0]  if_id;
wire    [31:0]  rfs_o;
wire    [31:0]  rft_o;
wire    [31:0]  se_o;
wire    [10:0]  mux_id_o;
//control signal
wire            extend_o;
wire            regwrite_o; //WB
wire    [1:0]   mem2reg_o;
wire            branch_o;   //M
wire            memread_o;
wire            memwrite_o;
wire            regdst_o;   //EX
wire    [2:0]   aluop_o;
wire            alusrc_o;
wire    [1:0]   branchtype_o;   //useless
wire            jump_o;         //useless
wire            pcwrite_o;
wire            ifidstall_o;
wire            ifflush_o;
wire            idflush_o;
wire            exflush_o;
/**** EX stage ****/
wire    [153:0] id_ex;
wire    [31:0]  adder_ex;
wire    [31:0]  shift_o;
wire            alu_zero;
wire    [31:0]  alu_result;
wire    [31:0]  mux_ex_1;
wire    [4:0]   mux_ex_2;
wire            alu_cout_o;     //useless
wire            alu_overflow_o; //useless
wire    [2:0]   mux_exflush_1_o;
wire    [2:0]   mux_exflush_2_o;
wire    [31:0]  mux_exalu_a_o;
wire    [31:0]  mux_exalu_b_o;
//control signal
wire    [3:0]   alu_ctrl_o;
wire    [1:0]   forwarda;
wire    [1:0]   forwardb;
/**** MEM stage ****/
wire    [107:0] ex_mem;
wire    [31:0]  dm_o;
//control signal
wire            pcsrc_o;

/**** WB stage ****/
wire    [71:0]  mem_wb;
wire    [31:0]  mux_wb_o;
//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux_IF(
    .data0_i(adder_if_o),
    .data1_i(ex_mem[101:70]),
    .select_i(pcsrc_o),
    .data_o(mux_if_o)
        );

ProgramCounter PC(          //PC
    .clk_i(clk_i),
    .rst_n(rst_n),
    .PCWrite(pcwrite_o),
    .pc_in_i(mux_if_o),
    .pc_out_o(pc_o)
        );

Instr_Memory IM(
    .pc_addr_i(pc_o),
    .instr_o(im_o)
	    );
			
Adder Add_pc(
	.src1_i(pc_o),
	.src2_i(32'd4),
	.sum_o(adder_if_o)
		);

		
Pipe_Reg_IFID #(.size(64)) IF_ID(        //N is the total length of input/output
    .rst_i(rst_n),
	.clk_i(clk_i),
    .IFIDStall(ifidstall_o),
    .IFFlush(ifflush_o),
	.data_i({adder_if_o, im_o}),
	.data_o(if_id)
		);
		
//Instantiate the components in ID stage
Hazard Hazard_ID(
    .PCSrc(pcsrc_o),
    .PCWrite(pcwrite_o),
    .IFIDStall(ifidstall_o),
    .IFIDRsRt(if_id[25:16]),
    .IDEXRt(id_ex[9:5]),
    .IFFlush(ifflush_o),
    .EXFlush(exflush_o),
    .IDEXmemread(id_ex[144]),
    .IDFlush(idflush_o)
        );

Reg_File RF(
    .clk_i(clk_i),
	.rst_n(rst_n),
    .RSaddr_i(if_id[25:21]),
    .RTaddr_i(if_id[20:16]),
    .RDaddr_i(mem_wb[4:0]),
    .RDdata_i(mux_wb_o),
    .RegWrite_i(mem_wb[71]),
    .RSdata_o(rfs_o),
    .RTdata_o(rft_o)
		);

Decoder Control(
	.instr_op_i(if_id[31:26]),
	.RegWrite_o(regwrite_o),
	.ALU_op_o(aluop_o),
	.ALUSrc_o(alusrc_o),
	.RegDst_o(regdst_o),
	.Branch_o(branch_o),
	.extend_o(extend_o),
    
	.Mem2Reg_o(mem2reg_o),
	.BranchType_o(branchtype_o),
	.Jump_o(jump_o),
	.MemRead_o(memread_o),
	.MemWrite_o(memwrite_o)
		);

MUX_2to1 #(.size(11)) Mux_ID(
    .data0_i({regwrite_o, mem2reg_o, branch_o, memread_o, memwrite_o, regdst_o, aluop_o, alusrc_o}),
    .data1_i(11'd0),
    .select_i(idflush_o),
    .data_o(mux_id_o)
        );

Sign_Extend Sign_Extend(
	.extend_i(extend_o),
	.data_i(if_id[15:0]),
	.data_o(se_o)
		);	

Pipe_Reg #(.size(154)) ID_EX(           //add IF_ID.RegisterRs  153:149 (lab5)
    .rst_i(rst_n),
	.clk_i(clk_i),   
	.data_i({if_id[25:21], mux_id_o, if_id[63:32], rfs_o, rft_o, se_o, if_id[20:11]}),
	.data_o(id_ex)
		);
		
//Instantiate the components in EX stage
Adder Add_EX(
	.src1_i(id_ex[137:106]),
	.src2_i(shift_o),
	.sum_o(adder_ex)
		);

Shift_Left_Two_32 SHIFTER(
    .data_i(id_ex[41:10]),
    .data_o(shift_o)
        );
        
MUX_2to1 #(.size(3)) Mux_EXFLUSH_1(
    .data0_i(id_ex[148:146]),
    .data1_i(3'd0),
    .select_i(exflush_o),
    .data_o(mux_exflush_1_o)
        );

MUX_2to1 #(.size(3)) Mux_EXFLUSH_2(
    .data0_i(id_ex[145:143]),
    .data1_i(3'd0),
    .select_i(exflush_o),
    .data_o(mux_exflush_2_o)
        );

MUX_4to1 #(.size(32)) Mux_EXALU_A(
    .data0_i(id_ex[105:74]),
    .data1_i(ex_mem[68:37]),
    .data2_i(mux_wb_o),
    .data3_i(32'dx),
    .select_i(forwarda),
    .data_o(mux_exalu_a_o)
        );

MUX_4to1 #(.size(32)) Mux_EXALU_B(
    .data0_i(id_ex[73:42]),
    .data1_i(ex_mem[68:37]),
    .data2_i(mux_wb_o),
    .data3_i(32'dx),
    .select_i(forwardb),
    .data_o(mux_exalu_b_o)
        );
        
alu ALU(
    .rst_n(rst_n),              // negative reset            (input)
    .src1(mux_exalu_a_o),       // 32 bits source 1          (input)
    .src2(mux_ex_1),            // 32 bits source 2          (input)
    .ALU_control(alu_ctrl_o),   // 4 bits ALU control input  (input)
    .bonus_control(3'b000),     // 3 bits bonus control input(input) 
    .result(alu_result),        // 32 bits result            (output)
    .zero(alu_zero),            // 1 bit when the output is 0, zero must be set (output)
    .cout(alu_cout_o),          // 1 bit carry out           (output)
    .overflow(alu_overflow_o)
        );
		
ALU_Ctrl ALU_Control(
    .funct_i(id_ex[15:10]),
    .ALUOp_i(id_ex[141:139]),
    .ALUCtrl_o(alu_ctrl_o)
		);

MUX_2to1 #(.size(32)) Mux_EX_1(
    .data0_i(mux_exalu_b_o),
    .data1_i(id_ex[41:10]),
    .select_i(id_ex[138]),
    .data_o(mux_ex_1)
        );
		
MUX_2to1 #(.size(5)) Mux_EX_2(
    .data0_i(id_ex[9:5]),
    .data1_i(id_ex[4:0]),
    .select_i(id_ex[142]),
    .data_o(mux_ex_2)
        );

Forwarding Forwarding_EX (
    .ForwardA(forwarda),
    .ForwardB(forwardb),    
    .IDEXRs(id_ex[153:149]),
    .IDEXRt(id_ex[9:5]),
    .EXMEMRd(ex_mem[4:0]),
    .EXMEMRegWrite(ex_mem[107]),
    .MEMWBRd(mem_wb[4:0]),
    .MEMWBRegWrite(mem_wb[71])
        );

Pipe_Reg #(.size(108)) EX_MEM(
    .rst_i(rst_n),
	.clk_i(clk_i),
	.data_i({mux_exflush_1_o, mux_exflush_2_o, adder_ex, alu_zero, alu_result, mux_exalu_b_o, mux_ex_2}),
	.data_o(ex_mem)
		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(ex_mem[68:37]),
	.data_i(ex_mem[36:5]),
	.MemRead_i(ex_mem[103]),
	.MemWrite_i(ex_mem[102]),
	.data_o(dm_o)
	    );
        
and branch(pcsrc_o , ex_mem[104], ex_mem[69]);

Pipe_Reg #(.size(72)) MEM_WB(
    .rst_i(rst_n),
	.clk_i(clk_i),   
	.data_i({ex_mem[107:105], dm_o, ex_mem[68:37], ex_mem[4:0]}),
	.data_o(mem_wb)
        );

//Instantiate the components in WB stage
MUX_4to1 #(.size(32)) Mux_WB(
    .data0_i(mem_wb[36:5]),                 //different between Lab3 and Lab4.
    .data1_i(mem_wb[68:37]),                //So I change the order.
    .data2_i(32'dx),
    .data3_i(32'dx),
    .select_i(mem_wb[70:69]),
    .data_o(mux_wb_o)
        );

/****************************************
signal assignment
****************************************/	
endmodule

