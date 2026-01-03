`timescale 1ns/10ps

module MEM_WB_regs (
    clk, reset, ReadData_in, ALU_Result_in, LSR_Result_in, Rd_in,
    RegWrite_in, MemToReg_in, ReadData_out,
    ALU_Result_out, LSR_Result_out, Rd_out,
    RegWrite_out, MemToReg_out
);

    input logic clk, reset;

    input logic [63:0] ReadData_in;     // Output from datamem
    input logic [63:0] ALU_Result_in;   // Result from ALU (passed through MEM stage)
    input logic [63:0] LSR_Result_in;   // Result from shifter (passed through MEM stage)

    input logic [4:0]  Rd_in;           // Destination Register

    input logic        RegWrite_in;     // Does this instruction write back?
    input logic [1:0]  MemToReg_in;     // Mux selector for WB data

    output logic [63:0] ReadData_out;
    output logic [63:0] ALU_Result_out;
    output logic [63:0] LSR_Result_out;

    output logic [4:0]  Rd_out;

    output logic        RegWrite_out;
    output logic [1:0]  MemToReg_out;

    reg_64 mem_reg  (.clk(clk), .reset(reset), .write(1'b1), .in(ReadData_in),   .out(ReadData_out));
    reg_64 alu_reg  (.clk(clk), .reset(reset), .write(1'b1), .in(ALU_Result_in), .out(ALU_Result_out));
    reg_64 lsr_reg  (.clk(clk), .reset(reset), .write(1'b1), .in(LSR_Result_in), .out(LSR_Result_out));

    reg_5  rd_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(Rd_in),         .out(Rd_out));

    reg_1  rw_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(RegWrite_in),   .out(RegWrite_out));

    reg_1 mtr_0     (.clk(clk), .reset(reset), .write(1'b1), .in(MemToReg_in[0]), .out(MemToReg_out[0]));
    reg_1 mtr_1     (.clk(clk), .reset(reset), .write(1'b1), .in(MemToReg_in[1]), .out(MemToReg_out[1]));

endmodule // MEM_WB_regs
