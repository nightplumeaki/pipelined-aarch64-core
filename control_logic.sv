`timescale 1ns/10ps

module control_logic (Opcode, negative, zero, overflow, carry_out,
							 Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, ALUop, UpdateFlags);
	input  logic [31:21] Opcode;
	input  logic			negative, zero, overflow, carry_out;
	output logic 			Reg2Loc, RegWrite, MemWrite, BrTaken, UncondBr, UpdateFlags;
	output logic [ 2: 0] ALUop;
	output logic [ 1: 0] ALUSrc, MemToReg;
	
	parameter [10: 0] ADDI = 11'b1001000100x,
							ADDS = 11'b10101011000,
							 AND = 11'b10001010000,
							   B = 11'b000101xxxxx,
							B_LT = 11'b01010100xxx,
							 CBZ = 11'b10110100xxx,
							 EOR = 11'b11001010000,
							LDUR = 11'b11111000010,
							 LSR = 11'b11010011010,
							STUR = 11'b11111000000,
							SUBS = 11'b11101011000;
	always_comb begin
		casex(Opcode)
			ADDI: begin
				Reg2Loc  = 1'b0;
				ALUSrc   = 2'b10;
				ALUop    = 3'b010;
				MemToReg = 2'b00;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end // ADDI
			
			ADDS: begin
				Reg2Loc  = 1'b1;
				ALUSrc   = 2'b00;
				ALUop    = 3'b010;
				MemToReg = 2'b00;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b1;
			end // ADDS
			
			AND: begin
				Reg2Loc  = 1'b1;
				ALUSrc   = 2'b00;
				ALUop    = 3'b100;
				MemToReg = 2'b00;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end // AND
			
			B: begin
				Reg2Loc  = 1'b0;
				ALUSrc   = 2'b00;
				ALUop    = 3'b000;
				MemToReg = 2'b00;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
				BrTaken  = 1'b1;
				UncondBr = 1'b1;
				UpdateFlags = 1'b0;
			end // B
			
			B_LT: begin
				Reg2Loc  = 1'b0;
				ALUSrc   = 2'b00;
				ALUop    = 3'b000;
				MemToReg = 2'b00;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
				BrTaken  = (negative ^ overflow);
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end // B.LT
			
			CBZ: begin
				Reg2Loc  = 1'b0;
				ALUSrc   = 2'b00;
				ALUop    = 3'b000;
				MemToReg = 2'b00;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
				BrTaken  = zero;
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end // CBZ
			
			EOR: begin
				Reg2Loc  = 1'b1;
				ALUSrc   = 2'b00;
				ALUop    = 3'b110;
				MemToReg = 2'b00;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end // EOR
			
			LDUR: begin
				Reg2Loc  = 1'b0;
				ALUSrc   = 2'b01;
				ALUop    = 3'b010;
				MemToReg = 2'b01;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end // LDUR
			
			LSR: begin
				Reg2Loc  = 1'b0;
				ALUSrc   = 2'b00;
				ALUop    = 3'b000;
				MemToReg = 2'b10;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end // LSR
			
			STUR: begin
				Reg2Loc  = 1'b0;
				ALUSrc   = 2'b01;
				ALUop    = 3'b010;
				MemToReg = 2'b00;
				RegWrite = 1'b0;
				MemWrite = 1'b1;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end
			
			SUBS: begin
				Reg2Loc  = 1'b1;
				ALUSrc   = 2'b00;
				ALUop    = 3'b011;
				MemToReg = 2'b00;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b1;
			end
			
			default: begin
				Reg2Loc  = 1'b0;
				ALUSrc   = 2'b00;
				ALUop    = 3'b000;
				MemToReg = 2'b00;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
				BrTaken  = 1'b0;
				UncondBr = 1'b0;
				UpdateFlags = 1'b0;
			end
		
		endcase // Opcode
	end // always_comb
							 
endmodule // control_logic