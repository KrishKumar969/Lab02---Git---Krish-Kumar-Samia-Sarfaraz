module top (
    input        clk,
    input        rst,
    input  [3:0] sw,
    input  [3:0] btns,
    output [3:0] led
);
 
    // wires for this module
    wire [31:0] leds_readData;
    wire [31:0] sw_readData;
 
   
    wire [31:0] writeData    = 32'd0;
    wire        writeEnable  = 1'b0;
    wire        readEnable   = 1'b1;
    wire [29:0] memAddress   = 30'd0;
 
    // Leds
    leds u_leds (
        .clk        (clk),
        .rst        (rst),
        .btns       ({12'd0, btns}),   
        .writeData  (writeData),
        .writeEnable(writeEnable),
        .readEnable (readEnable),
        .memAddress (memAddress),
        .sw         ({12'd0, sw}),     
        .readData   (leds_readData)
    );
 
    // switches
    switches u_switches (
        .clk        (clk),
        .rst        (rst),
        .writeData  (writeData),
        .writeEnable(writeEnable),
        .readEnable (readEnable),
        .memAddress (memAddress),
        .readData   (sw_readData),
        .leds       ()                 
    );
 
    
    assign led = leds_readData[3:0];
 
endmodule