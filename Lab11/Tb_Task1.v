

`timescale 1ns / 1ps

module tb_Task1;

    // --------------------------------------------------------
    // Clock and reset
    // --------------------------------------------------------
    reg clk;
    reg rst;

    initial clk = 0;
    always #5 clk = ~clk;   // 10 ns period → 100 MHz

    // --------------------------------------------------------
    // Wires connecting all modules
    // --------------------------------------------------------
    wire [31:0] PC;
    wire [31:0] PC_Plus4;
    wire [31:0] BranchTarget;
    wire [31:0] PC_Next;

    reg         PCSrc;
    reg  [31:0] Imm_In;        // manual immediate fed to branchAdder for PC tests
    reg  [31:0] Instruction;   // fed to immGen for immediate generation tests
    wire [31:0] Imm_Out;       // immGen output

    // --------------------------------------------------------
    // Instantiate all Task 1 modules
    // --------------------------------------------------------
    ProgramCounter u_PC (
        .clk    (clk),
        .rst    (rst),
        .PC_Next(PC_Next),
        .PC     (PC)
    );

    pcAdder u_pcAdder (
        .PC      (PC),
        .PC_Plus4(PC_Plus4)
    );

    branchAdder u_branchAdder (
        .PC          (PC),
        .Imm         (Imm_In),
        .BranchTarget(BranchTarget)
    );

    mux2 u_mux2 (
        .In0(PC_Plus4),
        .In1(BranchTarget),
        .Sel(PCSrc),
        .Out(PC_Next)
    );

    immGen u_immGen (
        .Instruction(Instruction),
        .Imm        (Imm_Out)
    );

    // --------------------------------------------------------
    // Task: check and print result
    // --------------------------------------------------------
    integer pass_count;
    integer fail_count;

    task check;
        input [31:0] actual;
        input [31:0] expected;
        input [127:0] test_name;
        begin
            if (actual === expected) begin
                $display("PASS | %-30s | got 0x%08X", test_name, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %-30s | got 0x%08X, expected 0x%08X",
                          test_name, actual, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // --------------------------------------------------------
    // Test stimulus
    // --------------------------------------------------------
    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("  Lab 11 Task 1 Testbench");
        $display("========================================");

        // ----------------------------------------------------
        // Reset
        // ----------------------------------------------------
        rst    = 1;
        PCSrc  = 0;
        Imm_In = 32'd0;
        Instruction = 32'd0;
        @(posedge clk); #1;
        @(posedge clk); #1;
        rst = 0;

        $display("\n--- Test 1: PC resets to 0 ---");
        check(PC, 32'h00000000, "PC after reset");

        // ----------------------------------------------------
        // Test 1: Sequential PC increment (PCSrc = 0)
        // ----------------------------------------------------
        $display("\n--- Test 2: Sequential increment (PCSrc=0) ---");
        PCSrc = 0;

        @(posedge clk); #1;
        check(PC, 32'h00000004, "PC = 0x04");

        @(posedge clk); #1;
        check(PC, 32'h00000008, "PC = 0x08");

        @(posedge clk); #1;
        check(PC, 32'h0000000C, "PC = 0x0C");

        @(posedge clk); #1;
        check(PC, 32'h00000010, "PC = 0x10");

        // ----------------------------------------------------
        // Test 2: Branch taken (PCSrc = 1)
        // Imm = 10 → BranchTarget = PC + (10 << 1) = PC + 20
        // At this point PC = 0x10, so target = 0x10 + 20 = 0x24
        // ----------------------------------------------------
        $display("\n--- Test 3: Branch taken (PCSrc=1) ---");
        Imm_In = 32'd10;
        PCSrc  = 1;

        @(posedge clk); #1;
        check(PC, 32'h00000024, "PC branches to 0x24");

        // Branch from 0x24 with Imm = 4 → target = 0x24 + 8 = 0x2C
        Imm_In = 32'd4;
        @(posedge clk); #1;
        check(PC, 32'h0000002C, "PC branches to 0x2C");

        // ----------------------------------------------------
        // Test 3: Back to sequential after branch
        // ----------------------------------------------------
        $display("\n--- Test 4: Sequential after branch ---");
        PCSrc = 0;

        @(posedge clk); #1;
        check(PC, 32'h00000030, "PC = 0x30 after branch");

        @(posedge clk); #1;
        check(PC, 32'h00000034, "PC = 0x34");

        // ----------------------------------------------------
        // Test 4: Negative branch offset (branch backwards)
        // Imm = -8 → BranchTarget = PC + (-8 << 1) = PC - 16
        // PC = 0x34, target = 0x34 - 16 = 0x24
        // ----------------------------------------------------
        $display("\n--- Test 5: Backward branch (negative Imm) ---");
        Imm_In = -32'd8;
        PCSrc  = 1;

        @(posedge clk); #1;
        check(PC, 32'h00000024, "PC backward branch to 0x24");

        // ----------------------------------------------------
        // Test 5: Reset mid-execution
        // ----------------------------------------------------
        $display("\n--- Test 6: Reset mid-execution ---");
        PCSrc = 0;
        @(posedge clk); #1;   // PC = 0x28
        rst = 1;
        @(posedge clk); #1;
        rst = 0;
        @(posedge clk); #1;
        check(PC, 32'h00000004, "PC resets and restarts from 0x04");

        // ----------------------------------------------------
        // Test 6: immGen - I-type (ADDI x1, x0, -5)
        // opcode = 7'b0010011, imm[11:0] = 12'b111111111011 = -5
        // inst = {12'hFFB, 5'b00000, 3'b000, 5'b00001, 7'b0010011}
        //      = 0xFFB00093
        // Expected: sign-extended -5 = 0xFFFFFFFB
        // ----------------------------------------------------
        $display("\n--- Test 7: immGen I-type (ADDI imm=-5) ---");
        PCSrc = 0;
        Instruction = 32'hFFB00093;
        #1;
        check(Imm_Out, 32'hFFFFFFFB, "immGen I-type imm=-5");

        // I-type positive: ADDI x1, x0, 213 (0xD5)
        // inst = {12'h0D5, 5'b00000, 3'b000, 5'b00001, 7'b0010011}
        //      = 0x0D500093
        // Expected: 0x000000D5
        Instruction = 32'h0D500093;
        #1;
        check(Imm_Out, 32'h000000D5, "immGen I-type imm=+213");

        // ----------------------------------------------------
        // Test 7: immGen - S-type (SW x9, 0(x5))
        // opcode = 7'b0100011, imm = 0
        // inst[31:25]=0, inst[11:7]=0
        // inst = {7'b0000000, 5'b01001, 5'b00101, 3'b010, 5'b00000, 7'b0100011}
        //      = 0x0092A023
        // Expected: 0x00000000
        // ----------------------------------------------------
        $display("\n--- Test 8: immGen S-type (SW imm=0) ---");
        Instruction = 32'h0092A023;
        #1;
        check(Imm_Out, 32'h00000000, "immGen S-type imm=0");

        // S-type with offset 4: SW x1, 4(x2)
        // inst = {7'b0000000, 5'b00001, 5'b00010, 3'b010, 5'b00100, 7'b0100011}
        //      = 0x00112223
        // Expected: 0x00000004
        Instruction = 32'h00112223;
        #1;
        check(Imm_Out, 32'h00000004, "immGen S-type imm=4");

        // ----------------------------------------------------
        // Test 8: immGen - B-type (BEQ x9, x0, -20)
        // Offset = -20 (byte), imm field encodes -20 in B encoding
        // inst = 0xFE048AE3  (from our assembled code)
        // Expected: sign-extended imm = -12 → 0xFFFFFFF4
        // (branchAdder then shifts left 1: PC + (-12<<1) = PC - 24)
        // ----------------------------------------------------
        $display("\n--- Test 9: immGen B-type (BEQ imm=-12) ---");
        Instruction = 32'hFE048AE3;
        #1;
        check(Imm_Out, 32'hFFFFFFF4, "immGen B-type imm=-12");

        // B-type positive: BNE x20, x0, +38 offset
        // inst = 0x020A1C63 (bne x20, x0, do_reset from our code)
        // imm = 0x38 = 56? Let's verify: 
        // inst[31]=0, inst[7]=1, inst[30:25]=010000, inst[11:8]=1100
        // imm = {0, 1, 010000, 1100, 0} = 0_1_010000_1100_0
        //     = 0b0_1010_0001_1000 = 0x0A18? No:
        // bit12=0, bit11=inst[7]=1, bits10:5=010000, bits4:1=1100, bit0=0
        // imm = {19'b0, 0, 1, 010000, 1100, 0} = 0x00000038 = 56
        // Expected: 0x00000038
        Instruction = 32'h020A1C63;
        #1;
        check(Imm_Out, 32'h00000038, "immGen B-type imm=+56");

        // ----------------------------------------------------
        // Summary
        // ----------------------------------------------------
        $display("\n========================================");
        $display("  Results: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("========================================");

        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("tb_Task1.vcd");
        $dumpvars(0, tb_Task1);
    end

endmodule
