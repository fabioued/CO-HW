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
wire	[4:0]		mux5_o;
wire	[31:0]	mux32_o;
wire	[31:0]	mux32_2_o;
wire	[31:0]	aluresult_o;
wire	[31:0]	alu_result_o;
wire				alu_zero_o;
wire				alu_cout_o;
wire				alu_overflow_o;
wire	[31:0]	shift_o;
wire	[31:0]	rfs_o, rft_o;
wire				andz_o;
wire				extend_o;
//Greate componentes
ProgramCounter PC(
			.clk_i(clk_i),      
			.rst_n (rst_n),     
			.pc_in_i(mux32_2_o),   
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
			.data_o(mux5_o)
			);	
		
Reg_File RF(
			.clk_i(clk_i),      
			.rst_n(rst_n) ,     
			.RSaddr_i(im_o[25:21]) ,  
			.RTaddr_i(im_o[20:16]) ,  
			.RDaddr_i(mux5_o) ,  
			.RDdata_i(alu_result_o), 
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
			.extend_o(extend_o)
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
			.data_o(mux32_o)
			);	
		
alu ALU(
			.rst_n(rst_n),
			.src1(rfs_o),
			.src2(mux32_o),
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
			.select_i(andz_o),
			.data_o(mux32_2_o)
			);	

and And_zero_branch(andz_o, branch_o, alu_zero_o);
/*
Andzero And_zero_branch(
		.branch_i(branch_o),
		.aluzero_i(alu_zero_o),
		.select_o(andz_o)
    );
*/

endmodule
		  


