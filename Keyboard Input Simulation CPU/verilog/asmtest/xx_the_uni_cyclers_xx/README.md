**Test**: Calculated the minimum number of moves required to solve the Tower of Hanoi puzzle with 
N disks using its recurrence relation (H<sub>n</sub> = 2H<sub>n-1</sub> + 1)

**Expected Results**: You should expect to see the following results at the following addresses in memory
- 0x00002000: 65535<sub>10</sub>
- 0x00002020: 511<sub>10</sub>
- 0x00002040: 1023<sub>10</sub>

**Memory Layout**: We initialize the following ``.data`` section in our code to initialize an array in memory:
```assembly
.data
our_array:
0x00000010
0x00000009
0x0000000A
```

**Functions Tested**: Our program should be runnable by everyone, for it test the baseline functions ```beq, add, addi, sw, lw,``` and ```j```
