`timescale 1ns/10ps

module zeroExtend (in, out);
	input  logic [11:0] in;
	output logic [63:0] out;
	
	assign out[11:0] = in;
	genvar i;
	generate
		for (i = 12; i < 64; i++) begin : TIE_ZERO
			assign out[i] = 1'b0;
		end
	endgenerate
endmodule // zeroExtend