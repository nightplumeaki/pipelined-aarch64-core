`timescale 1ns/10ps

module mux_4_1_64 (
    input  logic [1:0]  sel,         // 2-bit select: 00, 01, 10, 11
    input  logic [63:0] in0, in1, in2, in3, // four 64-bit inputs
    output logic [63:0] out           // 64-bit output
);
    // intermediate wires
    logic [63:0] low_out;   // result of first stage (in0 vs in1)
    logic [63:0] high_out;  // result of first stage (in2 vs in3)

    genvar i;
    generate
        for (i = 0; i < 64; i++) begin : MUX_4_TO_1
            // Stage 1: select between in0/in1 and in2/in3
            mux_2_1 mux_low  (.sel(sel[0]), .in({in1[i], in0[i]}), .out(low_out[i]));
            mux_2_1 mux_high (.sel(sel[0]), .in({in3[i], in2[i]}), .out(high_out[i]));

            // Stage 2: select between low_out/high_out
            mux_2_1 mux_final(.sel(sel[1]), .in({high_out[i], low_out[i]}), .out(out[i]));
        end
    endgenerate
endmodule // mux_4_1_64
