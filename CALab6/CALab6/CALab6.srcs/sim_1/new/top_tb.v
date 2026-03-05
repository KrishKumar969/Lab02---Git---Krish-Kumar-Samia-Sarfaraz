`timescale 1ns / 1ps
module top_tb;

    reg        clk;
    reg        rst;
    reg  [3:0] sw;
    reg  [3:0] btns;
    wire [15:0] led;

    top uut (
        .clk  (clk),
        .rst  (rst),
        .sw   (sw),
        .btns (btns),
        .led  (led)
    );

    always #5 clk = ~clk;

    initial begin
        clk  = 0;
        rst  = 1;
        sw   = 4'b0000;
        btns = 4'b0000;
        #20;
        rst  = 0;
        #20;

        sw = 4'b0000; #200_000_000;
        $display("AND:      sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b0001; #200_000_000;
        $display("OR:       sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b0010; #200_000_000;
        $display("XOR:      sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b0100; #200_000_000;
        $display("SL:       sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b0101; #200_000_000;
        $display("SR:       sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b0110; #200_000_000;
        $display("ADD:      sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b0111; #200_000_000;
        $display("SUB:      sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b1100; #200_000_000;
        $display("SL cin=1: sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b1110; #200_000_000;
        $display("ADD cin=1:sw=%b led=%b (%h)", sw, led, led);

        sw = 4'b1111; #200_000_000;
        $display("SUB cin=1:sw=%b led=%b (%h)", sw, led, led);

        rst = 1; #20;
        $display("RST:      led=%b (expected all 0)", led);
        rst = 0;

        $finish;
    end

endmodule