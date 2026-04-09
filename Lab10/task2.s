.text
.globl _start

_start:
    lui  x2,  0x00000
    addi x2,  x2,  0x1FC

    addi x5,  x0,  512
    addi x6,  x0,  768
    addi x7,  x0,  772

    lui  x18, 0x3
    addi x18, x18, 0x30D5 & 0xFFF

    addi x8,  x0,  0
    sw   x0,  0(x5)
    j    fsm_loop

fsm_loop:
    lw   x20, 0(x7)
    bne  x20, x0, do_reset

    lw   x9,  0(x6)
    beq  x9,  x0,  fsm_loop

    addi x8,  x0,  1
    sw   x9,  0(x5)
    addi x10, x9,  0

    addi x2,  x2,  -4
    sw   x1,  0(x2)

    jal  x1,  countdown

    lw   x1,  0(x2)
    addi x2,  x2,  4

    addi x8,  x0,  0
    sw   x0,  0(x5)
    j    fsm_loop

do_reset:
    addi x8,  x0,  0
    addi x9,  x0,  0
    sw   x0,  0(x5)
    j    fsm_loop

countdown:
    addi x2,  x2,  -8
    sw   x1,  4(x2)
    sw   x8,  0(x2)

countdown_loop:
    beq  x10, x0,  countdown_done

    lw   x20, 0(x7)
    bne  x20, x0, countdown_reset

    sw   x10, 0(x5)
    addi x11, x18, 0

delay_loop:
    addi x11, x11, -1
    bne  x11, x0,  delay_loop

    addi x10, x10, -1
    j    countdown_loop

countdown_reset:
    sw   x0,  0(x5)
    addi x10, x0,  0

countdown_done:
    lw   x8,  0(x2)
    lw   x1,  4(x2)
    addi x2,  x2,  8

    jalr x0,  x1,  0