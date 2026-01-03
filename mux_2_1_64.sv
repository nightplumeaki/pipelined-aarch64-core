`timescale 1ns/10ps

module mux_2_1_64 (
    input  logic        sel,
    input  logic [63:0] in0,   // input when sel = 0
    input  logic [63:0] in1,   // input when sel = 1
    output logic [63:0] out
);
    genvar i;
    generate
        for (i = 0; i < 64; i++) begin : MUX_BIT
            mux_2_1 mux_bit (
                .sel (sel),
                .in  ({in1[i], in0[i]}),
                .out (out[i])
            );
        end
    endgenerate
endmodule // mux_2_1_64
