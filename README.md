# Pipelined ARMv8 CPU
SystemVerilog implementation of a 5‑stage pipelined ARMv8‑A subset CPU for EE 469 Lab #4 at the University of Washington. The design includes early branch target calculation, flag forwarding, and data forwarding to minimize stalls. Simulation is set up for ModelSim.

## Layout
- `cpu.sv`: Top-level pipeline wiring (IF/RF/EX/MEM/WB), branch target acceleration, and flag forwarding.
- `control_logic.sv`: Decodes opcodes (ADDI/ADDS/AND/B/B.LT/CBZ/EOR/LDUR/LSR/STUR/SUBS) and generates control.
- `regfile.sv`, `*_regs.sv`, `mux_*.sv`, `adder*.sv`, `alu.sv`, `flag_control.sv`, `forwarding_unit.sv`: Pipeline plumbing, ALU, status flags, and hazard forwarding.
- `instructmem.sv`, `datamem.sv`: Instruction ROM (loads `.arm` benchmark files) and byte-addressable data memory.
- `cpustim.sv`, `cpustim_wave.do`, `runlab.do`: Testbench, waveform setup, and ModelSim do file.
- `benchmarks/`: Provided programs (`test01_AddiB.arm` … `test12_CRC16.arm`).

## Running the simulation (ModelSim)
1) Start ModelSim and change to this folder.  
2) From the transcript, run the provided do file:
   ```tcl
   do runlab.do
   ```
   This compiles all `.sv` sources, uses `+acc` for debugging, and launches the `cpustim` testbench with the default waveform script. The current `runlab.do` points to `benchmarks/test12_CRC16.arm`.
3) To switch benchmarks without editing the do file, re-run `vlog` with a different `BENCHMARK` define and restart `vsim`, for example:
   ```tcl
   vlib work
   vlog +define+BENCHMARK="./benchmarks/test04_LdurStur.arm" "./*.sv"
   vsim -voptargs="+acc" -t 1ps -lib work cpustim
   do cpustim_wave.do
   run -all
   ```
   Alternatively, change the active `\`define BENCHMARK` line near the top of `instructmem.sv`.

## Notes
- Clock period in `cpustim.sv` is 50 ms (50000000 ps); adjust `CLOCK_PERIOD` if you want faster simulation.
- `rd=31` is treated as `XZR` in forwarding logic to avoid false dependencies.
- Data memory is little-endian and supports 1/2/4/8-byte aligned accesses; `xfer_size` is fixed to 8 bytes in `cpu.sv`.
- Wave configuration is in `cpustim_wave.do`; add signals there if you probe new modules.
