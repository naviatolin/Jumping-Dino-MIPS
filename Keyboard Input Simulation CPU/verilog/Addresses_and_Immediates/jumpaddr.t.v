`include "jumpaddr.v"

module jumpaddrTest();
    wire [31:0] jump_addr;
    reg [31:0] PC;
    reg [25:0] address;

    jumpAddress dut(.jump_addr(jump_addr), .address(address), .PC(PC));

    initial begin
        address = 26'b11111111111111111111111111;
        PC = 32'd0;
        #1
        if (jump_addr != 32'b00001111111111111111111111111100) $display("Error");
    end
endmodule