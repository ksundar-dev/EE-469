
# runlab.do -- Lab 2: ARM ALU
# alustim.sv's module is literally named "alustim" (not "alu_testbench"),
# so this targets it directly instead of the generic run.do template.

vlib work

vlog -sv FullAdder.sv
vlog -sv MUX2to1_1bit.sv
vlog -sv MUX8to1_1bit.sv
vlog -sv alu.sv
vlog -sv alustim.sv

vsim -voptargs=+acc work.alustim

do alustim_wave.do

run -all
