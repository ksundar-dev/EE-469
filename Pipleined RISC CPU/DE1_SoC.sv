//Kavin SUndar
//Lab 1
//7/3
`timescale 1ps/1ps
//TOP LEVEL TO TEST ON HARDWARE. NEVER ACTUALLY CHECKED AS I DONT HAV EBOARD BUT I AM USED TO KEEPING
//A TOP LEVEL FROm EE 371
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input  logic         CLOCK_50; // 50MHz clock.
	output logic  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic  [9:0]  LEDR;
	input  logic  [3:0]  KEY; // True when not pressed, False when pressed
	input  logic  [9:0]  SW;

	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic reset;
	/*
	logic [31:0] div_clk;

	assign reset = SW[9];
	parameter whichClock = 25;	// 0.75 Hz clock
	clock_divider cdiv (.clock(CLOCK_50),
                       .reset(reset),
                       .divided_clocks(div_clk));

	// Clock selection; allows for easy switching between sim and board clocks
	logic clkSelect;
	// Detect when we're in Quartus and use the divided clock,
	// otherwise assume we're in ModelSim and use the fast clock
	`ifdef ALTERA_RESERVED_QIS
	    assign clkSelect = div_clk[whichClock]; // for board
	`else
	    assign clkSelect = CLOCK_50; // for simulation
	`endif
	*/
	//SET UP FSMS ETC
	// Wire up ALU	
	logic  [63:0] A, B;
	logic  [2:0]  cntrl;
	logic  [63:0] result;
	logic         negative, zero, overflow, carry_out;
 
	assign cntrl = SW[2:0];
	assign A     = {60'b0, SW[6:3]};
	assign B     = {61'b0, SW[9:7]};
 
	alu alurun(.*);
	
	

endmodule
