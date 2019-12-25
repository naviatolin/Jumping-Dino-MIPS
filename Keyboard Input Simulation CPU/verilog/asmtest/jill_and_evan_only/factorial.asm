# Calculate the factorial of `$a0` and store it in `$v0`
addi $a0, $zero, 4  # set this to test

addi $t1, $zero, 1  # intermediate result
beq $a0, $zero, END  # 0! = 0, so end
beq $a0, $t1, END  # 1! = 0, so end

addi $t0, $a0, 1  # $t0 is loop end condition
addi $t2, $zero, 2  # outer loop counter
FORCOND:
beq $t2, $t0, END
FORBDY:
# mult $t1, $t1, $t2  by addition

addi $t3, $zero, 0  # counter
addi $t4, $zero, 0  # mult/repeated sum result
MULTCOND:
beq $t3, $t2, MULTEND
MULTBDY:
add $t4, $t4, $t1  # add a0 to sum
addi $t3, $t3, 1  # iterate counter
j MULTCOND
MULTEND:
addi $t1, $t4, 0  # set $t1 to multiply result
# end the loop
addi $t2, $t2, 1
j FORCOND
END:
addi $v0, $t1, 0
