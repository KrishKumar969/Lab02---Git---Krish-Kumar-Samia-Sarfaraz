.text
.globl main
main:
#Task 1
# addi x10,x0,12  # initialise variables
# addi x11,x0,12
# jal x1,sum   # function call
# addi x11,x10,0   # ecall id
# li x10,1    # ecall value
# ecall
# j exit
# sum:    # label
#     add x10,x11,x10      # sum
#     jalr x0,0(x1)   # exit the function
# exit:

# Task 2
# li x10,3    # initialise variables
# li x11,4
# li x12,5
# li x13,6
# jal x1,leaf_example # function call
# j exit
# leaf_example:
#     addi sp,sp,-12   # allocating space in the stack
#     sw x18,8(sp)   # storing initial values in the stack
#     sw x19,4(sp)
#     sw x20,0(sp)
#     add x18,x10,x11    # g + h
#     add x19,x12,x13    # i + j
#     sub x20,x18,x19    # f = (g+h) - (i+j)
#     li x10,1      # ecall id
#     mv x11, x20   # ecall value
#     ecall
#     lw x18,8(sp)   # loading from the stack
#     lw x19,4(sp)
#     lw x20,0(sp)
#     addi sp,sp,12  # dealocating the stack
#     jalr x0,0(x1)  # exit the function
# exit:

# Task 3
li x10,0x100  # array location
li x11, 0    # k
li x9, 7      # random values
sw x9, 0(x10)
li x9, 2
sw x9, 4(x10)
li x9, 6
sw x9, 8(x10)

jal x1,swap   # function call
j exit

swap:
    add x10,x10,x11    # 0x100 + 0  #k    
    lw x5, 0(x10)  #0x100
    addi x11,x11,4  # x11 = 4
    add x10,x10,x11
    lw x6, 0(x10)  #0x100 + 4

    sw x5, 0(x10)    # swapping values
    sub x10,x10,x11
    sw x6, 0(x10)

    jalr x0,0(x1)      # exit function
exit:


end:
    j end