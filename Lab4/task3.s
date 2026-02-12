.text
.globl main
main:
    li x10,0x100  # array location
    li x11, 5    # k
    li x9, 7      # random values
    sw x9, 0(x10)
    li x9, 2
    sw x9, 4(x10)
    li x9, 6
    sw x9, 8(x10)
    li x9, 9
    sw x9,12(x10)
    li x9,3
    sw x9,16(x10)

    addi x5,x0,0    # counter for i
    Loop1:
        bge x5,x11,end  # if counter == k
        add x6,x0,x5   # j = i
    
    Loop2:
        bge x6,x11,increment_i  # if j=k
        slli x4,x5,2  # offset for i
        add x4,x4,x10   # address of a[i]
        lw x20,0(x4)  # value a[i]
        slli x8,x6,2  # offset for j
        add x8,x8,x10  # address for a[j] 
        lw x21, 0(x8) # value a[j]
        bgt x20,x21,increment_j   # if a[i] > a[j] 
        
        sw x21,0(x4)   # swapping
        sw x20,0(x8)
    
    increment_j:
        addi x6,x6,1
        beq x0,x0,Loop2
    
    increment_i:
        addi x5,x5,1
        beq x0,x0,Loop1
        
end:
    j end