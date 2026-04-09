`timescale 1ns / 1ps

module SR_1Bit(
    input wire a,
    input wire signal_in,
    output wire y,
    output wire signal_out
    );
    
    assign signal_out = a;
    assign y = signal_in;

endmodule
