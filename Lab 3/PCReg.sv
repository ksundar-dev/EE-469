//Kavin Sundar
//Lab 3
//7/20
`timescale 1ps/1ps
// The Program Counter. Unlike REG64 the PC always takes a new value every clock
// single-cycle CPU advances the PC on every cycle, so no write-enable/
// feedback-mux is needed here, just 64 D_FFs with a reset input
module PCReg (q, d, reset, clk);

	output [63:0] q;
	input  [63:0] d;
	input         reset;
	input         clk;

	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin : BITS
			D_FF ff (.q(q[i]), .d(d[i]), .reset(reset), .clk(clk));
		end
	endgenerate

endmodule
