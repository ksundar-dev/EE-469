//Kavin Sundar 7/2
// Lab 1
`timescale 1ps/1ps
// Top-level 32 x 64 ARM register file. Works as the wiring for the registers decopder, and multiplexeros.
// This is pretty much our top level module for the register file.
module regfile (ReadData1, ReadData2,ReadRegister1, ReadRegister2, WriteRegister,WriteData, RegWrite, clk);

	
	output [63:0] ReadData1;
	output [63:0] ReadData2;

	input  [4:0]  ReadRegister1;
	input  [4:0]  ReadRegister2;
	input  [4:0]  WriteRegister;
	input  [63:0] WriteData;
	input         RegWrite;
	input         clk;
	// 64-bit wire per register
	wire [63:0] regout [0:31];
	// writeenable for register
	wire [30:0] we;
	
	//Call the decoder
	RegDecoder dec (.we(we), .addr(WriteRegister), .regwrite(RegWrite));
	
	//Make real registers
	genvar r;
	generate
		for (r = 0; r < 31; r = r + 1) begin : regs
			//call registers
			REG64 reg_i (.q(regout[r]),.d(WriteData),.we(we[r]),.clk(clk));
		end
	endgenerate

	//the 31 wires stated we need
	assign regout[31] = 64'b0;

	// Build the two 64-bit-wide 32:1 muxes, one output bit at a time.
	// For each bit position b, gather bit b from all 32 registers
	// into a 32-bit column then feed it into a single-bit 32:1 mux
	genvar b, j;
	generate
		for (b = 0; b < 64; b = b + 1) begin : cols
			wire [31:0] col;
			for (j = 0; j < 32; j = j + 1) begin : gather
				assign col[j] = regout[j][b];
			end
			MUX32to1_1bit rd1 (.out(ReadData1[b]), .in(col), .sel(ReadRegister1));
			MUX32to1_1bit rd2 (.out(ReadData2[b]), .in(col), .sel(ReadRegister2));
		end
	endgenerate

endmodule
