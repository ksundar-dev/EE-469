# Makefile -- Icarus Verilog + GTKWave flow for the pipelined LEGv8 CPU
#
# Targets:
#   make compile  -- build sim.out from all sources (errors here mean a real bug)
#   make run      -- compile (if needed) then simulate, prints the same pass/fail
#                    trace you've been checking in ModelSim, and produces dump.vcd
#   make wave     -- run (if needed) then open the waveform in GTKWave
#   make clean    -- remove build products
#
# NOTE ON BENCHMARKS: instructmem.sv's `define BENCHMARK line picks which
# .arm test program gets loaded, and its path (../benchmarks/test0X.arm) is
# resolved relative to wherever you invoke `make`/`vvp` from -- keep a
# benchmarks/ folder one level above this Makefile's directory, or edit that
# `define to a same-directory filename instead. This is the exact path
# issue that bit us in ModelSim; iverilog has the identical requirement.

SOURCES = \
	D_FF.sv \
	MUX2to1_1bit.sv \
	MUX32to1_1bit.sv \
	MUX8to1_1bit.sv \
	Mux2.sv \
	Mux4.sv \
	PCReg.sv \
	PipeReg.sv \
	REG64.sv \
	RegDecoder.sv \
	RegMatch.sv \
	IsReg31.sv \
	IsZero64.sv \
	ForwardMux.sv \
	ForwardSelect.sv \
	FlagsReg.sv \
	FullAdder.sv \
	alu.sv \
	ImmGen.sv \
	controlunit.sv \
	regfile.sv \
	datamem.sv \
	instructmem.sv \
	cpu.sv \
	cpustim.sv

TOPLEVEL = cpustim
SIM      = sim.out
VCD      = dump.vcd

.PHONY: compile run wave clean

compile: $(SIM)

$(SIM): $(SOURCES)
	iverilog -g2012 -s $(TOPLEVEL) -o $(SIM) $(SOURCES)

run: $(SIM)
	vvp $(SIM)

$(VCD): $(SIM)
	vvp $(SIM)

wave: $(VCD)
	gtkwave $(VCD) &

clean:
	rm -f $(SIM) $(VCD)
