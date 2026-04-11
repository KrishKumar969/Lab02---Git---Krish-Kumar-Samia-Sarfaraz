
module ProgramCounter (
    input             clk,
    input             rst,
    input      [31:0] PC_Next,   // next PC value (from mux2)
    output reg [31:0] PC         // current PC value
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            PC <= 32'h00000000;
        else
            PC <= PC_Next;
    end

endmodule
