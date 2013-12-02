//Student ID: 0016311
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
	instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	extend_o,
	
	Mem2Reg_o,
	BranchType_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	RegWriteData_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [1:0]   RegDst_o;
output         Branch_o;
output			extend_o;

output [1:0]	Mem2Reg_o;
output [1:0]	BranchType_o;
output			Jump_o;
output			MemRead_o;
output			MemWrite_o;
output			RegWriteData_o;
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [1:0]   RegDst_o;
reg            Branch_o;
reg				extend_o;

reg	 [1:0]	Mem2Reg_o;
reg 	 [1:0]	BranchType_o;
reg				Jump_o;
reg				MemRead_o;
reg				MemWrite_o;
reg				RegWriteData_o;
//Parameter


//Main function
always @(*)
begin
	case (instr_op_i)
	6'b000000:			//R-type
	begin
		ALU_op_o <= 3'b010;
		ALUSrc_o <= 0;
		RegWrite_o <= 1;
		RegDst_o <= 2'b01;
		Branch_o <= 0;
		extend_o <= 1;
		
		Mem2Reg_o 		<= 2'b00;
		BranchType_o	<= 2'b00;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;
	end
	6'b001000:			//add immediate
	begin
		ALU_op_o <= 3'b100;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 2'b00;
		Branch_o <= 0;
		extend_o <= 1;
		
		Mem2Reg_o 		<= 2'b00;
		BranchType_o	<= 2'b00;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;
	end
	6'b000100:			//Branch on Equal  beq
	begin
		ALU_op_o <= 3'b101;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 2'b00;
		Branch_o <= 1;
		extend_o <= 1;
		
		Mem2Reg_o 		<= 2'b00;
		BranchType_o	<= 2'b00;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;		
	end
	6'b001101:			//OR immedicate
	begin
		ALU_op_o <= 3'b110;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 2'b00;
		Branch_o <= 0;
		extend_o <= 0;
		
		Mem2Reg_o 		<= 2'b00;
		BranchType_o	<= 2'bxx;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;
	end
	6'b100011:			//lw
	begin
		ALU_op_o <= 3'b000;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 2'b00;
		Branch_o <= 0;
		extend_o <= 1;
		
		Mem2Reg_o 		<= 2'b01;
		BranchType_o	<= 2'bxx;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b1;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;		
	end
	6'b101011:			//sw		Mem[rs+imm] = Reg[rt]
	begin
		ALU_op_o <= 3'b000;
		ALUSrc_o <= 1;
		RegWrite_o <= 0;
		RegDst_o <= 2'b01;
		Branch_o <= 0;
		extend_o <= 1;
		
		Mem2Reg_o 		<= 2'b01;
		BranchType_o	<= 2'bxx;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b1;
		RegWriteData_o	<= 1'b0;		
	end		
	6'b000010:			//jump
	begin
		ALU_op_o <= 3'bxxx;
		ALUSrc_o <= 1'bx;
		RegWrite_o <= 1'b0;
		RegDst_o <= 2'bxx;
		Branch_o <= 1'b0;
		extend_o <= 1'bx;
		
		Mem2Reg_o 		<= 2'bxx;
		BranchType_o	<= 2'bxx;
		Jump_o 			<= 1'b1;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;		
	end
	6'b000111:			//bgt
	begin
		ALU_op_o <= 3'b101;
		ALUSrc_o <= 1'b0;
		RegWrite_o <= 1'b0;
		RegDst_o <= 2'bxx;
		Branch_o <= 1'b1;
		extend_o <= 1'b1;
		
		Mem2Reg_o 		<= 2'bxx;
		BranchType_o	<= 2'b01;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;		
	end		
	6'b000101:			//bnez
	begin
		ALU_op_o <= 3'b101;
		ALUSrc_o <= 1'b0;
		RegWrite_o <= 1'b0;
		RegDst_o <= 2'bxx;
		Branch_o <= 1'b1;
		extend_o <= 1'b1;
		
		Mem2Reg_o 		<= 2'bxx;
		BranchType_o	<= 2'b11;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;		
	end	
	6'b000001:			//bgez
	begin
		ALU_op_o <= 3'b101;
		ALUSrc_o <= 1'b0;
		RegWrite_o <= 1'b0;
		RegDst_o <= 2'bxx;
		Branch_o <= 1'b1;
		extend_o <= 1'b1;
		
		Mem2Reg_o 		<= 2'bxx;
		BranchType_o	<= 2'b10;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;		
	end	
	6'b001111:			//lui
	begin
		ALU_op_o <= 3'bxxx;
		ALUSrc_o <= 1'bx;
		RegWrite_o <= 1'b1;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b0;
		extend_o <= 1'b1;
		
		Mem2Reg_o 		<= 2'b10;
		BranchType_o	<= 2'bxx;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;		
	end
	6'b000011:			//jal jump and link
	begin
		ALU_op_o <= 3'bxxx;
		ALUSrc_o <= 1'bx;
		RegWrite_o <= 1'b1;
		RegDst_o <= 2'b10;
		Branch_o <= 1'b0;
		extend_o <= 1'b1;
		
		Mem2Reg_o 		<= 2'b10;
		BranchType_o	<= 2'bxx;
		Jump_o 			<= 1'b1;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b1;		
	end		
	default:
	begin
		ALU_op_o <= 3'b111;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 2'b00;
		Branch_o <= 0;
		extend_o <= 1;
		
		Mem2Reg_o 		<= 2'b00;
		BranchType_o	<= 2'bxx;
		Jump_o 			<= 1'b0;
		MemRead_o 		<= 1'b0;
		MemWrite_o 		<= 1'b0;
		RegWriteData_o	<= 1'b0;		
	end
	endcase
end
endmodule





                    
                    