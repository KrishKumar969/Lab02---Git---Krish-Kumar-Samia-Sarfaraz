module ALU_32Bit(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] Control,
    output wire signal_out,
    output wire [31:0] Y
    );
    
    wire [31:0] signal_chain;
    wire [31:0] y_chain;
    wire [31:0] sr_result;
    wire sr_op;
    
    assign sr_op    = (Control[2:0] == 3'b101);
    assign sr_result = {A[31], A[31:1]};
    wire cin0 = Control[0];
    
    ALU_1Bit ALU0 (.a(A[0]), .b(B[0]), .control({cin0, Control[2:0]}), .signal_out(signal_chain[0]), .y(y_chain[0]));
    ALU_1Bit ALU1 (.a(A[1]),  .b(B[1]),  .control({signal_chain[0],  Control[2:0]}), .signal_out(signal_chain[1]),  .y(y_chain[1]));
    ALU_1Bit ALU2 (.a(A[2]),  .b(B[2]),  .control({signal_chain[1],  Control[2:0]}), .signal_out(signal_chain[2]),  .y(y_chain[2]));
    ALU_1Bit ALU3 (.a(A[3]),  .b(B[3]),  .control({signal_chain[2],  Control[2:0]}), .signal_out(signal_chain[3]),  .y(y_chain[3]));
    ALU_1Bit ALU4 (.a(A[4]),  .b(B[4]),  .control({signal_chain[3],  Control[2:0]}), .signal_out(signal_chain[4]),  .y(y_chain[4]));
    ALU_1Bit ALU5 (.a(A[5]),  .b(B[5]),  .control({signal_chain[4],  Control[2:0]}), .signal_out(signal_chain[5]),  .y(y_chain[5]));
    ALU_1Bit ALU6 (.a(A[6]),  .b(B[6]),  .control({signal_chain[5],  Control[2:0]}), .signal_out(signal_chain[6]),  .y(y_chain[6]));
    ALU_1Bit ALU7 (.a(A[7]),  .b(B[7]),  .control({signal_chain[6],  Control[2:0]}), .signal_out(signal_chain[7]),  .y(y_chain[7]));
    ALU_1Bit ALU8 (.a(A[8]),  .b(B[8]),  .control({signal_chain[7],  Control[2:0]}), .signal_out(signal_chain[8]),  .y(y_chain[8]));
    ALU_1Bit ALU9 (.a(A[9]),  .b(B[9]),  .control({signal_chain[8],  Control[2:0]}), .signal_out(signal_chain[9]),  .y(y_chain[9]));
    ALU_1Bit ALU10(.a(A[10]), .b(B[10]), .control({signal_chain[9],  Control[2:0]}), .signal_out(signal_chain[10]), .y(y_chain[10]));
    ALU_1Bit ALU11(.a(A[11]), .b(B[11]), .control({signal_chain[10], Control[2:0]}), .signal_out(signal_chain[11]), .y(y_chain[11]));
    ALU_1Bit ALU12(.a(A[12]), .b(B[12]), .control({signal_chain[11], Control[2:0]}), .signal_out(signal_chain[12]), .y(y_chain[12]));
    ALU_1Bit ALU13(.a(A[13]), .b(B[13]), .control({signal_chain[12], Control[2:0]}), .signal_out(signal_chain[13]), .y(y_chain[13]));
    ALU_1Bit ALU14(.a(A[14]), .b(B[14]), .control({signal_chain[13], Control[2:0]}), .signal_out(signal_chain[14]), .y(y_chain[14]));
    ALU_1Bit ALU15(.a(A[15]), .b(B[15]), .control({signal_chain[14], Control[2:0]}), .signal_out(signal_chain[15]), .y(y_chain[15]));
    ALU_1Bit ALU16(.a(A[16]), .b(B[16]), .control({signal_chain[15], Control[2:0]}), .signal_out(signal_chain[16]), .y(y_chain[16]));
    ALU_1Bit ALU17(.a(A[17]), .b(B[17]), .control({signal_chain[16], Control[2:0]}), .signal_out(signal_chain[17]), .y(y_chain[17]));
    ALU_1Bit ALU18(.a(A[18]), .b(B[18]), .control({signal_chain[17], Control[2:0]}), .signal_out(signal_chain[18]), .y(y_chain[18]));
    ALU_1Bit ALU19(.a(A[19]), .b(B[19]), .control({signal_chain[18], Control[2:0]}), .signal_out(signal_chain[19]), .y(y_chain[19]));
    ALU_1Bit ALU20(.a(A[20]), .b(B[20]), .control({signal_chain[19], Control[2:0]}), .signal_out(signal_chain[20]), .y(y_chain[20]));
    ALU_1Bit ALU21(.a(A[21]), .b(B[21]), .control({signal_chain[20], Control[2:0]}), .signal_out(signal_chain[21]), .y(y_chain[21]));
    ALU_1Bit ALU22(.a(A[22]), .b(B[22]), .control({signal_chain[21], Control[2:0]}), .signal_out(signal_chain[22]), .y(y_chain[22]));
    ALU_1Bit ALU23(.a(A[23]), .b(B[23]), .control({signal_chain[22], Control[2:0]}), .signal_out(signal_chain[23]), .y(y_chain[23]));
    ALU_1Bit ALU24(.a(A[24]), .b(B[24]), .control({signal_chain[23], Control[2:0]}), .signal_out(signal_chain[24]), .y(y_chain[24]));
    ALU_1Bit ALU25(.a(A[25]), .b(B[25]), .control({signal_chain[24], Control[2:0]}), .signal_out(signal_chain[25]), .y(y_chain[25]));
    ALU_1Bit ALU26(.a(A[26]), .b(B[26]), .control({signal_chain[25], Control[2:0]}), .signal_out(signal_chain[26]), .y(y_chain[26]));
    ALU_1Bit ALU27(.a(A[27]), .b(B[27]), .control({signal_chain[26], Control[2:0]}), .signal_out(signal_chain[27]), .y(y_chain[27]));
    ALU_1Bit ALU28(.a(A[28]), .b(B[28]), .control({signal_chain[27], Control[2:0]}), .signal_out(signal_chain[28]), .y(y_chain[28]));
    ALU_1Bit ALU29(.a(A[29]), .b(B[29]), .control({signal_chain[28], Control[2:0]}), .signal_out(signal_chain[29]), .y(y_chain[29]));
    ALU_1Bit ALU30(.a(A[30]), .b(B[30]), .control({signal_chain[29], Control[2:0]}), .signal_out(signal_chain[30]), .y(y_chain[30]));
    ALU_1Bit ALU31(.a(A[31]), .b(B[31]), .control({signal_chain[30], Control[2:0]}), .signal_out(signal_chain[31]), .y(y_chain[31]));

    assign Y          = sr_op ? sr_result : y_chain;
    assign signal_out = sr_op ? A[0] : signal_chain[31];

endmodule