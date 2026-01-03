`timescale 1ns/10ps

module signExtend19 (in, out);
	input  logic [18:0] in;
	output logic [63:0] out;
	
	assign out[18:0] = in;
	
	genvar i;
	generate
		for (i = 19; i < 64; i++) begin : SIGN_FO
			assign out[i] = in[18];
		end
	endgenerate
endmodule // signExtend19