`timescale 1ns / 1ps

module MemorySystem_tb;

    // -------------------------------------------------------
    // Testbench Inputs
    // -------------------------------------------------------
    reg        clk;
    reg        rst;
    reg [15:0] sw;
    reg [15:0] btns;

    // -------------------------------------------------------
    // Visible wires between FSM and Memory System
    // (these will all appear in the waveform)
    // -------------------------------------------------------
    wire [31:0] address;
    wire        readEnable;
    wire        writeEnable;
    wire [31:0] writeData;
    wire [31:0] readData;

    // -------------------------------------------------------
    // Address Decoder enable signals (visible in waveform)
    // -------------------------------------------------------
    wire        DataMem;
    wire        LEDWrite;
    wire        SwitchReadEnable;

    // -------------------------------------------------------
    // Final output
    // -------------------------------------------------------
    wire [15:0] leds;

    // -------------------------------------------------------
    // Full 512-entry DataMemory array visible in waveform
    // -------------------------------------------------------
    wire [31:0] DataMemory_Array [511:0];
    genvar k;
    generate
        for (k = 0; k < 512; k = k + 1) begin : mem_probe
            assign DataMemory_Array[k] = u_mem.u_datamem.Memory[k];
        end
    endgenerate

    // -------------------------------------------------------
    // FSM - acts as CPU, generates memory access signals
    // -------------------------------------------------------
    fsm_task3 u_fsm (
        .clk        (clk),
        .rst        (rst),
        .sw         (sw),
        .btns       (btns),
        .readData   (readData),
        .address    (address),
        .readEnable (readEnable),
        .writeEnable(writeEnable),
        .writeData  (writeData)
    );

    // -------------------------------------------------------
    // Address Decoder - instantiated separately so
    // DataMem, LEDWrite, SwitchReadEnable are visible
    // -------------------------------------------------------
    AddressDecoder u_decoder (
        .rst             (rst),
        .address         (address[9:0]),
        .DataMem         (DataMem),
        .LEDWrite        (LEDWrite),
        .SwitchReadEnable(SwitchReadEnable)
    );

    // -------------------------------------------------------
    // Memory System - routes signals to correct peripheral
    // -------------------------------------------------------
    addressDecoderTop u_mem (
        .clk        (clk),
        .rst        (rst),
        .address    (address),
        .readEnable (readEnable),
        .writeEnable(writeEnable),
        .writeData  (writeData),
        .switches   (sw),
        .btns       (btns),
        .readData   (readData),
        .leds       (leds)
    );

    // -------------------------------------------------------
    // Clock: 10ns period (100 MHz)
    // -------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // -------------------------------------------------------
    // Helper: wait N rising edges
    // -------------------------------------------------------
    task wait_cycles;
        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1)
                @(posedge clk);
            #1;
        end
    endtask

    // -------------------------------------------------------
    // Helper: apply reset
    // -------------------------------------------------------
    task do_reset;
        begin
            rst = 1;
            wait_cycles(3);
            rst = 0;
            wait_cycles(2);
        end
    endtask

    // -------------------------------------------------------
    // Test stimulus
    // -------------------------------------------------------
    integer pass_count;
    integer fail_count;

    initial begin
        clk        = 0;
        rst        = 0;
        sw         = 16'd0;
        btns       = 16'd0;
        pass_count = 0;
        fail_count = 0;

        $display("======================================");
        $display("   MemorySystem Testbench Starting    ");
        $display("======================================");

        // -------------------------------------------------------
        // Test 1: Reset clears LEDs
        // -------------------------------------------------------
        $display("\n=== Test 1: Reset clears LEDs ===");
        sw = 16'hFFFF;
        do_reset;
        if (leds === 16'd0) begin
            $display("PASS: leds = 0x%04X after reset", leds);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: leds = 0x%04X (expected 0x0000)", leds);
            fail_count = fail_count + 1;
        end

        // -------------------------------------------------------
        // Test 2: Basic switch passthrough sw=0xA5A5
        // -------------------------------------------------------
        $display("\n=== Test 2: Switch passthrough (sw=0xA5A5) ===");
        sw = 16'hA5A5;
        wait_cycles(10);
        if (leds === 16'hA5A5) begin
            $display("PASS: leds = 0x%04X", leds);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: leds = 0x%04X (expected 0xA5A5)", leds);
            fail_count = fail_count + 1;
        end

        // -------------------------------------------------------
        // Test 3: Switch value 0x1234
        // -------------------------------------------------------
        $display("\n=== Test 3: Switch value 0x1234 ===");
        sw = 16'h1234;
        wait_cycles(10);
        if (leds === 16'h1234) begin
            $display("PASS: leds = 0x%04X", leds);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: leds = 0x%04X (expected 0x1234)", leds);
            fail_count = fail_count + 1;
        end

        // -------------------------------------------------------
        // Test 4: All switches ON
        // -------------------------------------------------------
        $display("\n=== Test 4: All switches ON (0xFFFF) ===");
        sw = 16'hFFFF;
        wait_cycles(10);
        if (leds === 16'hFFFF) begin
            $display("PASS: leds = 0x%04X", leds);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: leds = 0x%04X (expected 0xFFFF)", leds);
            fail_count = fail_count + 1;
        end

        // -------------------------------------------------------
        // Test 5: All switches OFF
        // -------------------------------------------------------
        $display("\n=== Test 5: All switches OFF (0x0000) ===");
        sw = 16'h0000;
        wait_cycles(10);
        if (leds === 16'h0000) begin
            $display("PASS: leds = 0x%04X", leds);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: leds = 0x%04X (expected 0x0000)", leds);
            fail_count = fail_count + 1;
        end

        // -------------------------------------------------------
        // Test 6: Reset mid-run then recover
        // -------------------------------------------------------
        $display("\n=== Test 6: Reset mid-run then recover ===");
        sw = 16'hBEEF;
        wait_cycles(5);
        do_reset;
        if (leds === 16'h0000) begin
            $display("PASS: leds = 0x%04X immediately after reset", leds);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: leds = 0x%04X after reset (expected 0x0000)", leds);
            fail_count = fail_count + 1;
        end
        wait_cycles(10);
        if (leds === 16'hBEEF) begin
            $display("PASS: leds = 0x%04X after recovery", leds);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: leds = 0x%04X after recovery (expected 0xBEEF)", leds);
            fail_count = fail_count + 1;
        end

        // -------------------------------------------------------
        // Test 7: Dynamic switch changes
        // -------------------------------------------------------
        $display("\n=== Test 7: Dynamic switch changes ===");
        sw = 16'h00FF;
        wait_cycles(10);
        sw = 16'hFF00;
        wait_cycles(10);
        if (leds === 16'hFF00) begin
            $display("PASS: leds = 0x%04X after switch change", leds);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: leds = 0x%04X (expected 0xFF00)", leds);
            fail_count = fail_count + 1;
        end

        // -------------------------------------------------------
        // Summary
        // -------------------------------------------------------
        $display("\n======================================");
        $display("   Results: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("======================================");

        $finish;
    end

endmodule
