# Crazy MIPS-Notes
This tiny doc is going to help me write some MIPS code for school work

## Data Type
```
.data
	myMessage: .asciiz "Hello World \n"
	myCharacter: .byte 'm'
	myAge: .word 23
  myPie: .float 3.14
  myDouble: .double 7.202
	zeroDouble: .double 0.0
	myArray: .space 12
```

## li types
```
li $v0, 1     # code 1 == print word
li $v0, 2     # code 2 == print float
li $v0, 3     # code 3 == print double
li $v0, 4     # code 4 == print string
li $v0, 10    # code 10 == program termination
```



## Print String
```
li      $v0,4       # code 4 == print string
la      $a0,string  # $a0 == address of the string
syscall             # Ask the operating system to 
                    # perform the service.
```


##  Print Integer/Word
```
li $v0, 1     # code 1 == print word
lw $a0, myAge # $a0 == address of the string
syscall 
```


## Print Float
```
li $v0, 2        # code 2 == print float
lwc1 $f12, myPie # $f12 == address of the float
syscall 
```

## Print Double
```
ldc1 $f2, myDouble
ldc1 $f0, zeroDouble
	
li $v0, 3
add.d $f12, $f2, $f0 # For double, it always take a pair
syscall 
```

## Add & Print Integer
```
lw $t0, number1($zero)
lw $t1, number2($zero)
	
add $t2, $t0, $t1

# Print Integer
li $v0, 1
add $a0, $zero, $t2
syscall 

```

## Subtract
```
	lw $s0, number1
	lw $s1, number2
	
	sub $t0, $s0, $s1
	
	li $v0, 1
	move $a0, $t0
	syscall 
```

## Multiplication 1 (Max 16 bit)
```
	addi $s0, $zero, 10
	addi $s1, $zero, 4
	
	mul $t0, $s0, $s1   # Max 16 bits number can be used 
	
	li $v0, 1
	add $a0, $zero, $t0
	syscall 
```

## Multiplication 2
```
	addi $t0, $zero, 2000
	addi $t1, $zero, 10
	
	mult  $t0, $t1
	
	mflo $s0
	
	li $v0, 1
	add $a0, $zero, $s0
	syscall 
```


## Division 1
```

	addi $t0, $zero, 30
	addi $t1, $zero, 5
	
	div $s0, $t0, $t1
		
	li $v0, 1
	add $a0, $zero, $s0
	syscall 

```

##  Division 2
```
	addi $t0, $zero, 30
	addi $t1, $zero, 8
	
	div $t0, $t1
	
	mflo $s0  # Quotient
	mfhi $s1  # Quotient
		
	li $v0, 1
	add $a0, $zero, $s1
	syscall 
```

# Functions
Always use `$a0, $a1, $a2, $a3` to pass params. 
Always use `$v1` to return value from a function

### Function without param or return
```
main:
	jal displayMessage
	
	
	# Tell the system that the program is done
	li $v0, 10
	syscall 
	
	displayMessage:
		li $v0, 4
		la $a0, message
		syscall 

		# This is bascailly a return statement
		# Jump back
		jr $ra 
```

### Function with params and return
```
	main:
		addi $a1, $zero, 50
		addi $a2, $zero, 100
	
		jal addNumbers
		
		li $v0, 1
		addi $a0, $v1, 0
		syscall 
	
	
	# Tell the system that the program is done
		li $v0, 10
		syscall 
	
	addNumbers:
		# store value in $v1 for function return
		add $v1 $a1, $a2
		jr $ra
```

## Conditional Statement
### Simple Compare

```
bqe  $t0, $t1, numbersEqual # branch if equal
bne  $t0, $t1, numbersEqual # branch if not equal
b  $t0, $t1, numbersEqual   # branch 
```
### Less than
```
slt  $s0, $t0, $t1 # If true then $s0 = 1 otherwise $s0 = 0

# after getting the result, do a branch
bne $s0, $zero, printMessage
```

### Some pseudo Instruction
This will save few line of code and 10 seconds of my life.
```
addi $s0, $zero, 14
addi $s1, $zero, 10

# blt for "branch less than"
# bgtz & bltz for compare to 0		
bgt $s0, $s1, printMessage 
```


### While Loop
For while loop, we need 2 labels (something like `while`, `exit` but it doesn’t have to be the exact  same words)    
```
	main:
		# i = 0
		addi $t0, $zero, 0
		
		while:
			bgt $t0, 10, exit
			jal printMessage
			
			addi $t0, $t0, 1 
			
			j while
		
		exit:
			li $v0, 4
			la $a0, message
			syscall
		
	# End of program
	li $v0, 10
	syscall 
		
	printMessage:
		li $v0, 1
		add $a0, $t0, $zero
		syscall 
	
		li $v0, 4
		la $a0, space
		syscall 
		
		jr $ra
```

## Array
Use a while loop to print array items
```
	main:
		addi $s0, $zero, 4
		addi $s1, $zero, 10
		addi $s2, $zero, 12
		
		
		#index = $t0
		addi $t0, $zero, 0
		
		# Assing numbers one by one
		sw $s0, myArray($t0)
			addi $t0, $t0, 4
		sw $s1, myArray($t0)
			addi $t0, $t0, 4
		sw $s2, myArray($t0)
			addi $t0, $t0, 4		
			
		# Clear $t0 to 0
		addi $t0, $zero, 0
		
		while:
			# while loop condition check
			beq $t0, 12, exit
			
			lw $t6, myArray($t0)
			
			addi $t0, $t0, 4
			
			li $v0, 1
			move $a0, $t6
			syscall 
			
			j while
		exit:	
			# End of program
			li $v0, 10
			syscall 
```

I can also use array initializer

```
.data
	myArray: .word 10 15 30 50
```
