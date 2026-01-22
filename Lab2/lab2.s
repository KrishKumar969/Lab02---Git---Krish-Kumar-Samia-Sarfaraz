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

# # Task 2
#     li x1,1
#     li x2,2
#     li x3,3
#     li x4,4
#     li x22,8
#     li x23,4
#     li x20,1

#     beq x20,x1,CASE1

#     beq x20,x2,CASE2

#     beq x20,x3,CASE3

#     beq x20,x4,CASE4

#     li x21,0
#     beq x0,x0,end

#     CASE1:
#     add x21,x22,x23
#     beq x0,x0,end

#     CASE2:
#     sub x21,x22,x23
#     beq x0,x0,end

#     CASE3:
#     slli x21,x22,1
#     beq x0,x0,end

#     CASE4:
#     srai x21,x22,1
#     beq x0,x0,end

# # Task 3
# li x10, 10
# li x22,0
# li x23,0
# li x15,0x200

# Loop1:sw x22, 0x200(x22) 
#     addi x22,x22,1
#     beq x22, x10, CASE5
#     beq x0, x0, Loop1

# CASE5:
# li x22,0
# beq x0,x0,Loop2

# Loop2:add x23, x23, x22
#     addi x22,x22,1
#     beq x22, x10, end
#     beq x0, x0, Loop2

# Task 4
    li x5, 10
    li x6, 5
    li x7,0
    li x29,0

    Loop1: li x29,0 
        blt x7,x5,Loop2
        beq x0,x0,end
    Loop2: slli x20, x29, 2
        add x25, x7, x29
        sw x25, 0x200(x20)
        addi x29,x29,1
        blt x29,x6,Loop2
        addi x7,x7,1
        beq x0,x0,Loop1


end:
    j end
