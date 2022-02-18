module instruction_decoder(inst,opcode,RS1,RS2,RSD);
input  [31:0] inst;
output [4:0] RS1,RS2,RSD;
output [6:0] opcode;

assign opcode[6:0] = inst[6:0];
assign RS2[4:0] = inst[24:20];
assign RS1[4:0] = inst[19:15];
assign RSD[4:0] = inst[11:7];




endmodule 