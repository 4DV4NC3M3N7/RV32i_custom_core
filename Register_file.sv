module Register_file(RS1,RS2,RSD,Data_in,clr,Reg_Write,RD1,RD2);
input [4:0] RS1,RS2,RSD;
input [31:0] Data_in;
input clr,Reg_Write;
wire  [31:0] decoder_wire;
wire [1023:0] Data_bus;
output[31:0] RD1,RD2;


Double_MUX_32_5bit_sel MUX32(
										.RS1(RS1),
										.RS2(RS2),
										.out1(RD1),
										.out2(RD2),
										.Data_out(Data_bus)
										);
										
Register_block block(
							.choose(decoder_wire),
							.enable(1'b1),
							.clr(clr),
							.clk(Reg_Write),
							.Data_in(Data_in),
							.Data_out(Data_bus)
							);
							
Decoder_5bit Decode(
							.RSD(RSD),
							.Reg_select(decoder_wire)
							);


endmodule 
//=============================================
module Double_MUX_32_5bit_sel(RS1,RS2,out1,out2,Data_out);
input [1023:0]Data_out;
wire [31:0] Data1 [31:0];
wire [31:0] Data2 [31:0];
input [4:0] RS1,RS2;
wire [31:0] bus1 [31:0];
wire [31:0] bus2 [31:0];
output[31:0] out1,out2;

generate
	genvar i,j,k;
	for(k=0;k<32;k++)begin : rewire1
							assign Data1[k] = Data_out[31+(32*k):0+(32*k)];  
	end
	for(j=0;j<32;j++) begin : bit_width1
		for(i=0;i<32;i++)begin : select1
					assign bus1[j][i] = Data1[i][j]&((RS1[4]~^((i&16)>>4)) & (RS1[3]~^((i&8)>>3)) & (RS1[2]~^((i&4)>>2)) & (RS1[1]~^((i&2)>>1)) & (RS1[0]~^(i&1)));
		end
		assign out1[j] = 	bus1[j][0]|bus1[j][1]|bus1[j][2]|bus1[j][3]|bus1[j][4]|bus1[j][5]|bus1[j][6]|bus1[j][7]|
								bus1[j][8]|bus1[j][9]|bus1[j][10]|bus1[j][11]|bus1[j][12]|bus1[j][13]|bus1[j][14]|bus1[j][15]|
								bus1[j][16]|bus1[j][17]|bus1[j][18]|bus1[j][19]|bus1[j][20]|bus1[j][21]|bus1[j][22]|bus1[j][23]|
								bus1[j][24]|bus1[j][25]|bus1[j][26]|bus1[j][27]|bus1[j][28]|bus1[j][29]|bus1[j][30]|bus1[j][31];
	end
	for(k=0;k<32;k++)begin : rewire2
							assign Data2[k] = Data_out[31+(32*k):0+(32*k)];  
	end
	for(j=0;j<32;j++) begin : bit_width2
		for(i=0;i<32;i++)begin : select2
					assign bus2[j][i] = Data2[i][j]&((RS2[4]~^((i&16)>>4)) & (RS2[3]~^((i&8)>>3)) & (RS2[2]~^((i&4)>>2)) & (RS2[1]~^((i&2)>>1)) & (RS2[0]~^(i&1)));
		end
		assign out2[j] = 	bus2[j][0]|bus2[j][1]|bus2[j][2]|bus2[j][3]|bus2[j][4]|bus2[j][5]|bus2[j][6]|bus2[j][7]|
								bus2[j][8]|bus2[j][9]|bus2[j][10]|bus2[j][11]|bus2[j][12]|bus2[j][13]|bus2[j][14]|bus2[j][15]|
								bus2[j][16]|bus2[j][17]|bus2[j][18]|bus2[j][19]|bus2[j][20]|bus2[j][21]|bus2[j][22]|bus2[j][23]|
								bus2[j][24]|bus2[j][25]|bus2[j][26]|bus2[j][27]|bus2[j][28]|bus2[j][29]|bus2[j][30]|bus2[j][31];
	end
	endgenerate
	
endmodule 

//=============================================
module Decoder_5bit(RSD,Reg_select);

input [4:0] RSD;
output[31:0] Reg_select;
	generate
	genvar i;
		for(i=0;i<32;i++)begin : select
					assign Reg_select[i] = ~(RSD[4]^((i&16)>>4)) & ~(RSD[3]^((i&8)>>3)) & ~(RSD[2]^((i&4)>>2)) & ~(RSD[1]^((i&2)>>1)) & ~(RSD[0]^(i&1));
		end
	endgenerate

endmodule 

//=============================================

module Register_block(choose,enable,clr,clk,Data_in,Data_out);

input clr,clk,enable;
input 	[31:0] choose;
input 	[31:0] Data_in;
wire 		[31:0] Data [31:0];
output 	[1023:0] Data_out;
assign Data_out = {	Data[31],Data[30],Data[29],Data[28],Data[27],Data[26],Data[25],Data[24],Data[23],Data[22],Data[21],Data[20],Data[19],Data[18],Data[17],Data[16],
							Data[15],Data[14],Data[13],Data[12],Data[11],Data[10],Data[9],Data[8],Data[7],Data[6],Data[5],Data[4],Data[3],Data[2],Data[1],Data[0]};
generate
	genvar i;
	for(i=0;i<32;i++)begin : REG_bar
			Reg_32bit r(.enable(enable),.choose(choose[i]),.clr(clr),.clk(clk),.Data_in(Data_in),.Data_out(Data[i]));
	end

endgenerate

endmodule 


//=============================================
module Reg_32bit(enable,choose,clr,clk,Data_in,Data_out);

input enable,choose,clr,clk;
input 	[31:0] Data_in;
output 	[31:0] Data_out;


generate
	genvar i;
	for(i=0;i<32;i++)begin : REG
			Reg_1bit r(.clr(clr),.clk(clk & choose & enable ),.Data_in(Data_in[i]),.Data_out(Data_out[i]));
	end

endgenerate

endmodule 
//=============================================
module Reg_1bit(clr,clk,Data_in,Data_out);
input clr,clk,Data_in;
output reg Data_out;
//initial begin 
//	clr <= 1;
//end
always @(posedge clk or posedge clr)begin
  if(clr) Data_out <= 1'b0 ;
  else Data_out <= Data_in;
end

endmodule 
//=============================================
