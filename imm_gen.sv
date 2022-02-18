module imm_gen(inst,result);//imm_U,imm_B,imm_S,imm_I,imm_J,shamt
input [31:0]inst;
wire [31:0]imm_U,imm_B,imm_S,imm_I,imm_J,shamt;
wire [2:0] sel;
wire [7:0] flag;
output  [31:0] result;

assign imm_U[31:0] = {inst[31:12],12'h0};
assign imm_I[31:0] = {{21{inst[31]}},inst[30:20]};
assign imm_S[31:0] = {{21{inst[31]}},inst[30:25],inst[11:7]};
assign imm_J[31:0] = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
assign imm_B[31:0] = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
assign shamt[31:0] = {27'h0,inst[24:20]};
///*
check_opcode lui	(inst[6:0],7'h37,flag[0]);
check_opcode auipc(inst[6:0],7'h17,flag[1]);
check_opcode ld	(inst[6:0],7'h03,flag[2]);
check_opcode st	(inst[6:0],7'h23,flag[3]);
check_opcode ri	(inst[6:0],7'h13,flag[4]);
check_opcode b		(inst[6:0],7'h63,flag[5]);
check_opcode j		(inst[6:0],7'h6f,flag[6]);
check_opcode jr	(inst[6:0],7'h67,flag[7]);

assign sel[2] =(~flag[7] & ~flag[6] & ~flag[5] & flag[4] & ~flag[3] & ~flag[2] & ~flag[1] & ~flag[0]) |
					(~flag[7] & ~flag[6] & flag[5] & ~flag[4] & ~flag[3] & ~flag[2] & ~flag[1] & ~flag[0]) | 
					(~flag[7] & flag[6] & ~flag[5] & ~flag[4] & ~flag[3] & ~flag[2] & ~flag[1] & ~flag[0]) | 
					(flag[7] & ~flag[6] & ~flag[5] & ~flag[4] & ~flag[3] & ~flag[2] & ~flag[1] & ~flag[0]);
assign sel[1] =(~flag[7] & ~flag[6] & ~flag[5] & ~flag[4] & ~flag[3] & flag[2] & ~flag[1] & ~flag[0]) |
					(~flag[7] & ~flag[6] & ~flag[5] & ~flag[4] & flag[3] & ~flag[2] & ~flag[1] & ~flag[0]) | 
					(~flag[7] & flag[6] & ~flag[5] & ~flag[4] & ~flag[3] & ~flag[2] & ~flag[1] & ~flag[0]) | 
					(flag[7] & ~flag[6] & ~flag[5] & ~flag[4] & ~flag[3] & ~flag[2] & ~flag[1] & ~flag[0]);
assign sel[0] =(~flag[7] & ~flag[6] & ~flag[5] & ~flag[4] & ~flag[3] & ~flag[2] & flag[1] & ~flag[0]) | 
					(~flag[7] & ~flag[6] & ~flag[5] & ~flag[4] & flag[3] & ~flag[2] & ~flag[1] & ~flag[0]) | 
					(~flag[7] & ~flag[6] & flag[5] & ~flag[4] & ~flag[3] & ~flag[2] & ~flag[1] & ~flag[0]) | 
					(flag[7] & ~flag[6] & ~flag[5] & ~flag[4] & ~flag[3] & ~flag[2] & ~flag[1] & ~flag[0]);

Mux_8 sel_8_32bits (	.sel(sel),
							.in_0(imm_U),
							.in_1(imm_U),
							.in_2(imm_I),
							.in_3(imm_S),
							.in_4({imm_I,shamt}),
							.in_5(imm_B),
							.in_6(imm_J),
							.in_7(imm_I),
							.funct_3(inst[14:12]),
							.out(result)
						 );
//*/

endmodule 
///*
/*flag for capturing opcode selecting immediate value for each type of operation*/
//================================================================================
module check_opcode(inst,opcode,flag);
input [6:0] opcode,inst;
wire [6:0] temp;
output flag;
genvar i;
generate
	for(i=0;i<7;i++)begin : muxe
			 assign temp[i] = ~(opcode[i]^inst[i]);
	end
	assign flag = temp[0]&temp[1]&temp[2]&temp[3]&temp[4]&temp[5]&temp[6];
endgenerate

endmodule 
//================================================================================
//*/
///*
//================================================================================
module Mux_8(sel,in_0,in_1,in_2,in_3,in_4,in_5,in_6,in_7,funct_3,out);
input 	[2:0]sel,funct_3;
input 	[31:0] in_0,in_1,in_2,in_3,in_5,in_6,in_7;
input    [63:0] in_4;
wire 	   [31:0] out_n [7:0];
output 	[31:0] out;
generate
genvar i;
		for(i=0;i<32;i++)begin : mux_8_32bits
			assign out_n[0][i] = in_0[i]&~sel[2]&~sel[1]&~sel[0];
			assign out_n[1][i] = in_1[i]&~sel[2]&~sel[1]&sel[0];
			assign out_n[2][i] = in_2[i]&~sel[2]&sel[1]&~sel[0];
			assign out_n[3][i] = in_3[i]&~sel[2]&sel[1]&sel[0];
			
			assign out_n[4][i] = ((~funct_3[2]&~funct_3[1]&funct_3[0])|(funct_3[2]&~funct_3[1]&funct_3[0]))&sel[2]&~sel[1]&~sel[0]?
										in_4[i]:
										~((~funct_3[2]&~funct_3[1]&funct_3[0])|(funct_3[2]&~funct_3[1]&funct_3[0]))&sel[2]&~sel[1]&~sel[0]?
										in_4[32+i]:1'b0;
			assign out_n[5][i] = in_5[i]&sel[2]&~sel[1]&sel[0];
			assign out_n[6][i] = in_6[i]&sel[2]&sel[1]&~sel[0];
			assign out_n[7][i] = in_7[i]&sel[2]&sel[1]&sel[0];
			assign out[i] =out_n[0][i]|
								out_n[1][i]|
								out_n[2][i]|
								out_n[3][i]|
								out_n[4][i]|
								out_n[5][i]|
								out_n[6][i]|
								out_n[7][i];  
		end
endgenerate
endmodule 
//================================================================================
//*/
/*behavioral way to do the selecting imm_gen*/
//===============================================================================
//
/*
always @(inst)
begin
//integer i;
		//for(i=0;i<32;i++)begin
			case({1'b0,inst[6:0]})//opcode detecting
					8'b0011_0111:result <= imm_U;
					8'b0001_0111:result <= imm_U;
					8'b0000_0011:result <= imm_I;
					8'b0010_0011:result <= imm_S;
					8'b0001_0011:	begin
								if(inst[14:12]==3'b001|3'b101) result <= shamt;
								else result <= imm_I;
							end
					8'b0110_0011:result <= imm_B;
					8'b0110_1111:result <= imm_J;
					8'b0110_0111:result <= imm_I;
					default:result <= 32'bx ;
			endcase
		//end
end
//
*/
//===============================================================================
/*
generate
	for(i=0;i<32;i++)begin : muxes
	assign result[i] = 	(flag[0] | flag[1]) ? imm_U[i]: 
								//flag[2] ? imm_I[i]: 
								flag[3] ? imm_S[i]:
								(flag[7]|flag[2]|(flag[4] & ~((~inst[14])&(~inst[13])&(inst[12])|(inst[14])&(~inst[13])&(inst[12]))))  ? imm_I[i]:
								(flag[4] & ((~inst[14])&(~inst[13])&(inst[12])|(inst[14])&(~inst[13])&(inst[12])))   ? shamt[i]:
								flag[5] ? imm_B[i]:
								flag[6] ? imm_J[i]: 		1'bx;
	end
endgenerate
*/
