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
module Forwarding(
            ForwardA,
            ForwardB,          
            IDEXRs,
            IDEXRt,
            EXMEMRd,
            EXMEMRegWrite,
            MEMWBRd,
            MEMWBRegWrite
);
					
input   [4:0]   IDEXRs;
input   [4:0]   IDEXRt;
input   [4:0]   EXMEMRd;
input           EXMEMRegWrite;
input   [4:0]   MEMWBRd;
input           MEMWBRegWrite;
output reg [1:0]   ForwardA;
output reg [1:0]   ForwardB;

always @(*) 
begin
    if (EXMEMRegWrite == 1'b1 && EXMEMRd == IDEXRs && EXMEMRd != 5'd0) ForwardA = 2'b01;
    else if (MEMWBRegWrite == 1'b1 && MEMWBRd == IDEXRs && MEMWBRd != 5'd0) ForwardA = 2'b10;
    else ForwardA = 2'b00;
end

always @(*) 
begin
    if (EXMEMRegWrite == 1'b1 && EXMEMRd == IDEXRt && EXMEMRd != 5'd0) ForwardB = 2'b01;
    else if (MEMWBRegWrite == 1'b1 && MEMWBRd == IDEXRt && MEMWBRd != 5'd0) ForwardB = 2'b10;
    else ForwardB = 2'b00;
end

endmodule	