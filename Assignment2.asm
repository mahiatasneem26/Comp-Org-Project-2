	.data				# mark beginning of data segment

	user_input: .space 1001		# allocate 1001 bytes of storage for 1000 charecters in global variable user_input
	too_large:			# store charectar sequence to prompt if user_input is invalid
		.asciiz "too large"
	invalid_input:
		.asciiz "NaN"

	.text				# mark beginning of text segment
main: 
	li $v0, 8			# call code to read string
	la $t0, user_input		# load address of user_input in register $t0
	la $a0, ($t0)			# load address of user_input in $t0 to argument register $a0
	la $a1, 9			# gets length of space in myWord to avoid exceeding memory limit
	syscall				# syscall to read user_input and store the string in memory
	
	addi $t2, 0($sp)	

iterate_string:				#iterate through user_input to check if all the charectars are valid
	
	lb $t1, 0($t0)			#load first byte of memory into register $t1
	beq $t1, 0, less_than_ten	#if the value at offset 0 < 8 or <10, branch to less_than 8
	beq $t1, 10, less_than_ten
	blt $t1, 48, if_invalid		#branch to if_invalid label if value in $t1 is less than 48 (ASCII dec for number 0)		
	addi $s1, $0, 48		# store the ASCII dec to be subtracted in $s1
	blt $t1, 58, convert_charecter		#branch to if_invalid label if value in $t1 is less than 58 (next ASCII dec for number 9)		
	blt $t1, 65, if_invalid		# 65 = ASCII dec for 'A'
	addi $s1, $0, 55
	blt $t1, 71, convert_charecter	# 71 = ASCII dec for 'G' , user_input is valid up to 'F'
	blt $t1, 97, if_invalid		# 97 = ASCII dec for 'a'
	addi $s1, $0, 87
	blt $t1, 103, convert_charecter	
	bgt $t1, 102, if_invalid	#branch to if_invalid if value in $t1 is greater than 102 (ASCII dec for 'f')
if_invalid:				#label to call invalid_input and exit program
	li $v0, 4			#call code to prompt invalid_input message
	la $a0, invalid_input
	syscall
	li $v0, 10			#call code to exit program
	syscall
if_valid:				#label to call valid_input and exit program
	$sp, $sp, -8
	sw $t0, 0($sp)
	addi $t0, $t0, 1		#increment offset of $t0 by 1

	bne $t0, $t7, iterate_string	#if offset of $t0 is not equal to $t7, branch to iterate_string to continue looping
sub_prog1:

if_valid:				#label to call valid_input and exit program

	sub $s4, $t1, $s1		#subtract appropriate ASCII dec value to get dec value of hex input
	sllv $s4, $s4, $s3		# multiply $s3 by 4
	addi $s3, $s3, -4
	add $s2, $s4, $s2		# add and store the value of $s4 and $s2 to $s2
	bne $t0, $t7, iterate_string	#if offset of $t0 is not equal to $t7, branch to iterate_string to continue looping

less_than_ten:				#if the value at offset 0 < 8 branch to this label
	addi $s0, $0, 10		#store 10 in $s0
	addi $t0, $t0, -1		#subtract 1 from user_input
	lb $t1, 0($t0)
	blt $t1, 58, exit_loop		#if 0($t0) < 10, branch to exit_loop
	divu $s2, $s0			# else divide by 10 and store in $s2
	mflo $a0			# move lower bits to $a0 and print
	li $v0, 1
	syscall
	mfhi $s2			#move higher bits to $s2
	
sub_prog2:
	addi $t0, $t0, 1		#increment offset of $t0 by 1
	sllv $s4, $s4, $s3		# multiply $s3 by 4
	addi $s3, $s3, -4



sub_prog3:

too_large:				#label to call invalid_input and exit program
	li $v0, 4			#call code to prompt too_large message
	la $a0, too_large
	syscall
	li $v0, 10			#call code to exit program
	syscall
exit_loop:
	li $v0, 1			#callcode to print integer
	addi $a0, $s2, 0
	syscall
	li $v0, 10			#call code to exit program
	syscall
# program flow:
# read input in main
# iterate through input until a comma is found
#save the charecters(including spaces and tabs) in an address and pass the string to subprogram #2
#subprog 2:
	#loop through string 
	# for spaces or tabs, increment offset
	# valid charecter 
		# send to subprog#1 to convert to decimal	
		# addi $s3, $s3, 4 to keep track of how much to multiply with
alternate:
	# loop through string 
	# for spaces or tabs, increment offset
	# charecter 
		# store charecter in stack1	
		# addi $s3, $s3, 4 to keep track of how much to multiply with (?)
	# comma
		# send stack to subprog#1 to convert to decimal
	# increment offset
	
subprog#1:
	# pop stack1 letter by letter
	# valid:
		# check_length
		# convert letter to ascii decimal
		# multiply by s3 and decrement s3
		# store charecter in stack2
	#invalid:
		# return to subprog2
	# return to subprog #2
#subprog 3:
	# decimal
		# do less than 10
	# else:  Nan/ too large
	# loop back to main to check for next set of strings
