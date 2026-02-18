.text
.globl main

main:
    li   x11, 6         # n 
    li   x18, 0         # sum
    li   x19, 0         # i

loop:
    mv   x10, x19       # x10 = i (argument for fib)
    jal  x1, fib        # Call to fib
    
    add  x18, x18, x10  # sum calculation
    
    addi x19, x19, 1    # i++
    ble  x19, x11, loop # if i <= n then jump to loop

    mv   x11, x18        # Move sum (x18) into x11 
    li   x10, 1          # ID
    ecall

    li   x10, 10         # Load Exit ID into x10
    ecall

    beq x0, x0, exit


fib:
    addi x2, x2, -16    # Allocate 16 bytes 
    sw   x1, 12(x2)     # Save return address
    sw   x8, 8(x2)      
    sw   x9, 4(x2)      

    mv   x8, x10        # x8 = n

    li   x5, 1    # if n <= 1 return n
    ble  x8, x5, base_case

    addi x10, x8, -1    # n - 1
    jal  x1, fib
    mv   x9, x10        # x9 = result of fib(n-1)

    addi x10, x8, -2    #n - 2
    jal  x1, fib
    
    
    add  x10, x9, x10   # x10 = fib(n-1) + fib(n-2)
    j    end

base_case:
    mv   x10, x8        # return n

end:
    lw   x9, 4(x2)
    lw   x8, 8(x2)
    lw   x1, 12(x2)
    addi x2, x2, 16     # Deallocate stack space
    jalr x0, 0(x1)      # Return to main

exit: 
