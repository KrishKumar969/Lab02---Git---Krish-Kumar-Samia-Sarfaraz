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


    always @(posedge clk or posedge rst) begin
        if (rst)
            readData <= 32'd0;
        else if (readEnable)
            readData <= {btns, sw};
        // holds last value when readEnable is low
    end

endmodule
