# Machine Project 1
# Cada, Louis
# Pecson, Richard

#MACROS
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
	li a7, 	6
	ecall
.end_macro

.macro PRINT_FLOAT
	li a7, 2
	ecall
.end_macro

.macro PRINT_STRING (%x) #7
	li a7, 4
	la a0, %x
	mv a1, a0
	ecall
.end_macro


#DATA
.data
	str_row: .asciz "Rows: "
	str_col: .asciz "Cols: "
	str_space: .asciz " "
	array: .space 100
	
.text
 
	#input counter t1
	addi t1, x0, 0
	PRINT_STRING str_row
	#get rows
	GET_DEC
	mv a3, a0
	
	PRINT_STRING str_col
	# get cols
	GET_DEC
	mv a4, a0
	mv t6, a0
	
	# Number of inputs t2
	mul t2, a3, a4
	
	#pointer to start of array
	la a5, array
	andi a5, a5, -4 #make word aligned
	
	j input_loop
	
	input_loop:
		beq t1, t2, print_array
		GET_FLOAT
		#store in array
		fsw fa0, 0(a5)
		#increment pointer
		addi a5, a5, 4
		
		#increment n ctr
		addi t1, t1, 1
		j input_loop
	
	print_array:
	    # reset array pointer to the beginning
	    la a5, array
	    
	    # initialize loop counter for printing
	    addi t3, x0, 0
	    
	print_loop:
	    # Check if we have printed all elements
	    beq t4, a3, end  # If rows are printed, exit
	    
	    # Load a floating-point value from the array
	    flw fa0, 0(a5)
	    
	    # Print the floating-point value
	    PRINT_FLOAT
	    
	    # Print a space to separate values within a row
	    PRINT_STRING str_space
	    
	    # Increment array pointer
	    addi a5, a5, 4
	    
	    # Increment column counter
	    addi t5, t5, 1
	    
	    # Check if we've printed all columns in the current row
	    bne t5, a4, continue_row
	    
	    # If we've printed all columns in the current row, move to the next row
	    NEWLINE  # Print a newline to start a new row
	    addi t4, t4, 1  # Increment row counter
	    li t5, 0  # Reset column counter
	    
	continue_row:
	    # Continue looping for the next element
	    j print_loop
	    
	end:
	    li a7, 10  # Exit program
	    ecall

		







