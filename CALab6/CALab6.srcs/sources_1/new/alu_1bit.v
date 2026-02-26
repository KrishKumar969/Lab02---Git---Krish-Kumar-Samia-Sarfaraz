// ============================================================
//  ALU_1bit.v
//  1-bit ALU slice
//
//  select[2:0] encoding:
//    000 = ADD
//    001 = SUB  (B is pre-inverted by caller, cin=1 on bit 0)
//    010 = AND
//    011 = OR
//    100 = XOR
//
//  Carry in/out chain connects 32 slices for ADD/SUB.
//  For logic/shift operations carry is irrelevant but still
//  passed through so the chain is uniform.
// ============================================================

module ALU_1bit(
    input        a,
    input        b,         // for SUB, pass ~B from top level
    input        cin,       // carry in  (from previous slice)
    input  [2:0] select,    // operation select
    output reg   result,    // 1-bit result
    output       cout       // carry out (to next slice)
);

    // Full adder internal wires
    wire fa_sum;
    wire fa_cout;

    // Full adder always runs; result mux picks it when needed
    assign fa_sum  = a ^ b ^ cin;
    assign fa_cout = (a & b) | (a & cin) | (b & cin);

    // Carry out only meaningful for ADD/SUB; tie to fa_cout always
    assign cout = fa_cout;

    always @(*) begin
        case (select)
            3'b000: result = fa_sum;   // ADD
            3'b001: result = fa_sum;   // SUB  (b is already inverted, cin carries the +1)
            3'b010: result = a & b;    // AND
            3'b011: result = a | b;    // OR
            3'b100: result = a ^ b;    // XOR
            default: result = 1'b0;
        endcase
    end

endmodule