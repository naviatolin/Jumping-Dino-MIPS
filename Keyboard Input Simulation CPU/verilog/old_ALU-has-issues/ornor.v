`timescale 1 ns / 1 ps

`define OR or #960
// `define NOT not #320
`define XOR xor #640


module ornor32bit
(
  output[31:0] aornorb,
  input[31:0]  a,
  input[31:0]  b,
  input inv
);
  wire[31:0] aorb;

  `OR orgate[31:0](aorb, a, b);

  `XOR xorgate[31:0](aornorb, aorb, inv);

endmodule