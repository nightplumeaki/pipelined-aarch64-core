`timescale 1ns/10ps

module reg_1 (clk, reset, write, in, out);
	input  logic    clk, reset, write;
	input  logic    in;
	output logic    out;
    
	logic d_in; // mux output to D_FF
    
	mux_2_1 write_en_mux (.sel(write), .in({in, out}), .out(d_in));
	D_FF ff (.q(out), .d(d_in), .reset, .clk);
    
endmodule // reg_1