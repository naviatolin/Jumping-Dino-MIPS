# Single Cycle CPU Assembly Test
# Liv Kelly, Jamie O'Brien, Sabrina Pereira

main: 
# Set up arguments for call to spin
addi  $a0, $zero, 5	
jal   fib


# Jump to "exit", rather than falling through to subroutines
j     program_end

#------------------------------------------------------------------------------
# Recursive Spinout Function. 
# Tells you the minimum number of moves necessary to solve the Spinout puzzle with n gates
# Uses recurrence relation: F(n) = F(n-1) + 2F(n-2) + 1
# Initial conditions: F(0) = 0; F(1) = 1
# 	Equivalent C code:
#	int Spinout(int n)
#	{
#	    if (n==0) return 0;
#	    if (n==1) return 1;
#	    int spin_1 = Spinout(n-1);
#	    int spin_2 = Spinout(n-2);
#	    return spin_1 + 2*spin_2 + 1	     
#	}
fib:
# Test base cases. If we're in a base case, return directly (no need to use stack)
bne   $a0, 0, testone
add   $v0, $zero, $zero		# a0 == 0 -> return 0
jr    $ra
testone:
bne   $a0, 1, spin_body
add   $v0, $zero, $a0		# a0 == 1 -> return 1
jr    $ra

spin_body:
# Create stack frame for fib: push ra and s0
addi  $sp, $sp, -8	# Allocate two words on stack at once for two pushes
sw    $ra, 4($sp)	# Push ra on the stack (will be overwritten by recursive function calls)
sw    $s0, 0($sp)	# Push s0 onto stack

# Call spin(n-1), save result + 1 in s0
add	$s0, $zero, $a0		# Save a0 argument
addi    $a0, $a0, -1	# a0 = n-1
jal	fib
add     $a0, $s0, -2	# a0 = n-2
add     $s0, $zero, $v0	# s0 = Spin(n-1)
addi	$s0, $s0, 1 	# s0 = Spin(n-1) + 1	


# Call spin(n-2), save 2*result in s0
jal	fib
add     $s0, $s0, $v0   # s0 = Spin(n-1) + 1 + Spin(n-2)		
add     $v0, $v0, $s0	# v0 = Spin(n-1) + 2*Spin(n-2) + 1

# Restore registers and pop stack frame
lw    $ra, 4($sp)
lw    $s0, 0($sp)
addi  $sp, $sp, 8

jr    $ra	# Return to caller

#------------------------------------------------------------------------------
# Jump loop to end execution
program_end:
