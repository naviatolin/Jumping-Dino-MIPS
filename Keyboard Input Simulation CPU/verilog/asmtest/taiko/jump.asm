main:
	j jump



jump:
	add $t0, $zero, 1
	move  $v0, $t0  ##Return 1 in $v0 (true) if the jump was made