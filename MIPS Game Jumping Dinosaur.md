# MIPS Game: Jumping Dinosaur

## The Game

The goal of this project was to recreate a well known and recognizable game: the Chrome  Dinosaur. This game appears on the Chrome Web Browser whenever a site cannot be reached. The player is a dinosaur who can jump using the keyboard keys. The dinosaur is faced with cacti which it has to jump over. The game ends if the player doesn't time jumping correctly and lands on or runs into the cactus. If this is the case, the player can no longer jump and the game must be restarted.

In this project, I aimed to recreate this classic game using the assembly language. I thought it would be a great way to gain a better understanding of how programming works which would then help me better understand how CPU's work. Earlier in the class, we had built a simulated CPU using an HDL called Verilog. To improve the functionality of this CPU, and better debug my Verilog CPU, I realized I needed to have a better grasp on how programming works and how a computer steps through instructions. I also hoped to improve my mental model of how memory worked as that seemed like a black box at the time. And what better way to accomplish all of those things than writing the Chrome Dinosaur Game in assembly!

## How To Play

Clone this repository onto your computer and navigate to it using terminal. Once you are located in this repository in your terminal:

    java -jar Mars4_Debugged.jar

This will launch the MARS MIPS Simulator. Open the game.asm file using this application. 

Before running this code, make sure that the memory configuration is set to default. Then, navigate to the "tools" and open the "Keyboard and Display MMIO Simulator" and the "Bitmap Display". 

Once these are both open, change the settings in the bitmap display to that of figure 0 shown below.

![MIPS%20Game%20Jumping%20Dinosaur/ezgif.com-video-to-gif.gif](MIPS%20Game%20Jumping%20Dinosaur/ezgif.com-video-to-gif.gif)

![MIPS%20Game%20Jumping%20Dinosaur/Untitled.png](MIPS%20Game%20Jumping%20Dinosaur/Untitled.png)

Figure 0: An image of how you should set up the bitmap display. 

Now connect both the Keyboard MMIO Simulator and Bitmap Display to MIPS. Lastly, assemble and run the current program.

This should start the game right away. So, be sure to click on the text box in the keyboard simulator.

In order to jump press the 'w' key.

## How This Works

### Bitmap Display

This game uses the inbuilt bitmap display of the MARS MIPS simulator in order to display the game. This bitmap display uses a set chunk in memory to act as the game display. In order to run this game, I set this chunk to start at 0x10040000 or the simulated heap. I chose the heap as the base address for the display because it was a large chunk of memory that didn't interfere with where the rest of the game data was stored (static memory, etc). Another reason why I chose this was because it was a very large chunk of memory so even if there were any memory issues, it wouldn't overwrite other game things stored in memory.

The screen renders these colors by reading what is stored in the allotted memory addresses for the number of units displayed in the screen. Since we know that each unit has a height and width of 8 pixels, and the screen is 512 by 256 pixels large, the screen is 64 units wide and 32 units high. This means that there are 2048 total addresses in memory allocated to this screen. 

These locations in memory have 32-bit color values stored in them. MARS looks at what is stored in the first 2048 memory addresses following the base address, and displays their contents on the bitmap display. 

### Keyboard Input

Keyboard input is also controlled using the MARS MIPS Simulator with the "Keyboard MMIO Simulator" tool. all keyboard input is stored in the 0xFFFF0004 location as the ASCII code. Keyboard inputs are read using the load word function. 

This MMIO functionality in the MARS emulator works using a polling approach. A ready bit is used to check whether or not we can load or store from this memory address. If something is being "stored" or "loaded from" this memory address, this ready bit will be set to 0 and will continue to be checked until it is 1 (nothing is happening with this memory address). Once this ready bit is 1, we can once again load or store from this register. 

### Flow of The Game

At the start of the game, the board color and the floor colors are drawn. Then, the dinosaur is initialized. 

The dinosaur is drawn by providing an initial memory location which is then used for as the bottom left block of the dinosaur. From there, there is a sequence of steps that draws the rest of the dinosaur in reference to that location. 

Then, the cactus is initialized at the right most position of the display. 

The cactus is drawn in a similar way where an initial reference point is given and then the rest of the cactus is drawn in reference. 

The cactus moves from right to left regardless of player actions. The cactus continues to be shifted left until it reaches the end of the allocated memory block, where we stop drawing that cactus and reinitialize a new cactus at the rightmost position of the display.

The cactus is shifted left by changing the starting or reference point for drawing the cactus. The previous reference point is used to redraw the cactus in the previous location in the same color as the background. Then, the new reference point, shifted left 1 unit, is provided such that the cactus can be redrawn in the cactus color. 

While this cactus is being shifted left, we are constantly loading what is stored in the keyboard press memory location. If this is equal to the 'w' key ascii value, then we start shifting the dinosaur up. 

The dinosaur is shifted up by a similar process to shifting the cactus left. The previous starting position is used to redraw the dinosaur in the background color, effectively erasing it. Then, the dinosaur is redrawn using the new, shifted up reference point. 

Once the dinosaur starts moving up, there is a set pattern for which it follows. It moves up a set number of times, waits a little bit, and then moves down the same number of times. During this period of time, keyboard input is not considered. This ensures that the dinosaur only jumps while it is on the ground and not when it is still in the air.

