module branch(funct_3,branch,more,even,less,imm_in,imm_out);
input [2:0] funct_3;
input [31:0] imm_in;
output[31:0] imm_out;
input branch,more,even,less;
logic branch_true;
logic [31:0] temp;

	check_valid check(
					.funct_3(funct_3),
					.branch(branch),
					.more(more),
					.even(even),
					.less(less),
					.branch_true(branch_true)
					);
	
	assign imm_out = branch_true?imm_in:32'h4;
	
endmodule 

module check_valid(funct_3,branch,more,even,less,branch_true);
input [2:0] funct_3;
input branch,more,even,less;
output branch_true;
			
		assign branch_true = (~more & ~even & less & branch & ~funct_3[2] & ~funct_3[1] & funct_3[0]) | 
									(~more & ~even & less & branch & funct_3[2] & ~funct_3[0]) | 
									(~more & even & ~less & branch & ~funct_3[2] & ~funct_3[1] & ~funct_3[0]) | 
									(more & ~even & ~less & ~branch & funct_3[2] & ~funct_3[1] & funct_3[0]) | 
									(more & ~even & ~less & branch & ~funct_3[2] & ~funct_3[1] & funct_3[0]) | 
									(more & ~even & ~less & branch & funct_3[2] & funct_3[1] & funct_3[0]);
				
endmodule 