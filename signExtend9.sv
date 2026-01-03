`timescale 1ns/10ps

module signExtend9 (in, out);
	input  logic [8:0] in;
	output logic [63:0] out;
	
	assign out[8:0] = in;
	
	genvar i;
	generate
		for (i = 9; i < 64; i++) begin : SIGN_FO
			assign out[i] = in[8];
		end
	endgenerate
endmodule // signExtend9