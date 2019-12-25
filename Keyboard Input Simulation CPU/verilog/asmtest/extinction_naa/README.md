## Assembly Tests: CUP 

#### Alex Bahner, Anna Griffin, Noah D'Souza


### Assembly code

Our test can be found in the multiply.asm file. The the test takes two inputs and multiplies them together. Since MIPS doesn't have a multiply function, we created a loop that performs addition. In our test file, we initialized register a0 with 5 and a1 with 7. The expected outcome of the multiplication operation 5*7 is 35. 

The multiply function in our test file has a loop that performs addition a1 many times. During each loop, we add the sum value that we are holding in the v0 register. When the loops have completed, we will have the accumulated sum of a0. 


