`timescale 1ns/10ps

module mux_2_1 (sel, in, out);
	input  logic 		 sel;
	input  logic [1:0] in;
	output logic 		 out;
	
	logic sel0, sel1;
	logic nsel;
	
	not #50 not0 (nsel, sel);
	
	and #50 and0 (sel0, nsel, in[0]);
	and #50 and1 (sel1,  sel, in[1]);
	
	or #50 or0 (out, sel0, sel1);
	
endmodule // mux_2_1