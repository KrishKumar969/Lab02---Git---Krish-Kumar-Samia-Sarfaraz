module fsm_counter (
    input        clk,   
    input        rst,
    input  [3:0] sw_in,
    output reg [3:0] led_out,
    output reg   cnt_en
);
    localparam S0 = 1'b0,
               S1 = 1'b1;
    reg        state;
    reg  [3:0] counter;
 
    
    // 100,000,000 cycles = 1 second
    reg [26:0] clk_div;
    reg        slow_clk;
 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_div  <= 27'd0;
            slow_clk <= 1'b0;
        end
        else begin
            if (clk_div == 27'd4) begin
                clk_div  <= 27'd0;
                slow_clk <= ~slow_clk;
            end
            else
                clk_div <= clk_div + 1;
        end
    end
 
    
    always @(posedge slow_clk or posedge rst) begin
        if (rst) begin
            state   <= S0;
            counter <= 4'd0;
            led_out <= 4'd0;
            cnt_en  <= 1'b0;
        end
        else begin
            case (state)
                S0: begin
                    cnt_en  <= 1'b0;
                    led_out <= 4'd0;
                    if (sw_in != 4'd0) begin
                        counter <= sw_in;
                        led_out <= sw_in;
                        state   <= S1;
                    end
                end
                S1: begin
                    cnt_en <= 1'b1;
                    if (counter == 4'd0) begin
                        cnt_en  <= 1'b0;
                        led_out <= 4'd0;
                        state   <= S0;
                    end
                    else begin
                        counter <= counter - 4'd1;
                        led_out <= counter;
                    end
                end
                default: state <= S0;
            endcase
        end
    end
endmodule
