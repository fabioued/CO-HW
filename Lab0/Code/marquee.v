`timescale 1ns/10ps
module marquee(
  clk,
  rst,
  indataA,
  indataB,
  outdata
  );

input clk;
input rst;  
input  [2:0] indataA;
input  [2:0] indataB;

output [5:0] outdata;


reg [1:0] counter_r, counter_n;


// To do:
// Please fulfill the code to make your output waveform the same as our specification

// To do:
// Please add sequential code here:
always@(posedge clk)begin
    if(rst)begin

    end
    else begin

    end
end



// To do:
// please add combinational code here:
always@(*)begin



end

endmodule
