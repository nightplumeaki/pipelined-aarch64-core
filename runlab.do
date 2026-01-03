# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./*.sv"

# vlog +define+BENCHMARK="./benchmarks/test01_AddiB.arm" "./instructmem.sv"
# vlog +define+BENCHMARK="./benchmarks/test02_AddsSubs.arm" "./instructmem.sv"
# vlog +define+BENCHMARK="./benchmarks/test03_CbzB.arm" "./instructmem.sv"
# vlog +define+BENCHMARK="./benchmarks/test04_LdurStur.arm" "./instructmem.sv"
# vlog +define+BENCHMARK="./benchmarks/test05_Blt.arm" "./instructmem.sv"
# vlog +define+BENCHMARK="./benchmarks/test06_AndEorLsr.arm" "./instructmem.sv"
# vlog +define+BENCHMARK="./benchmarks/test10_forwarding.arm" "./instructmem.sv"
# vlog +define+BENCHMARK="./benchmarks/test11_Sort.arm" "./instructmem.sv"
vlog +define+BENCHMARK="./benchmarks/test12_CRC16.arm" "./instructmem.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpustim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cpustim_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
