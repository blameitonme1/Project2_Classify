.globl dot
.data 
.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    # Prologue
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
    # check length
    addi t0, x0, 1
    blt a2, t0, exitLength
    # check both stride
    addi t0, x0, 1
    blt a3, t0, exitStride
    addi t0, x0, 1
    blt a4, t0, exitStride
    # t0 -> index , t1 -> v0's item , t2 -> v1'item, 
    # t3 -> mul, t4 -> sum
    addi t0, x0, 0
    add t4, x0, x0
loop_start:
    # if end, end the loop
    bge t0, a2,loop_end
    lw t1, 0(a0)
    lw t2, 0(a1)
    mul t3, t1, t2
    # update the dot product
    add t4, t4,t3
    # update address,consider stride!
    addi t6,x0, 4
    mul t5, t6, a3
    add a0, a0, t5
    addi t6,x0, 4
    mul t5, t6, a4
    add a1, a1, t5
    addi t0, t0, 1
    j loop_start
exitLength:
    li a1, 5
    jal exit2
exitStride:
    li a1, 6
    jal exit2
loop_end:
    # Epilogue
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
    add a0, x0, t4
    ret