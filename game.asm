.data

# Colors
backgroundColor: .word 0x00D0E0E3
dinoColor: .word 0x00351C75
obstacleColor: .word 0x00134F5C
keyPress: .word 0xFFFF0004
zero: .word 0x00000000

# Addresses
screenStart: .word 0x10040000 # screen starts at the heap

.macro Terminate
        li $v0, 10
        syscall
.end_macro

.macro Sleep
	li $a0, 50							
	li $v0, 32	# Pause for 80 milisec						
	syscall
.end_macro

.macro SleepLonger
	li $a0, 500
	li $v0, 32
	syscall
.end_macro

.macro drawBoard
	li $t0, 256
	li $t1, 0
	lw $t3, screenStart # the starting address of the screen is on $t3
	lw $t2, backgroundColor # the desired color of the background is on $t2
	
	drawRow:
		sw $t2, ($t3) #store the background color in the address stored in $t3
		addi $t3, $t3, 4 # increments the address of the pixel 
		addi $t1, $t1, 4 # increments the counter to tell when to switch rows
		blt $t1, $t0, drawRow
		b nextRow
	
	drawGround:
		lw $t2, obstacleColor
		
		drawGroundRow:
			sw $t2, ($t3) #store the ostsacle color in the address stored in $t3
			addi $t3, $t3, 4 # increments the address of the pixel 
			addi $t1, $t1, 4 # increments the counter to tell when to switch rows
			blt $t1, $t0, drawGroundRow
			lw $t2, backgroundColor
			b nextRow
			
	nextRow:
		addi $t0, $t0, 256
		beq $t0, 6656, drawGround
		ble $t0, 8192, drawRow
		
.end_macro

.text
drawBoard
li $t9, 0 # set the offsets for the dino (up or down)
li $t8, 0

li $a1, 0xFFFF0004 # storing the location of the key press data in a1

jal initDino

j checkKey

checkKey:
	lw $t7, ($a1) # load key press data into $t7
	
	beq $t7, 0x00000077, dinoUp
	
	j checkKey

initDino:
	# initialize the position of the dino
	li $s7, 48 # initialize how far over the dino starts
	li $s6, 24 # initialize how far down the dino starts

	li $s5, 256
	multu $s6,$s5
	mflo $s6
	add $s6, $s6, $s7 # $s6 stores the shift from the base address for the first pixel of the dino
	j drawDino
	
drawDino:
	li $t1, 0 # reset the horizontal counter
	li $t2, 0 # reset the vertical counter
	
	li $t4, 3 # maximum body width
	li $t7, 3 # maximum body height
	li $t6, 6 # maximum head height
	li $t5, 12 # how much to move back for each level
	
	lw $s4, screenStart # the starting address of the screen is on $s3
	add $s4, $s4, $s6 # add dino start position to the screen start position
	lw $s2, dinoColor # store dino color in a register
	add $s3, $s4, $zero
	
	drawBodyHorz:
		sw $s2, ($s3)
		addi $s3, $s3, 4
		addi $t1, $t1, 1
		blt $t1, $t4, drawBodyHorz
		
	drawBodyVert:
		
		sub $s3, $s3, $t5
		subi $s3, $s3, 256
		li $t1, 0 # reset the horizontal counter
		addi $t2, $t2, 1
		blt $t2, $t7, drawBodyHorz
		
		li $t4, 5 # maximum head width
		li $t5, 20 # how much to move back for each level with head
		blt $t2, $t6, drawBodyHorz
		j drawTail
		
	drawTail:
		add $s3, $s4, $zero
		subi $s3, $s3, 12
		subi $s3, $s3, 248
		
		sw $s2, ($s3)
		
		add $s3, $s4, $zero
		subi $s3, $s3, 12
		subi $s3, $s3, 508
		sw $s2, ($s3)
		jr $ra

eraseDino:
	li $t1, 0 # reset the horizontal counter
	li $t2, 0 # reset the vertical counter
	
	li $t4, 3 # maximum body width
	li $t7, 3 # maximum body height
	li $t6, 6 # maximum head height
	li $t5, 12 # how much to move back for each level
	
	lw $s4, screenStart # the starting address of the screen is on $s3
	add $s4, $s4, $a2 # add dino start position to the screen start position
	lw $s2, backgroundColor # store dino color in a register
	add $s3, $s4, $zero
	
	eraseBodyHorz:
		sw $s2, ($s3)
		addi $s3, $s3, 4
		addi $t1, $t1, 1
		blt $t1, $t4, eraseBodyHorz
		
	eraseBodyVert:
		
		sub $s3, $s3, $t5
		subi $s3, $s3, 256
		li $t1, 0 # reset the horizontal counter
		addi $t2, $t2, 1
		blt $t2, $t7, eraseBodyHorz
		
		li $t4, 5 # maximum head width
		li $t5, 20 # how much to move back for each level with head
		blt $t2, $t6, eraseBodyHorz
		j eraseTail
		
	eraseTail:
		add $s3, $s4, $zero
		subi $s3, $s3, 12
		subi $s3, $s3, 248
		
		sw $s2, ($s3)
		
		add $s3, $s4, $zero
		subi $s3, $s3, 12
		subi $s3, $s3, 508
		sw $s2, ($s3)
		jr $ra
		
dinoUp:
	add $a2, $s6, $zero
	subi $s6, $s6, 256
	lw $t0, zero #refresh the key press
	sw $t0, ($a1)
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	add $a2, $s6, $zero
	subi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	add $a2, $s6, $zero
	subi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	add $a2, $s6, $zero
	subi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	add $a2, $s6, $zero
	subi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	SleepLonger
	j dinoDown
	
dinoDown:
	add $a2, $s6, $zero
	addi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	add $a2, $s6, $zero
	addi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	add $a2, $s6, $zero
	addi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	add $a2, $s6, $zero
	addi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino
	
	add $a2, $s6, $zero
	addi $s6, $s6, 256
	Sleep
	jal eraseDino
	jal drawDino
	jal drawDino #draw the dino

	SleepLonger
	
	j checkKey
		
		




Terminate




	
	
	
	
	










