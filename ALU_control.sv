module ALU_control(opcode,funct_7,funct_3,ALUop,operation);

/*ALUop*/
//=========================================================
/*
	00 = R->R,R->I(ADD->AND)
	01 = branching(SUB)
	10 = LD,SD(ADD)
	11 = dont care
*/
//=========================================================


//=========================================================
input [6:0] funct_7,opcode;
input [2:0] funct_3;
input [1:0] ALUop;
logic	funct_7_fix;// help reconfigure ALU immediate signed number operation
output [3:0] operation;


assign funct_7_fix = ~((opcode == 7'h13)&~((funct_3 == 1'h1)|(funct_3 == 3'h5)))&funct_7[5];


mux8 mux_8(.funct_7(funct_7_fix),.funct_3(funct_3),.ALUop(ALUop),.out(operation));
//=========================================================

/*opcode detecting*/
//===========================================
//check_opcode lui	(opcode[6:0],'h37,flag[0]);
//check_opcode auipc(opcode[6:0],'h17,flag[1]);
//check_opcode ld	(opcode[6:0],'h03,flag[2]);
//check_opcode st	(opcode[6:0],'h23,flag[3]);
//check_opcode ri	(opcode[6:0],'h13,flag[4]);
//check_opcode b		(opcode[6:0],'h63,flag[5]);
//check_opcode j		(opcode[6:0],'h6f,flag[6]);
//check_opcode jr	(opcode[6:0],'h67,flag[7]);
//===========================================



endmodule 

module mux8(funct_7,funct_3,ALUop,out);
 
input 			funct_7;
input  [2:0] 	funct_3;
input  [1:0] 	ALUop;
output reg [3:0] out; 

//
/*
genvar i;
generate
		for(i=0;i<3;i++)begin: mux_3
			assign out[i] = ALUop[1]?funct_3[i]:1'b0;
		end
endgenerate
assign out[3] = ALUop[0]?1'b1:(funct_7&(~ALUop[1]));
//
*/	
//assign out[0]=

///*	
	always @(*) begin
			case(ALUop)
				2'b00:
					begin
						out[2:0] <= funct_3;
						out[3]   <= funct_7;
					end
				2'b01:
					begin
						out[2:0] <= 3'b000;
						out[3]   <= 1'b1;
					end
				2'b10:
					begin
						out[2:0] <= 3'b000;
						out[3]   <= 1'b0;
					end	
				2'b11:					begin
						out[2:0] <= 3'b000;
						out[3]   <= 1'b0;
					end	
			endcase
	end
//*/	

endmodule
