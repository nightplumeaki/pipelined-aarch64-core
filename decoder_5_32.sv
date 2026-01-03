`timescale 1ns/10ps

module decoder_2_4 (en, in, out);
	input  logic       en;
	input  logic [1:0] in;
	output logic [3:0] out;
	
	logic [1:0] neg; // negate of input
	
	not #50 not0 (neg[0], in[0]);
	not #50 not1 (neg[1], in[1]);
	
	//	3-input AND											 out[i]	 in[1] in[0]
	and #50 out0 (out[0], en, neg[1], neg[0]); // out[0] =   0     0
	and #50 out1 (out[1], en, neg[1],  in[0]); // out[1] =   0     1
	and #50 out2 (out[2], en,  in[1], neg[0]); // out[2] =   1     0
	and #50 out3 (out[3], en,  in[1],  in[0]); // out[3] =   1     1
	
endmodule // decoder_2_4


module decoder_3_8 (en, in, out);
	input  logic       en;
	input  logic [2:0] in;
	output logic [7:0] out;
	
	logic [2:0] neg; // negate of input
	
	not #50 not0 (neg[0], in[0]);
	not #50 not1 (neg[1], in[1]);
	not #50 not2 (neg[2], in[2]);
	
	//	4-input AND														out[i]	in[2] in[1] in[0]
	and #50 out0 (out[0], en, neg[2], neg[1], neg[0]); // out[0] =   0     0     0
	and #50 out1 (out[1], en, neg[2], neg[1],  in[0]); // out[1] =   0     0     1
	and #50 out2 (out[2], en, neg[2],  in[1], neg[0]); // out[2] =   0     1     0
	and #50 out3 (out[3], en, neg[2],  in[1],  in[0]); // out[3] =   0     1     1
	and #50 out4 (out[4], en,  in[2], neg[1], neg[0]); // out[4] =   1     0     0
	and #50 out5 (out[5], en,  in[2], neg[1],  in[0]); // out[5] =   1     0     1
	and #50 out6 (out[6], en,  in[2],  in[1], neg[0]); // out[6] =   1     1     0
	and #50 out7 (out[7], en,  in[2],  in[1],  in[0]); // out[7] =   1     1     1
	
endmodule // decoder_3_8


module decoder_5_32 (en, in, out);
	input  logic        en;
	input  logic [ 4:0] in;
	output logic [31:0] out;
	
	logic [3:0] sel_dec_3_8_en;
	
	// 2:4 decoder for selecting in[4:3]
	decoder_2_4 sel_in_4_3 (.en, .in(in[4:3]), .out(sel_dec_3_8_en));
	
	// 3:8 decoder for selecting in[2:0]
	genvar i;
	generate 
		for (i = 0; i < 4; i++) begin : generate_decoder_3_8
			decoder_3_8 sel_in_2_0 (.en(sel_dec_3_8_en[i]), .in(in[2:0]), .out(out[8*i+7:8*i]));
		end // generate_decoder_3_8
	endgenerate
	
endmodule // decoder_5_32