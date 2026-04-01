## ============================================================
## Basys 3 Constraints â€” RISC-V Control Path  Lab 9
##
## Switch mapping:
##   sw[6:0]  â†’ opcode[6:0]
##   sw[9:7]  â†’ funct3[2:0]
##   sw[10]   â†’ funct7[5]
##   sw[15:11]â†’ unused
##
## Button mapping:
##   btns[0]  â†’ BTNC (centre) â€” reset
##
## LED mapping:
##   led_pins[0]    â†’ RegWrite
##   led_pins[1]    â†’ ALUSrc
##   led_pins[2]    â†’ MemtoReg
##   led_pins[3]    â†’ MemRead
##   led_pins[4]    â†’ MemWrite
##   led_pins[5]    â†’ Branch
##   led_pins[7:6]  â†’ ALUOp[1:0]
##   led_pins[11:8] â†’ ALUControl[3:0]
##   led_pins[13:12]â†’ FSM state (debug)
##   led_pins[15:14]â†’ unused
## ============================================================

## Clock (100 MHz)
set_property PACKAGE_PIN W5  [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset
set_property PACKAGE_PIN U17 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## â”€â”€ Switches â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

## opcode[6:0] â†’ sw[6:0]
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]

set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]

set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]

set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]

set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]

set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]

set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]

## funct3[2:0] â†’ sw[9:7]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]

set_property PACKAGE_PIN V2  [get_ports {sw[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]

set_property PACKAGE_PIN T3  [get_ports {sw[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]

## funct7[5] â†’ sw[10]
set_property PACKAGE_PIN T2  [get_ports {sw[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]

## sw[15:11] â€” unused but constrained to avoid warnings
set_property PACKAGE_PIN R3  [get_ports {sw[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]

set_property PACKAGE_PIN W2  [get_ports {sw[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]

set_property PACKAGE_PIN U1  [get_ports {sw[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]

set_property PACKAGE_PIN T1  [get_ports {sw[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]

set_property PACKAGE_PIN R2  [get_ports {sw[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]

## â”€â”€ Buttons â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

## btns[0] = BTNC (centre) â€” debounced reset
set_property PACKAGE_PIN U18 [get_ports {btns[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns[0]}]

## btns[1] = BTNU (up) â€” unused but declared
set_property PACKAGE_PIN T18 [get_ports {btns[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns[1]}]

## btns[2] = BTNL (left)
set_property PACKAGE_PIN W19 [get_ports {btns[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns[2]}]

## btns[3] = BTNR (right)
set_property PACKAGE_PIN T17 [get_ports {btns[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns[3]}]

## btns[4] = BTND (down)
set_property PACKAGE_PIN V17 [get_ports {btns[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns[4]}]

## â”€â”€ LEDs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

## led_pins[0]  â†’ RegWrite
set_property PACKAGE_PIN U16 [get_ports {led_pins[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[7]}]

## led_pins[1]  â†’ ALUSrc
set_property PACKAGE_PIN E19 [get_ports {led_pins[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[6]}]

## led_pins[2]  â†’ MemtoReg
set_property PACKAGE_PIN U19 [get_ports {led_pins[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[5]}]

## led_pins[3]  â†’ MemRead
set_property PACKAGE_PIN V19 [get_ports {led_pins[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[4]}]

## led_pins[4]  â†’ MemWrite
set_property PACKAGE_PIN W18 [get_ports {led_pins[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[3]}]

## led_pins[5]  â†’ Branch
set_property PACKAGE_PIN U15 [get_ports {led_pins[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[2]}]

## led_pins[6]  â†’ ALUOp[0]
set_property PACKAGE_PIN U14 [get_ports {led_pins[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[0]}]

## led_pins[7]  â†’ ALUOp[1]
set_property PACKAGE_PIN V14 [get_ports {led_pins[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[1]}]

## led_pins[8]  â†’ ALUControl[0]
set_property PACKAGE_PIN V13 [get_ports {led_pins[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[8]}]

## led_pins[9]  â†’ ALUControl[1]
set_property PACKAGE_PIN V3  [get_ports {led_pins[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[9]}]

## led_pins[10] â†’ ALUControl[2]
set_property PACKAGE_PIN W3  [get_ports {led_pins[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[10]}]

## led_pins[11] â†’ ALUControl[3]
set_property PACKAGE_PIN U3  [get_ports {led_pins[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[11]}]

## led_pins[12] â†’ FSM state[0]
set_property PACKAGE_PIN P3  [get_ports {led_pins[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[12]}]

## led_pins[13] â†’ FSM state[1]
set_property PACKAGE_PIN N3  [get_ports {led_pins[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[13]}]

## led_pins[14] â†’ unused
set_property PACKAGE_PIN P1  [get_ports {led_pins[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[14]}]

## led_pins[15] â†’ unused
set_property PACKAGE_PIN L1  [get_ports {led_pins[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_pins[15]}]
