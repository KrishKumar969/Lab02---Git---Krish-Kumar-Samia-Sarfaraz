// ============================================================
// Main Control Unit - Single-Cycle RISC-V (RV32I)
// EE/CE 321L/371L  Lab 9
//
// Input  : opcode[6:0]
// Outputs: RegWrite, ALUOp[1:0], MemRead, MemWrite,
//          ALUSrc, MemtoReg, Branch
// ============================================================
module main_control (
    input  wire [6:0] opcode,
    output reg        RegWrite,
    output reg [1:0]  ALUOp,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        ALUSrc,
    output reg        MemtoReg,
    output reg        Branch
);

    // RISC-V opcode definitions
    localparam OP_RTYPE  = 7'b0110011; // ADD, SUB, SLL, SRL, AND, OR, XOR
    localparam OP_ITYPE  = 7'b0010011; // ADDI
    localparam OP_LOAD   = 7'b0000011; // LW, LH, LB
    localparam OP_STORE  = 7'b0100011; // SW, SH, SB
    localparam OP_BRANCH = 7'b1100011; // BEQ

    always @(*) begin
        // Safe defaults (don't-care ? 0)
        RegWrite = 1'b0;
        ALUOp    = 2'b00;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        Branch   = 1'b0;

        case (opcode)
            // --------------------------------------------------
            // R-type: ADD, SUB, SLL, SRL, AND, OR, XOR
            // --------------------------------------------------
            OP_RTYPE: begin
                RegWrite = 1'b1;
                ALUOp    = 2'b10;   // ALU control decodes funct3/funct7
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUSrc   = 1'b0;    // second operand from register
                MemtoReg = 1'b0;    // write-back from ALU
                Branch   = 1'b0;
            end

            // --------------------------------------------------
            // I-type arithmetic: ADDI
            // --------------------------------------------------
            OP_ITYPE: begin
                RegWrite = 1'b1;
                ALUOp    = 2'b11;   // ALU control decodes funct3 (funct7 ignored)
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUSrc   = 1'b1;    // second operand from immediate
                MemtoReg = 1'b0;
                Branch   = 1'b0;
            end

            // --------------------------------------------------
            // Load: LW, LH, LB
            // --------------------------------------------------
            OP_LOAD: begin
                RegWrite = 1'b1;
                ALUOp    = 2'b00;   // ADD for address calculation
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                ALUSrc   = 1'b1;    // base + immediate offset
                MemtoReg = 1'b1;    // write-back from memory
                Branch   = 1'b0;
            end

            // --------------------------------------------------
            // Store: SW, SH, SB
            // --------------------------------------------------
            OP_STORE: begin
                RegWrite = 1'b0;
                ALUOp    = 2'b00;   // ADD for address calculation
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                ALUSrc   = 1'b1;    // base + immediate offset
                MemtoReg = 1'b0;    // don't care (no reg write)
                Branch   = 1'b0;
            end

            // --------------------------------------------------
            // Branch: BEQ
            // --------------------------------------------------
            OP_BRANCH: begin
                RegWrite = 1'b0;
                ALUOp    = 2'b01;   // SUB for comparison
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUSrc   = 1'b0;    // both operands from registers
                MemtoReg = 1'b0;    // don't care
                Branch   = 1'b1;
            end

            // --------------------------------------------------
            // Default / illegal opcode - safe outputs
            // --------------------------------------------------
            default: begin
                RegWrite = 1'b0;
                ALUOp    = 2'b00;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                Branch   = 1'b0;
            end
        endcase
    end

endmodule