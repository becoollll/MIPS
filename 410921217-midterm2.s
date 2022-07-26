#example input:
#input: 9^2*2/3+8=
#example output:
#the answer is: 62
#########################################
#Rules:
#1) for the operator part, please input *, / and ^ first, than input + and -.
#2) Remember that you can't divide zero, or this mips program will crush.
#3) You can only enter positive integers from 0 to 99!
#4) The answer will show remainder only when the last operator is divide.
#5) Remember to input '=' after you input the arithmetic expression.

.data 
	welcome:.asciiz "Welcome to this little calculator~\nplease input the numbers and operators in the same line~\nthese operation is accepted: +,-,*,/,^"
	rule1:	.asciiz "\nRules:\n1) for the operator part, please input *, / and ^ first, than input + and -."
	rule2:	.asciiz "\n2) Remember that you can't divide zero, or this mips program will crush."	
	rule3:	.asciiz "\n3) You can only enter positive integers from 0 to 99!"
	rule4:	.asciiz "\n4) The answer will show remainder only when the last operator is divide."
	rule5:	.asciiz "\n5) Remember to input '=' after you input the arithmetic expression." 
	hr:	.asciiz "\n============================================================"
	input:	.asciiz "\ninput: "
	answer:	.asciiz "\nthe answer is: "
	str:	.space 256
	
.text
	add $t2, $zero, $zero	#temp for remainder
	li $v0, 4
	la $a0, welcome
	syscall
	la $a0, rule1
	syscall
	la $a0, rule2
	syscall
	la $a0, rule3
	syscall
	la $a0, rule4
	syscall
	la $a0, rule5
	syscall
	
inputstring:
	li $v0, 4
	la $a0, hr
	syscall
	la $a0, input
	la $a1 str
	syscall
	li $v0, 8
	la $a0, str
	syscall
	la $t3, str
	move $t6, $t3	#counter for look over next character is number or operator
	lb $t4, ($t3)
	
first_str: 
	jal to_first_num
	
scan:	
	addi $t3, $t3, 1
	addi $t6, $t6, 1
	lb $t4, ($t3)
	jal to_op
	addi $t3, $t3, 1
	addi $t6, $t6, 1
	lb $t4, ($t3)
	jal to_not_first_num
	j cal

to_first_num:
	sub $t4, $t4, 48
	add $t6, $t6, 1
	lb $t5, ($t6)
	beq $t5,'0',store2
	beq $t5,'1',store2
	beq $t5,'2',store2
	beq $t5,'3',store2
	beq $t5,'4',store2
	beq $t5,'5',store2
	beq $t5,'6',store2
	beq $t5,'7',store2
	beq $t5,'8',store2
	beq $t5,'9',store2
	move $s1, $t4
	jr $ra
	
store2:	
	mul $t4, $t4, 10
	addi $t3, $t3, 1
	lb $t7, ($t3)
	sub $t7, $t7, 48
	add $s1, $t4, $t7
	jr $ra
	
to_op:
	move $s0, $t4		#s0 store operator
	beq $s0, '=', print
	jr $ra
	
to_not_first_num:
	sub $t4, $t4, 48
	add $t6, $t6, 1
	lb $t5, ($t6)
	beq $t5,'0',store2_2
	beq $t5,'1',store2_2
	beq $t5,'2',store2_2
	beq $t5,'3',store2_2
	beq $t5,'4',store2_2
	beq $t5,'5',store2_2
	beq $t5,'6',store2_2
	beq $t5,'7',store2_2
	beq $t5,'8',store2_2
	beq $t5,'9',store2_2
	move $s2, $t4
	jr $ra

store2_2:	
	mul $t4, $t4, 10
	addi $t3, $t3, 1
	lb $t8, ($t3)
	sub $t8, $t8, 48
	add $s2, $t4, $t8
	jr $ra
	
cal:
	beq $s0, '+', add	
	beq $s0, '-', subtract
	beq $s0, '*', multiply
	beq $s0, '/', divide
	beq $s0, '^', power
	j end			#if input operator is illegal
	
add:
	add $t2, $zero, $zero	#temp for remainder
	add $s1, $s1, $s2
	j scan
	
subtract:
	add $t2, $zero, $zero	#temp for remainder
	sub $s1, $s1, $s2
	j scan

multiply:
	add $t2, $zero, $zero	#temp for remainder
	mult $s1, $s2
	mflo $s1
	j scan

divide:	
	add $t2, $zero, 1	#temp for remainder
	rem $t0, $s1, $s2	#remainder value = $t0
	div $s1, $s2
	mflo $s1
	j scan
	
power:	# $s1 ^ $s2
	add $t2, $zero, $zero	#temp for remainder
	add $t1, $t1, $s1	#input $s1 store into $t1
	sub $s2, $s2, 1		#counter--
	
pp:
	mult $s1, $t1
	mflo $s1
	sub $s2, $s2, 1
	bne $s2, $zero, pp	#when counter = 0, end power
	j scan

print:
	li $v0, 4
	la $a0, answer
	syscall	
	li $v0, 1
	la $a0, ($s1)			#value
	syscall
	add $t1, $zero, $zero		#reset $t1 (for power)
	bne $t2, $zero, printrem	#for print remainder
	j inputstring

printrem:		#print...remainder
	li $v0, 11
	li $a0, '.'
	syscall
	li $a0, '.'
	syscall
	li $a0, '.'
	syscall
	li $v0, 1
	la $a0, ($t0)	#value of remainder
	syscall
	j inputstring

end:	
	li $v0, 10
	syscall