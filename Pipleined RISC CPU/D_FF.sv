//Kavin Sundar 7/2
// Lab 1
`timescale 1ps/1ps
// D_FF.v
// Given by the lab handout
// Positive edge-triggered D flip-flop with synchronous reset.
module D_FF (q, d, reset, clk);
  output reg q;
  input d, reset, clk;
  always_ff @(posedge clk)
    if (reset)
      q <= 0;      // On reset, set to 0
    else
      q <= d;       // Otherwise out = d
endmodule
