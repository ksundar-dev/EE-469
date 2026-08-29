//Kavin Sundar
//Lab 2
//7/10
//a 8 to 1 Mux that calls the 2 to 1 muxs (three times 2^3 = 8).
`timescale 1ps/1ps
module MUX8to1_1bit (out, in, sel);
	output out;
   input  [7:0] in;
   input  [2:0] sel;

   wire [3:0] level1;
   wire [1:0] level2;

   genvar i;
   generate
		for (i = 0; i < 4; i = i + 1) begin : L1
			//first mux
			MUX2to1_1bit m1 (.out(level1[i]),.a(in[2*i]),.b(in[2*i+1]),.sel(sel[0]));
      end
      for (i = 0; i < 2; i = i + 1) begin : L2
			//second mux
         MUX2to1_1bit m2 (.out(level2[i]),.a(level1[2*i]),.b(level1[2*i+1]),.sel(sel[1]));
      end
   endgenerate
	//third and final mux with other two muxs outputs as in
   MUX2to1_1bit m3 (.out(out), .a(level2[0]), .b(level2[1]), .sel(sel[2]));

endmodule
