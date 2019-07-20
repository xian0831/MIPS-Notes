# This is a exercise for my school work. It has not yet been optimized in any way.
# WARNING: DO NOT COPY the work. If your professor or I found out about it, you may get F.
# I would also like to share the link to a very helpful tutorial by Amell Peralta. 
# https://youtu.be/u5Foo6mmW0I

.data
	minMessage: .asciiz "The smallest numebr in the array is "
	maxMessage: .asciiz "The largest numebr in the array is "
	newLine: .asciiz "\n"
	myArray: .word 50 40 90 30 10
	
.text
	main:
		
			
		# Clear $t0 to 0
		addi $t0, $zero, 0
		
		# $t1 = first elment as min
		lw $t1, myArray($t0)
		# $t2 = first elment as min
		lw $t2, myArray($t0)
		
		while:
			beq $t0, 20, exit
			
			lw $t6, myArray($t0)
			
			addi $t0, $t0, 4
			
			#li $v0, 1
			#move $a0, $t6
			#syscall 
			
			blt $t6, $t1, setMin
			bgt $t6, $t2, setMax
			
			j while
		exit:
		
			li      $v0, 4       		# code 4 == print string
			la      $a0, minMessage  	# $a0 == address of the string
			syscall             		# Ask the operating system to 
			
			# Print Min
			li $v0, 1
			move $a0, $t1
			syscall
			
			# Print new line
			li      $v0, 4       		# code 4 == print string
			la      $a0, newLine  	# $a0 == address of the string
			syscall 
			
			li      $v0, 4       		# code 4 == print string
			la      $a0, maxMessage  	# $a0 == address of the string
			syscall   
			
			# Print Max
			li $v0, 1
			move $a0, $t2
			syscall
			
			# t End of program
			li $v0, 10
			syscall 
			
		setMin: 
			move $t1, $t6	 	
			j while
			
		setMax: 
			move $t2, $t6
			j while			
			
		
	
		
			
