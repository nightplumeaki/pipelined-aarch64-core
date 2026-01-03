`timescale 1ns/10ps

module adder_64 (A, B, result);
	input  logic [63:0] A, B;
	output logic [63:0] result;
	
	logic [64:1] carryConnection;
	
	adder bit_adder_first (.a(A[0]), .b(B[0]), .cin(0), .cout(carryConnection[1]), .sum(result[0]));
	
	genvar i;
	generate
		for (i = 1; i < 63; i++) begin
			adder bit_adder (.a(A[i]), .b(B[i]), .cin(carryConnection[i]), .cout(carryConnection[i+1]), .sum(result[i]));
		end
	endgenerate
	
	adder bit_adder_last (.a(A[63]), .b(B[63]), .cin(carryConnection[63]), .cout(carryConnection[64]), .sum(result[63]));
	
endmodule // adder_64