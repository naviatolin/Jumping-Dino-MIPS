addi $t0, $zero, 5 #set value for input 1
addi $t1, $zero, 0 #Set value for input 2
addi $t2, $zero, 0 #If true, +1



bne $t1, $t2, NE
	addi $t2, $t2, 1   #I ended,
	j END
NE:
	j END

END:
move $v0, $t2


