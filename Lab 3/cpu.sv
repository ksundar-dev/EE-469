//Kavin Sundar
//Lab 3
//7/20
`timescale 1ps/1ps
// Single-cycle LEGv8 CPU the TOP LEVEL. All operations (register selects,
// ALU operand selects, PC selects, PC+4/branch-target math, branch-taken
// determination)  built from  Mux2/Mux4/PCReg/FlagsReg/IsZero64, 
// all  MUX2to1_1bit + D_FF + basic gates, plus
// three reused `alu` for all the  arithmetic atff
module cpu (clk, reset, PC_out);
 
	input  clk, reset;
	output [63:0] PC_out;
 
	localparam ALU_ADD = 3'b010;
 
	// Program counter
	wire [63:0] PC, NextPC;
	PCReg pcreg (.q(PC), .d(NextPC), .reset(reset), .clk(clk));
	assign PC_out = PC;
 
	// Instruction fetch
	wire [31:0] instruction;
	instructmem imem (.address(PC), .instruction(instruction), .clk(clk));
 
	// Control unit (RTL, narrow signals only)
	wire         RegWrite, MemRead, MemWrite, RegDst, ReadReg2Src, FlagWrite;
	wire         UncondBranch, IsBR, IsCBZ, IsBLT, ImmSelBranch;
	wire [1:0]   ALUSrcB, RegWriteSrc;
	wire [2:0]   ALUCntrl;
 
	controlunit cu (
		.instruction(instruction),
		.RegWrite(RegWrite), .ALUSrcB(ALUSrcB), .ALUCntrl(ALUCntrl),
		.MemRead(MemRead), .MemWrite(MemWrite), .RegWriteSrc(RegWriteSrc),
		.RegDst(RegDst), .ReadReg2Src(ReadReg2Src), .FlagWrite(FlagWrite),
		.UncondBranch(UncondBranch), .IsBR(IsBR), .IsCBZ(IsCBZ), .IsBLT(IsBLT),
		.ImmSelBranch(ImmSelBranch)
		);
 
	// Instruction field extraction (plain wire slices)
	wire [4:0] Rn, Rm, Rdt;
	assign Rn  = instruction[9:5];
	assign Rm  = instruction[20:16];
	assign Rdt = instruction[4:0];
 
	// Immediates
	wire [63:0] ZeroExtImm12, SignExtImm9, SignExtImm19x4, SignExtImm26x4;
	ImmGen immgen (.instruction(instruction), .ZeroExtImm12(ZeroExtImm12),
	               .SignExtImm9(SignExtImm9), .SignExtImm19x4(SignExtImm19x4),
	               .SignExtImm26x4(SignExtImm26x4));
 
	// Register file
	wire [4:0]  ReadRegister2, WriteRegister;
	wire [63:0] ReadData1, ReadData2, RegWriteData;
 
	Mux2 #(5) rr2mux (.out(ReadRegister2), .a(Rm), .b(Rdt), .sel(ReadReg2Src));
	Mux2 #(5) wrmux  (.out(WriteRegister), .a(Rdt), .b(5'd30), .sel(RegDst));
 
	regfile rf (
		.ReadData1(ReadData1), .ReadData2(ReadData2), .WriteData(RegWriteData),
		.ReadRegister1(Rn), .ReadRegister2(ReadRegister2),
		.WriteRegister(WriteRegister), .RegWrite(RegWrite), .clk(clk)
		);
	// Main ALU
	wire [63:0] ALUSrcBValue, ALUResult;
	wire        ALU_negative, ALU_zero, ALU_overflow, ALU_carry_out;
 
	Mux4 #(64) alusrcbmux (.out(ALUSrcBValue), .in0(ReadData2), .in1(SignExtImm9),
	                       .in2(ZeroExtImm12), .in3(64'b0), .sel(ALUSrcB));
 
	alu main_alu (.A(ReadData1), .B(ALUSrcBValue), .cntrl(ALUCntrl),
	              .result(ALUResult), .negative(ALU_negative), .zero(ALU_zero),
	              .overflow(ALU_overflow), .carry_out(ALU_carry_out));
 
	// Flags register (captures negative/overflow only on ADDS/SUBS;
	// B.LT reads these stored bits, not the live ALU output)
	wire flag_negative, flag_overflow;
	FlagsReg flags (.negative_out(flag_negative), .overflow_out(flag_overflow),
	                .negative_in(ALU_negative), .overflow_in(ALU_overflow),
	                .FlagWrite(FlagWrite), .clk(clk));
 
	// Data memory (doubleword accesses only, per this ISA subset)
	wire [63:0] MemReadData;
	datamem dmem (.address(ALUResult), .write_enable(MemWrite), .read_enable(MemRead),
	              .write_data(ReadData2), .clk(clk), .xfer_size(4'd8), .read_data(MemReadData));
 
	// PC+4 and branch-target adders (reusing the ALU project itself)
	wire [63:0] PC_plus4, BranchOffset, BranchTarget;
 
	alu pc4_alu (.A(PC), .B(64'd4), .cntrl(ALU_ADD), .result(PC_plus4),
	             .negative(), .zero(), .overflow(), .carry_out());
 
	Mux2 #(64) branchimm_mux (.out(BranchOffset), .a(SignExtImm19x4),
	                          .b(SignExtImm26x4), .sel(ImmSelBranch));
 
	alu branch_alu (.A(PC), .B(BranchOffset), .cntrl(ALU_ADD), .result(BranchTarget),
	                .negative(), .zero(), .overflow(), .carry_out());
 
	// Branch-taken determination (structural gates, since it directly
	// drives the datapath's PC-select mux)
	wire cbz_is_zero;
	IsZero64 cbzcheck (.out(cbz_is_zero), .in(ReadData2));
 
	wire blt_taken;
	xor #50 (blt_taken, flag_negative, flag_overflow);
 
	wire cbz_term, blt_term, branch_taken;
	and #50 (cbz_term, IsCBZ, cbz_is_zero);
	and #50 (blt_term, IsBLT, blt_taken);
	or  #50 (branch_taken, UncondBranch, cbz_term, blt_term);
 
	// PCSrcSel: 00=PC+4, 01=BranchTarget, 10=ReadData1 (BR target), 11=unused.
	// IsBR and branch_taken are mutually exclusive by construction (only one
	// instruction-type branch in controlunit's if-else chain ever fires), so
	// no extra combining gate is needed -- just direct wire routing.
	wire [1:0] PCSrcSel;
	assign PCSrcSel[0] = branch_taken;
	assign PCSrcSel[1] = IsBR;
 
	// in2 = ReadData2, not ReadData1: BR's target register is encoded in the
	// Rd/Rt field, which ReadRegister2 is routed to (via ReadReg2Src) for BR,
	// same as it is for STUR's store-data register.
	Mux4 #(64) pcmux (.out(NextPC), .in0(PC_plus4), .in1(BranchTarget),
	                  .in2(ReadData2), .in3(64'b0), .sel(PCSrcSel));
 
	// Register write-back data select
	Mux4 #(64) wbmux (.out(RegWriteData), .in0(ALUResult), .in1(MemReadData),
	                  .in2(PC_plus4), .in3(64'b0), .sel(RegWriteSrc));
 
endmodule
 
