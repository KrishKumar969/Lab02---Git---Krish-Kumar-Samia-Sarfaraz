`timescale 1ns / 1ps

module addressDecoderTop(
    input         clk,
    input         rst,
    input  [31:0] address,
    input         readEnable,
    input         writeEnable,
    input  [31:0] writeData,
    input  [15:0] switches,
    input  [15:0] btns,
    output [31:0] readData,
    output [15:0] leds
);

    // -------------------------------------------------------
    // Internal wires from Address Decoder
    // -------------------------------------------------------
    wire DataMemEnable;
    wire LEDWrite;
    wire SwitchReadEnable;

    wire [31:0] dataMemReadData;
    wire [31:0] ledReadData;
    wire [31:0] switchReadData;

    // -------------------------------------------------------
    // Address Decoder
    // -------------------------------------------------------
    AddressDecoder u_decoder (
        .rst             (rst),
        .address         (address[9:0]),
        .DataMem         (DataMemEnable),
        .LEDWrite        (LEDWrite),
        .SwitchReadEnable(SwitchReadEnable)
    );

    // -------------------------------------------------------
    // Data Memory
    // -------------------------------------------------------
    DataMemory u_datamem (
        .clk      (clk),
        .rst      (rst),
        .MemWrite (DataMemEnable & writeEnable),
        .address  (address[9:0]),
        .WriteData(writeData),
        .ReadData (dataMemReadData)
    );

    // -------------------------------------------------------
    // LEDs
    // -------------------------------------------------------
    leds u_leds (
        .clk        (clk),
        .rst        (rst),
        .writeData  (writeData),
        .writeEnable(LEDWrite & writeEnable),
        .readEnable (1'b0),
        .memAddress (address[29:0]),
        .readData   (ledReadData),
        .leds       (leds)
    );

    // -------------------------------------------------------
    // Switches
    // -------------------------------------------------------
    switches u_switches (
        .clk        (clk),
        .rst        (rst),
        .btns       (btns),
        .writeData  (writeData),
        .writeEnable(writeEnable),
        .readEnable (SwitchReadEnable & readEnable),
        .memAddress (address[29:0]),
        .sw         (switches),
        .readData   (switchReadData)
    );

    // -------------------------------------------------------
    // Read Data Mux
    // -------------------------------------------------------
    assign readData = SwitchReadEnable ? switchReadData :
                      DataMemEnable    ? dataMemReadData :
                                         32'd0;

endmodule
