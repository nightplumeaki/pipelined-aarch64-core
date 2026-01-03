`timescale 1ns/10ps

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module bit_ALU (A, B, cin, cout, cntrl, result);
	input  logic 		 A, B, cin;
	input  logic [2:0] cntrl;
	output logic 		 cout, result;

	logic sum_or_diff, bit_and, bit_or, bit_xor;
	logic b_port_input;
	logic not_B;
	
	// Negate B for subtraction: not_B = ~B
	not #50 not0 (not_B, B);
	
	// cntrl[0] = 0 -> addition (+B)
	// cntrl[0] = 1 -> subtraction (-B)
	mux_2_1 b_port_mux (.sel(cntrl[0]), .in({not_B, B}), .out(b_port_input));
	
	// Addition or subtration logic
	adder a (.a(A), .b(b_port_input), .cin, .cout, .sum(sum_or_diff));
	
	// Bitwise A & B logic
	and #50 and0 (bit_and, A, B);
	
	// Bitwise A | B logic
	or  #50 or0  (bit_or, A, B);
	
	// Bitwise A XOR B logic
	xor #50 xor0 (bit_xor, A, B);
	
	// 8:1 mux for control logic			  111    110      101     100        011          010       001 000
	mux_8_1 cntrl_mux (.sel(cntrl), .in({1'b0, bit_xor, bit_or, bit_and, sum_or_diff, sum_or_diff, 1'b0, B}), .out(result));
	
endmodule // bit_ALU