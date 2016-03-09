#Joseph Noyes
#CS 413 Lab 2
#Program simulates a vending machine, allows the user to enter in the money
#needed to buy a soda, then allows the user to select what type of soda they
#would like.

#variables needed
	.data
	cost:	.word	55
	purchaseTotal:	.word	0
	introString:	.asciiz	"Welcome to Joseph's Vending Machine!\n"
	introString2:	.asciiz	"Coke, Sprite, Dr. Pepper, Diet Coke, and Mellow Yellow is 55 cents.\n\n"
	instructionString:	.asciiz	"Enter a coin or select return (R)\n"
	instructionString2:	.asciiz	"\nPlease select a drink or press R to quit:\n"
	currentTotal:	.asciiz	"\nTotal is: "
	cents:		.asciiz	" cents \n"

	#Shows the user the choices for coins
	coinChoices1:	.asciiz	"P  Penny\nN  Nickel\nD  Dime\nQ  Quarter\n"
	coinChoices2:	.asciiz "F  Fifty-Cents\n\nB  Dollar Bill\nR  Return Change\n\n"
	drinks:	.asciiz	"C  Coke\nS  Sprite\nP  Dr. Pepper\nM  Mellow Yellow\n"
	cokeString:	.asciiz	"\n\nDispensing Coke\n"
	spriteString:	.asciiz	"\n\nDispensing Sprite\n"
	dpepperString:	.asciiz	"\n\nDispensing Dr. Pepper\n"
	myellowString:	.asciiz	"\n\nDispensing Mellow Yellow\n"

	changeString:	.asciiz	"\n\nYour change is: "

	exitString:	.asciiz	"\n\nThanks for using Joseph's Vending Machine!\n"

################################################################################

#main Program
	.text
	.globl main
main:

	move $t3, $zero #total cost of drink
	#Display Introductions
	la $a0, introString
	li $v0, 4
	syscall

	la $a0, introString2
	li $v0, 4
	syscall

	#Show the choices the user has for coins
	la $a0, coinChoices1
	li $v0, 4
	syscall

	la $a0, coinChoices2
	li $v0, 4
	syscall

	#show the user the choices for drinks
	la $a0, drinks
	li $v0, 4
	syscall

################################################################################
	#Start allowing the user to insert coins into the machine
	
	move $t0, $zero #holds the total amount the user entered
	lw $t2, cost #holds the amount a drink costs
	coinLoop:
		#print instructions
		la $a0, instructionString
		li $v0, 4
		syscall

		#Get user input
		li $v0, 12
		syscall #What user entered will be stored in $v0


		#Based on what the user entered, go to the correct coin, or exit
		beq $v0, 'P', penny
		beq $v0, 'N', nickel
		beq $v0, 'D', dime
		beq $v0, 'Q', quarter
		beq $v0, 'F', fifty
		beq $v0, 'B', dollar
		beq $v0, 'R', Exit

		penny:
		  addi $t0, $t0, 1
		  j endAddCoin

		nickel:
		  addi $t0, $t0, 5
		  j endAddCoin

		dime:
		  addi $t0, $t0, 10
		  j endAddCoin

		quarter:
		  addi $t0, $t0, 25
		  j endAddCoin

		fifty:
		  addi $t0, $t0, 50
		  j endAddCoin

		dollar:
		  addi $t0, $t0, 100
		  j endAddCoin

		endAddCoin:  #Finished getting coins

		#print current total
		la $a0, currentTotal
		li $v0, 4
		syscall

		la $a0, ($t0)
		li $v0, 1
		syscall

		la $a0, cents
		li $v0, 4
		syscall
		
		bgt $t0, $t2, endCoinLoop #if total is greater than cost, end
		bne $t0, $t2, coinLoop #if the branch is not equal

	endCoinLoop: #Makes it here if total >= cost

################################################################################
	#Allow the user to select the drink

	#Print strings for instructions and drink choices
	la $a0, instructionString2
	li $v0, 4
	syscall

	la $a0, drinks
	li $v0, 4
	syscall

	#obtain the drink the user selected
	li $v0, 12
	syscall  #v0 will now contain what the user entered

	
	#Based on what the user entered, jump to code section
	beq $v0, 'C', coke
	beq $v0, 'S', sprite
	beq $v0, 'P', dpepper
	beq $v0, 'M', myellow
	beq $v0, 'R', return

	#Dispense the correct drink choice, make cost 55, jump to Exit
	coke:
	  lw $t3, cost
	  la $a0, cokeString
	  li $v0, 4
	  syscall
	  j Exit
	sprite:
	  lw $t3, cost
	  la $a0, spriteString
	  li $v0, 4
	  syscall
	  j Exit
	dpepper:
	  lw $t3, cost
	  la $a0, dpepperString
	  li $v0, 4
	  syscall
	  j Exit
	myellow:
	  lw $t3, cost
	  la $a0, myellowString
	  li $v0, 4
	  syscall
	  j Exit
	return:  #If the user does not get a drink
	  move $t3, $zero
	  j Exit

################################################################################

	Exit:

		#Give back change
		sub $s1, $t0, $t3 #amount of change will be in $s1
		la $a0, changeString
		li $v0, 4
		syscall

		la $a0, ($s1)
		li $v0, 1
		syscall

		la $a0, cents
		li $v0, 4
		syscall
		
		#Exit the program
		#Print Exit Message
		la $a0, exitString
		li $v0, 4
		syscall

		#Exit program
		li $v0, 10
		syscall
