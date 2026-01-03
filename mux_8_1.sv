`timescale 1ns/10ps

module mux_8_1 (sel, in, out);
	input  logic [2:0] sel;
	input  logic [7:0] in;
	output logic 		 out;
	
	logic [3:0] s0_out;
	logic [1:0] s1_out;
	
	genvar i;
	
	// Stage 0: 8 -> 4
	generate
		for (i = 0; i < 4; i++) begin : gen_mux_s0
			mux_2_1 m0 (.sel(sel[0]), .in(in[2*i+1:2*i]), .out(s0_out[i]));
		end // gen_mux_s0
	endgenerate
	
	// Stage 1: 4 -> 2
	generate
		for (i = 0; i < 2; i++) begin : gen_mux_s1
			mux_2_1 m1 (.sel(sel[1]), .in(s0_out[2*i+1:2*i]), .out(s1_out[i]));
		end // gen_mux_s1
	endgenerate
	
	// Stage 2: 2 -> 1
	mux_2_1 m2 (.sel(sel[2]), .in(s1_out), .out);
	
endmodule // mux_8_1