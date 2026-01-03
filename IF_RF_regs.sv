`timescale 1ns/10ps

module IF_RF_regs (
        clk, reset,
        PC_in, Instruction_in,
        PC_out, Instruction_out
    );

    input  logic        clk, reset;
    input  logic [63:0] PC_in;            // PC from fetch
    input  logic [31:0] Instruction_in;   // Instruction from memory

    output logic [63:0] PC_out;           // PC into decode
    output logic [31:0] Instruction_out;  // Instruction into decode

    reg_64 pc_reg    (.clk(clk), .reset(reset), .write(1'b1), .in(PC_in),          .out(PC_out));
    reg_32 instr_reg (.clk(clk), .reset(reset), .write(1'b1), .in(Instruction_in), .out(Instruction_out));

endmodule // IF_RF_regs
