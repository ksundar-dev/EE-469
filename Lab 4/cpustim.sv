//Kavin Sundar
//Lab 4 - Pipelined CPU
`timescale 1ns/10ps
// Top-level testbench for the pipelined CPU. The clock period is huge
// (same as Lab 3) so that every 50ps gate in the datapath
module cpustim ();

	parameter ClockPeriod = 1000000; // 1,000,000 ps = 1us
	parameter NumCycles   = 1000; // comfortably more than any provided test program needs

	logic clk, reset;
	wire [63:0] PC_out;

	cpu dut (.clk(clk), .reset(reset), .PC_out(PC_out));

	initial $timeformat(-9, 2, " ns", 10);

	// Clock generation
	initial begin
		clk = 0;
		forever #(ClockPeriod/2) clk = ~clk;
	end

	// Reset pulse, then run the program for NumCycles clocks.
	integer i;
	initial begin
		reset = 1;
		@(posedge clk);
		@(negedge clk);
		reset = 0;

		for (i = 0; i < NumCycles; i = i + 1) begin
			@(posedge clk);
			#(1); // let settle
			$display("%t  PC=%0d (0x%0h)  IF_instr=%b  ID_instr=%b", $time, PC_out, PC_out,
			          dut.instruction_IF, dut.instruction_ID);
		end

		$display("\n%t ---- Final register file contents ----", $time);
		for (i = 0; i < 32; i = i + 1)
			$display("X%0d = %0d (0x%h)", i, $signed(dut.rf.regout[i]), dut.rf.regout[i]);

		$display("\n%t ---- Data memory bytes [0:15] ----", $time);
		for (i = 0; i < 16; i = i + 1)
			$display("mem[%0d] = 0x%h", i, dut.dmem.mem[i]);

		$finish;
	end

endmodule
