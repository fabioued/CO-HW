`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:52:59 10/10/2013 
// Design Name: 
// Module Name:    addunit 
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
module addunit(
		wA,
		wB,
		cin,
		wwADD,
		cout
    );
input		wA;
input		wB;
input		cin;
output	wwADD;
output	cout;	 
wire	a,b,c;
//addunit adding(wA, wB, cin, wwADD);
	xor xor1(wwADD, wA, wB, cin);
	and and1(a, wA, wB);
	and and2(b, wA, cin);
	and and3(c, cout, wB);
	or or1(cout, a, b, c);
endmodule
