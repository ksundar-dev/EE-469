//Kavin Sundar 7/2
// Lab 1
`timescale 1ps/1ps
//2 to 1 MUX FROM SIMPLE GATES
module MUX2to1_1bit (out, a, b, sel);
	output out;
	input  a, b, sel;
	
	wire nsel, t1, t2;

	not #50 g_inv  (nsel, sel);
	and #50 g_and1 (t1, a, nsel);
	and #50 g_and2 (t2, b, sel);
	or  #50 g_or   (out, t1, t2);

endmodule
