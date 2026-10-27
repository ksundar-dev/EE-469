//Kavin Sundar
//Lab 4 (Pipelined CPU)
`timescale 1ps/1ps
// 5-bit cpmnapaere used by the forwarding logic to test whether a
// register being read in ID matches the destination register of an
// instruction further down the pipeline. Built liek the ALU's
// bit-compare logic: an XNOR per bit, tehn a 4-input AND
// followed by a 2-input AND to cobine the 5 XNOR outputs (keeps every
// gate at <=4 inputs).
module RegMatch (match, a, b);

	output match;
	input  [4:0] a, b;

	wire [4:0] xn;

	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1) begin : BITCMP
			xnor #50 (xn[i], a[i], b[i]);
		end
	endgenerate

	wire and4;
	and #50 (and4, xn[0], xn[1], xn[2], xn[3]);
	and #50 (match, and4, xn[4]);

endmodule
