module switches (
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

    wire [3:0]  led_out;
    wire [3:0]  alu_control;
    wire        cnt_en;

    fsm_counter u_fsm (
        .clk        (clk),
        .rst        (reset),
        .sw_in      (sw[3:0]),
        .led_out    (led_out),
        .alu_control(alu_control),
        .cnt_en     (cnt_en)
    );

    wire [31:0] A = 32'h10101010;
    wire [31:0] B = 32'h01010101;

    wire        alu_signal_out;
    wire [31:0] alu_result;

    ALU_32Bit u_alu (
        .A          (A),
        .B          (B),
        .Control    (alu_control),
        .signal_out (alu_signal_out),
        .Y          (alu_result)
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            readData <= 32'd0;
        else if (readEnable)
            readData <= alu_result;
    end

endmodule