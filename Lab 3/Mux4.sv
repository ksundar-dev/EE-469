//Kavin Sundar
//Lab 3
//7/20
`timescale 1ps/1ps
// Mux4.sv
// specfic 4 to Mux but with 3 
module Mux4 #(parameter WIDTH = 64) (out, in0, in1, in2, in3, sel);

	output [WIDTH-1:0] out;
	input  [WIDTH-1:0] in0, in1, in2, in3;
	input  [1:0]        sel;

	wire [WIDTH-1:0] lo, hi;

	Mux2 #(WIDTH) mlo (.out(lo), .a(in0), .b(in1), .sel(sel[0]));
	Mux2 #(WIDTH) mhi (.out(hi), .a(in2), .b(in3), .sel(sel[0]));
	Mux2 #(WIDTH) mfin (.out(out), .a(lo), .b(hi), .sel(sel[1]));

endmodule
