
# runlab.do -- Lab 3: ARM Single-Cycle CPU
# cpustim is the top-level testbench module (not "<module>_testbench"),
# so this targets it directly
# NOTE: datamem.sv and instructmem.sv(we want instruct)

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
vlog -sv cpu.sv
vlog -sv datamem.sv
vlog -sv instructmem.sv
vlog -sv cpustim.sv

vsim -voptargs=+acc work.cpustim

do cpu_wave.do

run -all
