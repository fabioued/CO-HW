//Student ID: 0016311
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
			 ALUCtrl_jr_o,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;
output				 ALUCtrl_jr_o;
output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg					 ALUCtrl_jr_o;
//Parameter


always @(*) 
begin
	case(ALUOp_i)
	3'b000:		//lw,sw
	begin
		ALUCtrl_o <= 4'b0010;
		ALUCtrl_jr_o <= 1'b0;
	end
	3'b010:		//R-type
	begin
		case (funct_i)
		6'b000000:	//SLL
		begin
			ALUCtrl_o <= 4'b0111;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b000100:	//SLLV
		begin
			ALUCtrl_o <= 4'b0111;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b000010:	//SRL
		begin
			ALUCtrl_o <= 4'b0111;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b000110:	//SRLV
		begin
			ALUCtrl_o <= 4'b0111;
			ALUCtrl_jr_o <= 1'b0;
		end
		
		6'b100000:	//addition
		begin
			ALUCtrl_o <= 4'b0010;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b100010:	//subtraction
		begin
			ALUCtrl_o <= 4'b0110;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b100100:	//logic and
		begin
			ALUCtrl_o <= 4'b0000;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b100101:	//logic or
		begin
			ALUCtrl_o <= 4'b0001;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b101010:	//set on less than
		begin
			ALUCtrl_o <= 4'b0111;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b011000:	//mul
		begin
			ALUCtrl_o <= 4'b1111;
			ALUCtrl_jr_o <= 1'b0;
		end
		6'b001000:	//jr   jump return Lab3 bonus
		begin
			ALUCtrl_o <= 4'b0010;
			ALUCtrl_jr_o <= 1'b1;
		end
		default:
		begin
			ALUCtrl_o <= 4'b0000;
			ALUCtrl_jr_o <= 1'b0;
		end
		endcase
	end
	3'b100:		//add immediate
	begin
		ALUCtrl_o <= 4'b0010;
		ALUCtrl_jr_o <= 1'b0;
	end
	3'b101:		//Branch on Equal
	begin
		ALUCtrl_o <= 4'b0110;
		ALUCtrl_jr_o <= 1'b0;
	end	
	3'b110:		//OR immedicate
	begin
		ALUCtrl_o <= 4'b0001;
		ALUCtrl_jr_o <= 1'b0;
	end
	default:
	begin
		ALUCtrl_o <= 4'b0000;
		ALUCtrl_jr_o <= 1'b0;
	end
	endcase
end
       
//Select exact operation

endmodule     





                    
                    