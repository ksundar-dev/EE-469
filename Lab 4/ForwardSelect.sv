//Kavin Sundar
//Lab 4 (Pipelined CPU)
`timescale 1ps/1ps
// Complete forwarding decision for ONE register-file read port (Rn or
// Rm/Rt). Given the raw regfile output and the destination-register +
// write-enable + candidate-value information currently sitting in the EX,
// MEM, and WB pipeline stages, produces the value that instruction in ID
// should actually see this cycle -- covering the "0 delay slot needed"
// case (EX, i.e. the immediately preceding instruction), the "1 delay
// slot" case (MEM, e.g. a load whose data just came back from memory),
// and the "2 delay slot" / same-cycle-as-writeback case (WB).
//
// A destination of X31 is explicitly excluded from ever winning a forward
// (regardless of RegWrite), since X31 is architecturally hardwired to 0 --
// this is Issue #1 from the lab handout.
module ForwardSelect (
	value,
	raw, readreg,
	wreg_ex,  regwrite_ex,  val_ex,
	wreg_mem, regwrite_mem, val_mem,
	wreg_wb,  regwrite_wb,  val_wb
	);

	output [63:0] value;

	input  [63:0] raw;
	input  [4:0]  readreg;

	input  [4:0]  wreg_ex;
	input         regwrite_ex;
	input  [63:0] val_ex;

	input  [4:0]  wreg_mem;
	input         regwrite_mem;
	input  [63:0] val_mem;

	input  [4:0]  wreg_wb;
	input         regwrite_wb;
	input  [63:0] val_wb;

	// Register-number matches
	wire eqEx, eqMem, eqWb;
	RegMatch mEx  (.match(eqEx),  .a(readreg), .b(wreg_ex));
	RegMatch mMem (.match(eqMem), .a(readreg), .b(wreg_mem));
	RegMatch mWb  (.match(eqWb),  .a(readreg), .b(wreg_wb));

	// X31-destination exclusion (a write to X31 is architecturally a no-op)
	wire is31Ex, is31Mem, is31Wb;
	IsReg31 r31Ex  (.is31(is31Ex),  .r(wreg_ex));
	IsReg31 r31Mem (.is31(is31Mem), .r(wreg_mem));
	IsReg31 r31Wb  (.is31(is31Wb),  .r(wreg_wb));

	wire not31Ex, not31Mem, not31Wb;
	not #50 (not31Ex,  is31Ex);
	not #50 (not31Mem, is31Mem);
	not #50 (not31Wb,  is31Wb);

	// Final per-stage select = register matches AND stage writes a
	// register AND that register isn't X31
	wire selEx_t, selMem_t, selWb_t;
	wire selEx, selMem, selWb;
	and #50 (selEx_t,  eqEx,  regwrite_ex);
	and #50 (selEx,    selEx_t,  not31Ex);
	and #50 (selMem_t, eqMem, regwrite_mem);
	and #50 (selMem,   selMem_t, not31Mem);
	and #50 (selWb_t,  eqWb,  regwrite_wb);
	and #50 (selWb,    selWb_t,  not31Wb);

	ForwardMux fm (
		.out(value), .raw(raw),
		.wbVal(val_wb),  .wbSel(selWb),
		.memVal(val_mem),.memSel(selMem),
		.exVal(val_ex),  .exSel(selEx)
		);

endmodule
