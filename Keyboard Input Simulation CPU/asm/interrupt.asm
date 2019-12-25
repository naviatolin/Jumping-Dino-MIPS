# to simulate how this might work in MIPS -- not exact location in memory that would be used as we have memory contraints

# -------------------------------------------------------------------------- #
#                               Register Usage                               #
# -------------------------------------------------------------------------- #
# $t0: control bit value
# $t1: storing the keyboard input loaded in from memory from the data register
# $t2: storing the expectedd ascii value from the data register in CPU register
# $t3: storing the memory location of the data register
# $t4: storing the memory location of the control register
# $t5: loading the control data information into this register

# store the memory location of the keyboard input -- data register is at memory location 4
addi $t3, $zero 4 

# simulate someone pressing the w key but really just loading 
addi $t2, $zero, 0x00000060
sw $t2, ($t3)

# store the control register location -- control register is at memory location 6
addi $t4, $zero, 6
addi $t0, $zero, 0
sw $t0, ($t4)

checkKeyboardInput:
    jal controlHigh
    lw $t1, ($t3) # read keyboard input from memory
    lw $t5, ($t4) # read control bit again
    add $t9, $t1, $t5
    jal controlLow # set control bit to low
    lw $t5, ($t4) #load control bit into cpu registers
    j checkKeyboardInput #repeat the process again

controlHigh:
    addi $t0, $zero, 1
    sw $t0, ($t4)
    jr $ra

controlLow:
    addi $t0, $zero, 0
    sw $t0, ($t4)
    jr $ra

.data
