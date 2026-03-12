`timescale 1ns / 1ps

module MemorySystem_tb;

    // Inputs
    reg         clk;
    reg         rst;
    reg  [31:0] address;
    reg         readEnable;
    reg         writeEnable;
    reg  [31:0] writeData;
    reg  [15:0] switches;
    reg  [15:0] btns;

    // Outputs
    wire [31:0] readData;
    wire [15:0] leds;

    // Instantiate DUT
    addressDecoderTop uut (
        .clk        (clk),
        .rst        (rst),
        .address    (address),
        .readEnable (readEnable),
        .writeEnable(writeEnable),
        .writeData  (writeData),
        .switches   (switches),
        .btns       (btns),
        .readData   (readData),
        .leds       (leds)
    );

    // Clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    task tick;
        begin
            @(posedge clk);
            #1; // small delay after edge to let outputs settle
        end
    endtask

    initial begin
        // -------------------------------------------------------
        // Initialise
        // -------------------------------------------------------
        rst         = 1;
        address     = 32'd0;
        readEnable  = 0;
        writeEnable = 0;
        writeData   = 32'd0;
        switches    = 16'd0;
        btns        = 16'd0;

        tick; tick;
        rst = 0;
        tick;

        // -------------------------------------------------------
        // Test 1: Write to Data Memory (address[9:8] = 00)
        // Address 0x004 -> bits[9:8] = 00 -> DataMem
        // -------------------------------------------------------
        $display("=== Test 1: Data Memory Write ===");
        address     = 32'h004;   // address[9:8] = 2'b00
        writeData   = 32'hDEAD_BEEF;
        writeEnable = 1;
        readEnable  = 0;
        tick;
        writeEnable = 0;
        $display("Wrote 0xDEADBEEF to DataMem address 0x004");

        // -------------------------------------------------------
        // Test 2: Read back from Data Memory
        // -------------------------------------------------------
        $display("=== Test 2: Data Memory Read ===");
        address    = 32'h004;
        readEnable = 1;
        tick;
        readEnable = 0;
        if (readData === 32'hDEAD_BEEF)
            $display("PASS: readData = 0x%08X", readData);
        else
            $display("FAIL: readData = 0x%08X (expected 0xDEADBEEF)", readData);

        // -------------------------------------------------------
        // Test 3: Write to LEDs (address[9:8] = 01 -> 0x100)
        // -------------------------------------------------------
        $display("=== Test 3: LED Write ===");
        address     = 32'h100;   // address[9:8] = 2'b01
        writeData   = 32'h0000_A5A5;
        writeEnable = 1;
        readEnable  = 0;
        tick;
        writeEnable = 0;
        tick;
        if (leds === 16'hA5A5)
            $display("PASS: leds = 0x%04X", leds);
        else
            $display("FAIL: leds = 0x%04X (expected 0xA5A5)", leds);

        // -------------------------------------------------------
        // Test 4: Read from Switches (address[9:8] = 10 -> 0x200)
        // -------------------------------------------------------
        $display("=== Test 4: Switch Read ===");
        switches   = 16'h1234;
        btns       = 16'h00FF;
        address    = 32'h200;    // address[9:8] = 2'b10
        readEnable = 1;
        writeEnable = 0;
        tick;
        readEnable = 0;
        if (readData === {16'h00FF, 16'h1234})
            $display("PASS: readData = 0x%08X", readData);
        else
            $display("FAIL: readData = 0x%08X (expected 0x00FF1234)", readData);

        // -------------------------------------------------------
        // Test 5: Unused address region (address[9:8] = 11 -> 0x300)
        // Should return 0
        // -------------------------------------------------------
        $display("=== Test 5: Unused Address Region ===");
        address    = 32'h300;    // address[9:8] = 2'b11
        readEnable = 1;
        tick;
        readEnable = 0;
        if (readData === 32'd0)
            $display("PASS: readData = 0x%08X (unused region returns 0)", readData);
        else
            $display("FAIL: readData = 0x%08X (expected 0x00000000)", readData);

        // -------------------------------------------------------
        // Test 6: Reset clears LEDs
        // -------------------------------------------------------
        $display("=== Test 6: Reset ===");
        rst = 1;
        tick; tick;
        rst = 0;
        tick;
        if (leds === 16'd0)
            $display("PASS: leds reset to 0x%04X", leds);
        else
            $display("FAIL: leds = 0x%04X after reset (expected 0x0000)", leds);

        // -------------------------------------------------------
        // Test 7: Write multiple Data Memory locations
        // -------------------------------------------------------
        $display("=== Test 7: Multiple DataMem Writes/Reads ===");
        address     = 32'h010;
        writeData   = 32'hCAFEBABE;
        writeEnable = 1; tick; writeEnable = 0;

        address     = 32'h020;
        writeData   = 32'h12345678;
        writeEnable = 1; tick; writeEnable = 0;

        address    = 32'h010;
        readEnable = 1; tick; readEnable = 0;
        if (readData === 32'hCAFEBABE)
            $display("PASS: addr 0x010 readData = 0x%08X", readData);
        else
            $display("FAIL: addr 0x010 readData = 0x%08X (expected 0xCAFEBABE)", readData);

        address    = 32'h020;
        readEnable = 1; tick; readEnable = 0;
        if (readData === 32'h12345678)
            $display("PASS: addr 0x020 readData = 0x%08X", readData);
        else
            $display("FAIL: addr 0x020 readData = 0x%08X (expected 0x12345678)", readData);

        $display("=== Testbench Complete ===");
        $finish;
    end

endmodule