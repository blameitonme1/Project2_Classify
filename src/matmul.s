.globl matmul
.data 
exit_code1: .word 2
exit_code2: .word 3
exit_code3: .word 4
.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    # check dimensions
    lw t1, exit_code1
    addi t0, x0, 1
    blt a1, t0, exit
    blt a2, t0, exit
    lw t1, exit_code2
    addi t0, x0, 1
    blt a4, t0, exit
    blt a5, t0, exit
    lw t1, exit_code3
    bne a2, a4, exit
    # Prologue
    # d[i,j], t0 -> i, t1 -> j, save a0 when call dot
    # i <= a1, j <= a5
    addi t0, x0, 0
    addi t1, x0, 0
    mv s5, ra
outer_loop_start:
    bge t0, a1, outer_loop_end
    j inner_loop_start
inner_loop_start:
    bge t1, a5, inner_loop_end
    # save
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    # start of vector1, remember add on origin pointer!
    mul t2, a2, t0
    li t3, 4
    mul t2, t2, t3
    add a0, a0 , t2
    # start of vector2
    li t3,4
    mul t2, t1,t3
    add a1, a3, t2
    # length
    add a2, x0, a2
    # stride 1
    addi a3, x0, 1
    # stride 2
    add a4, x0, a5
    # store t0 and t1
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    # call dot
    jal ra, dot
    sw a0, 0(a6)
    # restore
    lw t0, 0(sp)
    lw t1, 4(sp)
	addi sp, sp, 8
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    # add a6
    addi a6, a6, 4
    addi t1, t1, 1
    j inner_loop_start
inner_loop_end:
    # add row
    addi t0, t0, 1
    # t1 back to 0
    add t1, x0, x0
    j outer_loop_start
outer_loop_end:
    # Epilogue
    mv ra,s5
    ret
exit: 
    add a0, t1, x0
    li a7, 93 
    ecall
    ret