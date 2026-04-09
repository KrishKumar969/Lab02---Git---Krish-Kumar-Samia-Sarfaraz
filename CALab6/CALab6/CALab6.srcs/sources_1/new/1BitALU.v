`timescale 1ns / 1ps

module ALU_1Bit(
    input wire a,
    input wire b,
    input wire [3:0] control,
    output reg signal_out,
    output reg y
    );
    
    wire signal_in = control[3];
    wire control_for_addsub = control[0];
    wire and_out;
    wire or_out;
    wire xor_out;
    wire sl_out; wire sl_signal_out;
    wire sr_out; wire sr_signal_out;
    wire add_out; wire add_signal_out;
    
    AND_1Bit AND(
        .a(a),
        .b(b),
        .y(and_out)
    );
    
    OR_1Bit OR(
        .a(a),
        .b(b),
        .y(or_out)
    );
    
    XOR_1Bit XOR(
        .a(a),
        .b(b),
        .y(xor_out)
    );
    
    SL_1Bit SL(
        .a(a),
        .signal_in(signal_in),
        .y(sl_out),
        .signal_out(sl_signal_out)
    );
    
    SR_1Bit SR(
        .a(a),
        .signal_in(signal_in),
        .y(sr_out),
        .signal_out(sr_signal_out)
    );
    
    ADDER_SUBTRACTOR_1Bit ADD(
        .a(a),
        .b(b),
        .signal(control_for_addsub),
        .cin(signal_in),
        .y(add_out),
        .cout(add_signal_out)
    );
    
    always @(*) begin
    case(control)
        4'b0000: begin y = and_out;  signal_out = 0;               end
        4'b0001: begin y = or_out;   signal_out = 0;               end
        4'b0010: begin y = xor_out;  signal_out = 0;               end
        4'b0100: begin y = sl_out;   signal_out = sl_signal_out;   end
        4'b0101: begin y = sr_out;   signal_out = sr_signal_out;   end
        // dont care cases where control_for_addsub doesnt matter
        4'b1000: begin y = and_out;  signal_out = 0;               end
        4'b1001: begin y = or_out;   signal_out = 0;               end
        4'b1010: begin y = xor_out;  signal_out = 0;               end
        4'b1100: begin y = sl_out;   signal_out = sl_signal_out;   end
        4'b1101: begin y = sr_out;   signal_out = sr_signal_out;   end

        4'b1110: begin y = add_out;  signal_out = add_signal_out;  end   // cin = 1, sub = 0
        4'b1111: begin y = add_out;  signal_out = add_signal_out;  end   // cin = 1, sub = 1
        4'b0110: begin y = add_out;  signal_out = add_signal_out;  end   // cin = 0, sub = 0
        4'b0111: begin y = add_out;  signal_out = add_signal_out;  end   // cin = 0, sub = 1
        default: begin y = 0;        signal_out = 0;               end
    endcase
end
    
endmodule
