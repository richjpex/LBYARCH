# Machine Project 1
# Cada, Louis
# Pecson, Richard

#MACROS
.macro NEWLINE 
	mv t0, a0
	li a0, 10
	li a7, 11
	ecall
	mv a0, t0
.end_macro

.macro GET_FLOAT
	li a7, 6
	ecall
.end_macro

.macro PRINT_FLOAT
	li a7, 2
	ecall
.end_macro

.macro PRINT_STRING (%x) 
	li a7, 4
	la a0, %x
	ecall
.end_macro

.macro PRINT_SPACE (%x)
	li a7, 4
	la a0, %x
	ecall
.end_macro

#DATA
.data
	str_row: .asciz "Rows: "
	str_col: .asciz "Cols: "
	str_space: .asciz " "

#TEXT
.text
	#initialization
	PRINT_STRING str_row #displays message for row input
	GET_FLOAT #asks for row input
	fcvt.wu.s a1, fa0 #saves integer from float for row
	PRINT_STRING str_col #displays message for column input
	GET_FLOAT #asks for column input
	fcvt.wu.s a2, fa0 #saves integer from float for column
	mul a0, a1, a2 #uses mul to determine number of inputs
	andi a0, a0, -4 #make word aligned
	li a7, 9 #allocates heap memory
	ecall
	
	mv a4, a0 #address of array
	mv a5, a0 #address of temp array
	
	#enter main loop
	j reg_loop
	
	reg_loop:
		mul a3, a1, a2 #uses mul to save the number of inputs
		j check_input_loop
	
	check_input_loop:
		beq t1, a3, matrix_start #stores a3 counter for t1
		GET_FLOAT
		fsw fa0, 0(a0) #stores in array
		addi a0, a0, 4 #increment pointer
		addi t1, t1, 1 	#increment n ctr
		j check_input_loop
		
	#get matrix 
	matrix_start: #initialize loop counter for storing matrix
		addi t1, x0, 0 #sets t1 to 0 for looping variable
		mv a0, a5 #uses the temp address to store matrix before usage
		j matrix_counter
	
	matrix_counter: #stores all the values in the row matrix
		beq t1, a1, transpose_start #if t1 = a1 go to transpose_loop, if not, proceed to next line
		addi t2, x0, 0 #sets t2 to 0 for looping variable
		j matrix_columnincrement
		
	matrix_columnincrement: #iterates thru the columns in the curr row
		beq t2, a2, matrix_rowincrement #if t2 = a2 go to matrix_rowincrement, if not, proceed to next line
		flw fa0, 0(a0)
		addi a0, a0, 4 #loads the next value by 4 bytes
		addi t2, t2, 1 #increments counter by 1 
		j matrix_columnincrement #jumps back to store next value
	
	matrix_rowincrement: #iterates thru the next row in the matrix
		add a5, a5, s0 #adds the stored a5 to the new a5
		mv a0, a5 #sets a0 to start of the next row in memory
		addi t1, t1, 1 #increments counter by 1
		j matrix_counter #jumps back to the counter to repeat iteration
		
	#get transpose matrix
	transpose_start: #initialize loop counter for transposing matrix
		addi t1, x0, 0 #sets t1 to 0 for looping variable
		mv a0, a4 #uses the orig address to transpose matrix
		j transpose_counter
	
	transpose_counter: #iterates thru rows of the transposed matrix
		beq t1, a2, end #if t1 = a2 go to end, if not, proceed to next line
		addi t2, x0, 0 #sets t2 to 0 for looping variable
		mv t0, a0 #hold a0 in t0 before transposing because a0 will be used to print the space
		j transpose_columnincrement
		
	transpose_columnincrement: #iterates thru the columns in the curr row
		beq t2, a1, transpose_rowincrement #if t2 = a1 go to transpose_rowincrement, if not, proceed to next line
		flw fa0, 0(t0) #load the value from the current memory location of t0
		PRINT_FLOAT #display the value
		slli s0, a2, 2 # multiply value of rows with 4 to get to the next element
		add t0, t0, s0 #calculates the offest to move to the next element
		PRINT_SPACE str_space
		addi t2, t2, 1 #incements counter by 1
		j transpose_columnincrement #jumps back to store next value
		
	transpose_rowincrement: #iterates thru the next row in the matrix
		addi a4, a4, 4  #loads 4 bytes
		mv a0, a4 #moves a4 back to the base address and incerments it by 4 bytes
		addi t1, t1, 1 #increments counter by 1
		NEWLINE
		j transpose_counter #jumps back to the counter to repeat iteration
		
	end:
		li a7, 10 #ends the program
		ecall
		
	
	
