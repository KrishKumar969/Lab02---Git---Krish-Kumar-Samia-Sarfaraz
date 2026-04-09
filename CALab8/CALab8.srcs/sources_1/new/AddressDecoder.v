`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2026 09:50:22 AM
// Design Name: 
// Module Name: AddressDecoder
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


module AddressDecoder(
    input         rst,
    input  [9:0]  address,
    output DataMem,
    output LEDWrite,
    output SwitchReadEnable
    );
    
    wire [1:0] signal = address[9:8];
    
    assign DataMem          = (signal == 2'b00);
    assign LEDWrite         = (signal == 2'b01);
    assign SwitchReadEnable = (signal == 2'b10);
endmodule
