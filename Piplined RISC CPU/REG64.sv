//Kavin Sundar 7/2
// Lab 1
`timescale 1ps/1ps
// A 64-bit register with a write-enable, built  from the
// given D_FF (no enable pin) plus additional gate-level logic
//Essentially flip flop to mux if we is 0 then the flip flop gets its
// q value if not a new d value is passed
module REG64 (q, d, we, clk);
	output [63:0] q;
	input  [63:0] d;
	input         we, clk;
	wire [63:0] d_mux;
	
	//c=generate the actual hardware
	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin : bitslice
			MUX2to1_1bit fbmux (.out(d_mux[i]), .a(q[i]), .b(d[i]), .sel(we));
			D_FF ff(.q(q[i]), .d(d_mux[i]), .reset(1'b0), .clk(clk));
		end
	endgenerate

endmodule
