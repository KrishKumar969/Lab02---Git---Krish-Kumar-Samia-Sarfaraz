module top(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  select,
    output reg  [31:0] result,
    output wire        zero
);

    // Wires to hold each submodule's output
    wire [31:0] add_out;
    wire [31:0] and_out;
    wire [31:0] or_out;
    wire [31:0] xor_out;
    wire [31:0] shl_out;
    wire [31:0] shr_out;
    wire        cout_unused;

    // ? Declare select_3 as a wire
    wire        select_bit;
    wire [2:0]  select_3;

    assign select_bit = select[3];      // MSB controls add/sub
    assign select_3   = select[2:0];    // lower 3 bits select operation

    // ? Correct module names and port names matching each submodule
    ThirtyTwobitAddSub u_add (.A(A), .B(B), .Sub(select_bit), .S(add_out), .Cout(cout_unused));
    AND_32bit          u_and (.A(A), .B(B), .result(and_out));
    OR_32bit           u_or  (.A(A), .B(B), .result(or_out));
    XOR_32bit          u_xor (.A(A), .B(B), .result(xor_out));
    shift_left         u_shl (.A(A), .result(shl_out));
    shift_right        u_shr (.A(A), .result(shr_out));

    // ? Correct case syntax: 3'b values, no assign inside always
    always @(*) begin
        case (select_3)
            3'b000: result = add_out;
            3'b001: result = xor_out;
            3'b010: result = and_out;
            3'b011: result = or_out;
            3'b100: result = shr_out;
            3'b101: result = shl_out;
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);

endmodule