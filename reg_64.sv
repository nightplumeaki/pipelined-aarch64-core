`timescale 1ns/10ps

module reg_64 (clk, reset, write, in, out);
	input  logic 		  clk, reset, write;
	input  logic [63:0] in;
	output logic [63:0] out;
	
	logic [63:0] d_in; // mux outputs to D_FF
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : generate_dff
			mux_2_1 write_en_mux (.sel(write), .in({in[i], out[i]}), .out(d_in[i]));
			D_FF ff (.q(out[i]), .d(d_in[i]), .reset, .clk);
		end
	endgenerate // generate_dff
	
endmodule // reg_64