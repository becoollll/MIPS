.data

text:  .asciiz "n: "
space:  .asciiz " "

.text

 main:
# Print n:
li $v0, 4
la $a0, text
syscall

# Get input
li $v0, 5
syscall

# Moving the integer input to another register
move $t0, $v0

addi $t1, $t1, 0
addi $t2, $t2, 1

# if input n = 0
addi $s1, $s1, 0
beq $t0, $s1, Exit

# if input n = 1
addi $s1, $s1, 1
beq $t0, $s1, printZero

# Print 0
li $v0, 1
move $a0, $t1
syscall
li $v0, 4
la $a0, space
syscall

# Print 0
li $v0, 1
move $a0, $t2
syscall
li $v0, 4
la $a0, space
li $t3, 2 # counter
syscall

loop: 
	bge $t3, $t0, Exit # if counter = input number then endloop
	addi $t3, $t3, 1 # counter++
	
	add $t4, $t1, $t2 # add the sum of t1, t2 in to t4 (t4 = t1+t2)
	
	# print sum
	li $v0, 1
	move $a0, $t4 
	syscall 
	li $v0, 4
	la $a0, space 
	syscall
	
	move $t1, $t2
	move $t2,$t4
	j loop
	
printZero:
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, space
	syscall
	j Exit
	
Exit:
	li $v0,10
	syscall
