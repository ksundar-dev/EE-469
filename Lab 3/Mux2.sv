//Kavin Sundar
//Lab 3
//7/20
`timescale 1ps/1ps
//specfic mux for register to ALU
module Mux2 #(parameter WIDTH = 64) (out, a, b, sel);

	output [WIDTH-1:0] out;
	input  [WIDTH-1:0] a, b;
	input               sel;

	genvar i;
	generate
		for (i = 0; i < WIDTH; i = i + 1) begin : BITS
			MUX2to1_1bit m (.out(out[i]), .a(a[i]), .b(b[i]), .sel(sel));
		end
	endgenerate

endmodule
