	.data				# mark beginning of data segment

	user_input: .space 1001		# allocate 1001 bytes of storage for 1000 charecters in global variable user_input
	too_large:			# store charectar sequence to prompt if user_input is invalid
		.asciiz "too large"
	invalid_input:
		.asciiz "NaN"

	.text				# mark beginning of text segment
main: 
	#read input
	li $v0, 8			# call code to read string
	la $t0, user_input		# load address of user_input in register $t0
	la $a0, ($t0)			# load address of user_input in $t0 to argument register $a0
	la $a1, 1000			# gets length of space in user_input to avoid exceeding memory limit
	syscall				# syscall to read user_input and store the string in memory
	
!	lb $t1, 0($t0)			#load first byte of memory into register $t1 (inside loop_String??)
	addi $t7, $t0, 8		#add the value of the 9th byte of user_input to the register $t7 (not sure if I need it)

	
	# loop through string
  loop_string:

	# for spaces or tabs, increment offset
	beq $t1, 32, increment_offset 	
	beq $t1, 11, increment_offset
  increment_offset:
	addi $t0, $t0, 1		#increment offset of $t0 by 1
	j loop_string

	# store charecter in stack1
	bne $t1, 44, stack1		# if $t1 != ',' branch to stack1
  stack1:
	addi $sp, $sp, -8
!	sw   $t1, 0($sp)		# how to increment this pointer to store updated values in $t1 in different stack positions?
	
	addi $t0, $t0, 1		#increment offset of $t0 by 1
	j loop_string  

	# call subprogram_2 if comma
	beq $t1, 44, comma
  comma:
	jal subprogram_2
	addi $t0, $t0, 1		#increment offset of $t0 by 1
	j loop_string	
		
subprogram_1:
	#convert numbers
	beq $t1, 48, convert_num
	blt $t1, 58, convert_num 
	addi $s1, $0, 48
  convert_num:
	sub $s4, $t1, $s1
	
	#convert lowercase
	beq $t1, 97, convert_lowerCase
	blt $t1, 103, convert_lowerCase
	addi $s1, $0, 87
  convert_lowerCase:
	sub $s4, $t1, $s1

	#convert upperCase
	beq $t1, 65, convert_upperCase
	blt $t1, 71, convert_upperCase
	addi $s1, $0, 55
  convert_upperCase:
	sub $s4, $t1, $s1	
	
subprogram_2:
	#pop stack

# program flow:
main:
	# read input
	# loop through string 
	# for spaces or tabs, increment offset
	# charectar 
		# store charecter in stack1	
		# addi $s3, $s3, 4 to keep track of how much to multiply with (?)
	# comma
		# send stack1 to subprog_2 to convert to decimal
	# increment offset

subprog_1:
	# convert letter to ascii decimal	
subprog_2:
	# pop stack1 letter by letter
	# valid:
		# check_length
			# loop through stack1 and increment $s3 by 4
			# if length > 8 : output too large
			# else:
				# call subprog_1 to convert to decimal 
				# multiply by s3 and decrement s3
				# push string in stack2 and return stack2
	#invalid:
		# return to main
	# return to main
#subprog 3:
	# decimal
		# pop stack2
		# do less than 10
		# output string and comma
	# loop back to main to check for next set of strings
