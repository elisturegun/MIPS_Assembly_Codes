.data
begAddress: .space 8
start: .asciiz "HEX TO DECIMAL CONVERTER\n"
newLine: .asciiz "\n"
inputHex: .asciiz "ENTER HEX ( 0 TO EXIT): "
printResult: .asciiz "\nDECIMAL FORM: "


.text
program:
la $a0, start
li $v0, 4
syscall

userLoop:

	la $a0, inputHex #ASKING USER TO ENTER HEX
	li $v0, 4
	syscall

	la $a0, begAddress #load the char array's address
	
	li $a1, 10
	li $v0, 8
	syscall
	
	la $a0, begAddress #load start address of array
	
	
	lbu $t0, 0($a0) #EXIT OPTION
	subi $t0, $t0, 48
	beq $t0, 0, exitProgram
	
	
	jal convertOperation

convertOperation:

move $s0, $a0	#load s0 = begAdress
	
	moveInString:
	
		lbu $s1, 0($s0)	 #get next single byte 
		
		blt $s1, 10, normalCalculation	#value will not be calculating as A , B, C , D, E, F 
		
		addi $s0, $s0, 1 #move to the next character in string
		
	j moveInString
		

	normalCalculation:
	
		subi $s0, $s0, 2 #address s0 to the rigth -> least significant bit
		
		li $s7, 0
		
		li $s2, 1 #calculte decimal value of digit
		
		li $s6, 16 #opeartion for multiplying with hexadecimal 16
		li $s4, 0

		
	decimalCalc:
		
		blt $s0, $a0, endCalculating #ending of calculatýng numbers
		
		lbu $s1, 0($s0) #get next character
		
		#converting A,B,C,D,E,F TO DECIMAL
	
		blt $s1, 58, ABCDEF	
		blt $s1, 71, ABCDEF
		blt $s1, 103, ABCDEF
		
		
	
	ABCDEF:
	
			bgt $s1, 70, opr2abcdef	
			j inner1
			
			opr2abcdef:
			
				subi $s1, $s1, 32
	
			inner1:
		
			bgt $s1, 57, oprABCDEF	
			j inner2
			
			oprABCDEF:
			
				subi $s1, $s1, 55		
				j summation
		
			inner2:
		
			subi $s1, $s1, 48
		
		summation:
	
			mul $s1, $s2, $s1
			add $s7, $s7, $s1
			
			subi $s0, $s0, 1 #next character
			
			mul $s2, $s2, $s3
		j decimalCalc
			
	endCalculating:
	 	
	 	la $a0, printResult
	 	li $v0, 4
	 	syscall
	 	
	 	move $a0, $s4
	 	li $v0, 1
	 	syscall
	 	
	 j userLoop
	 	

exitProgram:
	
	li $v0, 10 #exit instruction
	syscall


