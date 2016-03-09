#Joseph Noyes
#CS 413 Lab 1
#Program generates even numbers from 1 to 50, and gets the sum of these numbers.
#The program then generates the odd numbers from 1 to 50, and gets the sum of 
#those numbers.  It then takes the even sum and subtracts it from the odd sum.

#Variables needed
	.data
	one:	.word	1
	adder:	.word	2
	maxNumEven:	.word	50
	maxNumOdd:	.word	51 #Needs to be 1 more than what is needed
	newLine:	.asciiz	"\n"
	evenIntro:	.asciiz	"List of even numbers between 1 and 50:\n"
	oddIntro:	.asciiz	"List of odd numbers between 1 and 50:\n"
	evenTotalString:	.asciiz	"The sum of all the even values is: "
	oddTotalString:		.asciiz	"The sum of all the odd values is: "
	subtractString:		.asciiz "Even total - odd total is: "

################################################################################

#main program
	.text
	.globl main

main:
	#Print the even intro
	la $a0, evenIntro
	li $v0, 4
	syscall

	#load up the registers
	lw $s0, adder #stores 2, used to add to the current even/odd number
	lw $s1, maxNumEven
	lw $s2, maxNumOdd
	move $t1, $zero #the current even number
	move $t2, $zero #the even total
	lw $t3, one #the current odd number
	move $t4, $zero #the current odd total

################################################################################

evenLoop:
	add $t1, $s0, $t1 #get next even number
	add $t2, $t1, $t2 #sum of even numbers

	#Print out even number
	la $a0, ($t1)
	li $v0, 1
	syscall

	#print newline
	la $a0, newLine
	li $v0, 4
	syscall

	bne $t1, $s1, evenLoop

#Print odd intro
	la $a0, oddIntro
	li $v0, 4
	syscall

################################################################################

oddLoop:
	#odd loop starts at 1
	la $a0, ($t3)
	li $v0, 1
	syscall
	
	#print newline
	la $a0, newLine
	li $v0, 4
	syscall

	#Add two to the current odd number, add odd number to current sum
	add $t4, $t3, $t4
	add $t3, $s0, $t3

	bne $t3, $s2, oddLoop

################################################################################
	
	#Print results
	la $a0, evenTotalString
	li $v0, 4
	syscall
	la $a0, ($t2)
	li $v0, 1
	syscall
	
	#newline
	li $v0, 4
	la $a0, newLine
	syscall

	la $a0, oddTotalString
	li $v0, 4
	syscall
	la $a0, ($t4)
	li $v0, 1
	syscall
	
	#newline
	li $v0, 4
	la $a0, newLine
	syscall

################################################################################
	#Find difference, print it out to the screen
	move $s3, $zero
	sub $s3, $t2, $t4
	la $a0, subtractString
	li $v0, 4
	syscall
	la $a0, ($s3)
	li $v0, 1
	syscall

	#Exit program
	li $v0, 10
	syscall
