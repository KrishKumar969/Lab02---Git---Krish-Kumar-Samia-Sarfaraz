// ============================================================
// Top-Level: RISC-V Control Path FPGA Verification
// EE/CE 321L/371L  Lab 9  -  Task 3
//
// Switch mapping (11 switches used, sw[15:11] unused):
//   sw[6:0]  → opcode[6:0]
//   sw[9:7]  → funct3[2:0]
//   sw[10]   → funct7[5]        (only relevant funct7 bit)
//   sw[15:11]→ unused
//
//   btns[0]  → reset (debounced)
//
// LED mapping (led_pins[15:0]):
//   led_pins[0]    → RegWrite
//   led_pins[1]    → ALUSrc
//   led_pins[2]    → MemtoReg
//   led_pins[3]    → MemRead
//   led_pins[4]    → MemWrite
//   led_pins[5]    → Branch
//   led_pins[7:6]  → ALUOp[1:0]
//   led_pins[11:8] → ALUControl[3:0]
//   led_pins[13:12]→ FSM state (debug)
//   led_pins[15:14]→ unused (0)
// ============================================================
`timescale 1ns/1ps

module top_control (
    input         clk,
    input         rst,
    input  [15:0] sw,
    input  [15:0] btns,
    output [15:0] led_pins
);

    // --------------------------------------------------------
    // Debounce reset button (btns[0])
    // --------------------------------------------------------
    wire rst_db;
    debouncer u_deb (
        .clk  (clk),
        .pbin (btns[0]),
        .pbout(rst_db)
    );
    wire reset = rst | rst_db;

    // --------------------------------------------------------
    // Switches peripheral - packs {btns, sw} into readData
    //   readData[15:0]  = sw[15:0]
    //   readData[31:16] = btns[15:0]
    // --------------------------------------------------------
    wire [31:0] sw_readData;

    switches u_switches (
        .clk        (clk),
        .rst        (reset),
        .btns       (btns),
        .writeData  (32'd0),
        .writeEnable(1'b0),
        .readEnable (1'b1),
        .memAddress (30'd0),
        .sw         (sw),
        .readData   (sw_readData)
    );

    // Extract instruction fields directly from sw (combinational - no register delay)
    // sw_readData is registered inside the switches peripheral, so reading it
    // would give stale values for one cycle after a switch change.
    wire [6:0] opcode = sw[6:0];
    wire [2:0] funct3 = sw[9:7];
    wire [6:0] funct7 = {1'b0, sw[10], 5'b0};  // only funct7[5] = sw[10]

    // --------------------------------------------------------
    // Main Control Unit
    // --------------------------------------------------------
    wire        RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0]  ALUOp;

    main_control u_main (
        .opcode  (opcode),
        .RegWrite(RegWrite),
        .ALUOp   (ALUOp),
        .MemRead (MemRead),
        .MemWrite(MemWrite),
        .ALUSrc  (ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch  (Branch)
    );

    // --------------------------------------------------------
    // ALU Control Unit
    // --------------------------------------------------------
    wire [3:0] ALUControl;

    alu_control u_alu (
        .ALUOp     (ALUOp),
        .funct3    (funct3),
        .funct7    (funct7),
        .ALUControl(ALUControl)
    );

    // --------------------------------------------------------
    // FSM - 2 states
    //
    //   S_IDLE    (2'b00): held in reset
    //   S_DISPLAY (2'b10): combinational outputs are valid immediately;
    //                      re-latch and re-write on every switch change
    //
    // No S_SAMPLE wait needed - main_control and alu_control are
    // purely combinational, driven directly from sw[10:0].
    // --------------------------------------------------------
    localparam S_IDLE    = 2'b00,
               S_DISPLAY = 2'b10;

    reg [1:0]  state, next_state;
    reg [10:0] sw_prev;

    // Latched control signal registers
    reg        r_RegWrite, r_ALUSrc,  r_MemtoReg;
    reg        r_MemRead,  r_MemWrite, r_Branch;
    reg [1:0]  r_ALUOp;
    reg [3:0]  r_ALUControl;

    // Signals to leds peripheral
    reg [31:0] led_writeData;
    reg        led_writeEnable;

    // --- State register ---
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state   <= S_IDLE;
            sw_prev <= 11'd0;
        end else begin
            state   <= next_state;
            sw_prev <= sw[10:0];
        end
    end

    // --- Next-state logic ---
    wire inputs_changed = (sw[10:0] != sw_prev);

    always @(*) begin
        case (state)
            S_IDLE:    next_state = S_DISPLAY;
            S_DISPLAY: next_state = S_DISPLAY;  // stay; re-latch handled in datapath
            default:   next_state = S_IDLE;
        endcase
    end

    // --- Datapath: latch and write on every cycle inputs are stable ---
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_RegWrite     <= 1'b0;
            r_ALUSrc       <= 1'b0;
            r_MemtoReg     <= 1'b0;
            r_MemRead      <= 1'b0;
            r_MemWrite     <= 1'b0;
            r_Branch       <= 1'b0;
            r_ALUOp        <= 2'b00;
            r_ALUControl   <= 4'b0000;
            led_writeData  <= 32'd0;
            led_writeEnable<= 1'b0;
        end else begin
            // Always latch combinational outputs every cycle
            r_RegWrite   <= RegWrite;
            r_ALUSrc     <= ALUSrc;
            r_MemtoReg   <= MemtoReg;
            r_MemRead    <= MemRead;
            r_MemWrite   <= MemWrite;
            r_Branch     <= Branch;
            r_ALUOp      <= ALUOp;
            r_ALUControl <= ALUControl;

            // Write to LEDs every cycle - leds peripheral only updates on writeEnable
            led_writeData  <= {16'd0,
                               2'b00,
                               state[1:0],     // [13:12] FSM debug
                               r_ALUControl,   // [11:8]
                               r_ALUOp,        // [7:6]
                               r_Branch,       // [5]
                               r_MemWrite,     // [4]
                               r_MemRead,      // [3]
                               r_MemtoReg,     // [2]
                               r_ALUSrc,       // [1]
                               r_RegWrite      // [0]
                              };
            led_writeEnable <= (state == S_DISPLAY);
        end
    end

    // --------------------------------------------------------
    // LEDs peripheral - writeData[15:0] drives physical LEDs
    // --------------------------------------------------------
    wire [31:0] led_readData;   // unused - leds is write-only here

    leds u_leds (
        .clk        (clk),
        .rst        (reset),
        .writeData  (led_writeData),
        .writeEnable(led_writeEnable),
        .readEnable (1'b0),
        .memAddress (30'd0),
        .readData   (led_readData),
        .leds       (led_pins)
    );

endmodule
