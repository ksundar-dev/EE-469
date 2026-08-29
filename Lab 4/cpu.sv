//Kavin Sundar
//Lab 4 - Pipelined LEGv8 CPU
`timescale 1ps/1ps
// 5-stage pipelined LEGv8 CPU: IF -> ID -> EX -> MEM -> WB.
//
// every branch (B, BL, BR, CBZ, B.LT) is resolved
// combinationally in the ID stage, off the IF/ID pipeline register, using
// register/flag values.  the PC only updates once per cycle 
// and the instruction that is being fetched was already committed to fetch 
// cycle
module cpu (clk, reset, PC_out);
 
	input clk, reset;
	output [63:0] PC_out;
 
	localparam ALU_ADD = 3'b010;
 
 // IF stge
	wire [63:0] PC, NextPC;
	PCReg pcreg (.q(PC), .d(NextPC), .reset(reset), .clk(clk));
	assign PC_out = PC;
 
	wire [31:0] instruction_IF;
	instructmem imem (.address(PC), .instruction(instruction_IF), .clk(clk));
 
	// Default "no branch  this cycle" sonext-fetch adress
	wire [63:0] PC_plus4_IF;
	alu pc4_alu (.A(PC), .B(64'd4), .cntrl(ALU_ADD), .result(PC_plus4_IF),
	.negative(), .zero(), .overflow(), .carry_out());
 
	// IF/ID pipeline register: carries the fetched instruction plus its
	// own PC (needed in ID to compute branch targets and BL's link value)
	wire [95:0] ifid_d, ifid_q;
	assign ifid_d = {PC, instruction_IF};
	PipeReg #(96) ifid_reg (.q(ifid_q), .d(ifid_d), .reset(reset), .clk(clk));
 
	wire [63:0] PC_ID;
	wire [31:0] instruction_ID;
	assign {PC_ID, instruction_ID} = ifid_q;
 
	// ID stage
	wire RegWrite, MemRead, MemWrite, RegDst, ReadReg2Src, FlagWrite;
	wire UncondBranch, IsBR, IsCBZ, IsBLT, ImmSelBranch;
	wire [1:0] ALUSrcB, RegWriteSrc;
	wire [2:0] ALUCntrl;
 
	controlunit cu (.instruction(instruction_ID),.RegWrite(RegWrite), .ALUSrcB(ALUSrcB), .ALUCntrl(ALUCntrl),
	.MemRead(MemRead), .MemWrite(MemWrite), .RegWriteSrc(RegWriteSrc),.RegDst(RegDst), .ReadReg2Src(ReadReg2Src), .FlagWrite(FlagWrite),
	.UncondBranch(UncondBranch), .IsBR(IsBR), .IsCBZ(IsCBZ), .IsBLT(IsBLT),.ImmSelBranch(ImmSelBranch));
 
	// Instruction field extraction
	wire [4:0] Rn, Rm, Rdt;
	assign Rn = instruction_ID[9:5];
	assign Rm = instruction_ID[20:16];
	assign Rdt = instruction_ID[4:0];
 
	// Immediates
	wire [63:0] ZeroExtImm12, SignExtImm9, SignExtImm19x4, SignExtImm26x4;
	ImmGen immgen (.instruction(instruction_ID), .ZeroExtImm12(ZeroExtImm12),
	.SignExtImm9(SignExtImm9), .SignExtImm19x4(SignExtImm19x4),
	.SignExtImm26x4(SignExtImm26x4));
 
	// Register file 
	wire [4:0] ReadRegister2, WriteRegister_ID;
	wire [63:0] ReadData1_raw, ReadData2_raw;
	wire [63:0] RegWriteData_WB;
	wire [4:0] WriteRegister_WB;
	wire RegWrite_WB;
 
	Mux2 #(5) rr2mux (.out(ReadRegister2), .a(Rm), .b(Rdt), .sel(ReadReg2Src));
	Mux2 #(5) wrmux (.out(WriteRegister_ID), .a(Rdt), .b(5'd30), .sel(RegDst));
 
	regfile rf (.ReadData1(ReadData1_raw), .ReadData2(ReadData2_raw), .WriteData(RegWriteData_WB),
	.ReadRegister1(Rn), .ReadRegister2(ReadRegister2),.WriteRegister(WriteRegister_WB), .RegWrite(RegWrite_WB), .clk(clk));
 
	// Forwarding network (fed by EX/MEM/WB-stage signals produced
	// further down in this file by the EX/MEM/WB pipeline stages to these
	wire [4:0] WriteRegister_EX, WriteRegister_MEM;
	wire RegWrite_EX_for_fwd, RegWrite_MEM;
	wire [63:0] EarlyWBValue_EX, RegWriteData_MEM;
	wire FlagWrite_EX, ALU_negative_EX, ALU_overflow_EX;
 
	wire [63:0] ReadData1_fwd, ReadData2_fwd;
 
	ForwardSelect fwd1 (.value(ReadData1_fwd), .raw(ReadData1_raw), .readreg(Rn),.wreg_ex(WriteRegister_EX), .regwrite_ex(RegWrite_EX_for_fwd), .val_ex(EarlyWBValue_EX),
	.wreg_mem(WriteRegister_MEM),.regwrite_mem(RegWrite_MEM), .val_mem(RegWriteData_MEM),.wreg_wb(WriteRegister_WB), .regwrite_wb(RegWrite_WB), .val_wb(RegWriteData_WB));
 
	ForwardSelect fwd2 (
	.value(ReadData2_fwd), .raw(ReadData2_raw), .readreg(ReadRegister2),
	.wreg_ex(WriteRegister_EX), .regwrite_ex(RegWrite_EX_for_fwd), .val_ex(EarlyWBValue_EX),
	.wreg_mem(WriteRegister_MEM),.regwrite_mem(RegWrite_MEM), .val_mem(RegWriteData_MEM),
	.wreg_wb(WriteRegister_WB), .regwrite_wb(RegWrite_WB), .val_wb(RegWriteData_WB));
 
	// Flags forwarding
	wire flagsrc_negative, flagsrc_overflow;
	MUX2to1_1bit flagfwdN (.out(flagsrc_negative), .a(flag_negative_reg), .b(ALU_negative_EX), .sel(FlagWrite_EX));
	MUX2to1_1bit flagfwdO (.out(flagsrc_overflow), .a(flag_overflow_reg), .b(ALU_overflow_EX), .sel(FlagWrite_EX));
 
	// rBanch-taken determination (early, in ID) 
	wire cbz_is_zero;
	IsZero64 cbzcheck (.out(cbz_is_zero), .in(ReadData2_fwd));
 
	wire blt_taken;
	xor #50 (blt_taken, flagsrc_negative, flagsrc_overflow);
 
	wire cbz_term, blt_term, branch_taken;
	and #50 (cbz_term, IsCBZ, cbz_is_zero);
	and #50 (blt_term, IsBLT, blt_taken);
	or #50 (branch_taken, UncondBranch, cbz_term, blt_term);
 
	wire [1:0] PCSrcSel;
	assign PCSrcSel[0] = branch_taken;
	assign PCSrcSel[1] = IsBR;
 
	// Branch target = this (ID-stage) PC + offset
	wire [63:0] BranchOffset, BranchTarget;
	Mux2 #(64) branchimm_mux (.out(BranchOffset), .a(SignExtImm19x4),
	.b(SignExtImm26x4), .sel(ImmSelBranch));
	alu branch_alu (.A(PC_ID), .B(BranchOffset), .cntrl(ALU_ADD), .result(BranchTarget),
	.negative(), .zero(), .overflow(), .carry_out());
 
	// BL's link value =  PC + 4 
	wire [63:0] PCLink_ID;
	alu pclink_alu (.A(PC_ID), .B(64'd4), .cntrl(ALU_ADD), .result(PCLink_ID),
	.negative(), .zero(), .overflow(), .carry_out());
 
	// PCSrcSel: 00=PC+4, 01=BranchTarget, 10=ReadData2 (BR target), 11=unused.
	// in2 = ReadData2_fwd
	Mux4 #(64) pcmux (.out(NextPC), .in0(PC_plus4_IF), .in1(BranchTarget),
	.in2(ReadData2_fwd), .in3(64'b0), .sel(PCSrcSel));
 
	// ALUSrcB select, resolved here 
	wire [63:0] ALUSrcBValue;
	Mux4 #(64) alusrcbmux (.out(ALUSrcBValue), .in0(ReadData2_fwd), .in1(SignExtImm9),
	.in2(ZeroExtImm12), .in3(64'b0), .sel(ALUSrcB));
 
	// ID/EX pipeline register 270 bits
	wire [269:0] idex_d, idex_q;
	assign idex_d = {ReadData1_fwd, ALUSrcBValue, ReadData2_fwd, PCLink_ID,
	WriteRegister_ID, ALUCntrl, RegWrite, MemRead, MemWrite,
	RegWriteSrc, FlagWrite};
	PipeReg #(270) idex_reg (.q(idex_q), .d(idex_d), .reset(reset), .clk(clk));
 
	wire [63:0] ALU_A_EX, ALU_B_EX, StoreData_EX, PCLink_EX;
	wire [2:0] ALUCntrl_EX;
	wire RegWrite_EX, MemRead_EX, MemWrite_EX;
	wire [1:0] RegWriteSrc_EX;
	assign {ALU_A_EX, ALU_B_EX, StoreData_EX, PCLink_EX, WriteRegister_EX,
	ALUCntrl_EX, RegWrite_EX, MemRead_EX, MemWrite_EX, RegWriteSrc_EX,
	FlagWrite_EX} = idex_q;
 
	// EX stage
	wire [63:0] ALUResult_EX;
	wire ALU_zero_EX, ALU_carry_EX;
 
	alu main_alu (.A(ALU_A_EX), .B(ALU_B_EX), .cntrl(ALUCntrl_EX),
	.result(ALUResult_EX), .negative(ALU_negative_EX), .zero(ALU_zero_EX),
	.overflow(ALU_overflow_EX), .carry_out(ALU_carry_EX));
 
	// Flags register
	FlagsReg flags (.negative_out(flag_negative_reg), .overflow_out(flag_overflow_reg),
	.negative_in(ALU_negative_EX), .overflow_in(ALU_overflow_EX),
	.FlagWrite(FlagWrite_EX), .reset(reset), .clk(clk));
 
	// A load's EX-stage ALU output is a meme addres, so the immediate-EX-stage forward tap
	// must never happen for da load
	wire nMemRead_EX;
	not #50 (nMemRead_EX, MemRead_EX);
	and #50 (RegWrite_EX_for_fwd, RegWrite_EX, nMemRead_EX);
 
	// The value THIS EX-stage instruction will eventually write back, for
	// the EX-forward tap. Loads are excluded above can only be the ALU result
	// or the link value for BL 
	Mux2 #(64) exfwdmux (.out(EarlyWBValue_EX), .a(ALUResult_EX), .b(PCLink_EX), .sel(RegWriteSrc_EX[1]));
 
	// EX/MEM pipeline register 202 bits
	wire [201:0] exmem_d, exmem_q;
	assign exmem_d = {ALUResult_EX, StoreData_EX, PCLink_EX, WriteRegister_EX,
	RegWrite_EX, MemRead_EX, MemWrite_EX, RegWriteSrc_EX};
	PipeReg #(202) exmem_reg (.q(exmem_q), .d(exmem_d), .reset(reset), .clk(clk));
 
	wire [63:0] ALUResult_MEM, StoreData_MEM, PCLink_MEM;
	wire MemRead_MEM, MemWrite_MEM;
	wire [1:0] RegWriteSrc_MEM;
	assign {ALUResult_MEM, StoreData_MEM, PCLink_MEM, WriteRegister_MEM,
	RegWrite_MEM, MemRead_MEM, MemWrite_MEM, RegWriteSrc_MEM} = exmem_q;
 
	// MEM stage
	wire [63:0] MemReadData_MEM;
	datamem dmem (.address(ALUResult_MEM), .write_enable(MemWrite_MEM), .read_enable(MemRead_MEM),
	.write_data(StoreData_MEM), .clk(clk), .xfer_size(4'd8), .read_data(MemReadData_MEM));
 
	// Register write-back data select. This is also, unmodified, the value
	// this stage offers the ID-stage forwarding network
	Mux4 #(64) wbmux (.out(RegWriteData_MEM), .in0(ALUResult_MEM), .in1(MemReadData_MEM),
	.in2(PCLink_MEM), .in3(64'b0), .sel(RegWriteSrc_MEM));
 
	// MEM/WB pipeline register
	wire [69:0] memwb_d, memwb_q;
	assign memwb_d = {RegWriteData_MEM, WriteRegister_MEM, RegWrite_MEM};
	PipeReg #(70) memwb_reg (.q(memwb_q), .d(memwb_d), .reset(reset), .clk(clk));
 
	assign {RegWriteData_WB, WriteRegister_WB, RegWrite_WB} = memwb_q;
 
 
endmodule