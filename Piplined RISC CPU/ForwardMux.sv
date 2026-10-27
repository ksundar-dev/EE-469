//Kavin Sundar
//Lab 4 (Pipelined CPU)
`timescale 1ps/1ps
// Priority mux for register forwarding: chooses among the raw register-file
// read and up to three forwarded candidate values (being the WB, MEM, and EX
//  stages), with EX taking priority over MEM, which is ver WB, which is over the raw value. 
// Just chaining three of the Mux2 modules ot each select
// simply overrides everything decided before it
module ForwardMux (out, raw, wbVal, wbSel, memVal, memSel, exVal, exSel);

	output [63:0] out;
	input  [63:0] raw, wbVal, memVal, exVal;
	input          wbSel, memSel, exSel;

	wire [63:0] afterWb, afterMem;

	Mux2 #(64) wbmux  (.out(afterWb),  .a(raw),     .b(wbVal),  .sel(wbSel));
	Mux2 #(64) memmux (.out(afterMem), .a(afterWb), .b(memVal), .sel(memSel));
	Mux2 #(64) exmux  (.out(out),      .a(afterMem),.b(exVal),  .sel(exSel));

endmodule
