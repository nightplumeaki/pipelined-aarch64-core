# 5-Stage Pipelined ARMv8 Processor

A 64-bit ARMv8-subset CPU implemented in SystemVerilog, featuring a 5-stage pipeline with data forwarding, flag forwarding, and software-scheduled hazard resolution. Verified in ModelSim across 12 benchmark programs including bubble sort and CRC-16.

---

## Overview

| Property | Detail |
|---|---|
| Architecture | ARMv8-A subset, 64-bit |
| Pipeline depth | 5 stages (IF → RF → EX → MEM → WB) |
| Hazard handling | Data forwarding (EX/MEM priority) + delay slots |
| Supported instructions | 11 (ADDI, ADDS, AND, B, B.LT, CBZ, EOR, LDUR, LSR, STUR, SUBS) |
| Implementation | SystemVerilog, gate-level primitives |
| Simulation | ModelSim |

---

## Pipeline Architecture
```
IF → RF → EX → MEM → WB
```

| Stage | Responsibility |
|---|---|
| **IF** | Fetch instruction from ROM; compute PC+4 and branch target |
| **RF** | Read register file; decode control signals; sign/zero-extend immediates |
| **EX** | ALU operation; logical shift right (LSR); flag update and forwarding |
| **MEM** | Read/write data memory using ALU result as address |
| **WB** | Select writeback value (ALU / memory / LSR) via MemToReg mux |

Pipeline registers (`IF_RF`, `RF_EX`, `EX_MEM`, `MEM_WB`) latch all data and control signals between stages.

---

## Key Design Decisions

### 1. Data forwarding with EX/MEM priority

To resolve RAW hazards, the forwarding unit compares the destination register of instructions in EX and MEM stages against the source registers of the instruction currently in RF:
```
if (RegWrite_EX && Rd_EX != X31 && Rd_EX == SrcA) → forward from EX/MEM
else if (RegWrite_MEM && Rd_MEM != X31 && Rd_MEM == SrcA) → forward from MEM/WB
```

EX takes priority over MEM, ensuring the most recently written value wins. X31 (the zero register) is explicitly excluded to prevent false dependencies — it is hardwired to 0 in the register file and never written.

### 2. Inverted clock register file (WB→RF forwarding for free)

The register file runs on the inverted clock (`clk_inv`). This means WB writes on one clock edge and RF reads on the other — within the same cycle. As a result, the forwarding unit never needs a WB→RF case: by the time RF reads, WB has already written the correct value.

### 3. Software-scheduled hazard resolution (delay slots)

Rather than inserting hardware stalls, the processor uses delay slots:

- **Branch delay slot**: the instruction immediately after any branch (`B`, `B.LT`, `CBZ`) always executes, regardless of whether the branch is taken. The branch target is resolved in RF stage using an accelerated adder, so there is only one delay slot.
- **Load delay slot**: the instruction immediately after `LDUR` always executes. This is because the loaded value is not available until after MEM stage — there is nothing to forward yet when the following instruction needs it in EX.

In both cases, the assembler (or programmer) is responsible for placing a useful instruction or NOP in the delay slot.

### 4. Flag forwarding (gated by UpdateFlags)

Conditional branches (`B.LT`, `CBZ`) evaluate flags in RF stage. If the immediately preceding instruction updates flags (e.g. `SUBS`) and is still in EX, the stored flag registers hold stale values. The processor forwards the fresh ALU flags directly to RF, gated by `UpdateFlags_EX`:
```systemverilog
mux_2_1 FlagNegMux (.sel(UpdateFlags_EX), .in({neg_EX, flag_neg}), .out(flag_neg_fwd));
```

Without the gate, every instruction — including those with meaningless ALU outputs — would corrupt the flags.

---

## Supported Instructions

| Instruction | Type | Operation |
|---|---|---|
| `ADDI` | I | `Rd = Rn + imm12` |
| `ADDS` | R | `Rd = Rn + Rm`, sets flags |
| `SUBS` | R | `Rd = Rn - Rm`, sets flags |
| `AND` | R | `Rd = Rn & Rm` |
| `EOR` | R | `Rd = Rn ^ Rm` |
| `LSR` | R | `Rd = Rn >> shamt` (logical) |
| `LDUR` | D | `Rd = Mem[Rn + imm9]` |
| `STUR` | D | `Mem[Rn + imm9] = Rt` |
| `B` | B | `PC = PC + imm26<<2` (unconditional) |
| `B.LT` | CB | Branch if `N != V` |
| `CBZ` | CB | Branch if `Rt == 0` |

---

## Running the Simulation

### Prerequisites
- ModelSim (or Questa)
- Benchmark `.arm` files in `benchmarks/`

### Quick start
```tcl
# From the ModelSim transcript:
do runlab.do
```

This compiles all `.sv` sources, loads the default benchmark (`test12_CRC16.arm`), and opens the waveform view.

### Switching benchmarks

Edit the active `` `define BENCHMARK `` line in `instructmem.sv`, or pass it as a compile-time define:
```tcl
vlib work
vlog +define+BENCHMARK="./benchmarks/test10_forwarding.arm" "./*.sv"
vsim -voptargs="+acc" -t 1ps -lib work cpustim
do cpustim_wave.do
run -all
```

### Benchmarks

| File | Tests |
|---|---|
| `test01_AddiB` | ADDI, B |
| `test02_AddsSubs` | ADDS, SUBS, flags |
| `test03_CbzB` | CBZ, B, delay slots |
| `test04_LdurStur` | LDUR, STUR, memory addressing |
| `test05_Blt` | B.LT, conditional branches |
| `test06_AndEorLsr` | AND, EOR, LSR |
| `test10_forwarding` | Full forwarding coverage |
| `test11_Sort` | Bubble sort (all instructions) |
| `test12_CRC16` | CRC-16 (full ISA stress test) |

---

## Repository Structure
```
├── cpu.sv                  # Top-level pipeline wiring
├── control_logic.sv        # Opcode decode → control signals
├── forwarding_unit.sv      # RAW hazard detection and forwarding
├── alu.sv / bit_ALU.sv     # 64-bit ripple-carry ALU
├── regfile.sv              # 32×64-bit register file (X31 hardwired 0)
├── flag_control.sv         # NZCV flag registers with forwarding
├── *_regs.sv               # Pipeline stage registers (IF/RF, RF/EX, EX/MEM, MEM/WB)
├── instructmem.sv          # Instruction ROM
├── datamem.sv              # Byte-addressable data memory (little-endian)
├── cpustim.sv              # Testbench
├── cpustim_wave.do         # ModelSim waveform setup
├── runlab.do               # Compile and simulate script
└── benchmarks/             # .arm test programs
```

---

## Notes

- Data memory is little-endian; `xfer_size` is fixed to 8 bytes (double-word).
- `X31` is the zero register — reads always return 0, writes are silently discarded.
- The register file uses an inverted clock so WB→RF writeback completes within the same cycle as RF read, eliminating the need for a WB forwarding path.
