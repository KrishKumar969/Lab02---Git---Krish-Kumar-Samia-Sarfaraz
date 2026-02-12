.text
.globl main
main:
    addi x5,x0,8     // n (the factorial)
    addi x6,x0,1     // product
    Loop:
        mul x6,x6,x5     // calculating the factorial
        addi x5,x5,-1    // n-1
        bne x5,x0,Loop   
end:
    j end
    
