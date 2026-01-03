`timescale 1ns/10ps 

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);

	input  logic [63:0] A,B;
	input  logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	
	logic [63:1] carryConnection;
	
	bit_ALU first (.A(A[0]),.B(B[0]), .cin(cntrl[0]), .cout(carryConnection[1]), .cntrl, .result(result[0])); 
	
	genvar i;
	
	generate
		for(i = 1; i < 63; i++) begin: ALU63_1
			bit_ALU middleChain (.A(A[i]),.B(B[i]), .cin(carryConnection[i]), .cout(carryConnection[i+1]), .cntrl, .result(result[i]));
		end
	endgenerate

	bit_ALU last (.A(A[63]),.B(B[63]), .cin(carryConnection[63]), .cout(carry_out), .cntrl, .result(result[63]));


	// overflow logic
	xor #50 xor0 (overflow, carryConnection[63], carry_out);
	
	// negative logic
	assign negative = result[63];
	
	// zero logic
	zero_flag zeroFlag (.in(result), .isZero(zero));

endmodule // alu