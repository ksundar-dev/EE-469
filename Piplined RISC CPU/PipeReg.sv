//Kavin Sundar
//Lab 4 (Pipelined CPU)
`timescale 1ps/1ps
// width-parameterized pipeline register, built  from the
//  D_FF, same technique as PCReg but reusable for any
// bus width. Used for IF/ID, ID/EX, EX/MEM, and MEM/WB. On reset every bit
// clears to 0; since instruction word 32'b0 decodes as a safe NOP
//  zeroing a pipeline register is a way to  injects a pause.
module PipeReg #(parameter WIDTH = 1) (q, d, reset, clk);

	output [WIDTH-1:0] q;
	input  [WIDTH-1:0] d;
	input               reset;
	input               clk;

	genvar i;
	generate
		for (i = 0; i < WIDTH; i = i + 1) begin : BITS
			D_FF ff (.q(q[i]), .d(d[i]), .reset(reset), .clk(clk));
		end
	endgenerate

endmodule
