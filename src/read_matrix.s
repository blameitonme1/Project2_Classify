.globl read_matrix
.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT: 
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
    
    # Prologue
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    mv s2,a2
    mv s1,a1
    mv s0,a0
    # open files
    mv a1,s0
    li a2, 0 # read only
    jal ra, fopen
    li t0, -1
    beq a0, t0, exit50
    # store file discriptor
    mv s3, a0
    # read files rows
    mv a1,s3
    mv a2,s1
    addi a3,x0,4
    jal ra, fread
    # exit if error
    li t0, 4
    bne t0, a0, exit51
    # read files cols
    mv a1,s3
    mv a2,s2
    addi a3,x0,4
    jal ra, fread
    # exit if error
    li t0, 4
    bne t0, a0, exit51
    lw s1, 0(s1) # of rows
    lw s2, 0(s2) # of columns
    # calculate total amount
    mul a0, s2, s1
    # remember 4 byte each elemenet!
    slli a0, a0, 2
    jal ra, malloc
    beq a0, x0, exit48
    # s4 is the heap memory now
    mv s4, a0
    # loop through
    addi t1, x0, 0
    mul t0, s2, s1
    # t2 store the allocated address
    add t2, s4, x0
loop:
        bge t1, t0, exit_loop
        # read bytes
        mv a1,s3
        mv a2,t2
        addi a3,x0,4
        jal ra, fread
        li t4, 4
        bne t4,a0, exit51
        addi t1, t1, 1
        addi t2, t2, 4
        j loop
exit_loop:
    # close the file
	mv a1, s3
    jal fclose
    li t0, -1
    beq t0, a0, exit52
    mv a0, s4
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
	addi sp, sp, 36
    ret
exit48:
    li a1,48
    jal exit2
exit50:
    li a1,50
    jal exit2
exit51:
    li a1,51
    jal exit2
exit52:
    li a1,52
    jal exit2

