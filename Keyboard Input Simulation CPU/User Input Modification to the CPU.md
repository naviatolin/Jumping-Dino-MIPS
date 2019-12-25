# User Input Modification to the CPU

## Introduction

In order to complete the Chrome Dinosaur Game properly, keyboard input from the user was required to play the game and make the dinosaur jump. In MARS, all I had to do was load the information from the allocated location in memory where keyboard input was stored as its ASCII code. Then from this information, we could tell which key the user has pressed. In the MARS Simulator, once a key has been pressed, the simulator didn't automatically reset the value stored in that data location so that when a user pressed the same key twice in a row, the program could tell. Therefore, the game had to load the information from that location in memory, and then store a reset value back to that memory location when it was done loading it. 

In order to gain a better understanding of what was going on here, I took a deeper dive into MMIO and how the MARS MIPS simulator ran Keyboard and MMIO simulation. And to do this, I simulated a CPU using the HDL Verilog and created some assembly code to simulate how a system like MARS would handle keyboard input. I also created a simplified error handler for this program counter such that it 

simply resets the PC if a simulated "error" occurs. 

## How Does Keyboard MMIO Work?

In order to process keyboard input, there are two locations in memory which monitor and store information about this process: the control and data registers. The data register stores the keyboard input data. In this case, the least significant byte or the first 8 bits of this data hold the ascii keyboard input from the user. These are both locations in memory, and not actual CPU registers. 

![User%20Input%20Modification%20to%20the%20CPU/Untitled.png](User%20Input%20Modification%20to%20the%20CPU/Untitled.png)

Figure 0: This is how the data register is laid out.

In the control register, all of the bits are irrelevant except for the LSB, or bit 0. This is the ready bit. The ready bit is 0 until user input is inputted into that memory location. Once the user types a key, the ready bit is set to one. 

![User%20Input%20Modification%20to%20the%20CPU/Untitled%201.png](User%20Input%20Modification%20to%20the%20CPU/Untitled%201.png)

Figure 1: This is how the control register is laid out.

After the ready bit is set to one, the information in the data register is loaded into a CPU register and the ready bit is set to 0 until the user inputs another key press.

![User%20Input%20Modification%20to%20the%20CPU/Untitled%202.png](User%20Input%20Modification%20to%20the%20CPU/Untitled%202.png)

Figure 2: This is the flow chart for how the logic works behind the keyboard input.

## Implementation in Verilog

![User%20Input%20Modification%20to%20the%20CPU/CPU_Schematic-3.png](User%20Input%20Modification%20to%20the%20CPU/CPU_Schematic-3.png)

Figure 3: Block diagram for the CPU implementation in Verilog.

In order to simulate this keyboard input, I first had to create a single cycle CPU in Verilog. The block diagram to drive the Verilog implementation is described above. 

Then, before each cycle of the CPU, the CPU checks for the status of the interrupt enable pin. If this interrupt enable pin is high and the ready bit is also high, then the cpu will proceed into a keyboard input handler.

To simplify things, this CPU works so that if the keyboard input by the user is anything other than the w key, it sets the interrupt enable to high. If both this interrupt enable and the ready bit are high, then the CPU resets the PC to 0. 

To see this in action, run the cpu with the following command once just outside the verilog folder:

    make clean && make

To see what happens, you can look at the program counters displayed in your terminal! The interrupt enable is displayed at every step through the program! The results are also shown in the screenshot below. Since the PC resets back to zero, and then right after, the interrupt enable is set back to zero, it can be seen that once the interrupt enable goes low, the PC jumps back to 0 as we were either loading or storing the player input and the player input was incorrect. 

![User%20Input%20Modification%20to%20the%20CPU/Untitled%203.png](User%20Input%20Modification%20to%20the%20CPU/Untitled%203.png)

Figure 4: Results from the incorrect keyboard input simulation

## Room For Improvement

This portion of this project was to show proof of concept and as an exploration of learning in this area. As a result, the interrupt enable was hardcoded to be checked at the line where things that needed to be compared were accessed.

## Resources

All code and diagrams are original. 

The following sources were used as reference.

[http://wilkinsonj.people.cofc.edu/mmio.html](http://wilkinsonj.people.cofc.edu/mmio.html)

[http://people.cs.pitt.edu/~don/coe1502/current/Unit4a/Unit4a.html](http://people.cs.pitt.edu/~don/coe1502/current/Unit4a/Unit4a.html)