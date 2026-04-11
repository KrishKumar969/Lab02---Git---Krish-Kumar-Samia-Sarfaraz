
module mux2 (
    input  [31:0] In0,      // input 0: PC + 4
    input  [31:0] In1,      // input 1: branch target
    input         Sel,      // select signal: PCSrc from control unit
    output [31:0] Out       // selected next PC value
);

    assign Out = Sel ? In1 : In0;

endmodule
