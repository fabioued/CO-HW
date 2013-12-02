`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:16:33 10/26/2013 
// Design Name: 
// Module Name:    Andzero 
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
module Andzero(
		branch_i,
		aluzero_i,
		select_o
    );

input		branch_i;
input 	aluzero_i;
output	select_o;

reg		select_o;

always @(*)
begin
	select_o = branch_i & aluzero_i;
end

endmodule
