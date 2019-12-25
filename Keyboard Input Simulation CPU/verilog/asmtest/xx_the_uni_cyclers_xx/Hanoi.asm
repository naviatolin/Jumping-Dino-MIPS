# Save the 0th address of the array into $t4
la $t4, our_array # addi, $t4, $zero,8192

# Save the length of the array into t3
addi, $t3, $zero, 3

# Label which iterates through the array
ARRAY:

# Check if we've finshed with last element of array
beq $t3, $zero, FINISH

# Get value from specified location in array and 
# set counter for tower of Hanoi recurrence relation to zero
lw, $t0, 0($t4)
addi $t1, $zero, 0

# Label marking Hanoi calculation loop
START:

# Check if register containing N is 0
beq $t0, $zero, END

# Double current value
add $t1, $t1, $t1
# Add 1 to current value
addi $t1, $t1, 1
# Subtract 1 from register containing N
addi $t0, $t0, -1

# Jump back start until desired N calculated
j START

END:

# Load result in $t1 into memory address where N came from
sw $t1, 0($t4)
# Iterate array index by 4
addi $t4, $t4, 4
# Subtract 1 from array length value
addi $t3, $t3, -1

# Keep iterating through array
j ARRAY

FINISH:

# Initialize array in memory
.data
our_array:
0x00000010
0x00000009
0x0000000A