The data that is stored in the keyboard press memory location will stay the same until a different keyboard has been pressed. For example, if the player pressed 'w' and then pressed 's' a while later, the data stored in this memory location would be the ascii value for 'w' and then the ascii value for 's'. From a game point of view, that means that if a user presses 'w' once and then presses 'w' again a while later, there is no way of knowing if the user pressed the same key twice. 

Therefore, when a user presses the 'w' key and we are able to read that, the first thing is to store a value of 32'b0 into that memory location. This will not allow the game to think that the user is still pressing w. In addition, the next time that the user presses the 'w' key, the value in that memory location will change again. 

Once, the dinosaur is on the ground, it will not jump again until the 'w' key has been pressed once more.

The last component to the game is the collision detection. Whenever any unit constructing the dinosaur is drawn, the previous color of the unit is checked. If this unit had a previous color other than the background color, it is safe to assume that the dinosaur is in contact with the cactus and therefore the game has ended.

When the game ends, each unit across the screen is colored the same color as the cactus in a slow moving fashion. It progresses slowly in the same style as old video games (hopefully) by waiting between coloring each unit. This continues until the whole screen is covered.

Lastly, the game is terminated using the proper procedures.

## Contribute

All of the game program is located in the "game.asm" file. 

### To Do List

There were quite a few paths of improvement that were explored, but due to a lack of time and excess in bugs, I did not include them in this final version.

- Multiple Cactuses

In order to have more than one cactus be displayed, you could have a random number be generated (a known process in the MIPS assembly). Then, you could display the corresponding cactus to the digit generated by reading the register where that value was stored. 

- Ducking The Dinosaur

To have the dinosaur duck, you could create a new image with the same reference point as the initialized dinosaur that would be a flattened image of it. It could duck down for a certain "sleep" period. Once this period has completed, the ducking dinosaur could be "erased" and the initialized dinosaur could be redrawn.

- Overhead Obstacles that Require Ducking

To draw the overhead obstacles, you could add this into the "multiple cactuses" functionality. When the number corresponding to the overhead obstacle is generated, this obstacle could be created. Then, the image could be painted at the rightmost location on the display and move left just as the cactus. The ducking could be used to avoid this obstacle.

- Debugging Speeding Up The Cacti

There was a bug with speeding up the cacti which I had not realized prior to the final demo which forced me to remove it from this code. This bug didn't allow the cactus to be erased in time (the number of steps before going off frame for a faster cactus is not the same as a slower cactus) and caused it to continue moving through memory and overwriting data far before the display itself.

## Debugging Process

The first bug I had run into was actually getting the Bitmap Display to display anything at all. This was due to the fact that my memory configuration did not match the memory addresses that I was writing to. In addition to this, fully understanding how not to overwrite large chunks of data when painting the game background took some time. This was because it took some time to understand how the unit system worked in MARS.

In the beginning of this project, I ran into an issue where a select few of the registers would contain the background color instead of whatever it was that I was trying to store in them. The solution to this problem was to change the base address of the display such that it never accidentally overwrites important data. This also forced me to understand how memory worked much better and the game no longer overwrites unwanted memory locations. 

Once I finally got to displaying the game and drawing the game objects, rapidly updating the screen started to become an issue. There were two main avenues that I  pursued the most: (1) rapidly redraw the background, then the cactus, then the dinosaur on repeat, (2) draw and erase the sprites and never redraw the background. Having tried the first option first, I quickly realized that this was causing the dinosaur and cactus to visibly disappear for periods long enough to not make the game fluid. At first, I thought that this was because of a few of the sleep statements that were located throughout the program. As it turned out, deleting this also did not fix the situation. After trying more possible solutions, I decided that redrawing the background was definitely not the way to proceed. Then, I started trying to erase the dinosaur and redraw it. Initially, there were a lot of issue with the dinosaur moving to many unwanted locations and the cacti being very finicky. However, at last, both the cactus and dinosaur moved much more fluidly than that they did in the past and this issue was solved.

There were many more bugs especially surrounding getting the dinosaur back to the initial location it started off with. To solve a lot of these errors, it was playing around with the order of erasing, displaying, and wait times between things to make sure that everything updates properly.

There are also a lot of attempted avenues of improvement that have not completely made their way to fruition. These are more heavily discussed in the contribute section as future hopes for this project.

## Reflection

I believe this portion of the project was successful. The dinosaur jumps! And the cactus moves! And when the dinosaur collides with the cactus the game ends. These are the basic premises of the Chrome Dinosaur game. If there was more time, I would definitely like to spend more time debugging all of the work put into moving the cactus faster, and making the dinosaur squat, and have more than one cactus. These were all attempted, but had a lot of bugs, so they aren't included in the current code.

Building this game was a lot of fun, and so was learning assembly. It allowed me to understand how CPU's work a lot more in depth than I had understood before, and actually allowed me to rewrite my Verilog CPU in its current working state with my newly gained knowledge. Writing assembly can be very time consuming, but it really helped me gain a better understanding of everything going on behind the scenes.

## Resources

All code written is put together originally.

In order to both learn more about assembly and assembly games I used the following links: 

[http://inst.eecs.berkeley.edu/~cs61cl/fa08/labs/lab25.html](http://inst.eecs.berkeley.edu/~cs61cl/fa08/labs/lab25.html)

[https://github.com/Misto423/Assembly-Snake](https://github.com/Misto423/Assembly-Snake)