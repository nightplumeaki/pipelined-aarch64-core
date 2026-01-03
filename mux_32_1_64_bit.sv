`timescale 1ns/10ps

module mux_32_1_64_bit (sel, in, out);
	input  logic [ 4:0] sel;
	input  logic [31:0][63:0] in; // 32x64-bit input
	output logic [63:0] out;
	
	logic [63:0][31:0] transposed;
	
	genvar i, j;
	
	generate
		for (i = 0; i < 64; i++) begin : outerFlip
			for (j = 0; j < 32; j++) begin : innerFlip
				assign transposed[i][j] = in[j][i];
			end
		end
	endgenerate
	
	genvar k;
	
	generate
		for (k = 0; k < 64; k++) begin : generate_mux_32_1
			mux_32_1 bit_mux (.sel, .in(transposed[k][31:0]), .out(out[k]));
		end // generate_mux_32_1
	endgenerate
	
endmodule // mux_32_1_64_bitgenere
