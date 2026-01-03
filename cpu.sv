`timescale 1ns/10ps

module cpu (clk, reset);

	input  logic clk, reset;

	// Inverted clock for better regfile
	logic clk_inv;
	not #50(clk_inv, clk);
	
	// IF Wires ==========================================================================================
	logic [63:0] pc_current, pc_next, pc_plus_4;
	logic [31:0] instr_fetched;
	logic [63:0] branch_target_RF, branch_target_EX;
	
	
	// RF Wires ==========================================================================================
	logic [63:0] PC_RF;
	logic [31:0] Instr_RF;
	logic [31:21] Opcode_RF;
	logic [4:0]  Rd_RF, Rn_RF, Rm_RF;
	logic [5:0]  Shamt_RF;
	logic [8:0]  Imm9_RF;
	logic [11:0] Imm12_RF;
	logic [18:0] Imm19_RF;
	logic [25:0] Imm26_RF;
	logic [63:0] Imm9_se_RF, Imm12_ze_RF, Imm19_se_RF, Imm26_se_RF;
	logic        cbz_is_zero;
	logic [63:0] Branch_Imm_RF;
	logic [63:0] ReadData1_RF, ReadData2_RF;
	logic [63:0] WriteData_WB;
	logic 		 Reg2Loc_RF, RegWrite_RF, MemWrite_RF, BrTaken_RF, UncondBr_RF, UpdateFlags_RF;
	logic [2:0]  ALUop_RF;
	logic [1:0]  ALUSrc_RF, MemToReg_RF;
	logic [4:0]  ReadReg2_Select_RF;
	logic [63:0] Shifted_Branch_Offset_RF;
	logic [1:0]  Forward_A, Forward_B;
	logic [63:0] Forward_EX_data, Forward_MEM_data;
	logic [63:0] ReadData1_fwd_RF, ReadData2_fwd_RF;
	
	
	// EX Wires ==========================================================================================
	logic [63:0] ReadData1_EX, ReadData2_EX;
	logic [63:0] Imm9_EX, Imm12_EX;
	logic [4:0]  Rd_EX;
	logic        RegWrite_EX, MemWrite_EX, UpdateFlags_EX, BrTaken_EX;
	logic [1:0]  MemToReg_EX, ALUSrc_EX;
	logic [2:0]  ALUop_EX;
	logic [5:0]  Shamt_EX;
	logic [63:0] LSR_Result_EX;
	logic [63:0] ALU_Input_B_raw;
	logic [63:0] ALU_Result_EX;
	logic        neg_EX, zero_EX, ovf_EX, cout_EX; 			// From ALU
	logic        flag_neg, flag_zero, flag_ovf, flag_cout; 	// Stored Flags
	logic        flag_neg_fwd, flag_zero_fwd, flag_ovf_fwd, flag_cout_fwd; // Forwarded flags for RF control
	
	
	// MEM Wires =========================================================================================
	logic [63:0] ALU_Result_MEM, LSR_Result_MEM, WriteData_MEM;
	logic [4:0]  Rd_MEM;
	logic        RegWrite_MEM, MemWrite_MEM;
	logic [1:0]  MemToReg_MEM;
	logic [63:0] Mem_ReadData_MEM;
	
	
	// WB Wires ==========================================================================================
	logic [63:0] Mem_ReadData_WB, ALU_Result_WB, LSR_Result_WB;
	logic [4:0]  Rd_WB;
	logic        RegWrite_WB;
	logic [1:0]  MemToReg_WB;
	
	// Constant xfer size for datamem
	logic [3:0]  xfer_size;
	assign xfer_size = 4'b1000;
	
	
	// STAGE 1: IF - Instruction Fetch ===================================================================
	mux_2_1_64 pc_mux (.sel(BrTaken_RF), .in0(pc_plus_4), .in1(branch_target_RF), .out(pc_next));
	pc Program_counter (.clk, .reset, .in(pc_next), .out(pc_current));
	adder_64 pc_adder (.A(pc_current), .B(64'd4), .result(pc_plus_4));
	instructmem Instruction_Memory (.address(pc_current), .instruction(instr_fetched), .clk);
	
	// [Pipeline Register] IF -> RF
	IF_RF_regs IF_RF (.clk, .reset,
					  .PC_in(pc_current), .Instruction_in(instr_fetched), 
					  .PC_out(PC_RF), .Instruction_out(Instr_RF));

	
	// STAGE 2: RF - Register Fetch ======================================================================
	// Instruction field extraction
	assign Rd_RF 	 = Instr_RF[ 4: 0];
	assign Rn_RF 	 = Instr_RF[ 9: 5];
	assign Rm_RF 	 = Instr_RF[20:16];
	assign Shamt_RF	 = Instr_RF[15:10];
	assign Imm9_RF 	 = Instr_RF[20:12];
	assign Imm12_RF	 = Instr_RF[21:10];
	assign Imm19_RF  = Instr_RF[23: 5];
	assign Imm26_RF	 = Instr_RF[25: 0];
	assign Opcode_RF = Instr_RF[31:21];
	
	// Control logic
	control_logic Control (.Opcode(Opcode_RF), .negative(flag_neg_fwd), .zero(cbz_is_zero), .overflow(flag_ovf_fwd), .carry_out(flag_cout_fwd), 
						   .Reg2Loc(Reg2Loc_RF), .ALUSrc(ALUSrc_RF), .MemToReg(MemToReg_RF), 
					       .RegWrite(RegWrite_RF), .MemWrite(MemWrite_RF), 
						   .BrTaken(BrTaken_RF), .UncondBr(UncondBr_RF), 
						   .ALUop(ALUop_RF), .UpdateFlags(UpdateFlags_RF));
	
	mux_2_1_5 Reg2Loc_Mux  (.sel(Reg2Loc_RF), .in0(Rd_RF), .in1(Rm_RF), .out(ReadReg2_Select_RF));
	
	// Register file
	regfile Reg_File (.ReadData1(ReadData1_RF), .ReadData2(ReadData2_RF),
				  .WriteData(WriteData_WB), 
				  .ReadRegister1(Rn_RF), .ReadRegister2(ReadReg2_Select_RF), 
				  .WriteRegister(Rd_WB), .RegWrite(RegWrite_WB), .clk(clk_inv));
							
	signExtend9  se9  (.in(Imm9_RF),  .out(Imm9_se_RF));
	zeroExtend   ze12 (.in(Imm12_RF), .out(Imm12_ze_RF));
	signExtend19 se19 (.in(Imm19_RF), .out(Imm19_se_RF));
	signExtend26 se26 (.in(Imm26_RF), .out(Imm26_se_RF));

	// Accelerate branch target calculation
	zero_flag cbz_zero_flag (.in(ReadData2_fwd_RF), .isZero(cbz_is_zero));
	mux_2_1_64 BrImm_Mux_RF (.sel(UncondBr_RF), .in0(Imm19_se_RF), .in1(Imm26_se_RF), .out(Branch_Imm_RF));
	shifter Branch_Shifter_RF (.value(Branch_Imm_RF), .direction(1'b0), .distance(6'b000010), .result(Shifted_Branch_Offset_RF));
	adder_64 Branch_Adder_RF (.A(Shifted_Branch_Offset_RF), .B(PC_RF), .result(branch_target_RF));
	
	// Forwarding Logic and Muxes
	forwarding_unit Forwarding_Logic (.SrcA_RF(Rn_RF), .SrcB_RF(ReadReg2_Select_RF),
									  .Rd_EX(Rd_EX), .Rd_MEM(Rd_MEM),
									  .RegWrite_EX(RegWrite_EX), .RegWrite_MEM(RegWrite_MEM),
									  .Forward_A(Forward_A), .Forward_B(Forward_B));

	// Forward data selections (EX/MEM stage values)
	mux_4_1_64 Forward_EX_mux  (.sel(MemToReg_EX),  .in0(ALU_Result_EX), .in1(ALU_Result_EX),
								.in2(LSR_Result_EX), .in3(ALU_Result_EX), .out(Forward_EX_data));
	mux_4_1_64 Forward_MEM_mux (.sel(MemToReg_MEM), .in0(ALU_Result_MEM), .in1(Mem_ReadData_MEM),
								.in2(LSR_Result_MEM), .in3(ALU_Result_MEM), .out(Forward_MEM_data));

	// Operand selections in RF (00=RF data, 01=EX data, 10/11=MEM data)
	mux_4_1_64 ForwardA_mux (.sel(Forward_A), .in0(ReadData1_RF), .in1(Forward_EX_data),
							 .in2(Forward_MEM_data), .in3(Forward_MEM_data), .out(ReadData1_fwd_RF));
	mux_4_1_64 ForwardB_mux (.sel(Forward_B), .in0(ReadData2_RF), .in1(Forward_EX_data),
							 .in2(Forward_MEM_data), .in3(Forward_MEM_data), .out(ReadData2_fwd_RF));

	// [Pipeline Register] RF -> EX
	RF_EX_regs RF_EX (.clk, .reset, .ReadData1_in(ReadData1_fwd_RF), .ReadData2_in(ReadData2_fwd_RF),
					.Imm9_in(Imm9_se_RF), .Imm12_in(Imm12_ze_RF), .Branch_Target_in(branch_target_RF),
					.Rd_in(Rd_RF), .Shamt_in(Shamt_RF), .RegWrite_in(RegWrite_RF), .MemWrite_in(MemWrite_RF),
					.MemToReg_in(MemToReg_RF), .ALUop_in(ALUop_RF), .ALUSrc_in(ALUSrc_RF), .UpdateFlags_in(UpdateFlags_RF),
					.BrTaken_in(BrTaken_RF),
					.ReadData1_out(ReadData1_EX), .ReadData2_out(ReadData2_EX), .Imm9_out(Imm9_EX), .Imm12_out(Imm12_EX), .Branch_Target_out(branch_target_EX),
					.Rd_out(Rd_EX), .Shamt_out(Shamt_EX), .RegWrite_out(RegWrite_EX), .MemWrite_out(MemWrite_EX),
					.MemToReg_out(MemToReg_EX), .ALUop_out(ALUop_EX), .ALUSrc_out(ALUSrc_EX), .UpdateFlags_out(UpdateFlags_EX),
					.BrTaken_out(BrTaken_EX));
	

	// STAGE 3: EX - Execution ===========================================================================
	// ALU input selection
	mux_4_1_64 ALUSrc_mux (.sel(ALUSrc_EX), .in0(ReadData2_EX), .in1(Imm9_EX), .in2(Imm12_EX), .in3(64'd0), .out(ALU_Input_B_raw));

	// Shifter (LSR), Arithmetic Logic Unit, and Flag Control
	shifter LSR_Shifter (.value(ReadData1_EX), .direction(1'b1), .distance(Shamt_EX), .result(LSR_Result_EX));
	alu Arithmetic_Logic_Unit (.A(ReadData1_EX), .B(ALU_Input_B_raw), .cntrl(ALUop_EX), .result(ALU_Result_EX),
							   .negative(neg_EX), .zero(zero_EX), .overflow(ovf_EX), .carry_out(cout_EX));
	flag_control Flags (.clk, .reset, .ALU_negative(neg_EX), .ALU_zero(zero_EX), .ALU_overflow(ovf_EX), .ALU_carry_out(cout_EX),
						.en(UpdateFlags_EX), .negative(flag_neg), .zero(flag_zero), .overflow(flag_ovf), .carry_out(flag_cout));
	// Forward freshly computed flags to RF-stage control when the instruction in EX updates them.
	mux_2_1 FlagNegMux   (.sel(UpdateFlags_EX), .in({neg_EX,  flag_neg}), .out(flag_neg_fwd));
	mux_2_1 FlagZeroMux  (.sel(UpdateFlags_EX), .in({zero_EX, flag_zero}), .out(flag_zero_fwd));
	mux_2_1 FlagOvfMux   (.sel(UpdateFlags_EX), .in({ovf_EX,  flag_ovf}), .out(flag_ovf_fwd));
	mux_2_1 FlagCoutMux  (.sel(UpdateFlags_EX), .in({cout_EX, flag_cout}), .out(flag_cout_fwd));
			
	// [Pipeline Register] EX -> MEM
	EX_MEM_regs EX_MEM (.clk, .reset,
						.ALU_Result_in(ALU_Result_EX), .LSR_Result_in(LSR_Result_EX), .WriteData_in(ReadData2_EX),
						.Rd_in(Rd_EX), .RegWrite_in(RegWrite_EX), .MemWrite_in(MemWrite_EX), .MemToReg_in(MemToReg_EX),
						.ALU_Result_out(ALU_Result_MEM), .LSR_Result_out(LSR_Result_MEM), .WriteData_out(WriteData_MEM),
						.Rd_out(Rd_MEM), .RegWrite_out(RegWrite_MEM), .MemWrite_out(MemWrite_MEM), .MemToReg_out(MemToReg_MEM));
	

	// STAGE 4: MEM - Memory Access =====================================================================
	datamem Data_Memory (.address(ALU_Result_MEM), .write_enable(MemWrite_MEM), .read_enable(1'b1),
						 .write_data(WriteData_MEM), .clk, .xfer_size(xfer_size), .read_data(Mem_ReadData_MEM));
	
	// [Pipeline Register] MEM -> WB
	MEM_WB_regs MEM_WB (.clk, .reset,
						.ReadData_in(Mem_ReadData_MEM), .ALU_Result_in(ALU_Result_MEM), .LSR_Result_in(LSR_Result_MEM),
						.Rd_in(Rd_MEM), .RegWrite_in(RegWrite_MEM), .MemToReg_in(MemToReg_MEM),
						.ReadData_out(Mem_ReadData_WB), .ALU_Result_out(ALU_Result_WB), .LSR_Result_out(LSR_Result_WB),
						.Rd_out(Rd_WB), .RegWrite_out(RegWrite_WB), .MemToReg_out(MemToReg_WB));
	

	// STAGE 5: WB - Write Back ==========================================================================
	mux_4_1_64 MemToReg_mux (.sel(MemToReg_WB), .in0(ALU_Result_WB), .in1(Mem_ReadData_WB), .in2(LSR_Result_WB), .in3(64'd0), .out(WriteData_WB));
	
endmodule // cpu_pipelined
