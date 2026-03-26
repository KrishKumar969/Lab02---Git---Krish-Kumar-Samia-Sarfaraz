// ============================================================
// ALU Control Unit - Single-Cycle RISC-V (RV32I)
// EE/CE 321L/371L  Lab 9
//
// Inputs : ALUOp[1:0], funct3[2:0], funct7[6:0]
// Output : ALUControl[3:0]
module alu_control (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b10: begin
                case (funct3)
                    3'b000: ALUControl = 4'b0011;   // ADD and SUB
                    3'b001: ALUControl = 4'b0100;   // SLL
                    3'b100: ALUControl = 4'b0010;   // XOR
                    3'b101: ALUControl = 4'b0101;   // SRL
                    3'b110: ALUControl = 4'b0000;   // OR
                    3'b111: ALUControl = 4'b0001;   // AND
                    default: ALUControl = 4'b0110;  // safe default: ADD
                endcase
            end

            default: ALUControl = 4'b0110;  // global safe default
        endcase
    end

endmodule
