`timescale 1ns/10ps

module flag_control (clk, reset, ALU_negative, ALU_zero, ALU_overflow, ALU_carry_out, en, negative, zero, overflow, carry_out);

	input  logic clk, reset, ALU_negative, ALU_zero, ALU_overflow, ALU_carry_out, en;
	output logic negative, zero, overflow, carry_out;
	
	logic d_negative, d_zero, d_overflow, d_carry_out;
	
	
    // Negative flag path
    mux_2_1 mux_neg (
        .sel (en),
        .in  ({ALU_negative, negative}),
        .out (d_negative)
    );
    D_FF ff_neg (
        .q     (negative),
        .d     (d_negative),
        .reset (reset),
        .clk   (clk)
    );

    // Zero flag path
    mux_2_1 mux_zero (
        .sel (en),
        .in  ({ALU_zero, zero}),
        .out (d_zero)
    );
    D_FF ff_zero (
        .q     (zero),
        .d     (d_zero),
        .reset (reset),
        .clk   (clk)
    );

    // Overflow flag path
    mux_2_1 mux_ov (
        .sel (en),
        .in  ({ALU_overflow, overflow}),
        .out (d_overflow)
    );
    D_FF ff_ov (
        .q     (overflow),
        .d     (d_overflow),
        .reset (reset),
        .clk   (clk)
    );

    // Carry-out flag path
    mux_2_1 mux_carry (
        .sel (en),
        .in  ({ALU_carry_out, carry_out}),
        .out (d_carry_out)
    );
    D_FF ff_carry (
        .q     (carry_out),
        .d     (d_carry_out),
        .reset (reset),
        .clk   (clk)
    );

endmodule // flag_control