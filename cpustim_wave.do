onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /cpustim/clk
add wave -noupdate /cpustim/reset
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[31]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[30]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[29]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[28]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[27]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[26]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[25]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[24]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[23]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[22]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[21]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[20]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[19]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[18]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[17]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[16]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[15]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[14]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[13]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[12]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[11]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[10]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[9]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[8]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[7]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[6]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[5]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[4]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[3]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[2]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[1]}
add wave -noupdate -expand -group {Registers X0-31} -radix decimal {/cpustim/dut/Reg_File/regMuxConnection[0]}
add wave -noupdate -expand -group {Register File} /cpustim/dut/Reg_File/RegWrite
add wave -noupdate -expand -group {Register File} -radix decimal /cpustim/dut/Reg_File/WriteRegister
add wave -noupdate -expand -group {Register File} -radix decimal /cpustim/dut/Reg_File/ReadRegister1
add wave -noupdate -expand -group {Register File} -radix decimal /cpustim/dut/Reg_File/ReadRegister2
add wave -noupdate -expand -group {Register File} -radix decimal /cpustim/dut/Reg_File/WriteData
add wave -noupdate -expand -group {Register File} -radix decimal /cpustim/dut/Reg_File/ReadData1
add wave -noupdate -expand -group {Register File} -radix decimal /cpustim/dut/Reg_File/ReadData2
add wave -noupdate -label Instruction /cpustim/dut/Instruction_Memory/instruction
add wave -noupdate -label {Program Counter} -radix decimal /cpustim/dut/Program_counter/out
add wave -noupdate -expand -group {PC mux} /cpustim/dut/pc_mux/sel
add wave -noupdate -expand -group {PC mux} /cpustim/dut/pc_mux/in0
add wave -noupdate -expand -group {PC mux} /cpustim/dut/pc_mux/in1
add wave -noupdate -expand -group {PC mux} /cpustim/dut/pc_mux/out
add wave -noupdate -expand -group {Forwarding logic} /cpustim/dut/Forwarding_Logic/SrcA_RF
add wave -noupdate -expand -group {Forwarding logic} /cpustim/dut/Forwarding_Logic/SrcB_RF
add wave -noupdate -expand -group {Forwarding logic} /cpustim/dut/Forwarding_Logic/Rd_EX
add wave -noupdate -expand -group {Forwarding logic} /cpustim/dut/Forwarding_Logic/Rd_MEM
add wave -noupdate -expand -group {Forwarding logic} /cpustim/dut/Forwarding_Logic/RegWrite_EX
add wave -noupdate -expand -group {Forwarding logic} /cpustim/dut/Forwarding_Logic/RegWrite_MEM
add wave -noupdate -expand -group {Forwarding logic} /cpustim/dut/Forwarding_Logic/Forward_A
add wave -noupdate -expand -group {Forwarding logic} /cpustim/dut/Forwarding_Logic/Forward_B
add wave -noupdate -expand -group Forward_EX_mux /cpustim/dut/Forward_EX_mux/sel
add wave -noupdate -expand -group Forward_EX_mux /cpustim/dut/Forward_EX_mux/in0
add wave -noupdate -expand -group Forward_EX_mux /cpustim/dut/Forward_EX_mux/in1
add wave -noupdate -expand -group Forward_EX_mux /cpustim/dut/Forward_EX_mux/in2
add wave -noupdate -expand -group Forward_EX_mux /cpustim/dut/Forward_EX_mux/in3
add wave -noupdate -expand -group Forward_EX_mux /cpustim/dut/Forward_EX_mux/out
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/ALU_negative
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/ALU_zero
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/ALU_overflow
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/ALU_carry_out
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/en
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/negative
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/zero
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/overflow
add wave -noupdate -expand -group {Flag Control} /cpustim/dut/Flags/carry_out
add wave -noupdate -expand -group ALU -radix decimal /cpustim/dut/Arithmetic_Logic_Unit/A
add wave -noupdate -expand -group ALU -radix decimal /cpustim/dut/Arithmetic_Logic_Unit/B
add wave -noupdate -expand -group ALU /cpustim/dut/Arithmetic_Logic_Unit/cntrl
add wave -noupdate -expand -group ALU -radix decimal /cpustim/dut/Arithmetic_Logic_Unit/result
add wave -noupdate -expand -group ALU /cpustim/dut/Arithmetic_Logic_Unit/negative
add wave -noupdate -expand -group ALU /cpustim/dut/Arithmetic_Logic_Unit/zero
add wave -noupdate -expand -group ALU /cpustim/dut/Arithmetic_Logic_Unit/overflow
add wave -noupdate -expand -group ALU /cpustim/dut/Arithmetic_Logic_Unit/carry_out
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/Reg2Loc
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/RegWrite
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/MemWrite
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/BrTaken
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/UncondBr
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/UpdateFlags
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/ALUop
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/ALUSrc
add wave -noupdate -expand -group {Control Signals} /cpustim/dut/Control/MemToReg
add wave -noupdate -group {Data Memory} {/cpustim/dut/Data_Memory/mem[16]}
add wave -noupdate -group {Data Memory} {/cpustim/dut/Data_Memory/mem[8]}
add wave -noupdate -group {Data Memory} {/cpustim/dut/Data_Memory/mem[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6531333677 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 184
configure wave -valuecolwidth 193
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 25
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {3855601342 ps} {14144429250 ps}
