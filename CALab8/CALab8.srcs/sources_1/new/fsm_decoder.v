`timescale 1ns / 1ps

module fsm_task3 (
    input         clk,
    input         rst,
    input  [15:0] sw,
    input  [15:0] btns,
    input  [31:0] readData,
    output reg [31:0] address,
    output reg        readEnable,
    output reg        writeEnable,
    output reg [31:0] writeData
);

    localparam IDLE          = 3'd0;
    localparam READ_SWITCHES = 3'd1;
    localparam WRITE_DATAMEM = 3'd2;
    localparam READ_DATAMEM  = 3'd3;
    localparam WRITE_LED     = 3'd4;

    reg [2:0]  state, next_state;
    reg [31:0] switch_data;

    // Counter to cycle through memory locations 0-255
    reg [7:0] mem_addr_counter;

    localparam ADDR_LED    = 32'h100;
    localparam ADDR_SWITCH = 32'h200;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    // Increment memory address counter each full FSM loop
    always @(posedge clk or posedge rst) begin
        if (rst)
            mem_addr_counter <= 8'd0;
        else if (state == WRITE_LED)
            mem_addr_counter <= mem_addr_counter + 1;
    end

    // Capture sw directly
    always @(posedge clk or posedge rst) begin
        if (rst)
            switch_data <= 32'd0;
        else if (state == READ_SWITCHES)
            switch_data <= {btns, sw};
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
        address     = 32'd0;
        readEnable  = 1'b0;
        writeEnable = 1'b0;
        writeData   = 32'd0;

        case (state)
            IDLE: begin
                address = 32'd0; readEnable = 0; writeEnable = 0; writeData = 0;
            end
            READ_SWITCHES: begin
                address    = ADDR_SWITCH;
                readEnable = 1'b1;
            end
            // Write to incrementing memory address each loop
            WRITE_DATAMEM: begin
                address     = {24'd0, mem_addr_counter};  // cycles 0x000, 0x001, 0x002...
                writeEnable = 1'b1;
                writeData   = switch_data;
            end
            // Read back from same address
            READ_DATAMEM: begin
                address    = {24'd0, mem_addr_counter};
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
