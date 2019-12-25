`timescale 1 ns / 1 ps

`define AND and #960
// `define NOT not #320
`define XOR xor #640


module AndNand32bit
(
  output[31:0] result,
  input[31:0] a,
  input[31:0] b,
  input inv
);
   
   wire[31:0] holder;

  `AND andgate[31:0](holder,a,b);
  `XOR xorgate[31:0](result,holder,inv);

endmodule



