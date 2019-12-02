.data

# Colors
backgroundColor: .word 0x00D0E0E3
dinoColor: .word 0x00351C75
obstacleColor: .word 0x00134F5C

# Addresses
screenStart: .word 0x10010000

.macro Terminate
        li $v0, 10
        syscall
.end_macro

.macro Sleep
	li $a0, 100							
	li $v0, 32	# Pause for 80 milisec						
	syscall
.end_macro

.macro SleepLonger
	li $a0, 50
	li $v0, 32
	syscall
.end_macro

.macro drawBoard
	li $t0, 512 
	li $t1, 0
	lw $t3, screenStart # the starting address of the screen is on $t3
	lw $t2, backgroundColor # the desired color of the background is on $t2
	
	drawRow:
		sw $t2, ($t3) #store the background color in the address stored in $t3
		addi $t3, $t3, 4 # increments the address of the pixel 
		addi $t1, $t1, 4 # increments the counter to tell when to switch rows
		blt $t1, $t0, drawRow
		b nextRow
	
	nextRow:
		addi $t0, $t0, 512
		ble $t0, 131072, drawRow
.end_macro

.text
drawBoard

li $s0, 3 # initial x position
li $s1, 3 # initial y position
lw $s2, dinoColor # store dino color in a register
	
li $t0, 0x10010704	# begin the dino here

initializeDino:
	sw $s2, ($t0)
	addi $t0, $t0, 4 		# while SB < SE, fill the display with the snake body (size: 6/4??)
	blt $t0, $t1, initializeDino
	
	lw $s2, dinoColor
	jal drawDino

drawDino:
	# computing and storing the location on screen to place dino
	sll $t1, $s1, 6 
	add $t1, $t1, $s0
	sll $t1, $t1, 2
	
	lw $t2, screenStart
	add $t1, $t1, $t2
	#lw $t7, ($t1)
	sw $s2, ($t1)
	
	
	
	
	










