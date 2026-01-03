`timescale 1ns/10ps

module mux_32_1 (sel, in, out);
	input  logic [ 4:0] sel;
	input  logic [31:0] in;
	output logic		  out;
	
	logic [15:0] s0_out;
	logic [ 7:0] s1_out;
	logic [ 3:0] s2_out;
	logic [ 1:0] s3_out;
	
	genvar i;
	
	// Stage 0: 32 -> 16
	generate 
		for (i = 0; i < 16; i++) begin : stage0
			mux_2_1 m0 (.sel(sel[0]), .in(in[2*i+1:2*i]), .out(s0_out[i]));
		end // stage0
	endgenerate
	
	// Stage 1: 16 -> 8
	generate 
		for (i = 0; i < 8; i++) begin : stage1
			mux_2_1 m1 (.sel(sel[1]), .in(s0_out[2*i+1:2*i]), .out(s1_out[i]));
		end // stage1
	endgenerate
	
	// Stage 2: 8 -> 4
	generate 
		for (i = 0; i < 4; i++) begin : stage2
			mux_2_1 m2 (.sel(sel[2]), .in(s1_out[2*i+1:2*i]), .out(s2_out[i]));
		end // stage2
	endgenerate
	
	// Stage 3: 4 -> 2
	generate 
		for (i = 0; i < 2; i++) begin : stage3
			mux_2_1 m3 (.sel(sel[3]), .in(s2_out[2*i+1:2*i]), .out(s3_out[i]));
		end // stage3
	endgenerate
	
	// Stage 4: 2 -> 1
	mux_2_1 m4 (.sel(sel[4]), .in(s3_out), .out);
	
endmodule // mux_32_1