`timescale 1ns/10ps

// Encoding: 00 = use RF value, 01 = forward from EX stage, 10 = forward from MEM stage.
module forwarding_unit (
    input  logic [4:0] SrcA_RF,      // Rn
    input  logic [4:0] SrcB_RF,      // Reg2Loc result (Rm or Rd for CBZ)
    input  logic [4:0] Rd_EX,        // dest in EX stage
    input  logic [4:0] Rd_MEM,       // dest in MEM stage
    input  logic       RegWrite_EX,  // EX writes back
    input  logic       RegWrite_MEM, // MEM writes back
    output logic [1:0] Forward_A,
    output logic [1:0] Forward_B
);

    always_comb begin
        Forward_A = 2'b00;
        Forward_B = 2'b00;

        // EX hazards first (newest)
        if (RegWrite_EX && (Rd_EX != 5'd31) && (Rd_EX == SrcA_RF))
            Forward_A = 2'b01; // Forward from EX stage
        else if (RegWrite_MEM && (Rd_MEM != 5'd31) && (Rd_MEM == SrcA_RF))
            Forward_A = 2'b10; // Forward from MEM stage

        if (RegWrite_EX && (Rd_EX != 5'd31) && (Rd_EX == SrcB_RF))
            Forward_B = 2'b01; // Forward from EX stage
        else if (RegWrite_MEM && (Rd_MEM != 5'd31) && (Rd_MEM == SrcB_RF))
            Forward_B = 2'b10; // Forward from MEM stage
    end

endmodule