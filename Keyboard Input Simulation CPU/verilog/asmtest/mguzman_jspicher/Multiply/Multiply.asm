addi $t0, $zero, 5 #a=5
addi $t1, $zero, 5 #b=5
addi $t2, $zero, 0 #sum=0
addi $t3, $zero, 0 #i=0

loop:
    beq $t3, $t1, exit 
    add $t2, $t2, $t0  #sum += a
    addi $t3, $t3, 1 #i = i+1
    j loop
exit:
   add $v0, $zero, $t2