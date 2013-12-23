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
module Hazard(
            PCSrc,
            PCWrite,
            IFIDStall,
            IFIDRsRt,
            IDEXRt,
            IFFlush,
            EXFlush,
            IDEXmemread,
            IDFlush
);

input           PCSrc;
input   [9:0]   IFIDRsRt;       //Rs 9:5 Rt 4:0
input   [4:0]   IDEXRt;
input           IDEXmemread;
output  reg     PCWrite;
output  reg     IFIDStall;
output  reg     IFFlush;
output  reg     EXFlush;
output  reg     IDFlush;

always @(*)
begin
    case(PCSrc)
    1'b0:
    begin
        if (IDEXmemread == 1'b1 && (IDEXRt == IFIDRsRt[9:5] || IDEXRt == IFIDRsRt[4:0])) 
        begin
            PCWrite <= 1'b0;
            IFIDStall <= 1'b1;
            IFFlush <= 1'b0;
            EXFlush <= 1'b0;
            IDFlush <= 1'b1;
        end
        else
        begin
            PCWrite <= 1'b1;
            IFIDStall <= 1'b0;
            IFFlush <= 1'b0;
            EXFlush <= 1'b0;
            IDFlush <= 1'b0;
        end
    end
    1'b1:
    begin
        PCWrite <= 1'b1;
        IFIDStall <= 1'b0;
        IFFlush <= 1'b1;
        EXFlush <= 1'b1;
        IDFlush <= 1'b1;
    end
    endcase
end
endmodule	