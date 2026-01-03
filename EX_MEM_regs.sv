`timescale 1ns/10ps

module EX_MEM_regs (clk, reset, ALU_Result_in, LSR_Result_in, WriteData_in, Rd_in, RegWrite_in, MemWrite_in, MemToReg_in, ALU_Result_out, 
                    LSR_Result_out, WriteData_out, Rd_out, RegWrite_out, MemWrite_out, MemToReg_out);

    input logic clk, reset;

    input logic [63:0] ALU_Result_in;   // Calculated address or ALU result
    input logic [63:0] LSR_Result_in;   // Shifter result (for LSR)
    input logic [63:0] WriteData_in;    // Data to be stored in memory (for STUR)

    input logic [4:0]  Rd_in;

    input logic        RegWrite_in;
    input logic        MemWrite_in;
    input logic [1:0]  MemToReg_in;

    output logic [63:0] ALU_Result_out;
    output logic [63:0] LSR_Result_out;
    output logic [63:0] WriteData_out;

    output logic [4:0]  Rd_out;

    output logic        RegWrite_out;
    output logic        MemWrite_out;
    output logic [1:0]  MemToReg_out;

    reg_64 alu_reg  (.clk(clk), .reset(reset), .write(1'b1), .in(ALU_Result_in), .out(ALU_Result_out));
    reg_64 lsr_reg  (.clk(clk), .reset(reset), .write(1'b1), .in(LSR_Result_in), .out(LSR_Result_out));
    reg_64 data_reg (.clk(clk), .reset(reset), .write(1'b1), .in(WriteData_in),  .out(WriteData_out));

    reg_5  rd_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(Rd_in),         .out(Rd_out));

    reg_1  rw_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(RegWrite_in),   .out(RegWrite_out));
    reg_1  mw_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(MemWrite_in),   .out(MemWrite_out));

    reg_1 mtr_0     (.clk(clk), .reset(reset), .write(1'b1), .in(MemToReg_in[0]), .out(MemToReg_out[0]));
    reg_1 mtr_1     (.clk(clk), .reset(reset), .write(1'b1), .in(MemToReg_in[1]), .out(MemToReg_out[1]));

endmodule // EX_MEM_regs