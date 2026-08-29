//Kavin Sundar
//Lab 5 (Pipelined CPU)
`timescale 1ps/1ps
// Detects whether a 5-bit register address equals 31 (5'b11111), i.e.
// X31. Used by the X31 is hardwired to 0 in the
// register file so  instruction that targets X31 must never be forwarded 
module IsReg31 (is31, r);

	output is31;
	input  [4:0] r;

	wire and4;
	and #50 (and4, r[0], r[1], r[2], r[3]);
	and #50 (is31, and4, r[4]);

endmodule
