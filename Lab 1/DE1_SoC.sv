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

	//SET UP FSMS ETC
	// Wire up regfile
	logic [4:0]  addr;
	logic [63:0] writeData;
	logic        regWrite;
	logic [63:0] readData1, readData2;

	assign addr      = SW[4:0];
	assign writeData = {60'b0, SW[8:5]};
	assign regWrite  = ~KEY[0];

	regfile rf (.ReadData1(readData1),.ReadData2(readData2),.ReadRegister1(addr),.ReadRegister2(addr),.WriteRegister(addr),.WriteData(writeData),.RegWrite(regWrite),.clk(clkSelect));

	// Display: low 24 bits of ReadData1 across HEX0-HEX5
	seg7dec d0 (.hex(readData1[3:0]),   .segments(HEX0));
	seg7dec d1 (.hex(readData1[7:4]),   .segments(HEX1));
	seg7dec d2 (.hex(readData1[11:8]),  .segments(HEX2));
	seg7dec d3 (.hex(readData1[15:12]), .segments(HEX3));
	seg7dec d4 (.hex(readData1[19:16]), .segments(HEX4));
	seg7dec d5 (.hex(readData1[23:20]), .segments(HEX5));

	// LEDs: address readback + write-in-progress indicator
	assign LEDR[4:0] = addr;
	assign LEDR[9]   = regWrite;

endmodule
