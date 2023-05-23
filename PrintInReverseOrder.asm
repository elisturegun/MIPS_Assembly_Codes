##################################################
#		PRINT IN REVERSE ORDER	  	   #
##################################################
#	CS224
#	Recitation 03
#	Section 02
#	Öykü Elis Türegün
#	21902976
#	29.03.2023
# PRINT IN REVERSE ORDER 
.data
line:	
	.asciiz "\n --------------------------------------"
nodeNumberLabel:
	.asciiz	"\n Node No.: "
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
space: 
	.asciiz " "
 enterSize: .asciiz "Enter the size of linked list: "
enterFirstInt: .asciiz "Enter the first integer: "
.text

	la $a0, enterSize#"Enter the size of linked list: "
	li $v0, 4 #displaying string
	syscall
	
	li $v0,5 # getting first size form user
	syscall
	
	#PASS THE ADDRESS OF LIST TO $V0
	move $a0, $v0 

	jal	createLinkedList
	
	li $a1, 1
	
	move $a0, $v0
	jal printInReverseOrder
	
	
	#EXIT PROGRAM
	li $v0, 10
	syscall

printInReverseOrder:

	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	lw $a0, 0($a0) # go to next node
	addi $a1, $a1, 1
	
	# base case
	beq $a0, $0, endF
	
	# recursive call
	jal printInReverseOrder
	
	endF:
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		addi $sp, $sp, 12
	
	######		$S0 = ADDRESS OF CURRENT	######
	######		$S1 = ADDRESS OF  NEXT		######
	######		$S2 = DATA OF CURRENT		######
	
	move $s0, $a0 # GOT CUR ADDRESS
	lw $s1, 0($a0) # GOT NEXT NODE ADDRESS
	lw $s2, 4($a0) # GOT DATA OF CUR
	move $s3, $a1 # number of node
	
	la	$a0, line
	li	$v0, 4
	syscall		
	
	#################################################
	#	GOT IT FROM PRINT LINKED LIST FUNCTION  #
	#################################################
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	# $s3 = no of current node
	move	$a0, $s3	
	li	$v0, 1 # print integer
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	# $s0 = address of current node
	move	$a0, $s0	
	li	$v0, 34 # hex
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	
	# $s1 = address of next node
	move	$a0, $s1	
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	# $s2 = data of current
	move	$a0, $s2
	li	$v0, 1		# print integer
	syscall	

	
jr $ra

#########################################

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


#######################################
#######################################
