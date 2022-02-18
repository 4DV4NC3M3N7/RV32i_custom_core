
module control(opcode,Branch,ALUop,Reg_Write,Mem_Read,Mem_Write,ALU_src_A,ALU_src_B,PC_Write,clk,reset,WB_Mux_sel,done,Debug,ebreak);
input 	clk,reset;
input  [6:0]opcode;
input  [11:0]ebreak;
output  reg [1:0] ALUop;
output  reg [1:0] WB_Mux_sel,ALU_src_B;
output  reg Reg_Write,Mem_Read,Mem_Write,ALU_src_A,PC_Write,Branch,done,Debug;
//logic [3:0] state, nextstate;

/*
		Reg_Write 	<=;
		Mem_Read		<=;
		Mem_Write	<=;
		ALU_src		<=;
		ALUop			<=;
		Branch		<=;
*/

enum int unsigned 	{state0=0, // IDLE and update PC 
					state1=1, // Decode
					state2=2, // 
					state3=3, 
					state4=4, 
					state5=5, 
					state6=6, 
					state7=7, 
					state8=8, 
					state9=9,
					state10=10,
					state11=11,
					state12=12,
					state13=13,
					state14=14,
					state15=15} f_state, next_state
					;
//byte unsigned f_state;

always @(posedge clk)
    begin
        	if (clk) begin
            f_state <= next_state;
        end
    end


always @(*)
//always_comb 
begin

	if(reset)
	begin
			next_state <= state0;
	end		
	else begin	
		case(f_state)
			state0: 
			begin 
			next_state <= state1;
			Debug			<=  'b0;
			done 			<=  'b1;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b0;// select current PC value stored in PC_register
			ALU_src_B	<=  'b01;// select " 'h4 " to add to next PC
			ALUop			<=  'b10;//Addition
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b1;
			end
			state1: 
			begin
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b0;// select current PC value stored in PC_register
			ALU_src_B	<=  'b01;
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;			
			PC_Write		<=  'b0;
			case(opcode)
				7'h03:
					begin
						next_state <= state2;// memroy address computation (LOAD)
					end
				7'h23:
					begin
						next_state <= state2;// memroy address computation (STORE)
					end
				7'h33:
					begin
						next_state <= state6;// R-type ALU integer computation
					end	
				7'h13:
					begin
						next_state <= state6;// I-type ALU integer computation
					end
				7'h63:
					begin
						next_state <= state8;// branch
					end
				7'h6f:
					begin
						next_state <= state9;// JAL
					end
				7'h67:
					begin
						next_state <= state9;//JALR
					end
				7'h73:
					begin
					if(ebreak == 'h1)
						next_state <= state13;//EBREAK
					else
						next_state <= state14;//ECALL
						//ecall is to halt the program then set PC to a trap vector or function handler
					end

				default:begin next_state <= state0; end
				endcase	
			end
			state2://LD or ST
			begin 
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b1;
			ALU_src_B	<=  'b10;
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;
				case(opcode)
				7'h03:
					begin
						next_state <= state3;// LD-memread
					end
				7'h23:
					begin
						next_state <= state5;// ST-memwrite
					end
				default:begin next_state <= state0; end
				endcase
			end
			state3://reading data from data memory
			begin 
			next_state <= state4;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b1;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b1;
			ALU_src_B	<=  'b10;
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;
			end
			state4://loading data from data memory to register 
			begin 
			next_state <= state0;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b1;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b1;
			ALU_src_B	<=  'b10;
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b10;//choose the read data to load data into destination register
			PC_Write		<=  'b0;
			end
			state5://storing data from register to data memory
			begin 
			next_state <= state0;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b1;
			ALU_src_A	<=  'b1;
			ALU_src_B	<=  'b10;
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;
			end
			state6:// R and I type operations
			begin 
			next_state <= state7;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b1;
			//==================
			if (opcode == 7'h33)begin
			ALU_src_B	<=  'b00;end
			else 					  begin
			ALU_src_B	<=  'b10;end
			//==================
			ALUop			<=  'b00;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;

			end
			state7://write back to register
			begin
			next_state <= state0;
			Debug		<=  'b0;	
			done 			<=  'b0;
			Reg_Write 	<=  'b1;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b1;
			//==================
			if (opcode == 7'h33)begin
			ALU_src_B	<=  'b00;end
			else 					  begin
			ALU_src_B	<=  'b10;end
			//==================
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;
			end
			state8:// branching comparing calculation
			begin 
			next_state <= state12;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b1;// choose RS1
			ALU_src_B	<=  'b00;// choose RS2 
			ALUop			<=  'b10;// because ALU design have it compare flags so whatever the output got still the comparison got recorded 
			Branch		<=  'b1;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;
			end
			state9:// JAL/JALR write PC+4 to RSD
			begin 
			next_state <= state10;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b1;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b0;// choose PC
			ALU_src_B	<=  'b01;// choose +4
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;
				case(opcode)
				7'h6f:
					begin
						next_state <= state10;// JAL: PC +imm
					end
				7'h67:
					begin
						next_state <= state11;// JALR: RS1 + imm
					end
				default:begin next_state <= state0; end
				endcase			
			end
			state10:// current PC + imm to the next PC
			begin 
			next_state <= state0;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b0;// choose PC
			ALU_src_B	<=  'b10;// choose imm
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b1;
			end		
			state11:// current RS1 + imm to the next PC
			begin 
			next_state <= state0;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b1;// choose RS1
			ALU_src_B	<=  'b10;// choose imm
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b1;
			end			
			state12:// branching PC alteration
			begin 
			next_state <= state0;
			Debug		<=  'b0;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b0;// choose PC
			ALU_src_B	<=  'b11;// choose imm
			ALUop			<=  'b10;
			Branch		<=  'b1;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b1;
			end	
			state13:// EBREAK
			begin 
			next_state <= state0;
			Debug		<=  'b1;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b0;
			ALU_src_B	<=  'b00;
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;
			end		
			/*
			state14:// EBREAK
			begin 
			next_state <= state0;
			Debug		<=  'b1;
			done 			<=  'b0;
			Reg_Write 	<=  'b0;
			Mem_Read		<=  'b0;
			Mem_Write	<=  'b0;
			ALU_src_A	<=  'b0;
			ALU_src_B	<=  'b00;
			ALUop			<=  'b10;
			Branch		<=  'b0;
			WB_Mux_sel  <=  'b00;
			PC_Write		<=  'b0;
			end
				*/
			default: 
			begin 
						next_state <= state0;
			end
		endcase
	end
end

endmodule 
