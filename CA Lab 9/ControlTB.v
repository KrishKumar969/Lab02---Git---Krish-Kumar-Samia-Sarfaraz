// ============================================================
// Testbench - ALU Control Unit
// EE/CE 321L/371L  Lab 9
//
// ALUControl encoding (from your module):
//   4'b0000 - OR
//   4'b0001 - AND
//   4'b0010 - XOR
//   4'b0011 - ADD / SUB  (funct3=000, ALUOp=10)
//   4'b0100 - SLL
//   4'b0101 - SRL
//   4'b0110 - default (safe / unused)
// ============================================================
`timescale 1ns/1ps

module tb_alu_control;

    // --------------------------------------------------------
    // DUT ports
    // --------------------------------------------------------
    reg  [1:0] ALUOp;
    reg  [2:0] funct3;
    reg  [6:0] funct7;
    wire [3:0] ALUControl;

    // --------------------------------------------------------
    // Instantiate DUT
    // --------------------------------------------------------
    alu_control uut (
        .ALUOp     (ALUOp),
        .funct3    (funct3),
        .funct7    (funct7),
        .ALUControl(ALUControl)
    );

    // --------------------------------------------------------
    // Pass/Fail counter
    // --------------------------------------------------------
    integer pass_count = 0;
    integer fail_count = 0;

    // --------------------------------------------------------
    // Check task
    // --------------------------------------------------------
    task check;
        input [8*10-1:0] instr_name;   // up to 10-char label
        input [3:0]      expected;
        begin
            #10;
            if (ALUControl === expected) begin
                $display("PASS  %-10s | ALUOp=%b  funct3=%b  funct7[5]=%b  =>  ALUControl=%b",
                          instr_name, ALUOp, funct3, funct7[5], ALUControl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL  %-10s | ALUOp=%b  funct3=%b  funct7[5]=%b  =>  Got=%b  Expected=%b",
                          instr_name, ALUOp, funct3, funct7[5], ALUControl, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // --------------------------------------------------------
    // Stimulus
    // --------------------------------------------------------
    initial begin
        $dumpfile("tb_alu_control.vcd");
        $dumpvars(0, tb_alu_control);

        $display("============================================");
        $display("       ALU Control Unit Testbench          ");
        $display("============================================\n");

        // ====================================================
        // ALUOp = 2'b10  →  R-type instructions
        // ====================================================
        $display("--- R-type (ALUOp = 10) ---");
        ALUOp = 2'b10;

        // ADD / SUB  funct3=000  (your module maps both to 4'b0011)
        funct3 = 3'b000; funct7 = 7'b0000000;  // ADD
        check("ADD",      4'b0011);

        funct3 = 3'b000; funct7 = 7'b0100000;  // SUB
        check("SUB",      4'b0011);             // same ALUControl - funct7 not decoded

        // SLL  funct3=001
        funct3 = 3'b001; funct7 = 7'b0000000;
        check("SLL",      4'b0100);

        // XOR  funct3=100
        funct3 = 3'b100; funct7 = 7'b0000000;
        check("XOR",      4'b0010);

        // SRL  funct3=101
        funct3 = 3'b101; funct7 = 7'b0000000;
        check("SRL",      4'b0101);

        // OR   funct3=110
        funct3 = 3'b110; funct7 = 7'b0000000;
        check("OR",       4'b0000);

        // AND  funct3=111
        funct3 = 3'b111; funct7 = 7'b0000000;
        check("AND",      4'b0001);

        // default funct3 under ALUOp=10 (e.g. funct3=010)
        funct3 = 3'b010; funct7 = 7'b0000000;
        check("R-default", 4'b0110);

        // ====================================================
        // ALUOp != 2'b10  →  global default (4'b0110)
        // Covers: Load, Store (ALUOp=00) and Branch (ALUOp=01)
        // ====================================================
        $display("\n--- Load / Store (ALUOp = 00) ---");
        ALUOp = 2'b00; funct3 = 3'b010; funct7 = 7'b0000000;
        check("LW",       4'b0110);

        ALUOp = 2'b00; funct3 = 3'b001; funct7 = 7'b0000000;
        check("LH",       4'b0110);

        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000;
        check("LB",       4'b0110);

        ALUOp = 2'b00; funct3 = 3'b010; funct7 = 7'b0000000;
        check("SW",       4'b0110);

        ALUOp = 2'b00; funct3 = 3'b001; funct7 = 7'b0000000;
        check("SH",       4'b0110);

        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000;
        check("SB",       4'b0110);

        $display("\n--- Branch / BEQ (ALUOp = 01) ---");
        ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000;
        check("BEQ",      4'b0110);

        $display("\n--- I-type arithmetic (ALUOp = 11) ---");
        ALUOp = 2'b11; funct3 = 3'b000; funct7 = 7'b0000000;
        check("ADDI",     4'b0110);   // falls into default

        // ====================================================
        // Summary
        // ====================================================
        $display("\n============================================");
        $display("  Results:  %0d PASSED  |  %0d FAILED", pass_count, fail_count);
        $display("============================================\n");

        $finish;
    end

endmodule
