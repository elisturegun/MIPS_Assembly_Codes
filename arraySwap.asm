.data
addressOfArr: .space 80
numberDisplay: .asciiz " ENTER THE NUMBER OF ELEMENTS: "
noelements: .asciiz " NO ELEMENTS ENTERED!"
numberEnter: .asciiz " ENTER THE NUMBERS: " 
arrElementsDisplay: .asciiz " ARRAY CONTENTS: "
swappedContents: .asciiz "\nSWAPPED ARRAY CONTENTS: "
spaceCharacter:  .asciiz " "

.text
la $a0, numberDisplay #" ENTER THE NUMBER OF ELEMENTS: "
li $v0,4 #displaying string
syscall 

li $v0, 5 #getting num of elements
syscall 

move $s0,$v0 # $s0 = number of elements from user #4

beq $s0, $zero noneElement #if there is no element

la $a0, numberEnter #" ENTER THE NUMBERS:"
li $v0,4 #displaying string
syscall 

li $v0, 5 
syscall

la $s4, addressOfArr # $s4 = begin address if number array
move $s7, $s4

sw $v0, 0($s4)
addi $s4, $s4, 4

li $t1, 1 # counter is 0 t1 = 0

forLoop:
	beq $t1,$s0, exitLoop
	
	li $v0, 5 #getting integers
	syscall 
	
	sw $v0, 0($s4) #memory write
	
	addi $t1,$t1,1 #size counter
	
	addi $s4,$s4,4  #byte counter
	
	
j forLoop


noneElement:
la $a0, noelements #there is no element
li $v0, 4 #print message
syscall

exitLoop:
li $t5, 0
addi $s4, $s4, -4 

la $a0, arrElementsDisplay #array contents
li $v0,4 #displaying string
syscall 

printLoop:

beq $t5,$s0, exitPrintLoop

lw $s6,0($s7) #memory read
move $a0,$s6

li $v0, 1
syscall

la $a0, spaceCharacter #put space btw elements
li $v0,4 #displaying string
syscall 

addi $t5,$t5,1
addi $s7,$s7,4

j printLoop

exitPrintLoop:

li $t5, 0 
la $a0,swappedContents
li $v0,4 #displaying string
syscall 
swapPrint:

beq $t5,$s0, exitSwap

lw $t8,0($s4) #memory read
move $a0,$t8

li $v0, 1
syscall

la $a0, spaceCharacter #put space btw elements
li $v0,4 #displaying string
syscall 

addi $t5,$t5,1
addi $s4,$s4,-4

j swapPrint

exitSwap:












