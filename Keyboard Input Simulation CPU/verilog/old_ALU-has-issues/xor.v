`timescale 1 ns / 1 ps

`define XOR xor #640

module XOR32bit
(
output[31:0]  result,
input[31:0]   operandA,
input[31:0]   operandB

);

  `XOR orgate[31:0](result, operandA, operandB);
 
endmodule
