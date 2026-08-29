//Kavin Sundar

//Lab 3
//7/20
`timescale 1ps/1ps
// Holds the negative/overflow flags from the most recent flag-setting
// instruction (ADDS/SUBS). B.LT reads stored bits, not whatever the
// ALU happens to be outputting during B.LT's own cycle. Same feedback-mux + D_FF
// write-enable pattern as REG64: when FlagWrite=0 each flip-flop re-latches
// its own value; when FlagWrite=1 the new ALU flags pass through.
module FlagsReg (negative_out, overflow_out, negative_in, overflow_in, FlagWrite, reset, clk);
 
	output negative_out, overflow_out;
	input  negative_in, overflow_in;
	input  FlagWrite;
	input  reset;
	input  clk;
 
	wire n_muxed, o_muxed;
 
	MUX2to1_1bit nmux (.out(n_muxed), .a(negative_out), .b(negative_in), .sel(FlagWrite));
	D_FF nff (.q(negative_out), .d(n_muxed), .reset(reset), .clk(clk));
 
	MUX2to1_1bit omux (.out(o_muxed), .a(overflow_out), .b(overflow_in), .sel(FlagWrite));
	D_FF off (.q(overflow_out), .d(o_muxed), .reset(reset), .clk(clk));
 
endmodule