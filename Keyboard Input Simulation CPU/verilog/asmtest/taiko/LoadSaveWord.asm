##Checks if Load Word is working. A sample value is inputted,
##And the output will be a 1 or 0. 1 if the word after saved and loaded still matches $a0, 0 if else.

main:
#save any registers needed in t
#set up arguments in $ao
addi $a0, $zero, 5 
addi $sp, $sp, -4  
sw $a0, 0($sp)

#call function
jal load         ##Calls load Function
#assume return value is in v0
lw $t0, 0($sp)
addi $sp, $sp, 4

beq $a0, $t0, EQUAL
	addi $t2, $t2, 1    #IF not equal, make $t2 true.
	j END
EQUAL:
	j END

END:
move $v0, $t2 #Move $t2 to the $v0 register.


load:
#assume argument is in a0
#Save any register in s or ra
addi $sp, $sp, -4
sw $ra, 0($sp) #push

lw $ra, 0($sp)  #pop
addi $sp, $sp, 4
#before return, need to restore any registers that are saved
jr $ra
