//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg_IFID(
            rst_i,
			clk_i,
            IFIDStall,
            IFFlush,
			data_i,
			data_o
);
					
parameter size = 0;
input                   rst_i;
input                   clk_i;
input                   IFIDStall;
input                   IFFlush;
input      [size-1: 0]  data_i;
output reg [size-1: 0]  data_o;
	  
always @(posedge clk_i or negedge  rst_i) begin
	if( rst_i == 0 || IFFlush == 1'b1) data_o <= 0;
    else if (IFIDStall == 1'b1) data_o <= data_o;
    else    data_o <= data_i;
end

endmodule	