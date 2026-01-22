.text
.globl main
main:
# Task1
    # li x9,5   Listing 3
    # li x10,8
    # li x21,7
    # li x24,4
    # li x25,5

#     bne x22,x23,Else
#     add x19,x20,x21
#     beq x0,x0,Exit
# Else: sub x19,x20,x21

# Exit:

# Listing 4
# Loop: slli x10,x22,3
#     add x10,x10,x25
#     lw x9,0(x10)
#     bne x9,x24, Exit
#     addi x22,x22,1
#     beq x0,x0,Loop
# Exit:

# Task 2
    li x1,1
    li x2,2
    li x3,3
    li x4,4
    li x22,8
    li x23,4
    li x20,1

    beq x20,x1,CASE1

    beq x20,x2,CASE2

    beq x20,x3,CASE3

    beq x20,x4,CASE4

    li x21,0
    beq x0,x0,end

    CASE1:
    add x21,x22,x23
    beq x0,x0,end


    CASE2:
    sub x21,x22,x23
    beq x0,x0,end

    CASE3:
    slli x21,x22,1
    beq x0,x0,end

    CASE4:
    srai x21,x22,1
    beq x0,x0,end
end:
    j end
