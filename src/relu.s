.globl relu
.data
exit_code: .word 8
.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
loop_start:
    # exit is a1 (length) less than 1
    addi t0, x0, 1
    blt a1, t0, exit
    add t0 , x0 ,x0
loop_continue:
    # end loop if no element left
    bge t0, a1, loop_end
    lw t1, 0(a0)
    bge t1, x0, next
    sw x0, 0(a0)
    next:
    # visit next item
    addi a0, a0, 4
    addi t0, t0, 1
    j loop_continue
exit:
    lw a0, exit_code 
    li a7, 93 
    ecall
    ret
loop_end:
    # Epilogue
	ret