// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;							// expected result
	logic exp_neg, exp_zero, exp_ovf, exp_co; // expected flags
	logic [64:0] test_val_extended;				// expected result, with an extra bit holding carry out if exists
	initial begin
	
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		for (i=0; i<1000; i++) begin
			A = $random(); B = $random();
			test_val = A + B;					// expected result
			test_val_extended = {1'b0, A} + {1'b0, B}; // expected result, with an extra bit holding carry out if exists
			exp_neg = test_val[63];			// expected negative flag
			exp_zero = (test_val == '0);	// expected zero flag
			exp_ovf = (~(A[63] ^ B[63])) & (test_val[63] ^ A[63]); // If A and B have the same sign but the result has opposite sign to A and B, overflow occurs
			exp_co = test_val_extended[64]; // expected carry out flag
			#(delay);
			assert(result == test_val && negative == exp_neg && zero == exp_zero && overflow == exp_ovf && carry_out == exp_co);
		end
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		for (i=0; i<1000; i++) begin
			A = $random(); B = $random();
			test_val = A - B;					// expected result
			test_val_extended = {1'b0, A} + {1'b0, ~B} + 65'b1; // expected result, with an extra bit holding carry out if exists
			exp_neg = test_val[63];			// expected negative flag
			exp_zero = (test_val == '0);	// expected zero flag
			exp_ovf = (A[63] ^ B[63]) & (test_val[63] ^ A[63]); // If A and B have the different sign but the result has opposite sign to A, overflow occurs
			exp_co = test_val_extended[64]; // expected carry out flag
			#(delay);
			assert(result == test_val && negative == exp_neg && zero == exp_zero && overflow == exp_ovf && carry_out == exp_co);
		end
		
		$display("%t testing AND", $time);
		cntrl = ALU_AND;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			test_val = A & B;					// expected result
			exp_neg = test_val[63];			// expected negative flag
			exp_zero = (test_val == '0);	// expected zero flag
			#(delay);
			assert(result == test_val && negative == exp_neg && zero == exp_zero);
		end
		
		$display("%t testing OR", $time);
		cntrl = ALU_OR;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			test_val = A | B;					// expected result
			exp_neg = test_val[63];			// expected negative flag
			exp_zero = (test_val == '0);	// expected zero flag
			#(delay);
			assert(result == test_val && negative == exp_neg && zero == exp_zero);
		end
		
		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			test_val = A ^ B;					// expected result
			exp_neg = test_val[63];			// expected negative flag
			exp_zero = (test_val == '0);	// expected zero flag
			#(delay);
			assert(result == test_val && negative == exp_neg && zero == exp_zero);
		end
	end
endmodule
