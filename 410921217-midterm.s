#example input:
#num: 5
#op: *
#num: 2
#op: +
#num: 1
#op: =
#example output:
#answer: 11
#########################################
#Rules:
#1) for the operator part, please input *, / and ^ first, than input + and -.
#2) Remember that you can't divide zero, or this mips program will crush.
#3) You can enter positive integers and negative integers in input number!
#4) The answer will show remainder only when the last operator is divide.
#5) You need to input \n after you input numbers, 
#   but you don't need to do that when you input operaters because it will switch line automatically. 

.data 
	welcome:.asciiz "Welcome to this little calculator~\nplease input the numbers and operators separately~"
	rule1:	.asciiz "\nRules:\n1) for the operator part, please input *, / and ^ first, than input + and -."
	rule2:	.asciiz "\n2) Remember that you can't divide zero, or this mips program will crush."	
	rule3:	.asciiz "\n3) You can enter positive integers and negative integers in input number!"
	rule4:	.asciiz "\n4) The answer will show remainder only when the last operator is divide."
	rule5:	.asciiz "\n5) You need to switch line by yourself after you input numbers, but you don't need to do that when you input operaters because it will switch line automatically." 
	hr:	.asciiz "\n============================================================"
	num: 	.asciiz "\nnum: "
	op:  	.asciiz "op(+,-,*,/,^): "
	answer:	.asciiz "\nthe answer is: "
		
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
	
first:
	li $v0, 4
	la $a0, hr
	syscall
	jal input_num
	move $s1, $v0	#s1 store every input number and store numbers after caculate
	
not_first:
	jal input_op
	move $s0, $v0		#s0 store operator
	beq $s0, '=', print
	add $t2, $t2, 1 	#temp for remainder
	jal input_num
	move $s2, $v0
	
	beq $s0, '+', add	
	beq $s0, '-', subtract
	beq $s0, '*', multiply
	beq $s0, '/', divide
	beq $s0, '^', power
	j end			#if input operator is illegal
	
add:
	add $t2, $zero, $zero	#temp for remainder
	add $s1, $s1, $s2
	j not_first
	
subtract:
	add $t2, $zero, $zero	#temp for remainder
	sub $s1, $s1, $s2
	j not_first

multiply:
	add $t2, $zero, $zero	#temp for remainder
	mult $s1, $s2
	mflo $s1
	j not_first

divide:	
	add $t2, $zero, 1	#temp for remainder
	rem $t0, $s1, $s2	#remainder value = $t0
	div $s1, $s2
	mflo $s1
	j not_first
	
power:	# $s1 ^ $s2
	add $t2, $zero, $zero	#temp for remainder
	add $t1, $t1, $s1	#input $s1 store into $t1
	sub $s2, $s2, 1		#counter--
pp:
	mult $s1, $t1
	mflo $s1
	sub $s2, $s2, 1
	bne $s2, $zero, pp	#when counter = 0, end power
	j not_first

print:
	li $v0, 4
	la $a0, answer
	syscall	
	li $v0, 1
	la $a0, ($s1)			#value
	syscall
	add $t1, $zero, $zero		#reset $t1 (for power)
	bne $t2, $zero, printrem	#for print remainder
	j first

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
	j first 
	
input_num:
	li $v0, 4
	la $a0, num
	syscall			
	li $v0, 5
	syscall
	jr $ra
	
input_op:	
	li $v0, 4
	la $a0, op
	syscall
	li $v0, 12	#input character
	syscall
	jr $ra
	
end:	
	li $v0, 10
	syscall
