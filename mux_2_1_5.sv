`timescale 1ns/10ps

module mux_2_1_5 (
    input  logic        sel,
    input  logic [4:0] in0,   // input when sel = 0
    input  logic [4:0] in1,   // input when sel = 1
    output logic [4:0] out
);
    genvar i;
    generate
        for (i = 0; i < 5; i++) begin : MUX_BIT
            mux_2_1 mux_bit (
                .sel (sel),
                .in  ({in1[i], in0[i]}),
                .out (out[i])
            );
        end
    endgenerate
endmodule // mux_2_1_5
