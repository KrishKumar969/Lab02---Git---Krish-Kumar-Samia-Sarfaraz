// ============================================================
//  top.v  -  32-bit ALU built from 32 x ALU_1bit slices
//
//  select[3:0] encoding:
//    4'b0000 = ADD
//    4'b0001 = SUB
//    4'b0010 = AND
//    4'b0011 = OR
//    4'b0100 = XOR
//    4'b0101 = SLL (shift left  by 1)
//    4'b0110 = SRL (shift right by 1)
//
//  zero flag: high when result == 0  (used for BEQ)
// ============================================================

module top(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  select,
    output wire [31:0] result,
    output wire        zero
);

    // is_sub = 1 when doing subtraction
    wire is_sub = (select == 4'b0001);

    // op = lower 3 bits sent to every slice
    wire [2:0] op = select[2:0];

    // Conditionally invert B for subtraction (two's complement trick)
    wire [31:0] B_in;
    assign B_in[0]  = B[0]  ^ is_sub;
    assign B_in[1]  = B[1]  ^ is_sub;
    assign B_in[2]  = B[2]  ^ is_sub;
    assign B_in[3]  = B[3]  ^ is_sub;
    assign B_in[4]  = B[4]  ^ is_sub;
    assign B_in[5]  = B[5]  ^ is_sub;
    assign B_in[6]  = B[6]  ^ is_sub;
    assign B_in[7]  = B[7]  ^ is_sub;
    assign B_in[8]  = B[8]  ^ is_sub;
    assign B_in[9]  = B[9]  ^ is_sub;
    assign B_in[10] = B[10] ^ is_sub;
    assign B_in[11] = B[11] ^ is_sub;
    assign B_in[12] = B[12] ^ is_sub;
    assign B_in[13] = B[13] ^ is_sub;
    assign B_in[14] = B[14] ^ is_sub;
    assign B_in[15] = B[15] ^ is_sub;
    assign B_in[16] = B[16] ^ is_sub;
    assign B_in[17] = B[17] ^ is_sub;
    assign B_in[18] = B[18] ^ is_sub;
    assign B_in[19] = B[19] ^ is_sub;
    assign B_in[20] = B[20] ^ is_sub;
    assign B_in[21] = B[21] ^ is_sub;
    assign B_in[22] = B[22] ^ is_sub;
    assign B_in[23] = B[23] ^ is_sub;
    assign B_in[24] = B[24] ^ is_sub;
    assign B_in[25] = B[25] ^ is_sub;
    assign B_in[26] = B[26] ^ is_sub;
    assign B_in[27] = B[27] ^ is_sub;
    assign B_in[28] = B[28] ^ is_sub;
    assign B_in[29] = B[29] ^ is_sub;
    assign B_in[30] = B[30] ^ is_sub;
    assign B_in[31] = B[31] ^ is_sub;

    // Carry chain
    wire [30:0] C;
    wire        cout_final;

    // 32 x 1-bit ALU slices
    wire [31:0] alu_result;

    ALU_1bit slice0  (.a(A[0]),  .b(B_in[0]),  .cin(is_sub), .select(op), .result(alu_result[0]),  .cout(C[0]));
    ALU_1bit slice1  (.a(A[1]),  .b(B_in[1]),  .cin(C[0]),   .select(op), .result(alu_result[1]),  .cout(C[1]));
    ALU_1bit slice2  (.a(A[2]),  .b(B_in[2]),  .cin(C[1]),   .select(op), .result(alu_result[2]),  .cout(C[2]));
    ALU_1bit slice3  (.a(A[3]),  .b(B_in[3]),  .cin(C[2]),   .select(op), .result(alu_result[3]),  .cout(C[3]));
    ALU_1bit slice4  (.a(A[4]),  .b(B_in[4]),  .cin(C[3]),   .select(op), .result(alu_result[4]),  .cout(C[4]));
    ALU_1bit slice5  (.a(A[5]),  .b(B_in[5]),  .cin(C[4]),   .select(op), .result(alu_result[5]),  .cout(C[5]));
    ALU_1bit slice6  (.a(A[6]),  .b(B_in[6]),  .cin(C[5]),   .select(op), .result(alu_result[6]),  .cout(C[6]));
    ALU_1bit slice7  (.a(A[7]),  .b(B_in[7]),  .cin(C[6]),   .select(op), .result(alu_result[7]),  .cout(C[7]));
    ALU_1bit slice8  (.a(A[8]),  .b(B_in[8]),  .cin(C[7]),   .select(op), .result(alu_result[8]),  .cout(C[8]));
    ALU_1bit slice9  (.a(A[9]),  .b(B_in[9]),  .cin(C[8]),   .select(op), .result(alu_result[9]),  .cout(C[9]));
    ALU_1bit slice10 (.a(A[10]), .b(B_in[10]), .cin(C[9]),   .select(op), .result(alu_result[10]), .cout(C[10]));
    ALU_1bit slice11 (.a(A[11]), .b(B_in[11]), .cin(C[10]),  .select(op), .result(alu_result[11]), .cout(C[11]));
    ALU_1bit slice12 (.a(A[12]), .b(B_in[12]), .cin(C[11]),  .select(op), .result(alu_result[12]), .cout(C[12]));
    ALU_1bit slice13 (.a(A[13]), .b(B_in[13]), .cin(C[12]),  .select(op), .result(alu_result[13]), .cout(C[13]));
    ALU_1bit slice14 (.a(A[14]), .b(B_in[14]), .cin(C[13]),  .select(op), .result(alu_result[14]), .cout(C[14]));
    ALU_1bit slice15 (.a(A[15]), .b(B_in[15]), .cin(C[14]),  .select(op), .result(alu_result[15]), .cout(C[15]));
    ALU_1bit slice16 (.a(A[16]), .b(B_in[16]), .cin(C[15]),  .select(op), .result(alu_result[16]), .cout(C[16]));
    ALU_1bit slice17 (.a(A[17]), .b(B_in[17]), .cin(C[16]),  .select(op), .result(alu_result[17]), .cout(C[17]));
    ALU_1bit slice18 (.a(A[18]), .b(B_in[18]), .cin(C[17]),  .select(op), .result(alu_result[18]), .cout(C[18]));
    ALU_1bit slice19 (.a(A[19]), .b(B_in[19]), .cin(C[18]),  .select(op), .result(alu_result[19]), .cout(C[19]));
    ALU_1bit slice20 (.a(A[20]), .b(B_in[20]), .cin(C[19]),  .select(op), .result(alu_result[20]), .cout(C[20]));
    ALU_1bit slice21 (.a(A[21]), .b(B_in[21]), .cin(C[20]),  .select(op), .result(alu_result[21]), .cout(C[21]));
    ALU_1bit slice22 (.a(A[22]), .b(B_in[22]), .cin(C[21]),  .select(op), .result(alu_result[22]), .cout(C[22]));
    ALU_1bit slice23 (.a(A[23]), .b(B_in[23]), .cin(C[22]),  .select(op), .result(alu_result[23]), .cout(C[23]));
    ALU_1bit slice24 (.a(A[24]), .b(B_in[24]), .cin(C[23]),  .select(op), .result(alu_result[24]), .cout(C[24]));
    ALU_1bit slice25 (.a(A[25]), .b(B_in[25]), .cin(C[24]),  .select(op), .result(alu_result[25]), .cout(C[25]));
    ALU_1bit slice26 (.a(A[26]), .b(B_in[26]), .cin(C[25]),  .select(op), .result(alu_result[26]), .cout(C[26]));
    ALU_1bit slice27 (.a(A[27]), .b(B_in[27]), .cin(C[26]),  .select(op), .result(alu_result[27]), .cout(C[27]));
    ALU_1bit slice28 (.a(A[28]), .b(B_in[28]), .cin(C[27]),  .select(op), .result(alu_result[28]), .cout(C[28]));
    ALU_1bit slice29 (.a(A[29]), .b(B_in[29]), .cin(C[28]),  .select(op), .result(alu_result[29]), .cout(C[29]));
    ALU_1bit slice30 (.a(A[30]), .b(B_in[30]), .cin(C[29]),  .select(op), .result(alu_result[30]), .cout(C[30]));
    ALU_1bit slice31 (.a(A[31]), .b(B_in[31]), .cin(C[30]),  .select(op), .result(alu_result[31]), .cout(cout_final));

    // Shift results (pure wiring, zero LUTs)
    wire [31:0] sll_result = {A[30:0], 1'b0};
    wire [31:0] srl_result = {1'b0, A[31:1]};

    // Final output mux: override with shift result if needed
    assign result = (select == 4'b0101) ? sll_result :
                    (select == 4'b0110) ? srl_result :
                                          alu_result;

    assign zero = (result == 32'b0);

endmodule
