`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 10:01:53 AM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input select,
    output reg [31:0] result
    );
    
    always @ (*) begin
    if (select == 0)
        result = A + B;
    else
        result = A - B;
    end
endmodule
