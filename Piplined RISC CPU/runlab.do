# runlab.do -- Lab 4: ARM Pipelined CPU
# cpustim is the top-level testbench module (not "<module>_testbench"),
# so this targets it directly.
# NOTE: instructmem.sv picks the benchmark program via the `BENCHMARK
# macro near the top of that file -- uncomment the test you want to run
# there before invoking this script.

vlib work

vlog -sv D_FF.sv
vlog -sv MUX2to1_1bit.sv
vlog -sv MUX32to1_1bit.sv
vlog -sv REG64.sv
vlog -sv RegDecoder.sv
vlog -sv regfile.sv
vlog -sv FullAdder.sv
vlog -sv MUX8to1_1bit.sv
vlog -sv alu.sv
vlog -sv Mux2.sv
vlog -sv Mux4.sv
vlog -sv PCReg.sv
vlog -sv FlagsReg.sv
vlog -sv IsZero64.sv
vlog -sv ImmGen.sv
vlog -sv controlunit.sv
vlog -sv PipeReg.sv
vlog -sv RegMatch.sv
vlog -sv IsReg31.sv
vlog -sv ForwardMux.sv
vlog -sv ForwardSelect.sv
vlog -sv cpu.sv
vlog -sv datamem.sv
vlog -sv instructmem.sv
vlog -sv cpustim.sv

vsim -voptargs=+acc work.cpustim

do cpu_wave.do

run -all
