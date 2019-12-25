
# Expected Results from Spin Test

This test is the recursion function to calculate the the minimum number of moves necessary to solve the Spinout puzzle with n gates. This puzzle is solved by the recurrence relation: `F(n) = F(n-1) + 2F(n-2) + 1`.

The current input for the function is `n=d5`, or, `n=b101`, so after running this assembly test, you should see that the output stored in $V0 should be `F(n)=d21`, or `F(n)=b10101`. 

Feel free to change the input by changing the line `addi  $a0, $zero, 5` in `main`, and checking to see if your CPU provides the correct output for a different input.

