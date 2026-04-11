

module immGen (
    input  [31:0] Instruction,  // full 32-bit instruction word
    output reg [31:0] Imm       // sign-extended immediate output
);

    wire [6:0] opcode = Instruction[6:0];

    always @(*) begin
        case (opcode)

            // I-type: ADDI, SLTI, ANDI, ORI, XORI, SLLI, SRLI
            //         LW, LH, LB, LHU, LBU, JALR
            7'b0010011,   // arithmetic immediate
            7'b0000011,   // loads
            7'b1100111:   // JALR
                Imm = {{20{Instruction[31]}}, Instruction[31:20]};

            // S-type: SW, SH, SB
            7'b0100011:
                Imm = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};

            // B-type: BEQ, BNE, BLT, BGE, BLTU, BGEU
            7'b1100011:
                Imm = {{19{Instruction[31]}}, Instruction[31], Instruction[7],
                        Instruction[30:25], Instruction[11:8], 1'b0};

            // Default: output zero for unsupported types
            default:
                Imm = 32'h00000000;

        endcase
    end

endmodule
