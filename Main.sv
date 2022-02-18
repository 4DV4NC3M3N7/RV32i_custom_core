module Main(enable,clk);
input enable,clk;
logic [31:0] PC,inst;
logic inst_fetc,reset;
		
		RV32IA core(.inst(inst),.clk_in(clk),.enable(enable),.PC_out(PC),.inst_fetc(inst_fetc),.reset(reset));
		//ROM rom(.out(inst),.address(PC));
						//.PC(PC),.inst(inst),.clk(clk));
		IMEM imem(.inst(inst),.PC(PC),.clk(inst_fetc));

endmodule 

module IMEM(inst,PC,clk);
parameter	INST_WIDTH_LENGTH = 32;
parameter	PC_WIDTH_LENGTH = 32;
parameter	MEM_WIDTH_LENGTH = 32;
parameter	MEM_DEPTH = 1<<18;
output	reg	[INST_WIDTH_LENGTH-1:0]inst;
input		[PC_WIDTH_LENGTH-1:0]PC;
input    clk;

/********* Instruction Memmory *************/
reg		[MEM_WIDTH_LENGTH-1:0]IMEM[0:255];

wire		[17:0]pWord;
wire		[1:0]pByte;

assign		pWord = PC[19:2];
assign		pByte = PC[1:0];

initial begin
$readmemh("G:/VLSI_ASIC_IC_designs/CAP_STONE_PROJECT_2/RV32i_Version/v1/RV32i_V1/instructions.bin",IMEM); 
//$readmemh("instuctions.bin",IMEM); 
end

always @(clk)
begin
	if (pByte == 2'b00)
		inst = IMEM[pWord];
	else
		inst = 'h0;
end

endmodule
