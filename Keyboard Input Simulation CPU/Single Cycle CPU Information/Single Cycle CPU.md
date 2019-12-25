# Single Cycle CPU

> Pranavi Boyalakuntla

---

## Introduction

The purpose of this lab was to implement a single cycle CPU in verilog with the following functionality.

- load word
- store word
- add
- add immediate
- subtract
- set less than
- xor immediate
- jump register
- jump and link
- jump
- branch equal
- branch not equal

In order to make sure that the CPU functions properly, I used assembly tests to see that those instructions were understood and executed correctly by the CPU. 

## Schematic/Block Diagram

![Single%20Cycle%20CPU/CPU_Schematic-3.png](Single%20Cycle%20CPU/CPU_Schematic-3.png)

Figure 0: The block diagram for this CPU that is implemented in Verilog.

## Design Choices

While making this CPU, I had to make decisions on the a lot of things including the control signals output by the state machine outputs. Initially, I was using 1 unique control signal for each instruction out of the FSM, but quickly realized that I could condense a lot of those signals as the different instructions overlapped.

The fact that the instructions overlap in what they want the CPU to do is shown by the or gates in the block diagram.

In addition to this, I made the decision to have a the register storing the previous PC update at the negedge of every clock cycle. In fact, I had to make a lot of decisions as to what the different muxes would always update to. These can be seen at the end of the "cpu.v" file. 

## Test Plan and Results

I tested all of the ALU related instructions in the "ALU.asm" file. This file tests the add, addi, sub, slt, and xori instructions together. 

Then, I tested all of the jump and memory related instructions together in the "Jumps_LW_SW.asm" file. This file tests the jump, jump and link, jump register, load word, and store word instructions together.

Lastly, I tested the two branch if equal and branch not equal instructions together in the "BEQ_BNE.asm" file. 

I recorded how the cpu test bench viewed the file .text.hex file location and used three if statements to check if the final register values matched up with what is expected for the current assembly test.

These assembly tests are located in the "asm" folder of this repository.

## Performance/Area Analysis of Design

The longest is 7 clock cycles with the branch instruction. 

In the Verilog implementation, however, it take exactly 1 clock cycle to go through any 1 instruction as the appropriate delays aren't included.