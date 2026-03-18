`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2026 09:50:50 AM
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input clk,
    input rst,
    input MemWrite,
    input [9:0] address,
    input [31:0] WriteData,
    output [31:0] ReadData
    );
    
    reg [31:0] Memory [511:0];
    integer i;
    
    initial begin
        for (i = 0; i < 512; i = i + 1)
            Memory[i] = i;
    end
       
    wire [7:0] location = address [7:0]; 
    always @(posedge clk or posedge rst) begin
        if (rst)
            Memory[location] <= 32'd0;
        else if (MemWrite)
            Memory[location] <= WriteData;
    end    
    
    assign ReadData = Memory[location]; 
endmodule
