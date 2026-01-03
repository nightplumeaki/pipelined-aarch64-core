`timescale 1ns/10ps

module RF_EX_regs (
        clk, reset,
        ReadData1_in, ReadData2_in,
        Imm9_in, Imm12_in, Branch_Target_in,
        Rd_in,
        Shamt_in,
        RegWrite_in, MemWrite_in, MemToReg_in, ALUop_in, ALUSrc_in,
        UpdateFlags_in, BrTaken_in,
        ReadData1_out, ReadData2_out,
        Imm9_out, Imm12_out, Branch_Target_out,
        Rd_out,
        Shamt_out,
        RegWrite_out, MemWrite_out, MemToReg_out, ALUop_out, ALUSrc_out,
        UpdateFlags_out, BrTaken_out
    );

    input  logic clk, reset;

    input  logic [63:0] ReadData1_in;
    input  logic [63:0] ReadData2_in;
    input  logic [63:0] Imm9_in;
    input  logic [63:0] Imm12_in;
    input  logic [63:0] Branch_Target_in;

    input  logic [4:0]  Rd_in;
    input  logic [5:0]  Shamt_in;

    input  logic        RegWrite_in;
    input  logic        MemWrite_in;
    input  logic [1:0]  MemToReg_in;
    input  logic [2:0]  ALUop_in;
    input  logic [1:0]  ALUSrc_in;
    input  logic        UpdateFlags_in;
    input  logic        BrTaken_in;

    output logic [63:0] ReadData1_out;
    output logic [63:0] ReadData2_out;
    output logic [63:0] Imm9_out;
    output logic [63:0] Imm12_out;
    output logic [63:0] Branch_Target_out;

    output logic [4:0]  Rd_out;
    output logic [5:0]  Shamt_out;

    output logic        RegWrite_out;
    output logic        MemWrite_out;
    output logic [1:0]  MemToReg_out;
    output logic [2:0]  ALUop_out;
    output logic [1:0]  ALUSrc_out;
    output logic        UpdateFlags_out;
    output logic        BrTaken_out;

    // 64-bit payloads
    reg_64 r1_reg    (.clk(clk), .reset(reset), .write(1'b1), .in(ReadData1_in),  .out(ReadData1_out));
    reg_64 r2_reg    (.clk(clk), .reset(reset), .write(1'b1), .in(ReadData2_in),  .out(ReadData2_out));
    reg_64 imm9_r    (.clk(clk), .reset(reset), .write(1'b1), .in(Imm9_in),       .out(Imm9_out));
    reg_64 imm12_r   (.clk(clk), .reset(reset), .write(1'b1), .in(Imm12_in),      .out(Imm12_out));
    reg_64 br_tgt_r  (.clk(clk), .reset(reset), .write(1'b1), .in(Branch_Target_in), .out(Branch_Target_out));

    // Register specifiers
    reg_5 rd_reg     (.clk(clk), .reset(reset), .write(1'b1), .in(Rd_in), .out(Rd_out));

    // Shamt
    reg_1 sh0 (.clk(clk), .reset(reset), .write(1'b1), .in(Shamt_in[0]), .out(Shamt_out[0]));
    reg_1 sh1 (.clk(clk), .reset(reset), .write(1'b1), .in(Shamt_in[1]), .out(Shamt_out[1]));
    reg_1 sh2 (.clk(clk), .reset(reset), .write(1'b1), .in(Shamt_in[2]), .out(Shamt_out[2]));
    reg_1 sh3 (.clk(clk), .reset(reset), .write(1'b1), .in(Shamt_in[3]), .out(Shamt_out[3]));
    reg_1 sh4 (.clk(clk), .reset(reset), .write(1'b1), .in(Shamt_in[4]), .out(Shamt_out[4]));
    reg_1 sh5 (.clk(clk), .reset(reset), .write(1'b1), .in(Shamt_in[5]), .out(Shamt_out[5]));
    
    // Control signals
    reg_1 rw_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(RegWrite_in),    .out(RegWrite_out));
    reg_1 mw_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(MemWrite_in),    .out(MemWrite_out));
    reg_1 uf_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(UpdateFlags_in), .out(UpdateFlags_out));
    reg_1 bt_reg   (.clk(clk), .reset(reset), .write(1'b1), .in(BrTaken_in),     .out(BrTaken_out));

    reg_1 mtr_0    (.clk(clk), .reset(reset), .write(1'b1), .in(MemToReg_in[0]), .out(MemToReg_out[0]));
    reg_1 mtr_1    (.clk(clk), .reset(reset), .write(1'b1), .in(MemToReg_in[1]), .out(MemToReg_out[1]));

    reg_1 asrc_0   (.clk(clk), .reset(reset), .write(1'b1), .in(ALUSrc_in[0]),   .out(ALUSrc_out[0]));
    reg_1 asrc_1   (.clk(clk), .reset(reset), .write(1'b1), .in(ALUSrc_in[1]),   .out(ALUSrc_out[1]));

    reg_1 aluop_0  (.clk(clk), .reset(reset), .write(1'b1), .in(ALUop_in[0]),    .out(ALUop_out[0]));
    reg_1 aluop_1  (.clk(clk), .reset(reset), .write(1'b1), .in(ALUop_in[1]),    .out(ALUop_out[1]));
    reg_1 aluop_2  (.clk(clk), .reset(reset), .write(1'b1), .in(ALUop_in[2]),    .out(ALUop_out[2]));
endmodule
