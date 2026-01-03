`timescale 1ns/10ps

module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input  logic clk;
	input  logic RegWrite;
	
	input  logic [ 4:0] WriteRegister, ReadRegister1, ReadRegister2;
	input  logic [63:0] WriteData;
	
	output logic [63:0] ReadData1, ReadData2;
	
	logic [31:0] 		 decRegConnection; 
	logic [31:0][63:0] regMuxConnection;
	logic					 reset;
	
	decoder_5_32 decBlock (.en(RegWrite), .in(WriteRegister), .out(decRegConnection));
	
	assign reset = 0;

	genvar i;
	
	generate
		for (i = 0; i < 31; i++) begin : genReg
			reg_64 regs(.clk, .reset, .write(decRegConnection[i]), .in(WriteData), .out(regMuxConnection[i]));
	
		end
		
		assign regMuxConnection[31] = 0;
		
	endgenerate
	
	mux_32_1_64_bit mux1 (.sel(ReadRegister1), .in(regMuxConnection), .out(ReadData1));
	mux_32_1_64_bit mux2 (.sel(ReadRegister2), .in(regMuxConnection), .out(ReadData2));	
	
endmodule // regfile