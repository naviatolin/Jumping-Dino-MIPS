# Arithmetic Test
# Nah, Alex, Anna

# memory configure memory
addi $sp, $zero, 0x3ffc



# Main function
main:

# intial values in a0 and a1
addi $a0, $zero, 5
addi $a1, $zero, 7

# call multiply function
jal multiply

j exit



# Multiply Function
multiply:

# initalize t0, counter, as 1
addi $t0, $zero, 1

# add a0 to itself a1 times
loop:
	# loop a1 times
	bgt $t0, $a1, exit
	
	# adding one to the counter
	addi $t0, $t0, 1
	
	# add a0 to v0 which holds the previous result
	add $v0, $v0, $a0
	
	# jump back to beginning of the loop
	j loop

exit:

