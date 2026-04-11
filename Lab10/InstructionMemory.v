

module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input  [OPERAND_LENGTH:0] instAddress,
    output reg [31:0]         instruction
);

    reg [7:0] memory [0:255];

    always @(*) begin
        instruction = {
            memory[instAddress + 3],
            memory[instAddress + 2],
            memory[instAddress + 1],
            memory[instAddress]
        };
    end

    // --------------------------------------------------------
    // Memory initialisation - FSM assembly program machine code
    //
    // Register assignments:
    //   x2  = stack pointer (SP)
    //   x5  = 0x200 (512)  ? LED  memory-mapped address
    //   x6  = 0x300 (768)  ? Switch memory-mapped address
    //   x7  = 0x304 (772)  ? Reset button address
    //   x8  = FSM state variable (0=INPUT_WAIT, 1=COUNTDOWN)
    //   x9  = captured switch input
    //   x10 = countdown counter
    //   x11 = delay loop counter
    //   x18 = delay constant (0x30D5 = 12501 ticks)
    //   x20 = reset button read value
    //
    // Label ? PC map:
    //   _start          : 0x00
    //   fsm_loop        : 0x28
    //   do_reset        : 0x64
    //   countdown       : 0x74
    //   countdown_loop  : 0x80
    //   delay_loop      : 0x94
    //   countdown_reset : 0xA4
    //   countdown_done  : 0xBC
    // --------------------------------------------------------
    initial begin

        // --------------------------------------------------
        // _start (PC = 0x00)
        // --------------------------------------------------

        // 0x00 : lui x2, 0x00000
        memory[0]   = 8'h37; memory[1]   = 8'h01; memory[2]   = 8'h00; memory[3]   = 8'h00;

        // 0x04 : addi x2, x2, 0x1FC   (SP = 0x1FC)
        memory[4]   = 8'h13; memory[5]   = 8'h01; memory[6]   = 8'hC1; memory[7]   = 8'h1F;

        // 0x08 : addi x5, x0, 512     (x5 = LED base)
        memory[8]   = 8'h93; memory[9]   = 8'h02; memory[10]  = 8'h00; memory[11]  = 8'h20;

        // 0x0C : addi x6, x0, 768     (x6 = Switch base)
        memory[12]  = 8'h13; memory[13]  = 8'h03; memory[14]  = 8'h00; memory[15]  = 8'h30;

        // 0x10 : addi x7, x0, 772     (x7 = Reset button)
        memory[16]  = 8'h93; memory[17]  = 8'h03; memory[18]  = 8'h40; memory[19]  = 8'h30;

        // 0x14 : lui x18, 0x3         (upper part of delay constant)
        memory[20]  = 8'h37; memory[21]  = 8'h39; memory[22]  = 8'h00; memory[23]  = 8'h00;

        // 0x18 : addi x18, x18, 213   (x18 = 0x30D5 = 12501, delay ticks)
        memory[24]  = 8'h13; memory[25]  = 8'h09; memory[26]  = 8'h59; memory[27]  = 8'h0D;

        // 0x1C : addi x8, x0, 0       (state = INPUT_WAIT)
        memory[28]  = 8'h13; memory[29]  = 8'h04; memory[30]  = 8'h00; memory[31]  = 8'h00;

        // 0x20 : sw x0, 0(x5)         (clear LEDs)
        memory[32]  = 8'h23; memory[33]  = 8'hA0; memory[34]  = 8'h02; memory[35]  = 8'h00;

        // 0x24 : j fsm_loop           (jal x0, +4)
        memory[36]  = 8'h6F; memory[37]  = 8'h00; memory[38]  = 8'h40; memory[39]  = 8'h00;

        // --------------------------------------------------
        // fsm_loop / INPUT_WAIT state (PC = 0x28)
        // --------------------------------------------------

        // 0x28 : lw x20, 0(x7)        (read reset button)
        memory[40]  = 8'h03; memory[41]  = 8'hAA; memory[42]  = 8'h03; memory[43]  = 8'h00;

        // 0x2C : bne x20, x0, do_reset  (if reset pressed ? do_reset)
        memory[44]  = 8'h63; memory[45]  = 8'h1C; memory[46]  = 8'h0A; memory[47]  = 8'h02;

        // 0x30 : lw x9, 0(x6)         (read switches)
        memory[48]  = 8'h83; memory[49]  = 8'h24; memory[50]  = 8'h03; memory[51]  = 8'h00;

        // 0x34 : beq x9, x0, fsm_loop (if sw==0 ? stay in INPUT_WAIT)
        memory[52]  = 8'hE3; memory[53]  = 8'h8A; memory[54]  = 8'h04; memory[55]  = 8'hFE;

        // 0x38 : addi x8, x0, 1       (state = COUNTDOWN)
        memory[56]  = 8'h13; memory[57]  = 8'h04; memory[58]  = 8'h10; memory[59]  = 8'h00;

        // 0x3C : sw x9, 0(x5)         (led = captured sw value)
        memory[60]  = 8'h23; memory[61]  = 8'hA0; memory[62]  = 8'h92; memory[63]  = 8'h00;

        // 0x40 : addi x10, x9, 0      (counter = sw_in)
        memory[64]  = 8'h13; memory[65]  = 8'h85; memory[66]  = 8'h04; memory[67]  = 8'h00;

        // 0x44 : addi x2, x2, -4      (push stack)
        memory[68]  = 8'h13; memory[69]  = 8'h01; memory[70]  = 8'hC1; memory[71]  = 8'hFF;

        // 0x48 : sw x1, 0(x2)         (save return address)
        memory[72]  = 8'h23; memory[73]  = 8'h20; memory[74]  = 8'h11; memory[75]  = 8'h00;

        // 0x4C : jal x1, countdown    (call countdown subroutine)
        memory[76]  = 8'hEF; memory[77]  = 8'h00; memory[78]  = 8'h80; memory[79]  = 8'h02;

        // 0x50 : lw x1, 0(x2)         (restore return address)
        memory[80]  = 8'h83; memory[81]  = 8'h20; memory[82]  = 8'h01; memory[83]  = 8'h00;

        // 0x54 : addi x2, x2, 4       (pop stack)
        memory[84]  = 8'h13; memory[85]  = 8'h01; memory[86]  = 8'h41; memory[87]  = 8'h00;

        // 0x58 : addi x8, x0, 0       (state = INPUT_WAIT)
        memory[88]  = 8'h13; memory[89]  = 8'h04; memory[90]  = 8'h00; memory[91]  = 8'h00;

        // 0x5C : sw x0, 0(x5)         (clear LEDs)
        memory[92]  = 8'h23; memory[93]  = 8'hA0; memory[94]  = 8'h02; memory[95]  = 8'h00;

        // 0x60 : j fsm_loop
        memory[96]  = 8'h6F; memory[97]  = 8'hF0; memory[98]  = 8'h9F; memory[99]  = 8'hFC;

        // --------------------------------------------------
        // do_reset (PC = 0x64)
        // --------------------------------------------------

        // 0x64 : addi x8, x0, 0       (state = INPUT_WAIT)
        memory[100] = 8'h13; memory[101] = 8'h04; memory[102] = 8'h00; memory[103] = 8'h00;

        // 0x68 : addi x9, x0, 0       (clear sw capture)
        memory[104] = 8'h93; memory[105] = 8'h04; memory[106] = 8'h00; memory[107] = 8'h00;

        // 0x6C : sw x0, 0(x5)         (clear LEDs)
        memory[108] = 8'h23; memory[109] = 8'hA0; memory[110] = 8'h02; memory[111] = 8'h00;

        // 0x70 : j fsm_loop
        memory[112] = 8'h6F; memory[113] = 8'hF0; memory[114] = 8'h9F; memory[115] = 8'hFB;

        // --------------------------------------------------
        // countdown subroutine (PC = 0x74)
        // --------------------------------------------------

        // 0x74 : addi x2, x2, -8      (allocate stack frame)
        memory[116] = 8'h13; memory[117] = 8'h01; memory[118] = 8'h81; memory[119] = 8'hFF;

        // 0x78 : sw x1, 4(x2)         (save return address)
        memory[120] = 8'h23; memory[121] = 8'h22; memory[122] = 8'h11; memory[123] = 8'h00;

        // 0x7C : sw x8, 0(x2)         (save state variable)
        memory[124] = 8'h23; memory[125] = 8'h20; memory[126] = 8'h81; memory[127] = 8'h00;

        // --------------------------------------------------
        // countdown_loop (PC = 0x80)
        // --------------------------------------------------

        // 0x80 : lw x20, 0(x7)        (poll reset button first)
        memory[128] = 8'h03; memory[129] = 8'hAA; memory[130] = 8'h03; memory[131] = 8'h00;

        // 0x84 : bne x20, x0, countdown_reset  (reset pressed?)
        memory[132] = 8'h63; memory[133] = 8'h10; memory[134] = 8'h0A; memory[135] = 8'h02;

        // 0x88 : beq x10, x0, countdown_done   (counter == 0 ? done)
        memory[136] = 8'h63; memory[137] = 8'h0A; memory[138] = 8'h05; memory[139] = 8'h02;

        // 0x8C : sw x10, 0(x5)        (led = counter)
        memory[140] = 8'h23; memory[141] = 8'hA0; memory[142] = 8'hA2; memory[143] = 8'h00;

        // 0x90 : addi x11, x18, 0     (load delay constant)
        memory[144] = 8'h93; memory[145] = 8'h05; memory[146] = 8'h09; memory[147] = 8'h00;

        // --------------------------------------------------
        // delay_loop (PC = 0x94)
        // --------------------------------------------------

        // 0x94 : addi x11, x11, -1
        memory[148] = 8'h93; memory[149] = 8'h85; memory[150] = 8'hF5; memory[151] = 8'hFF;

        // 0x98 : bne x11, x0, delay_loop
        memory[152] = 8'hE3; memory[153] = 8'h9E; memory[154] = 8'h05; memory[155] = 8'hFE;

        // 0x9C : addi x10, x10, -1    (decrement counter)
        memory[156] = 8'h13; memory[157] = 8'h05; memory[158] = 8'hF5; memory[159] = 8'hFF;

        // 0xA0 : j countdown_loop
        memory[160] = 8'h6F; memory[161] = 8'hF0; memory[162] = 8'h1F; memory[163] = 8'hFE;

        // --------------------------------------------------
        // countdown_reset (PC = 0xA4)
        // --------------------------------------------------

        // 0xA4 : lw x8, 0(x2)         (restore state variable)
        memory[164] = 8'h03; memory[165] = 8'h24; memory[166] = 8'h01; memory[167] = 8'h00;

        // 0xA8 : lw x1, 4(x2)         (restore return address)
        memory[168] = 8'h83; memory[169] = 8'h20; memory[170] = 8'h41; memory[171] = 8'h00;

        // 0xAC : addi x2, x2, 8       (deallocate stack frame)
        memory[172] = 8'h13; memory[173] = 8'h01; memory[174] = 8'h81; memory[175] = 8'h00;

        // 0xB0 : sw x0, 0(x5)         (clear LEDs)
        memory[176] = 8'h23; memory[177] = 8'hA0; memory[178] = 8'h02; memory[179] = 8'h00;

        // 0xB4 : addi x8, x0, 0       (state = INPUT_WAIT)
        memory[180] = 8'h13; memory[181] = 8'h04; memory[182] = 8'h00; memory[183] = 8'h00;

        // 0xB8 : j fsm_loop           (jump directly to INPUT_WAIT)
        memory[184] = 8'h6F; memory[185] = 8'hF0; memory[186] = 8'h1F; memory[187] = 8'hF7;

        // --------------------------------------------------
        // countdown_done (PC = 0xBC)
        // --------------------------------------------------

        // 0xBC : lw x8, 0(x2)         (restore state variable)
        memory[188] = 8'h03; memory[189] = 8'h24; memory[190] = 8'h01; memory[191] = 8'h00;

        // 0xC0 : lw x1, 4(x2)         (restore return address)
        memory[192] = 8'h83; memory[193] = 8'h20; memory[194] = 8'h41; memory[195] = 8'h00;

        // 0xC4 : addi x2, x2, 8       (deallocate stack frame)
        memory[196] = 8'h13; memory[197] = 8'h01; memory[198] = 8'h81; memory[199] = 8'h00;

        // 0xC8 : jalr x0, x1, 0       (return to caller)
        memory[200] = 8'h67; memory[201] = 8'h80; memory[202] = 8'h00; memory[203] = 8'h00;

    end

endmodule