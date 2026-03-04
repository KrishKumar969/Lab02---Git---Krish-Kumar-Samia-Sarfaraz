// ============================================================
// logic_module.v
// 32-bit Logic Operations Module
// Pure Verilog-2001 - works in Vivado without SV mode
// ============================================================

module AND_32bit (
    input  wire [31:0] A,
    input  wire [31:0] B,
    output [31:0] result
);

    assign result = A & B;

endmodule