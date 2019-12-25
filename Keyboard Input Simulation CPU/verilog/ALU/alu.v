// building a new simplified ALU using behavioral verilog because to see if it fixes things
`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module ALU
(
    output reg [31:0]  result,
    input [31:0]   operandA,
    input [31:0]   operandB,
    input clk,
    input [2:0]    command
);

always @(negedge clk, operandA, operandB, command) begin
    if (command == `ADD) result <= operandA + operandB;
    else if (command == `SUB) result <= operandA - operandA;
    else if (command == `XOR) result <= operandA ^ operandB;
    else if (command == `SLT) result <= (operandB < operandA) ? 32'd1:32'd0;
    else if (command == `AND) result <= operandA & operandB;
    else if (command == `NAND) result <= operandA ~& operandB;
    else if (command == `NOR) result <= operandA ~| operandB;
    else if (command == `OR) result <= operandA | operandA;
    else result <= command;
end
endmodule