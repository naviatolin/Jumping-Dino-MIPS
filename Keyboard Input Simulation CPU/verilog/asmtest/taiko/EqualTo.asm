addi $t0, $zero, 5 #set value for input 1
addi $t1, $zero, 5 #Set value for input 2
addi $t2, $zero, 0 #If true, +1



beq $t1, $t2, EQUAL
	addi $t2, $t2, 1    #IF not equal, make $t2 true.
	j END
EQUAL:
	addi $t3, $zero, 1
	j END

END:
move $v0, $t2 #Move $t2 to the $v0 reg
move $v1, $t3 #Move $t3 to the $v1 reg, if this happens, t

