
module branchAdder (
    input  [31:0] PC,           // current PC value
    input  [31:0] Imm,          // sign-extended immediate from immGen
    output [31:0] BranchTarget  // branch target address: PC + (Imm << 1)
);

    assign BranchTarget = PC + (Imm << 1);

endmodule
