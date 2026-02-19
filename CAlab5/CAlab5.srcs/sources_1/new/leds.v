module leds (
    input         clk,
    input         rst,
    input  [15:0] btns,
    input  [31:0] writeData,
    input         writeEnable,
    input         readEnable,
    input  [29:0] memAddress,
    input  [15:0] sw,
    output reg [31:0] readData
);

    wire rst_db;
    debouncer u_debouncer (
        .clk  (clk),
        .pbin (btns[0]),
        .pbout(rst_db)
    );

    wire reset = rst | rst_db;

    wire [3:0] led_out;
    wire       cnt_en;

    fsm_counter u_fsm (
        .clk    (clk),
        .rst    (reset),
        .sw_in  (sw[3:0]),
        .led_out(led_out),
        .cnt_en (cnt_en)
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            readData <= 32'd0;
        else if (readEnable)
            readData <= {28'd0, led_out};
    end

endmodule