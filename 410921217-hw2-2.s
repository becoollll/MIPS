.data
	text:  .asciiz "n: "
	space:  .asciiz " "
	n:  .word 0
	zero:  .word 0
	one:  .word 1

.text
main:
	# print n:
	li $v0, 4
	la $a0, text
	syscall

	# get input
	li $v0, 5
	syscall

	move $t0, $v0 # input number in t0 now

	sw $v0, n
	lw $t0, n
	la $t1, zero # load address of 0
	la $t2, one # load address of 1
	lw $t3, 0($t1) # t1(0) value into t3 
	lw $t4, 0($t2) # t2(1) value into t4 
	
	beq $t0, $t3, Exit
	beq $t0, $t4, printZero
	
	move $a0, $t3 # print 0  
	li $v0, 1
	syscall 
	li $v0, 4
	la $a0, space
	syscall
	
	move $a0,$t4 # print 1 
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, space
	syscall
	li $t5, 2 # counter
	
loop:
	beq $t5, $t0, Exit # end
	addi $t5, $t5, 1 # counter++
	addi $t2, $t2, 4 # next address(+4)
	add $t6, $t3, $t4
	sw $t6, 0($t2) # now sum
	
	move $a0, $t6 # print sum
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, space
	syscall
	
	move $t3, $t4
	move $t4, $t6
	
	j loop
	
printZero:
	move $a0, $t3   
	li $v0, 1
	syscall #show 0 
	li $v0, 4
	la $a0, space
	syscall
	j Exit
	
Exit:
	li $v0,10
	syscall
