//Kavin Sundar
//Lab 2
//7/10
//Top Level for ALU
`timescale 1ps/1ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);

    input  [63:0] A, B;
    input  [2:0]  cntrl;
    output [63:0] result;
    output        negative, zero, overflow, carry_out;

    // Constant 0, for the two unused  slots. Plain constant assign (001 or111)
    wire zero_const;
    assign zero_const = 1'b0;

    // sub = 1 for cntrl==011 (SUBTRACT), 0 for cntrl==010 (ADD).
    // For AND/OR/XOR/PASS_B this value is computed but simply never
    // routed to the output mux, so it does no harm.
    wire sub;
    assign sub = cntrl[0];


    // Adder / subtractor: B is conditionally inverted (two's complement),
    // carry chain seeded with sub as the initial carry-in.
    wire [63:0] bxor;        // B, or ~B when subtracting
    wire [63:0] sum;         // add/sub result
    wire [64:0] carry;       // carry[0] = cin, carry[64] = cout

    assign carry[0] = sub;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : ADDSUB
            xor #50 (bxor[i], B[i], sub);
            FullAdder fa (.sum(sum[i]), .cout(carry[i+1]),
                          .a(A[i]), .b(bxor[i]), .cin(carry[i]));
        end
    endgenerate

    // overflow = carry into MSB XOR carry out of MSB
    wire overflow_w;
    xor #50 (overflow_w, carry[64], carry[63]);
    assign overflow = overflow_w;

    // carry_out is a plain wire connect to the final carry
    assign carry_out = carry[64];

    // Bitwise logic arrays
    wire [63:0] andr, orr, xorr;

    generate
        for (i = 0; i < 64; i = i + 1) begin : LOGIC
            and #50 (andr[i], A[i], B[i]);
            or  #50 (orr[i],  A[i], B[i]);
            xor #50 (xorr[i], A[i], B[i]);
        end
    endgenerate

    // Per-bit 8:1 select, indexed to match cntrl directly:
    //   in[0]=B (PASS_B, 000)   in[1]=0 (unused, 001)
    //   in[2]=sum (ADD, 010)    in[3]=sum (SUB, 011)
    //   in[4]=AND (100)         in[5]=OR (101)
    //   in[6]=XOR (110)         in[7]=0 (unused, 111)
    generate
        for (i = 0; i < 64; i = i + 1) begin : RESULTMUX
            wire [7:0] muxin;
            assign muxin[0] = B[i];
            assign muxin[1] = zero_const;
            assign muxin[2] = sum[i];
            assign muxin[3] = sum[i];
            assign muxin[4] = andr[i];
            assign muxin[5] = orr[i];
            assign muxin[6] = xorr[i];
            assign muxin[7] = zero_const;

            MUX8to1_1bit rm (.out(result[i]), .in(muxin), .sel(cntrl));
        end
    endgenerate

    // negative is a plain wire connect to the MSB of result
    assign negative = result[63];

    // Zero flag: NOR-reduce all 64 result bits via a 3-level tree of
    // 4-input OR gates, then invert once.
    wire [15:0] orA;
    wire [3:0]  orB;
    wire        orC;

    generate
        for (i = 0; i < 16; i = i + 1) begin : ZEROA
            or #50 (orA[i], result[4*i], result[4*i+1], result[4*i+2], result[4*i+3]);
        end
        for (i = 0; i < 4; i = i + 1) begin : ZEROB
            or #50 (orB[i], orA[4*i], orA[4*i+1], orA[4*i+2], orA[4*i+3]);
        end
    endgenerate

    or  #50 (orC, orB[0], orB[1], orB[2], orB[3]);
    not #50 (zero, orC);

endmodule
