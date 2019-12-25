addi $a0, $zero, 1

main:
	jal jump
	add $t0, $a0, $zero
	move $v0, $t0  ##Output will be 1 if jump register and jump and link is made

	

jump:
	addi $a0, $zero, 1  ##if jump is made, $a0 becomes one
	jr $ra ##jumps for contents of first register
