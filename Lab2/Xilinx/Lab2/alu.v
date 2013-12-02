`timescale 1ns/1ps
//Student ID: 0016311
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2010
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

wire	[31:0]	result;
//wire	[31:0]	set_w;
wire	[30:0]	w_cin;
wire				cout_w;
reg				overflow;
reg				zero;
reg				cout;


wire	[31:0]	set;
wire				carryin;
/*
reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;
*/

assign carryin = ALU_control[2];
//carry out
always @(*)
begin
	cout = cout_w;
end

//zero
always @(*)
begin
	if (result == 32'd0) zero = 1'b1;
	else zero = 1'b0;
end

/////////bonus///////////////////////////////////////////
//equal
reg			ans;

always @(*)
begin
	case (bonus_control)
	3'b000:		//slt
	begin
		ans = set[31];
	end
	3'b001:		//sgt
	begin
		if	((set != 32'd0) && (cout == 1'b1)) ans = 1'b1;
		else	ans = 1'b0;
	end
	3'b010:		//sle
	begin
		if	((set != 32'd0) && (cout == 1'b1)) ans = 1'b0;
		else	ans = 1'b1;
	end
	3'b011:		//sge
	begin
		if	(set[31] == 1'b0) ans = 1'b1;
		else	ans = 1'b0;
	end
	3'b110:		//seq
	begin
		if ((set == 32'd0) && (cout == 1'b1)) ans = 1'b1;
		else ans = 1'b0;
	end
	3'b100:		//sne
	begin
		if	(set != 32'd0) ans = 1'b1;
		else	ans = 1'b0;
	end
	
	default:		//slt
	begin
		ans = set[31];
	end
	endcase
end
/////////bonus///////////////////////////////////////////


//overflow
always @(*)
begin
	overflow = (src1[31] & src2[31] & ~result[31])|(~src1[31] & ~src2[31] & result[31]);
end


//					scr1			scr2			less			A_invert			B_invert				cin			opteration			result			cout			set		

/* original
alu_top alu0(src1[0],		src2[0],		set,			ALU_control[3], ALU_control[2], carryin,		ALU_control[1:0], result[0],		w_cin[0]);
*/

alu_top alu0(src1[0],		src2[0],		ans,			ALU_control[3], ALU_control[2], carryin,		ALU_control[1:0], result[0],		w_cin[0],	set[0]);
alu_top alu1(src1[1],		src2[1],		1'b0,			ALU_control[3], ALU_control[2], w_cin[0],		ALU_control[1:0], result[1],		w_cin[1],	set[1]);
alu_top alu2(src1[2],		src2[2],		1'b0,			ALU_control[3], ALU_control[2], w_cin[1], 	ALU_control[1:0], result[2],		w_cin[2],	set[2]);
alu_top alu3(src1[3],		src2[3],		1'b0,			ALU_control[3], ALU_control[2], w_cin[2], 	ALU_control[1:0], result[3],		w_cin[3],	set[3]);
alu_top alu4(src1[4],		src2[4],		1'b0,			ALU_control[3], ALU_control[2], w_cin[3], 	ALU_control[1:0], result[4],		w_cin[4],	set[4]);
alu_top alu5(src1[5],		src2[5],		1'b0,			ALU_control[3], ALU_control[2], w_cin[4], 	ALU_control[1:0], result[5],		w_cin[5],	set[5]);
alu_top alu6(src1[6],		src2[6],		1'b0,			ALU_control[3], ALU_control[2], w_cin[5], 	ALU_control[1:0], result[6],		w_cin[6],	set[6]);
alu_top alu7(src1[7],		src2[7],		1'b0,			ALU_control[3], ALU_control[2], w_cin[6], 	ALU_control[1:0], result[7],		w_cin[7],	set[7]);
alu_top alu8(src1[8],		src2[8],		1'b0,			ALU_control[3], ALU_control[2], w_cin[7], 	ALU_control[1:0], result[8],		w_cin[8],	set[8]);
alu_top alu9(src1[9],		src2[9],		1'b0,			ALU_control[3], ALU_control[2], w_cin[8], 	ALU_control[1:0], result[9],		w_cin[9],	set[9]);
alu_top alu10(src1[10],		src2[10],	1'b0,			ALU_control[3], ALU_control[2], w_cin[9], 	ALU_control[1:0], result[10],		w_cin[10],	set[10]);
alu_top alu11(src1[11], 	src2[11],	1'b0,			ALU_control[3], ALU_control[2], w_cin[10],	ALU_control[1:0], result[11],		w_cin[11],	set[11]);
alu_top alu12(src1[12], 	src2[12],	1'b0,			ALU_control[3], ALU_control[2], w_cin[11],	ALU_control[1:0], result[12],		w_cin[12],	set[12]);
alu_top alu13(src1[13], 	src2[13],	1'b0,			ALU_control[3], ALU_control[2], w_cin[12],	ALU_control[1:0], result[13],		w_cin[13],	set[13]);
alu_top alu14(src1[14], 	src2[14],	1'b0,			ALU_control[3], ALU_control[2], w_cin[13], 	ALU_control[1:0], result[14], 	w_cin[14],	set[14]);
alu_top alu15(src1[15], 	src2[15],	1'b0,			ALU_control[3], ALU_control[2], w_cin[14], 	ALU_control[1:0], result[15], 	w_cin[15],	set[15]);
alu_top alu16(src1[16], 	src2[16],	1'b0,			ALU_control[3], ALU_control[2], w_cin[15], 	ALU_control[1:0], result[16], 	w_cin[16],	set[16]);
alu_top alu17(src1[17], 	src2[17],	1'b0,			ALU_control[3], ALU_control[2], w_cin[16], 	ALU_control[1:0], result[17], 	w_cin[17],	set[17]);
alu_top alu18(src1[18], 	src2[18],	1'b0,			ALU_control[3], ALU_control[2], w_cin[17], 	ALU_control[1:0], result[18], 	w_cin[18],	set[18]);
alu_top alu19(src1[19], 	src2[19],	1'b0,			ALU_control[3], ALU_control[2], w_cin[18], 	ALU_control[1:0], result[19], 	w_cin[19],	set[19]);
alu_top alu20(src1[20], 	src2[20],	1'b0,			ALU_control[3], ALU_control[2], w_cin[19], 	ALU_control[1:0], result[20], 	w_cin[20],	set[20]);
alu_top alu21(src1[21], 	src2[21],	1'b0,			ALU_control[3], ALU_control[2], w_cin[20], 	ALU_control[1:0], result[21], 	w_cin[21],	set[21]);
alu_top alu22(src1[22], 	src2[22],	1'b0,			ALU_control[3], ALU_control[2], w_cin[21], 	ALU_control[1:0], result[22], 	w_cin[22],	set[22]);
alu_top alu23(src1[23], 	src2[23],	1'b0,			ALU_control[3], ALU_control[2], w_cin[22], 	ALU_control[1:0], result[23], 	w_cin[23],	set[23]);
alu_top alu24(src1[24], 	src2[24],	1'b0,			ALU_control[3], ALU_control[2], w_cin[23], 	ALU_control[1:0], result[24], 	w_cin[24],	set[24]);
alu_top alu25(src1[25], 	src2[25],	1'b0,			ALU_control[3], ALU_control[2], w_cin[24], 	ALU_control[1:0], result[25], 	w_cin[25],	set[25]);
alu_top alu26(src1[26], 	src2[26],	1'b0,			ALU_control[3], ALU_control[2], w_cin[25], 	ALU_control[1:0], result[26], 	w_cin[26],	set[26]);
alu_top alu27(src1[27], 	src2[27],	1'b0,			ALU_control[3], ALU_control[2], w_cin[26], 	ALU_control[1:0], result[27], 	w_cin[27],	set[27]);
alu_top alu28(src1[28], 	src2[28],	1'b0,			ALU_control[3], ALU_control[2], w_cin[27], 	ALU_control[1:0], result[28], 	w_cin[28],	set[28]);
alu_top alu29(src1[29], 	src2[29],	1'b0,			ALU_control[3], ALU_control[2], w_cin[28], 	ALU_control[1:0], result[29], 	w_cin[29],	set[29]);
alu_top alu30(src1[30], 	src2[30],	1'b0,			ALU_control[3], ALU_control[2], w_cin[29], 	ALU_control[1:0], result[30], 	w_cin[30],	set[30]);
alu_top alu31(src1[31], 	src2[31],	1'b0,			ALU_control[3], ALU_control[2], w_cin[30], 	ALU_control[1:0], result[31], 	cout_w,		set[31]);




endmodule
