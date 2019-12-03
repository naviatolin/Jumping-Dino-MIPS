.data

# Colors
backgroundColor: .word 0x00D0E0E3
dinoColor: .word 0x00351C75
obstacleColor: .word 0x00134F5C
keyPress: .word 0xffff0004

# Addresses
screenStart: .word 0x10040000 # screen starts at the heap

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
	
	nextRow:
		addi $t0, $t0, 256
		ble $t0, 8192, drawRow
.end_macro

.text
drawBoard
li $t9, 0 # set the offsets for the dino (up or down)
li $t8, 0

checkKey:
	lw $a1, keyPress
	beq $a1, 0x00000077, dinoUp
	jal initDino

initDino:
	# initialize the position of the dino
	li $s7, 48 # initialize how far over the dino starts
	li $s6, 24 # initialize how far down the dino starts

	li $s5, 256
	multu $s6,$s5
	mflo $s6
	add $s6, $s6, $s7 # $s6 stores the shift from the base address for the first pixel of the dino
	sub $s6, $s6, $t9
	add $s6, $s6, $t8
	j drawDino
	
drawDino:
	li $t1, 0 # reset the horizontal counter
	li $t2, 0 # reset the vertical counter
	
	li $t4, 3 # maximum body width
	li $t7, 3 # maximum body height
	li $t6, 6 # maximum head height
	li $t5, 12 # how much to move back for each level
	
	lw $s4, screenStart # the starting address of the screen is on $t3
	add $s4, $s4, $s6
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
	
dinoUp:
	SleepLonger
	drawBoard
	li $t9, 256
	li $t8, 0
	jal initDino
	j dinoDown
	j checkKey
	
dinoDown:
	SleepLonger
	drawBoard
	li $t8, 256
	li $t9, 0
	jal initDino
	j dinoUp
	j checkKey
		
		




Terminate




	
	
	
	
	










