.text
.globl main
main:
#Task 1
# addi x10,x0,12
# addi x11,x0,12
# jal x1,sum
# addi x11,x10,0
# li x10,1
# ecall
# j exit
# sum:
#     add x10,x11,x10
#     jalr x0,0(x1)
# exit:

# Task 2
li x10,3
li x11,4
li x12,5
li x13,6
jal x1,leaf_example
j exit
leaf_example:
    addi sp,sp,-12
    sw x18,8(sp)
    sw x19,4(sp)
    sw x20,0(sp)
    add x18,x10,x11
    add x19,x12,x13
    sub x20,x18,x19 
    li x10,1
    mv x11, x20
    ecall
    lw x18,8(sp)
    lw x19,4(sp)
    lw x20,0(sp)
    addi sp,sp,12
    jalr x0,0(x1)
exit:
end:
    j end