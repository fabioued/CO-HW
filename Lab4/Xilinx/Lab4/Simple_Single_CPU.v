//Student ID : 0016311
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
			clk_i,
			rst_n
			);
		
//I/O port
input         clk_i;
input         rst_n;

//Internal Signles


////////////////////wire
wire	[31:0]	pc_o;
wire	[31:0]	add1_o;
wire	[31:0]	add2_o;
wire	[31:0]	im_o;
wire				regwrite_o;
wire	[2:0]		aluop_o;
wire				alusrc_o;
wire				regdst_o;
wire				branch_o;
wire	[3:0]		aluctrl_o;
wire	[31:0]	se_o;
wire	[4:0]		mux5_WR_o;
wire	[31:0]	mux32_alusrc_o;
wire	[31:0]	mux32_2_pc_o; 			//to PC
wire	[31:0]	alu_result_o;
wire				alu_zero_o;
wire				alu_cout_o;
wire				alu_overflow_o;
wire	[31:0]	shift_o;
wire	[31:0]	rfs_o, rft_o;
wire				andz_o;
wire				extend_o;

wire  [31:0]   Jshift_o;
wire  [31:0]   Mux2Mux;
wire  			jump_o;
wire 	[1:0]		mem2reg_o;
wire 	[1:0]		branchtype_o;
wire 				memread_o;
wire 				memwrite_o;
wire  [31:0]	DM_o;
wire	[31:0]	mux32_4_o;
wire				mux32_branchtype_o;
wire				and_muxbranchtype_branch;
//Greate componentes
ProgramCounter PC(
			.clk_i(clk_i),      
			.rst_n (rst_n),     
			.pc_in_i(mux32_2_pc_o),   
			.pc_out_o(pc_o) 
			);
	
Adder Adder1(
			.src1_i(32'd4),     
			.src2_i(pc_o),     
			.sum_o(add1_o)    
			);
	
Instr_Memory IM(
			.pc_addr_i(pc_o),  
			.instr_o(im_o)    
			);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
			.data0_i(im_o[20:16]),
			.data1_i(im_o[15:11]),
			.select_i(regdst_o),
			.data_o(mux5_WR_o)
			);	
		
Reg_File RF(
			.clk_i(clk_i),      
			.rst_n(rst_n) ,     
			.RSaddr_i(im_o[25:21]) ,  
			.RTaddr_i(im_o[20:16]) ,  
			.RDaddr_i(mux5_WR_o),  
			.RDdata_i(mux32_4_o), 
			.RegWrite_i (regwrite_o),
			.RSdata_o(rfs_o),  
			.RTdata_o(rft_o)   
			);
	
Decoder Decoder(
			.instr_op_i(im_o[31:26]), 
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

ALU_Ctrl AC(
			.funct_i(im_o[5:0]),   
			.ALUOp_i(aluop_o),   
			.ALUCtrl_o(aluctrl_o) 
			);
	
Sign_Extend SE(
			.extend_i(extend_o),
			.data_i(im_o[15:0]),
			.data_o(se_o)
			);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
			.data0_i(rft_o),
			.data1_i(se_o),
			.select_i(alusrc_o),
			.data_o(mux32_alusrc_o)
			);	
		
alu ALU(
			.rst_n(rst_n),
			.src1(rfs_o),
			.src2(mux32_alusrc_o),
			.ALU_control(aluctrl_o),
			.bonus_control(3'b000),
			.result(alu_result_o),
			.zero(alu_zero_o),
			.cout(alu_cout_o),
			.overflow(alu_overflow_o)
			);		
Adder Adder2(
			.src1_i(add1_o),     
			.src2_i(shift_o),     
			.sum_o(add2_o)      
			);
		
Shift_Left_Two_32 Shifter(
			.data_i(se_o),
			.data_o(shift_o)
			); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
			.data0_i(add1_o),
			.data1_i(add2_o),
			.select_i(and_muxbranchtype_branch),
			.data_o(Mux2Mux)
			);	

/////////Lab3
Shift_Left_Two_32 JumpShifter(
			.data_i({6'b000000,im_o[25:0]}),
			.data_o(Jshift_o)
			); 	

MUX_2to1 #(.size(32)) MUX_Jump(
			.data0_i(Mux2Mux),
			.data1_i({add1_o[31:28],Jshift_o[27:0]}),
			.select_i(jump_o),
			.data_o(mux32_2_pc_o)
			);	

Data_Memory DM (
			.clk_i(clk_i),
			.addr_i(alu_result_o),
			.data_i(rft_o),
			.MemRead_i(memread_o),
			.MemWrite_i(memwrite_o),
			.data_o(DM_o)
);

MUX_4to1 #(.size(32)) MUX_Mem2Reg(
			.data0_i(alu_result_o),
			.data1_i(DM_o),
			.data2_i(se_o),
			.data3_i(32'd0),
			.select_i(mem2reg_o),
			.data_o(mux32_4_o)
			);	
			
MUX_4to1 #(.size(1)) MUX_branchtype(
			.data0_i(alu_zero_o),
			.data1_i(~(alu_zero_o|alu_result_o[31])),
			.data2_i(~alu_result_o[31]),
			.data3_i(~alu_zero_o),
			.select_i(branchtype_o),
			.data_o(mux32_branchtype_o)
			);				
and MuxBrnchTBrnch(and_muxbranchtype_branch, mux32_branchtype_o, branch_o);


endmodule
		  


