module LD_ST_data_complete(opcode,funct_3,Read_Data_mem,Write_Data_mem,complete_Read_Data_mem,complete_Write_Data_mem);

input [31:0] Read_Data_mem,Write_Data_mem;
input [6:0] opcode;
input [2:0] funct_3;
output reg[31:0] complete_Read_Data_mem,complete_Write_Data_mem;
		
	always @(*) 
	begin
				case(opcode)
					7'h03:
					begin
						case(funct_3)
							3'h0://LB
							begin
								complete_Read_Data_mem <= (Read_Data_mem & 32'h7f) | {{25{Read_Data_mem[7]}},7'h0};
							end
							3'h1://LH
							begin
								complete_Read_Data_mem <= (Read_Data_mem & 32'h7fff) | {{17{Read_Data_mem[15]}},15'h0};
							end
							3'h2://LW
							begin
								complete_Read_Data_mem <= Read_Data_mem;
							end
							3'h4://LBU
							begin
								complete_Read_Data_mem <= Read_Data_mem & 32'hff;
							end
							3'h5://LHU
							begin
								complete_Read_Data_mem <= Read_Data_mem & 32'hffff;
							end							
							default:complete_Read_Data_mem <= 32'h0 ;
						endcase
					end
					7'h23:
					begin
						case(funct_3)
							3'h0://SB
							begin
								complete_Write_Data_mem <= (Write_Data_mem & 32'hff);
							end
							3'h1://SH
							begin
								complete_Write_Data_mem <= (Write_Data_mem & 32'hffff);
							end
							3'h2://SW
							begin
								complete_Write_Data_mem <= Write_Data_mem;
							end
							default:complete_Write_Data_mem <= 32'h0 ;
						endcase
					end					
					default:begin complete_Read_Data_mem <= 32'h0 ;complete_Write_Data_mem <= 32'h0;end
				endcase
				
	end


endmodule 