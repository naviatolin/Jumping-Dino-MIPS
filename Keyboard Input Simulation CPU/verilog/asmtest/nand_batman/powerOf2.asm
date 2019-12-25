addi $a0, $zero, 5

addi $t0, $zero, 1

loop:
beq $a0, 0, breakloop
add $t0, $t0, $t0
subi $a0, $a0, 1
j loop

breakloop:
add $v0, $zero, $t0