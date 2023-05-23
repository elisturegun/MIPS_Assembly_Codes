#####	x = (a+b)((a/b)-c)%10 	#####
.data
enterA: .asciiz " ENTER A VALUE: "
enterB: .asciiz " ENTER B VALUE: "
enterC: .asciiz " ENTER C VALUE: "
result: .asciiz " (a+b) ((a/b)-c) %  10= " 
msg: .asciiz " CALCULATION CANNOT BE DONE DUE TO B VALUE (DIVIDER) IS 0!!"
msg2: .asciiz " RESULT IS ZERO\n (a+b) ((a/b)-c) %  10= 0"

.text

la $a0, enterA  #"ENTER A VALUE: " 
li $v0,4 #displaying string
syscall 

li $v0, 5 #getting A value
syscall 

move $s0,$v0 #$s0 = A


la $a0, enterB #"ENTER B VALUE: " 
li $v0,4 #displaying string
syscall 

li $v0, 5 #getting B value
syscall 

move $s1,$v0 #$s1 = B 


la $a0, enterC #"ENTER C VALUE: " 
li $v0,4 #displaying string
syscall 

li $v0, 5 #getting C value
syscall 

move $s7,$v0 #$s7 = C 

beq $s1, 0, exit # IF B (DIVIDER) IS ZERO, END CALCULATION
bne $s1, 0 , calc # IF B (DIVIDER) IS NOT ZERO, CONTINUE CALCULATION


calc:
#calculations
add $s2, $s0, $s1 # s2 = a + b
div $s3, $s0, $s1 # s3 = a /b

sub $s4, $s3, $s7 # s4 = (a/b) - c

mul $s5, $s2, $s4 # s5 = ( a + b) ( ( a / b ) - c)

addi $s6, $0, 10
div $s5, $s6
mfhi $t0

blt $t0, 0 , negativeRem

#print result
la $a0, result #"(a+b)((a/b)-c)%10  = " 
li $v0,4 #displaying string
syscall 

move $a0, $t0

li $v0,1 #print integer
syscall

li $v0, 10
syscall
	
negativeRem: ##IF REMAIDER IS NEGATIVE ADD 10 TO REMAINDER AND PRINT CORRECT RESULT
	addi $t0, $t0 , 10
	la $a0, result #"(a+b)((a/b)-c)%10  = " 
	li $v0,4 #displaying string
	syscall 

	move $a0, $t0

	li $v0,1 #print integer
 	syscall

	li $v0, 10
	syscall
	
exit: 
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
