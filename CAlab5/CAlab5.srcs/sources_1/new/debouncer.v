`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 10:17:02 AM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input  clk,
    input  pbin,
    output pbout
    );
    reg [2:0] shift;

    always @(posedge clk)
        shift <= {shift[1:0], pbin};

    assign pbout = (shift == 3'b111);
endmodule
