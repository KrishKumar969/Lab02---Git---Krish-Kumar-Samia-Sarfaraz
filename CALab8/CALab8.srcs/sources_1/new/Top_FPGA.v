`timescale 1ns / 1ps

module top_fpga(
    input         clk,
    input         rst,
    input  [15:0] sw,
    input  [15:0] btns,
    output [15:0] leds
);

    // Wires connecting FSM (CPU) to memory system
    wire [31:0] address;
    wire        readEnable;
    wire        writeEnable;
    wire [31:0] writeData;
    wire [31:0] readData;

    // FSM: acts as the CPU, generates memory access signals
    fsm_task3 u_fsm (
        .clk        (clk),
        .rst        (rst),
        .sw         (sw),
        .btns       (btns),
        .readData   (readData),
        .address    (address),
        .readEnable (readEnable),
        .writeEnable(writeEnable),
        .writeData  (writeData)
    );

    // Memory system: routes CPU signals to correct peripheral
    addressDecoderTop u_mem (
        .clk        (clk),
        .rst        (rst),
        .address    (address),
        .readEnable (readEnable),
        .writeEnable(writeEnable),
        .writeData  (writeData),
        .switches   (sw),
        .btns       (btns),
        .readData   (readData),
        .leds       (leds)
    );

endmodule