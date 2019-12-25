jumpNext:
    addi $s0, $zero, 5
    addi $s1, $zero, 5
    addi $s3, $zeBEro, 0
    add $s2, $s1, $s0

beq $s3, $s2, jumpNext

jumpTo:
    sub $s4, $s2, $s0

bne $s0, $s1, jumpNext

.data
my_array:
0x00000000	# my_array[0]
0x11110000
0x22220000
0x33330000
0x44440000
0x55550000
0x66660000
0x77770000
0x88880000
0x99990000
0xAAAA0000
0xBBBB0000
0xCCCC0000
0xDDDD0000
0xEEEE0000
0xFFFF0000

