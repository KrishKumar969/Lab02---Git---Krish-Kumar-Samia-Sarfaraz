`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 11:18:21 AM
// Design Name: 
// Module Name: task2TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_fsm_counter;

    reg        clk;
    reg        rst;
    reg  [3:0] sw_in;
    wire [3:0] led_out;
    wire       cnt_en;

    fsm_counter uut (
        .clk    (clk),
        .rst    (rst),
        .sw_in  (sw_in),
        .led_out(led_out),
        .cnt_en (cnt_en)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst   = 0;
        sw_in = 4'd0;

        // Test 1: Reset
        rst = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        rst = 0;
        $display("T1 RESET   | state=%b cnt_en=%b led_out=%d | expect state=0 cnt_en=0 led=0",
                  uut.state, cnt_en, led_out);

        // Test 2: sw_in=0, stay in S0
        sw_in = 4'd0;
        repeat(3) @(posedge clk); #1;
        $display("T2 SW=0    | state=%b cnt_en=%b led_out=%d | expect state=0 cnt_en=0 led=0",
                  uut.state, cnt_en, led_out);

        // Test 3: sw_in=5, enter S1 and count down
        sw_in = 4'd5;
        @(posedge clk); #1;
        sw_in = 4'd0;
        $display("T3 SW=5 S1 | state=%b cnt_en=%b led_out=%d | expect state=1 cnt_en=1",
                  uut.state, cnt_en, led_out);
        repeat(5) begin
            @(posedge clk); #1;
            $display("   COUNT   | state=%b cnt_en=%b led_out=%d counter=%d",
                      uut.state, cnt_en, led_out, uut.counter);
        end
        $display("T3 DONE    | state=%b cnt_en=%b led_out=%d | expect state=0 cnt_en=0 led=0",
                  uut.state, cnt_en, led_out);

        // Test 4: async reset mid-countdown
        sw_in = 4'd7;
        @(posedge clk); #1;
        sw_in = 4'd0;
        repeat(3) @(posedge clk); #1;
        $display("T4 PRE-RST | state=%b cnt_en=%b led_out=%d counter=%d",
                  uut.state, cnt_en, led_out, uut.counter);
        rst = 1; #3;
        $display("T4 MID-RST | state=%b cnt_en=%b led_out=%d | expect state=0 cnt_en=0 led=0",
                  uut.state, cnt_en, led_out);
        rst = 0;
        @(posedge clk); #1;

        // Test 5: sw_in=15, full countdown
        sw_in = 4'd15;
        @(posedge clk); #1;
        sw_in = 4'd0;
        $display("T5 SW=15   | state=%b cnt_en=%b | expect state=1 cnt_en=1",
                  uut.state, cnt_en);
        repeat(16) @(posedge clk); #1;
        $display("T5 DONE    | state=%b cnt_en=%b led_out=%d | expect state=0 cnt_en=0 led=0",
                  uut.state, cnt_en, led_out);

        $display("\nSimulation complete.");
        $finish;
    end

    initial begin
        $dumpfile("tb_fsm_counter.vcd");
        $dumpvars(0, tb_fsm_counter);
    end

endmodule
