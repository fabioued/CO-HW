`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:47:59 10/11/2013 
// Design Name: 
// Module Name:    alu_bottom 
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
module alu_bottom(
					src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
					set			//set
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;
reg           result;

/////////////////////////////////////////////////////
output			set;
reg				set;
reg				wA,wB,wwADD,wwAND,wwOR;
reg				cout;
/////////////////////////////////////////////////////

always @(*)
begin
	//if (A_invert) wA <= ~src1;
	//else wA <= src1;
	wA <= src1 ^ A_invert;
	wB <= src2 ^ B_invert;
end


/*
always @(*)
begin
	wB <= src2 ^ B_invert;
end
*/

always @(*)
begin
	wwAND <= wA && wB;
	wwOR 	<= wA || wB;
	wwADD <= wA ^ wB ^ cin;
	if ((wA && wB)||(cin && wB)||(wA && cin)) cout <= 1;
	else cout <= 0;
end

//selector
always @(*)
begin
	case (operation)
	2'b00:		//AND
	begin
		result <= wwAND;
		set	 <= wwAND;
	end
	2'b01:		//OR
	begin
		result <= wwOR;
		set	 <= wwOR;
	end
	2'b10:		//ADD
	begin
		result <= wwADD;
		set	 <= wwADD;
	end
	2'b11:		//LESS
	begin
		result <= less;
		set	 <= wwADD;
	end
	endcase
end


//addunit addunit(.wA(scr1),.wB(scr2),.cin(cin),.wwADD(wwADD),.cout(cout));
endmodule
