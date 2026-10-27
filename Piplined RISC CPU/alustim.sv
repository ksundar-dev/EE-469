// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	//added for a 65-bit  value for computing expected add/sub + carry
	logic [64:0] wide; 
	initial begin
	
		$display("%t testing PASS_B operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		
		
		
		//MY ADDITIONS
		
		$display("%t testing add", $time);
		cntrl = ALU_ADD;
		for (i=0; i<100; i++) begin
			A = {$random(), $random()}; B = {$random(), $random()};
			#(delay);
			wide = {1'b0, A} + {1'b0, B};
			assert(result == wide[63:0] && carry_out == wide[64] &&
			       negative == result[63] && zero == (result == '0));
		end
		
 
		$display("%t testing addition edge cases (signed overflow)", $time);
		cntrl = ALU_ADD;
		// max positive + 1 => overflow, pos + pos = neg
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h8000000000000000 && overflow == 1 && negative == 1);
 
		// min negative + -1 => overflow, neg + neg = pos
		A = 64'h8000000000000000; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'h7FFFFFFFFFFFFFFF && overflow == 1 && negative == 0);
 
		// pos + neg should never overflow
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(overflow == 0);
 
		// unsigned carry_out: max unsigned + 1 wraps to 0, carry_out set
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 1 && zero == 1);
		
		
		
 
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		for (i=0; i<100; i++) begin
			A = {$random(), $random()}; B = {$random(), $random()};
			#(delay);
			wide = {1'b0, A} - {1'b0, B};
			assert(result == wide[63:0] &&
			       negative == result[63] && zero == (result == '0));
		end
		
		
 
		$display("%t testing subtraction edge cases", $time);
		// A - A = 0, zero flag set
		A = 64'hDEADBEEFCAFEBABE; B = A;
		#(delay);
		assert(result == 64'h0000000000000000 && zero == 1 && negative == 0);
 
		// min negative - 1 => overflow, neg - pos = pos
		A = 64'h8000000000000000; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h7FFFFFFFFFFFFFFF && overflow == 1 && negative == 0);
 
		// 0 - 1 => result is all 1s (negative), no signed overflow
		A = 64'h0000000000000000; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && overflow == 0);
		
		
		
 
		$display("%t testing AND", $time);
		cntrl = ALU_AND;
		for (i=0; i<100; i++) begin
			A = {$random(), $random()}; B = {$random(), $random()};
			#(delay);
			assert(result == (A & B) &&
			       negative == result[63] && zero == (result == '0));
		end
		
		
 
		$display("%t testing OR)", $time);
		cntrl = ALU_OR;
		for (i=0; i<100; i++) begin
			A = {$random(), $random()}; B = {$random(), $random()};
			#(delay);
			assert(result == (A | B) &&
			       negative == result[63] && zero == (result == '0));
		end
		
		
 
		$display("%t testing bitwise XOR", $time);
		cntrl = ALU_XOR;
		for (i=0; i<100; i++) begin
			A = {$random(), $random()}; B = {$random(), $random()};
			#(delay);
			assert(result == (A ^ B) &&
			       negative == result[63] && zero == (result == '0));
		end
		
 
		$display("%t testing ops zero/negative edge cases", $time);
		// AND of two disjoint bit patterns -> zero
		A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555; cntrl = ALU_AND;
		#(delay);
		assert(result == 64'h0000000000000000 && zero == 1);
 
		// OR of two disjoint bit patterns -> all ones (negative)
		A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555; cntrl = ALU_OR;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);
 
		// XOR of a value with itself -> zero
		A = 64'h0123456789ABCDEF; B = A; cntrl = ALU_XOR;
		#(delay);
		assert(result == 64'h0000000000000000 && zero == 1);
 
		
	end
endmodule
