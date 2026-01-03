`timescale 1ns/10ps

// 1-bit full adder
module adder (a, b, cin, cout, sum);
	input  logic a, b, cin;
	output logic cout, sum;
	
	logic ab, acin, bcin;
	
	// cout logic
	and #50 and0 (ab, a, b);
	and #50 and1 (acin, a, cin);
	and #50 and2 (bcin, b, cin);
	or  #50 or0  (cout, ab, acin, bcin);
	
	// sum logic
	xor #50 xor0 (sum, a, b, cin); 
endmodule // adder