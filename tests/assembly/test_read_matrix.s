.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "tests/inputs/test_read_matrix/test_input.bin"
.text
main:
    #allocate memory
    li a0, 4
    jal malloc
    mv s0, a0 # row
    li a0, 4
    jal malloc
    mv s1, a0 # row
    # Read matrix into memory
    la a0, file_path
    mv a1, s0
    mv a2, s1
    jal read_matrix
    # Print out elements of matrix
    lw a1, 0(s0)
    lw a2, 0(s1)
    jal print_int_array
    # Terminate the program
    jal exit