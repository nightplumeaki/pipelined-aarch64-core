`timescale 1ns/10ps 

module pc (clk, reset, in, out);
	input  logic clk, reset;
	input  logic [63:0] in;
	output logic [63:0] out;
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : gen_dff
			D_FF pc_dff (.q(out[i]), .d(in[i]), .reset, .clk);
		end
	endgenerate

endmodule // pc