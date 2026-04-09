`timescale 1ns / 1ps

module RF_ALU_FSM_tb;

    // ----------------------------------------------------------
    // Clock
    // ----------------------------------------------------------
    reg clk;
    initial clk = 0;
    always #5 clk = ~clk;   // 100 MHz

    // ----------------------------------------------------------
    // Register-file ports
    // ----------------------------------------------------------
    reg         reset;
    reg         WriteEnable;
    reg  [4:0]  rs1, rs2, rd;
    reg  [31:0] WriteData;
    wire [31:0] ReadData1, ReadData2;

    register_file u_rf (
        .clk        (clk),
        .reset      (reset),
        .WriteEnable(WriteEnable),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .WriteData  (WriteData),
        .ReadData1  (ReadData1),
        .ReadData2  (ReadData2)
    );

    // ----------------------------------------------------------
    // ALU ports
    // ----------------------------------------------------------
    reg  [31:0] A, B;
    reg  [3:0]  Control;
    wire [31:0] Y;
    wire        signal_out;

    ALU_32Bit u_alu (
        .A          (A),
        .B          (B),
        .Control    (Control),
        .Y          (Y),
        .signal_out (signal_out)
    );

    wire zero_flag = (Y == 32'd0);

    // ----------------------------------------------------------
    // FSM state encoding (matches lab diagram)
    // ----------------------------------------------------------
    localparam  IDLE            = 3'd0,
                READ_REGISTERS  = 3'd1,
                ALU_OPERATION   = 3'd2,
                WRITE_REGISTERS = 3'd3,
                DONE            = 3'd4;

    reg [2:0] state;

    // ----------------------------------------------------------
    // Internal storage
    // ----------------------------------------------------------
    integer     op_idx, i;
    reg [31:0]  alu_results  [0:6];
    reg [3:0]   alu_controls [0:6];
    reg [31:0]  beq_flag;

    // Control codes matching your 1BitALU encoding
    initial begin
        alu_controls[0] = 4'b0110; // ADD
        alu_controls[1] = 4'b0111; // SUB
        alu_controls[2] = 4'b0000; // AND
        alu_controls[3] = 4'b0001; // OR
        alu_controls[4] = 4'b0010; // XOR
        alu_controls[5] = 4'b0100; // SLL
        alu_controls[6] = 4'b0101; // SRL
    end

    function [63:0] op_name;
        input [2:0] idx;
        begin
            case (idx)
                3'd0: op_name = "ADD     ";
                3'd1: op_name = "SUB     ";
                3'd2: op_name = "AND     ";
                3'd3: op_name = "OR      ";
                3'd4: op_name = "XOR     ";
                3'd5: op_name = "SLL     ";
                3'd6: op_name = "SRL     ";
                default: op_name = "???     ";
            endcase
        end
    endfunction

    // Write one register and de-assert WriteEnable after clock edge
    task rf_write;
        input [4:0]  addr;
        input [31:0] data;
        begin
            rd          = addr;
            WriteData   = data;
            WriteEnable = 1'b1;
            @(posedge clk); #1;
            WriteEnable = 1'b0;
        end
    endtask

    // Read-back check on port 1
    task rf_check;
        input [4:0]  addr;
        input [31:0] expected;
        begin
            rs1 = addr;
            #1;
            if (ReadData1 === expected)
                $display("  PASS: x%0d = 0x%08X", addr, ReadData1);
            else
                $display("  FAIL: x%0d = 0x%08X  (expected 0x%08X)",
                         addr, ReadData1, expected);
        end
    endtask

    // ----------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------
    initial begin

        // ---- global reset ----
        reset       = 1;
        WriteEnable = 0;
        rs1 = 0; rs2 = 0; rd = 0; WriteData = 0;
        A = 0; B = 0; Control = 0;
        @(posedge clk); #1;
        reset = 0;

        // ==================================================
        // IDLE: write known constants into x1, x2, x3
        // ==================================================
        $display("\n========== STATE: IDLE ==========");
        state = IDLE;

        rf_write(5'd1, 32'h10101010);
        rf_write(5'd2, 32'h01010101);
        rf_write(5'd3, 32'h00000005);

        $display("  Constants loaded:");
        rf_check(5'd1, 32'h10101010);
        rf_check(5'd2, 32'h01010101);
        rf_check(5'd3, 32'h00000005);

        // ==================================================
        // READ_REGISTERS: read x1 -> A, x2 -> B
        // ==================================================
        $display("\n========== STATE: READ_REGISTERS ==========");
        state = READ_REGISTERS;

        rs1 = 5'd1; rs2 = 5'd2;
        #1;
        A = ReadData1;
        B = ReadData2;
        $display("  A (x1) = 0x%08X", A);
        $display("  B (x2) = 0x%08X", B);
        @(posedge clk); #1;

        // ==================================================
        // ALU_OPERATION: run all 7 ops on A, B
        // ==================================================
        $display("\n========== STATE: ALU_OPERATION ==========");
        state = ALU_OPERATION;

        for (op_idx = 0; op_idx < 7; op_idx = op_idx + 1) begin
            Control = alu_controls[op_idx];
            #10;
            alu_results[op_idx] = Y;
            $display("  %s ctrl=%b  Y=0x%08X  zero=%b  carry=%b",
                     op_name(op_idx), Control, Y, zero_flag, signal_out);
        end
        @(posedge clk); #1;

        // ==================================================
        // WRITE_REGISTERS: store ALU results into x4..x10
        //                  BEQ flag into x11
        //                  read-after-write test on x12
        // ==================================================
        $display("\n========== STATE: WRITE_REGISTERS ==========");
        state = WRITE_REGISTERS;

        for (i = 0; i < 7; i = i + 1)
            rf_write(5'd4 + i, alu_results[i]);

        // BEQ-style: if XOR(A,B) == 0 then branches taken (flag=1)
        beq_flag = (alu_results[4] == 32'd0) ? 32'd1 : 32'd0;
        rf_write(5'd11, beq_flag);
        $display("  BEQ flag -> x11 = %0d  (A XOR B %s 0)",
                 beq_flag, (beq_flag ? "==" : "!="));

        // Read-after-write timing test
        $display("\n  --- Read-after-write timing (x12) ---");
        rd = 5'd12; WriteData = 32'hCAFEBABE; WriteEnable = 1'b1;
        rs1 = 5'd12; #1;
        $display("  Before posedge: x12 = 0x%08X  (expect 0x00000000)", ReadData1);
        @(posedge clk); #1;
        WriteEnable = 1'b0;
        $display("  After  posedge: x12 = 0x%08X  (expect 0xCAFEBABE)", ReadData1);

        // Verify all results in register file
        $display("\n  --- Verifying register file contents ---");
        for (i = 0; i < 7; i = i + 1) begin
            rs1 = 5'd4 + i; #1;
            if (ReadData1 === alu_results[i])
                $display("  PASS: x%0d (%s) = 0x%08X", 5'd4+i, op_name(i), ReadData1);
            else
                $display("  FAIL: x%0d (%s) = 0x%08X  (expected 0x%08X)",
                         5'd4+i, op_name(i), ReadData1, alu_results[i]);
        end

        // x0 hardwired zero check
        rs1 = 5'd0; #1;
        if (ReadData1 === 32'd0)
            $display("  PASS: x0 = 0x00000000 (hardwired zero)");
        else
            $display("  FAIL: x0 = 0x%08X  (should be 0)", ReadData1);

        // ==================================================
        // DONE
        // ==================================================
        $display("\n========== STATE: DONE ==========");
        state = DONE;
        $display("  All states completed.\n");
        $finish;
    end

endmodule
