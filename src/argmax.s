.globl argmax
.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    # exit code 7 isf the length is less than 1
    addi t0 ,x0 ,1
    blt a1, t0, exit
loop_start:
    # t0 -> index
    add t0, x0, x0
    # load the first element in the vector for comparism
    lw t1,0(a0)
    # t4 -> current max index
    addi t4, x0, 0
loop_continue:
    bge t0, a1, loop_end # if t0 >= a1 then loop end
    lw t3,0(a0)
    blt t1, t3, set_index
    j next
set_index:
    add t4,t0,x0
    # update the current max value
    lw t1, 0(a0)
    j next
next:
    # visit next element
    addi a0, a0, 4
    addi t0, t0, 1
    j loop_continue
exit:
    li a1, 7
    jal exit2
loop_end:
    # Epilogue
    add a0, x0, t4
    ret