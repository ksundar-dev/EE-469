//Kavin Sundar
//Lab 2
//7/10
// a full bit addr logic as follows: sum  is = a ^ b ^ cin while cout = majority(a, b, cin) = (a&b) | (b&cin) | (a&cin)
`timescale 1ps/1ps
module FullAdder (sum, cout, a, b, cin);
	output sum, cout;
	input  a, b, cin;

   wire ab_xor;
   wire and1, and2, and3;

   // sum
   xor #50 (ab_xor, a, b);
   xor #50 (sum,ab_xor, cin);

   // carry out 3-input or, still <= 4 in
   and #50 (and1, a, b);
   and #50 (and2, b, cin);
   and #50 (and3, a, cin);
   or  #50 (cout, and1, and2, and3);

endmodule
