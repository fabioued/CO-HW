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
	extend_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output			extend_o; 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg				extend_o;
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
		RegDst_o <= 1;
		Branch_o <= 0;
		extend_o <= 1;
	end
	6'b001000:			//add immediate
	begin
		ALU_op_o <= 3'b100;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 0;
		Branch_o <= 0;
		extend_o <= 1;
	end
	6'b000100:			//Branch on Equal
	begin
		ALU_op_o <= 3'b101;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 0;
		Branch_o <= 1;
		extend_o <= 1;
	end
	6'b001101:			//OR immedicate
	begin
		ALU_op_o <= 3'b110;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 0;
		Branch_o <= 0;
		extend_o <= 0;
	end
	default:
	begin
		ALU_op_o <= 3'b111;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 0;
		Branch_o <= 0;
		extend_o <= 1;
	end
	endcase
end
endmodule





                    
                    