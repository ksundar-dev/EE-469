//Kavin Sundar 7/2
// Lab 1
`timescale 1ps/1ps
// Turns WriteRegister[4:0] + RegWrite into 31 per-register write-enable lines, we[0] to we[30].
module RegDecoder (we, addr, regwrite);
	output [30:0] we;
	input  [4:0]  addr;
	input         regwrite;

	wire [4:0] naddr;
	//invert the addr 
	genvar j;
	generate
		for (j = 0; j < 5; j = j + 1) begin : inv_addr
			not #50 g_inv (naddr[j], addr[j]);
		end
	endgenerate

	genvar i;
	generate
		for (i = 0; i < 31; i = i + 1) begin : dec
			wire b0, b1, b2, b3, b4;
			wire s1, s2, s3, match;

			// Pick addr[bit] if register i's bit is 1, otherwise the
			// inverted addr bit to be resolved at elaboration time
			// since i is a constant genvar we use pure wire connect
			assign b0 = i[0] ? addr[0] : naddr[0];
			assign b1 = i[1] ? addr[1] : naddr[1];
			assign b2 = i[2] ? addr[2] : naddr[2];
			assign b3 = i[3] ? addr[3] : naddr[3];
			assign b4 = i[4] ? addr[4] : naddr[4];
			
			//and all of them togetehr
			and #50 g1 (s1, b0, b1);
			and #50 g2 (s2, s1, b2);
			and #50 g3 (s3, s2, b3);
			and #50 g4 (match, s3, b4);
			and #50 g5 (we[i], match, regwrite);
		end
	endgenerate

endmodule
