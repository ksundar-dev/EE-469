//Kavin Sundar
//Lab 3
//7/20
`timescale 1ps/1ps
// Extracts and extends every immediate field  ISA uses. Every assign
// here is  a plain field slice or a bit-replication/fanout of an
// existing wire NOTE* no two signals are ever combined through boolean logic
module ImmGen (instruction, ZeroExtImm12, SignExtImm9, SignExtImm19x4, SignExtImm26x4);

	input  [31:0] instruction;
	output [63:0] ZeroExtImm12;    // for ADDI
	output [63:0] SignExtImm9;     // for LDUR/STUR address offset
	output [63:0] SignExtImm19x4;  // for CBZ/B.LT branch offset, already <<2
	output [63:0] SignExtImm26x4;  // for B/BL branch offset, already <<2

	wire [11:0] imm12; assign imm12 = instruction[21:10];
	wire [8:0]  imm9;  assign imm9  = instruction[20:12];
	wire [18:0] imm19; assign imm19 = instruction[23:5];
	wire [25:0] imm26; assign imm26 = instruction[25:0];

	assign ZeroExtImm12   = {52'b0, imm12};
	assign SignExtImm9    = {{55{imm9[8]}}, imm9};
	assign SignExtImm19x4 = {{43{imm19[18]}}, imm19, 2'b00};
	assign SignExtImm26x4 = {{36{imm26[25]}}, imm26, 2'b00};

endmodule
