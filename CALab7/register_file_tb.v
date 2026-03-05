`timescale 1ns / 1ps

module register_file_tb;

    // Inputs
    reg        clk;
    reg        reset;
    reg        WriteEnable;
    reg [4:0]  rs1;
    reg [4:0]  rs2;
    reg [4:0]  rd;
    reg [31:0] WriteData;

    // Outputs
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Instantiate the register file
    register_file uut (
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

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to write a register
    task write_reg;
        input [4:0]  addr;
        input [31:0] data;
        begin
            rd          = addr;
            WriteData   = data;
            WriteEnable = 1;
            @(posedge clk); #1; // wait for rising edge
            WriteEnable = 0;
        end
    endtask

    // Task to read and check a register
    task check_reg;
        input [4:0]  addr1;
        input [4:0]  addr2;
        input [31:0] expected1;
        input [31:0] expected2;
        begin
            rs1 = addr1;
            rs2 = addr2;
            #1; // small delay for combinational read to settle
            if (ReadData1 === expected1)
                $display("PASS: regs[%0d] = 0x%08X", addr1, ReadData1);
            else
                $display("FAIL: regs[%0d] = 0x%08X, expected 0x%08X", addr1, ReadData1, expected1);

            if (ReadData2 === expected2)
                $display("PASS: regs[%0d] = 0x%08X", addr2, ReadData2);
            else
                $display("FAIL: regs[%0d] = 0x%08X, expected 0x%08X", addr2, ReadData2, expected2);
        end
    endtask

    initial begin
        // Initialize inputs
        clk         = 0;
        reset       = 0;
        WriteEnable = 0;
        rs1         = 0;
        rs2         = 0;
        rd          = 0;
        WriteData   = 0;

        #10;

        // -----------------------------------------------
        // Test 1: Write 0xDEADBEEF to x5, read it back
        // -----------------------------------------------
        $display("\n--- Test 1: Write/Read x5 ---");
        write_reg(5'd5, 32'hDEADBEEF);
        check_reg(5'd5, 5'd5, 32'hDEADBEEF, 32'hDEADBEEF);

        // -----------------------------------------------
        // Test 2: Write to x0, verify it stays zero
        // -----------------------------------------------
        $display("\n--- Test 2: Write to x0 (should stay 0) ---");
        write_reg(5'd0, 32'hFFFFFFFF);
        check_reg(5'd0, 5'd0, 32'h00000000, 32'h00000000);

        // -----------------------------------------------
        // Test 3: Simultaneous two-port read
        // -----------------------------------------------
        $display("\n--- Test 3: Simultaneous two-port read ---");
        write_reg(5'd1, 32'hAAAAAAAA);
        write_reg(5'd2, 32'h55555555);
        check_reg(5'd1, 5'd2, 32'hAAAAAAAA, 32'h55555555);

        // -----------------------------------------------
        // Test 4: Overwrite a register
        // -----------------------------------------------
        $display("\n--- Test 4: Overwrite x5 ---");
        write_reg(5'd5, 32'h12345678);
        check_reg(5'd5, 5'd5, 32'h12345678, 32'h12345678);

        // -----------------------------------------------
        // Test 5: Read-after-write timing
        // verify data appears AFTER the clock edge
        // -----------------------------------------------
        $display("\n--- Test 5: Read-after-write timing ---");
        rs1         = 5'd3;
        WriteData   = 32'hCAFEBABE;
        rd          = 5'd3;
        WriteEnable = 1;
        // Before clock edge, old value should still be there
        #1;
        $display("Before posedge: regs[3] = 0x%08X (expect 0x00000000)", ReadData1);
        @(posedge clk); #1;
        WriteEnable = 0;
        $display("After  posedge: regs[3] = 0x%08X (expect 0xCAFEBABE)", ReadData1);

        // -----------------------------------------------
        // Test 6: WriteEnable = 0, register should not change
        // -----------------------------------------------
        $display("\n--- Test 6: WriteEnable = 0 (no write) ---");
        rd          = 5'd1;
        WriteData   = 32'hDEADDEAD;
        WriteEnable = 0;
        @(posedge clk); #1;
        check_reg(5'd1, 5'd1, 32'hAAAAAAAA, 32'hAAAAAAAA);

        $display("\n--- All tests complete ---");
        
        // -----------------------------------------------
        // Test 7: Reset all registers to 0
        // -----------------------------------------------
        $display("\n--- Test 7: Reset (all registers should clear to 0) ---");
        // First write some values
        write_reg(5'd10, 32'hFFFFFFFF);
        write_reg(5'd11, 32'hABCDABCD);
        check_reg(5'd1, 5'd2, 32'hFFFFFFFF, 32'hABCDABCD);

        // Now assert reset
        reset = 1;
        @(posedge clk); #1;
        reset = 0;

        // All registers should now be 0
        check_reg(5'd10, 5'd11, 32'h00000000, 32'h00000000);
        check_reg(5'd5,  5'd1,  32'h00000000, 32'h00000000);
        
        $finish;
        
        
    end

endmodule
