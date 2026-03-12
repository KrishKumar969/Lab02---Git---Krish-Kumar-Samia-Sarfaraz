`timescale 1ns / 1ps

module addressDecoderTop(
    input         clk,
    input         rst,
    input  [15:0] sw,
    input  [15:0] btns,
    output [15:0] leds
);

    // -------------------------------------------------------
    // FSM States
    // -------------------------------------------------------
    localparam IDLE          = 3'd0;
    localparam READ_SWITCHES = 3'd1;
    localparam WRITE_DATAMEM = 3'd2;
    localparam READ_DATAMEM  = 3'd3;
    localparam WRITE_LED     = 3'd4;

    // Fixed addresses per memory map
    localparam ADDR_DATAMEM = 32'h000;  // address[9:8] = 00
    localparam ADDR_LED     = 32'h100;  // address[9:8] = 01
    localparam ADDR_SWITCH  = 32'h200;  // address[9:8] = 10

    reg [2:0]  state, next_state;
    reg [31:0] switch_data;

    // FSM-driven control signals
    reg [31:0] address;
    reg        readEnable;
    reg        writeEnable;
    reg [31:0] writeData;

    // -------------------------------------------------------
    // Internal wires from Address Decoder
    // -------------------------------------------------------
    wire DataMemEnable;
    wire LEDWrite;
    wire SwitchReadEnable;

    // Internal readData buses
    wire [31:0] dataMemReadData;
    wire [31:0] ledReadData;      // unused
    wire [31:0] switchReadData;
    wire [31:0] readData;

    // -------------------------------------------------------
    // Address Decoder
    // -------------------------------------------------------
    AddressDecoder u_decoder (
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
        .sw         (sw),
        .readData   (switchReadData)
    );

    // -------------------------------------------------------
    // Read Data Mux
    // -------------------------------------------------------
    assign readData = SwitchReadEnable ? switchReadData :
                      DataMemEnable    ? dataMemReadData :
                                         32'd0;

    // -------------------------------------------------------
    // FSM State Register
    // -------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Capture switch data during READ_SWITCHES state
    always @(posedge clk or posedge rst) begin
        if (rst)
            switch_data <= 32'd0;
        else if (state == READ_SWITCHES)
            switch_data <= readData;
    end

    // -------------------------------------------------------
    // FSM Next State Logic
    // -------------------------------------------------------
    always @(*) begin
        case (state)
            IDLE:          next_state = READ_SWITCHES;
            READ_SWITCHES: next_state = WRITE_DATAMEM;
            WRITE_DATAMEM: next_state = READ_DATAMEM;
            READ_DATAMEM:  next_state = WRITE_LED;
            WRITE_LED:     next_state = READ_SWITCHES;
            default:       next_state = IDLE;
        endcase
    end

    // -------------------------------------------------------
    // FSM Output Logic
    // -------------------------------------------------------
    always @(*) begin
        // Defaults
        address     = 32'd0;
        readEnable  = 1'b0;
        writeEnable = 1'b0;
        writeData   = 32'd0;

        case (state)
            IDLE: begin
                address     = 32'd0;
                readEnable  = 1'b0;
                writeEnable = 1'b0;
                writeData   = 32'd0;
            end
            READ_SWITCHES: begin
                address    = ADDR_SWITCH;
                readEnable = 1'b1;
            end
            WRITE_DATAMEM: begin
                address     = ADDR_DATAMEM;
                writeEnable = 1'b1;
                writeData   = switch_data;
            end
            READ_DATAMEM: begin
                address    = ADDR_DATAMEM;
                readEnable = 1'b1;
            end
            WRITE_LED: begin
                address     = ADDR_LED;
                writeEnable = 1'b1;
                writeData   = switch_data;
            end
        endcase
    end

endmodule