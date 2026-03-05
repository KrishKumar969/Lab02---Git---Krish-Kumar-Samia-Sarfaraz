`timescale 1ns / 1ps
module ALU_32Bit_tb;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] Control;
    wire signal_out;
    wire [31:0] Y;

    ALU_32Bit uut (
        .A(A),
        .B(B),
        .Control(Control),
        .signal_out(signal_out),
        .Y(Y)
    );

    initial begin
        A = 32'b00000000000000000000000000001010;  // 10
        B = 32'b00000000000000000000000000000011;  // 3

        $display("A = %d, B = %d", A, B);
        $display("--------------------------------------------------");

        // AND
        Control = 4'b0000; #10;
        $display("Control=0000 AND:        Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // OR
        Control = 4'b0001; #10;
        $display("Control=0001 OR:         Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // XOR
        Control = 4'b0010; #10;
        $display("Control=0010 XOR:        Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // SL cin=0
        Control = 4'b0100; #10;
        $display("Control=0100 SL cin=0:   Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // SL cin=1
        Control = 4'b1100; #10;
        $display("Control=1100 SL cin=1:   Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // SR
        Control = 4'b0101; #10;
        $display("Control=0101 SR:         Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // ADD cin=0 sub=0
        Control = 4'b0110; #10;
        $display("Control=0110 ADD:        Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // ADD cin=1 sub=0
        Control = 4'b1110; #10;
        $display("Control=1110 ADD cin=1:  Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // SUB cin=0 sub=1
        Control = 4'b0111; #10;
        $display("Control=0111 SUB:        Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        // SUB cin=1 sub=1
        Control = 4'b1111; #10;
        $display("Control=1111 SUB cin=1:  Y = %b (%d), signal_out = %b", Y, Y, signal_out);

        $display("--------------------------------------------------");
        $display("Testing with negative number A = -10");
        $display("--------------------------------------------------");

        A = 32'hFFFFFFF6;  // -10 in two's complement
        B = 32'b00000000000000000000000000000011;  // 3

        $display("A = %d, B = %d", $signed(A), B);

        // AND
        Control = 4'b0000; #10;
        $display("Control=0000 AND:        Y = %b (%d), signal_out = %b", Y, $signed(Y), signal_out);

        // OR
        Control = 4'b0001; #10;
        $display("Control=0001 OR:         Y = %b (%d), signal_out = %b", Y, $signed(Y), signal_out);

        // XOR
        Control = 4'b0010; #10;
        $display("Control=0010 XOR:        Y = %b (%d), signal_out = %b", Y, $signed(Y), signal_out);

        // SL cin=0
        Control = 4'b0100; #10;
        $display("Control=0100 SL cin=0:   Y = %b (%d), signal_out = %b", Y, $signed(Y), signal_out);

        // SL cin=1
        Control = 4'b1100; #10;
        $display("Control=1100 SL cin=1:   Y = %b (%d), signal_out = %b", Y, $signed(Y), signal_out);

        // SR arithmetic (sign extended)
        Control = 4'b0101; #10;
        $display("Control=0101 SR:         Y = %b (%d), signal_out = %b", Y, $signed(Y), signal_out);

        // ADD
        Control = 4'b0110; #10;
        $display("Control=0110 ADD:        Y = %b (%d), signal_out = %b", Y, $signed(Y), signal_out);

        // SUB
        Control = 4'b0111; #10;
        $display("Control=0111 SUB:        Y = %b (%d), signal_out = %b", Y, $signed(Y), signal_out);

        $display("--------------------------------------------------");
        $display("Edge cases");
        $display("--------------------------------------------------");

        // all zeros
        A = 32'h00000000; B = 32'h00000000;
        Control = 4'b0110; #10;
        $display("0 + 0:                   Y = %d, signal_out = %b", Y, signal_out);

        // overflow
        A = 32'h7FFFFFFF; B = 32'h00000001;
        Control = 4'b0110; #10;
        $display("MAX + 1 overflow:        Y = %d, signal_out = %b", $signed(Y), signal_out);

        // all ones
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF;
        Control = 4'b0000; #10;
        $display("0xFFFFFFFF AND 0xFFFFFFFF: Y = %h, signal_out = %b", Y, signal_out);

        $finish;
    end

endmodule