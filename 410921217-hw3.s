#input: 一行一個數字, input = 0, end
#selection sort
#for(i = 0; i < N; i = i+1){
#    for(j = i+1; j < N; j = j+1){
#        if(array[i] > array[j]){
#            temp = array[i];
#            array[i] = array[j];
#            array[j] = temp;
#        }
#    }
#}
 
.data
array: 	.space 1000
zero:	.word 0
space: 	.asciiz " "
sorted: .asciiz "after sort: "
 
.text
	li $s0, 0
input:
	#input
	li $v0, 5        
	syscall
 
	move $t0, $v0 #t0 = input number                   
	addi $t1, $t1, 0 #t1 = 0                
	sll $t1, $t2, 2 #t1 = t2 << 4                       
 	addi $t2, $t2, 1 #t2++ 
 	addi $s0, $s0, 1 #s0++  
	sw $t0, array($t1) #store value into array
 
	addi $t4, $t4, 0 #t4 = 0                   
	bne $t0, $t4, input #if input != 0, keep input                
 
load:
	la $a0, array #load address of array                      
	addi $a1, $s0, -1
	addi $s0, $s0, -2                    
	jal temp #jump to temp, address is stored in $ra
	                           
	li $t1, 0
	la $t0, array #load address of array                   
 	la $a0, sorted #print "after sort: "
    	li $v0, 4
   	syscall
print:
	lw $a0, 0($t0) #print value                     
	li $v0, 1
	syscall
	la $a0, space #print space
    	li $v0, 4
   	syscall

	addi $t0, $t0, 4 #t0 += 4 (address)                 
	addi $t1, $t1, 1 #t1 += 1                     
	slt $t2, $s0, $t1 #if s0 < t1, t2 = 1; else, t2 = 0   
	
	addi $t6, $t6, 0                 
	beq $t2, $t6, print #if s2 = 0 , keep printing         
	       
Exit:
	li $v0, 10                           
	syscall		                                       
 
temp:
	li $t0, 0 #t0 = temp of c++ code                           
 
sort:
	addi $t0, $t0, 1 #t0++                   
	bgt $t0, $a1 , re #if t0 > a1                 
	addi $t1, $a1, 0 #t1 = a1                  
 
loop:
	#if t0 > t1, sort, c++ code: if(arr[i] > arr[j])
	bgt $t0, $t1, sort     
	addi $t1, $t1, -1                      
	sll $t2, $t1, 2 #t2 = t1 << 4            
	addi $t3, $t2, -4                    
	add $t2, $t2, $a0                     
	add $t3, $t3, $a0 
 
	lw $t4, 0($t2) #t2[0] = t4's value
	lw $t5, 0($t3)
 
swap:
	bgt $t4, $t5, loop #if t4 > t5, jump to loop              
	#swap two value 
	sw $t4, 0($t3)                  
	sw $t5, 0($t2)
	j loop
 
re:
	jr $ra #return to caller
