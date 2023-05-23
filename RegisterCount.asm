######################################################################
#############		REGISTER COUNT 			################
#####################################################################
.data
welcome: .asciiz " *********** WELCOME TO REGISTER COUNT PROGRAM ***********\n" 
askRegNumber: .asciiz " Enter the register number  1 - 31 : "
resultCount: .asciiz " Register count found : "
errorMessage: .asciiz " Invalid entry for register number ! \n *********************************************************\n "  

.text
main:
	la $a0, welcome # *********** WELCOME TO REGISTER COUNT PROGRAM *********** 
	li $v0, 4 #print string
	syscall
	
	la $a0, askRegNumber #"Please enter register number(1-31): "
	li $v0, 4 #print string
	syscall
	
	li $v0, 5 # get register number from user
	syscall
	
	move $a2, $v0 # $a2 = register number
	
	# check for invalid input from user
	blt $v0, 1, invalidEntry
	bgt $v0, 31, invalidEntry

	la $a0, RegisterCount # $a0 = address of label registerCount
	la $a1, endCount  # $a1 = address of label endCount

	move $a2, $v0 # $a2 = register number
	
	jal RegisterCount # call function
	
	move $s0, $v0 #$s0 = register count
	
	# print result
	la $a0, resultCount #  Register count found : 
	li $v0, 4 #print string
	syscall
	
	
	move $a0, $s0 # $a0 = register count
	li $v0, 1 #read integer
	syscall
		
	
	j quitProgram

RegisterCount:
	# make space on stack
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp) 
	sw $s2, 12($sp) 
	sw $s3, 16($sp) 
	sw $s4, 20($sp)  
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)

	move $a2, $v0
	move $s0, $a0 #$s0 = adress of countRegister
	move $s1, $a1 #$s1 = adress of endCount


	loop: 
		bgt $s0, $s1, endLoop # loop control
		# load word instructions
		lw $s4, 0($s0) 
		lw $s5, 0($s0) 
		# get most significant 6 bits of instruction 
		srl $s4, $s4, 26  
		# masking bits 127
		andi $s4, $s4, 63 
	
		# if most significant 6 bits are 000000 --> R TYPE INSTRUCTION
		beq $s4, $0, register_type_ins 
		# if most significant 6 bits are 000010 --> J TYPE --> J INSTRUCTION
		beq $s4, 32, jump_type_ins # 32 = 000010 in hex
		# if most significant 6 bits are 000011 --> J TYPE --> JAL INSTRUCTION
		beq $s4, 48, jump_type_ins # 48 = 000011 in hex

	
		###########################################
		#####					#####
		#####		I - TYPE 		#####
		#####     				#####
		###########################################
		
		
		# IF NOT R TYPE OR J TYPE
		# IT IS I TYPE INSTRUCTION 
		# I - TYPE --> 2 REGISTERS --> RS AND RT
		
		# imm field is gone it was 16 bits
		srl $s5, $s5, 16 
		# opcode is gone it was 6 bits
		sll $s5, $s5, 6 
	
		# $s5 = rs rt 11110 10000 
		
		# $s6 =  rs --> 11110
		srl $s6, $s5, 5
		# mask $s6 --> 11111
		andi $s6, $s6, 0x7C 
	
		beq $s6, $a2, rs_count # if $s6 == register number
		
		j imm_continue
		
		rs_count:
		addi $s2, $s2, 1 #increment register count
		
	imm_continue:
		# $s5 = rt 10000
		sll $s5, $s5, 5 
		# mask $s5 --> 11111
		andi $s5, $s5, 0x7C 
	
		beq $s5, $a2, rt_count # if $s5 == register number
		j imm_continue2
		
		rt_count:
		addi $s2, $s2, 1 # update register count++
	
	imm_continue2:
		addi $s0, $s0, 4 # byte counter --> $s0 address is now $s0 + 4 --> next instruction
		
		j loop
	
		###########################################
		#####					#####
		#####		R - TYPE 		#####
		#####     				#####
		###########################################
		
	register_type_ins: 
	#	$s5 = 0  11110 10000 00010 00000 000000
		
		# $s5 opcode is gone it was 000000
		sll $s5, $s5, 6 
		# $s5 shamt & funct it was 0
		srl $s5, $s5, 11 
	
		# 3 registers --> rs rt rd 
	
		# $s6 ==> rs 11110
		srl $s6, $s5, 10  
		# mask $s6 --> 11111 
		andi $s6, $s6, 0x7C 
	
		beq $s6, $a2, incr_rs
		
		j continue_r_type
		incr_rs:
			addi $s2, $s2, 1 # update register count++
	
	continue_r_type:
		# $s7 ==> rd 00010
		sll $s7, $s5, 10 
		# mask $s7 --> 11111
		andi $s7, $s7, 0x7C 
	
		beq $s7, $a2, incr_rd
		j continue_r2
		incr_rd:
			addi $s2, $s2, 1 #increment register count
	
	continue_r2:
		# $s5 --> rt --> 10000
		sll $s5, $s5, 5 
		srl $s5, $s5, 5
		# mask $s5 --> 11111
		andi $s5, $s5, 0x7C 
	
		beq $s5, $a2, incr_rt 
		j continue_c
		incr_rt:
			addi $s2, $s2, 1 # update register count++
	
	continue_c:	
		addi $s0, $s0, 4 # byte counter --> $s0 address is now $s0 + 4 --> next instruction
		j loop
	
		###########################################
		#####					#####
		#####		J - TYPE 		#####
		#####     				#####
		###########################################
	jump_type_ins: 
		addi $s0, $s0, 4  # byte counter --> $s0 address is now $s0 + 4 --> next instruction
		j loop

	endLoop:
		move $v0, $s2 # put register count into $v0
	
	# deallocate space from stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp) 
	lw $s2, 12($sp) 
	lw $s3, 16($sp) 
	lw $s4, 20($sp)  
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36

jr $ra
invalidEntry:
		la $a0, errorMessage #  Invalid entry for register number ! 
		li $v0, 4 #prints string
		syscall	
quitProgram:
	li $v0, 10 # exit call
	
endCount: 	syscall

