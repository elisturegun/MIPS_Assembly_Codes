##########################################################
#						           #
#		copy linked list but not x int 	   #
#							   #
#########################################################
.data
welcome: .asciiz "\n**************WELCOME**************"
enterSize1: .asciiz "\nEnter the size of first linked list: "
enterSize2: .asciiz "\nEnter the size of second linked list: "
bothEmptyList: .asciiz "\nBoth list1 and list2 is empty!"
enterFirstInt: .asciiz "\nEnter first number: "
enterInt: .asciiz "\nEnter the integer value to be deleted when copying: "
lineSep: .asciiz "\n --------------------------------------"
	


nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
.text

	#PRINT WELCOME MESSAGE
	la $a0,welcome
	li $v0, 4
	syscall
	
	#LIST 1
	la $a0, enterSize1 #"Enter the size of first linked list: "
	li $v0, 4 #displaying string
	syscall
	
	li $v0,5 # getting first size form user
	syscall
	
	move $a0, $v0 # $a0 = size

	
	add $s6, $v0, $0 # $s6 = size 
	move $a2, $v0 # $a2 = size

	jal	createLinkedList
	
	
	move	$a0, $v0 # address
	move 	$s7, $v0 # address
	jal 	printLinkedList
	
	la $a0,enterInt
	li $v0, 4
	syscall
	
	li $v0, 5 # get integer to be excluded
	syscall 
	
	move $a0, $s6 #$a0 --> size of the linked list
	move $a1, $v0 # $a1 = x integer to be excluded
	move $a3, $s7 # $a3 --> address of list
	
	jal CopyAllExcept_x  
	

	move	$a0, $v0	# Pass the linked list address in $a0
	jal 	printLinkedList
	
	
	la	$a0, lineSep
	li	$v0, 4
	syscall	
	
	
	li $v0,10 #exit the program
	syscall
	
###
CopyAllExcept_x:
	
	li $s7, 0 # counter
	
	addi $sp, $sp, -36
	sw $s0, 0($sp)  
	sw $s1, 4($sp)  
	sw $s2, 8($sp)  
	sw $s3, 12($sp) 
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s1 , $a1 # s1 = x integer
	move $s0, $a3 # a3 = address of list
	
	# make node
	li	$v0, 9
	li	$a0, 8
	syscall
	
	move	$s3, $v0 # $s3 = head 
	move	$s2, $v0 # $s2 = first node

	# get values from linked list
	lw	$s4, 4($s0) # data of current		
	lw	$t0, 0($s0)
	
	move $s0, $t0
	# if x integer is not equal to current node
	bne $s4, $s1, store
	
funcLoop:

	beq $0, $s0, doneFunc # loop control
	
	# get linked list values
	lw	$s4, 4($s0)	# data item
	lw	$s0, 0($s0)	# next
		
	# if x integer is not equal to data item
	bne $s4, $s1, make

	j	funcLoop
make:
	addi	$s7, $s7, 1 # increment counter
	
	# make node
	li	$v0, 9
	li	$a0, 8 		
	syscall
	
	# put 2 nodes in order
	sw	$v0, 0($s2)
	move	$s2, $v0 # $s2 points to new node
	sw	$s4, 4($s2)	
	j funcLoop

store:
	addi	$s7, $s7, 1
	sw	$s4, 4($s2)
	
	j funcLoop
	
doneFunc:
	move	$v0, $s3 # v0 = address of list
	move	$v1, $s7 # put counter  = new size
	
	sw	$0, 0($s2) # last node to 0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)

	addi $sp, $sp, 36 #deallacote
	jr $ra #return address
	


###########################################
printLinkedList:
	# Print linked list nodes in the following format
	# --------------------------------------
	# Node No: xxxx (dec)
	# Address of Current Node: xxxx (hex)
	# Address of Next Node: xxxx (hex)
	# Data Value of Current Node: xxx (dec)
	# --------------------------------------

	# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

	# $a0: points to the linked list.
	# $s0: Address of current
	# s1: Address of next
	# $2: Data of current
	# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
	# $s0: address of current node: print in hex.
	# $s1: address of next node: print in hex.
	# $s2: data field value of current node: print in decimal.
	la	$a0, lineSep
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

	# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
	
printedAll:
	# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	

createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	li $v0,5
	syscall
	
	move $s4,$v0
	sw $s4,4($s2)
	
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	#node counter.
	li	$a0, 8 		
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	
	li $v0,5
	syscall
	
	move $s4,$v0
	sw $s4, 4($s2)
	
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
	move $a1 , $s1 #a1 is our node count now
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra







