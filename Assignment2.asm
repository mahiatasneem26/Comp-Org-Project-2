.data				# mark beginning of data segment

	user_input: .space 1001		# allocate 1001 bytes of storage for 1000 charecters in global variable user_input
	too_large:			# store charectar sequence to prompt if user_input is invalid
		.asciiz "too large"
	Nan:
		.asciiz "NaN"

	.text				# mark beginning of text segment
main: 
	#read input
	li $v0, 8			# call code to read string
	la $a0, user_input		# load address of user_input in $t0 to argument register $a0
	la $a1, 1001			# gets length of space in user_input to avoid exceeding memory limit
	syscall				# syscall to read user_input and store the string in memory
		
	la $s0, user_input
	li $a2, 0			# stores first index 
	li $a3, 0			# stores second index 
	
	# loop through string
   loop_string:
	addi $t0, $s0, $a3
	lb $t1, 0($t0)			# load first byte(first charectar) of $t0 into $t1
	
	
	beq $t1, 44, call_subProg2
	beq $t1, 0,  call_subProg2
	beq $t1, 10, call_subProg2

    	increment_offset:
		addi $a3, $a3, 1		# increment offset of $s0 by 1
		j loop_string

  	call_subProg2:
		jal subprogram_2
		addi $a3, $a3, 1		# increment offset of $s0 by 1
		addi $a2, $a3, 0		# set $a2 = $a3
		Print_Nan:
			li $v0, 4
			la $a0, Nan
			syscall
		j loop_string

   	
		
subprogram_1:
	addi $t1, $0, 87
	bgt $a1, 'f', Print_Nan	
	bge $a1, 'a', convert_num
	addi $t1, $0, 55
	bgt $a1, 'F', Print_Nan
	bge $a1, 'A', convert_num
	addi $t1, $0, 48
	bgt $a1, '9', Print_Nan
	bge $a1, '0', convert_num

	j Print_Nan

	#convert numbers
 	convert_num:
	sub $v1, $a1, $t1

	jr $ra 
	
subprogram_2:
	sw $ra, 0($sp) 
	# coopy a2 and a3 in temp registers
	li $t2, $a2
	li $t3, $a3
	
	
	# check for $t2 in a loop
   check_t2:
	addi $t0, $s0, $t2
	lb $t1, 0($t0)			# load first byte(first charectar) of $t0 into $t1
	
	# if comma, endline or newline, jump to Print_Nan
	beq $t2, $t3, jumpTo_Nan
	jumpTo_Nan:
		j Print_Nan

	# if space or tab increment $t2
	beq $t1, 32, increment_t2
	beq $t1, 9, increment_t2
	
	addi $t3, $t3, -1		# t3 begins with comma, so decrement it at the beginning of the loop
	j check_t3

	increment_t2:
		addi $t2, $t2, 1
		j check_t2

	# check for $t3 in a loop
   check_t3:
	addi $t0, $s0, $t3
	lb $t1, 0($t0)			# load first byte(first charectar) of $t0 into $t1	

	# if space or tab decrement $t3
	beq $t1, 32, decrement_t3
	beq $t1, 9, decrement_t3

	j compute_value

	decrement_t3:
		addi $t3, $t3, -1
		j check_t3
   compute_value:
	addi $t4, $0 , 0

	addi $t0, $t2, $s0
	lb $a1, 0($t0)
	jal subprogram_1

	sll $t4, 4
	or $t4, $t4, $v1

	beq $t2, $t3, return_value
	j compute_value
   
   return_value:
	lw $ra, 0($sp)
	sw $t4, 0($sp)
	jr $ra


subrogram_3:
	addi $t2, $0, 10		# store 10 in a register
	lw $t0, 0($sp)			# get return value from subprog2
	addi $t1, $0, 0			# register to increment stackpointer offset
	
  get_digits:
	divu $t0, $t2			# divide value by 10
	mflo $t0			# move quotient to t0
	mfhi $t3			# move remainder to t3
	add $t4, $sp, $t1 		# 
	sb $t3, 0($t4)			#
	beq $t0, $0, print_digits
	addi $t1, $t1, 1

  print_digits:				# CONTINUE HERE

