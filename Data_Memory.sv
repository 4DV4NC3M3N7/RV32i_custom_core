module Data_Memory(Write_Data,Address,Mem_Read,Mem_Write,Read_Data);
input [31:0] Write_Data,Address;
input Mem_Read,Mem_Write;
output [31:0] Read_Data;

single_port_ram RAM(.data(Write_Data),.address(Address[3:0]),.out(Read_Data),.we(Mem_Write),.re(Mem_Read));

endmodule 

module single_port_ram(data,address,we,re,out);

input [31:0] data;
input reg[3:0] address;
input we,re;
output reg[31:0] out;

reg [31:0] mem [15:0];
//reg [3:0] addr_reg;

always @(posedge we or posedge re)begin
	
	if(we) mem[address] <= data;
	else out <= mem[address]; 
	
end
	//assign out = rom[addr_reg];
	
endmodule






/*
module single_port_ram
#( parameter ADDR_WIDTH = 4,
	parameter DATA_WIDTH = 32,
	parameter DEPTH = 16
	)
	(clk,addr,data,cs,we,oe);
input clk;
input [ADDR_WIDTH-1:0]	addr;
inout [DATA_WIDTH-1:0]	data;
input cs,we,oe;
reg [DATA_WIDTH-1:0] tmp_data;
reg [DATA_WIDTH-1:0] mem [DEPTH];

always @ (posedge clk) begin

if (cs & we) mem[addr] <= data;

end 

always @ (posedge clk) begin

if (cs & !we) tmp_data <= mem[addr];

end 

assign data = cs& oe & !we ? tmp_data:'hz;

endmodule 
*/