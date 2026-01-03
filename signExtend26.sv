`timescale 1ns/10ps

module signExtend26 (in, out);
	input  logic [25:0] in;
	output logic [63:0] out;
	
	assign out[25:0] = in;
	
	genvar i;
	generate
		for (i = 26; i < 64; i++) begin : SIGN_FO
			assign out[i] = in[25];
		end
	endgenerate
endmodule // signExtend26