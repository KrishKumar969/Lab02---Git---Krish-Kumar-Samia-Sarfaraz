`timescale 1ns / 1ps

module XOR_1Bit(
    input wire a,
    input wire b,
    output wire y
    );
    
    assign y = (a & ~b) | (~a & b) ;
endmodule
