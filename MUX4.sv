module MUX4     (
							sel,
							in1, 	//alu calculation output
							in2,			//immediate
							in3, 	//Read data from addressed memory block
							in4,			//take the PC + 4
							MUX_OUT		//WBMux output
							);

input [31:0]in1, 	//alu calculation output
				in2,		//immediate for instruction type U
				in3, 	//Read data from addressed memory block
				in4;			//take the PC + 4
input [1:0] sel;
output[31:0] MUX_OUT ;
logic [31:0] out [3:0];
		
		generate
		genvar i;
					for(i=0;i<32;i++)begin : mux2
							assign out[0][i] = ~sel[1]&~sel[0]&in1[i];
							assign out[1][i] = ~sel[1]&sel[0]&in2[i];
							assign out[2][i] = sel[1]&~sel[0]&in3[i];
							assign out[3][i] = sel[1]&sel[0]&in4[i];
							assign MUX_OUT[i] = out[0][i]|out[1][i]|out[2][i]|out[3][i];  
					end
		endgenerate
		
		
endmodule 