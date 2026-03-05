`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 10:15:47 AM
// Design Name: 
// Module Name: switches
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


module leds(
    input clk,
    input rst,
    input [31:0] writeData,
    input writeEnable,
    input readEnable,
    input [29:0] memAddress,
    output reg [31:0] readData = 0, // not to be read
    output reg [15:0] leds
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            readData <= 32'd0;
            leds     <= 16'd0;
        end else begin
            readData <= 32'd0;
            leds     <= 16'd0;
        end
    end
    
endmodule