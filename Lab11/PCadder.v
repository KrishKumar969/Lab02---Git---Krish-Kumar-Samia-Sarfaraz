
module pcAdder (
    input  [31:0] PC,          // current PC value
    output [31:0] PC_Plus4     // next sequential instruction address
);

    assign PC_Plus4 = PC + 32'd4;

endmodule
