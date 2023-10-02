# Machine Project 1
# Cada, Louis
# Pecson, Richard

# MACROS
.macro NEWLINE
    li a0, 10
    li a7, 11
    ecall
.end_macro

.macro GET_DEC
    li a7, 5
    ecall
.end_macro

.macro GET_FLOAT
    li a7, 6
    ecall
.end_macro

.macro PRINT_FLOAT
    li a7, 2
    ecall
.end_macro

.macro PRINT_STRING(%x)
    li a7, 4
    la a0, %x
    mv a1, a0
    ecall
.end_macro

# DATA
.data
str_row: .asciz "Rows: "
str_col: .asciz "Cols: "
str_space: .asciz " "
array: .space 100

.text

# Input counter t1
addi t1, x0, 0
PRINT_STRING str_row
# Get rows
GET_DEC
mv a3, a0

PRINT_STRING str_col
# Get cols
GET_DEC
mv a4, a0

# Number of inputs t2
mul t2, a3, a4

# Pointer to start of array
la a5, array
andi a5, a5, -4  # Make word aligned

j input_loop

input_loop:
    beq t1, t2, print_array
    GET_FLOAT
    # Store in array
    fsw fa0, 0(a5)
    # Increment pointer
    addi a5, a5, 4

    # Increment n ctr
    addi t1, t1, 1
    j input_loop

print_array:
    # Reset array pointer to the beginning
    la a5, array

    # Initialize loop counters for printing
    addi t4, x0, 0  # Row counter
    addi t5, x0, 0  # Column counter

print_loop:
    # Check if we have printed all elements
    beq t5, a4, continue_col

    # Load a floating-point value from the array
    flw fa0, 0(a5)

    # Print the floating-point value
    PRINT_FLOAT

    # Print a space to separate values within a column
    PRINT_STRING str_space

    # Increment array pointer
    addi a5, a5, 4

    # Increment row counter
    addi t4, t4, 1

    # Check if we've printed all rows in the current column
    bne t4, a3, continue_col

    # If we've printed all rows in the current column, move to the next column
    NEWLINE  # Print a newline to start a new column
    addi t5, t5, 1  # Increment column counter
    li t4, 0  # Reset row counter

continue_col:
    # Continue looping for the next element
    j print_loop

end:
    li a7, 10  # Exit program
    ecall
