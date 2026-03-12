`timescale 1ns / 1ps

module fsm_task3 (
    input         clk,
    input         rst,
    input  [15:0] sw,
    input  [15:0] btns,
    input  [31:0] readData,     // from addressDecoderTop
    output reg [31:0] address,
    output reg        readEnable,
    output reg        writeEnable,
    output reg [31:0] writeData
);

    // FSM States
    localparam IDLE          = 3'd0;
    localparam READ_SWITCHES = 3'd1;
    localparam WRITE_DATAMEM = 3'd2;
    localparam READ_DATAMEM  = 3'd3;
    localparam WRITE_LED     = 3'd4;

    reg [2:0] state, next_state;

    // Register to hold switch data between states
    reg [31:0] switch_data;

    // Fixed addresses for each peripheral (matching memory map)
    localparam ADDR_DATAMEM = 32'h000;  // address[9:8] = 00
    localparam ADDR_LED     = 32'h100;  // address[9:8] = 01
    localparam ADDR_SWITCH  = 32'h200;  // address[9:8] = 10

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Capture readData when coming from READ_SWITCHES or READ_DATAMEM
    always @(posedge clk or posedge rst) begin
        if (rst)
            switch_data <= 32'd0;
        else if (state == READ_SWITCHES)
            switch_data <= readData;
    end

    // Next state logic
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

    // Output logic
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

            // Read current switch values
            READ_SWITCHES: begin
                address    = ADDR_SWITCH;
                readEnable = 1'b1;
            end

            // Write switch data into Data Memory
            WRITE_DATAMEM: begin
                address     = ADDR_DATAMEM;
                writeEnable = 1'b1;
                writeData   = switch_data;
            end

            // Read back from Data Memory
            READ_DATAMEM: begin
                address    = ADDR_DATAMEM;
                readEnable = 1'b1;
            end

            // Write the read-back value to LEDs
            WRITE_LED: begin
                address     = ADDR_LED;
                writeEnable = 1'b1;
                writeData   = switch_data; // display switch data on LEDs
            end
        endcase
    end

endmodule