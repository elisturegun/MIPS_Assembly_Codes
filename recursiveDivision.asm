
.data
	dividend: .asciiz "\nPLEASE ENTER THE DIVIDEND: "
	divisor: .asciiz "\nPLEASE ENTER THE DIVISOR: "
	result: .asciiz "\nRESULT: "
	continue: .asciiz "ENTER 1 TO CONTINUE, 0 TO EXIT: "
	errorDivisorZero: .asciiz "\nCANNOT DIVIDE WITH ZERO\n"
	errorBigger: .asciiz "\nRESULT IS 0\n"
	line: .asciiz "\n"
	remainder: .asciiz "\nREMAINDER: "

.text	

main:
	divFunction:
		
		#GET DIVIDEND FROM USER
        	la $a0,dividend 
        	li $v0,4 #display string
         	syscall
         	
         	li $v0, 5 #read integer
         	syscall
         	
         	add $s0, $v0, $0 #s0 = dividend
         	
         	#GET DIVISOR FROM USER
         	la $a0,divisor
        	li $v0,4 #display string
        	syscall
        	
        	li $v0, 5 #read integer
        	syscall
        	
        	add $s1, $v0, $0 #s1 =divisor
        	
        
        	beqz $s1, zeroDivisor #DIVISOR CANNOT BE ZERO

        	blt $s0, $s1, zeroDivisorBigger #DIVISOR CANNOT BE BIGGER THAN DIVIDEND
   
   		# $s0 = dividend & $s1 = divisor
        	add $a0,$s0,$0 ##passing dividend to argument1 $a0
        	add $a1,$s1,$0 #passing divisor to argument1 $a1
        	
        	beq $a1, $0, errorDivisorZero
        	
        	addi $s7, $0, 0 #counter
        	 addi $s6, $0, 0 #remainder
   
       		jal division # go to division operation
         
         	#print result
         	la $a0,result
         	li $v0,4
         	syscall
         	
         	la $a0, 0($s7)
         	li $v0, 1
		syscall
		
		#print remainder
        	la $a0, remainder
        	li $v0, 4
        	syscall
        
        	move $a0, $s6
        	li $v0, 1
        	syscall
		
		#print new line
		la $a0, line		
		li $v0, 4
		syscall

		j ask
		
		ask:		
		#DONE OR CONTINUE
		la $a0, continue
		li $v0, 4
		syscall
		
		addi $v0, $zero, 5
		syscall
		
		add $s4, $zero, $v0 #check if user wants to exit
		
		beqz $s4, exitProgram #user enter 0 to quit
		beq, $s4, 1, divFunction #continue
		
zeroDivisor:
	la $a0, errorDivisorZero
	li $v0,4
	syscall
	
	j ask
	#li $v0,10
	#syscall
	
        
zeroDivisorBigger:
	la $a0, errorBigger
	li $v0,4
	syscall
	
	j ask
       #li $v0,10
	#syscall

division:
	
	addi $sp, $sp, -4 #make 1 space 
	sw $ra, 0($sp) #assign return address to first space

	blt $a0, $a1, doneDiv
	
	sub $a0, $a0, $a1 # do division
	
	addi $s7, $s7, 1 #result++ QUOTIENT
	
	jal division #call itself to recursion
		
doneDiv:
	add $s6, $0, $a0
	#deallacote space
	addi $sp, $sp, 4 
	#assign return value = $sp
	lw $ra, 0($sp)
	jr $ra
	
exitProgram:
	
	li $v0,10  #exit program
	syscall
	
