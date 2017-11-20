	.data				#mark beginning of data segment

	user_input: .space 1001		#allocate 9 bytes of storage for 8 charecters in global variable user_input
	invalid_input:			#store charectar sequence to prompt if user_input is invalid
		.asciiz "Invalid hexadecimal number."

	.text				#mark beginning of text segment
main: 
