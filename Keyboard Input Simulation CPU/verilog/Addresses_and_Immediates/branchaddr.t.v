`include "branchaddr.v"

module branchaddrTest();
    wire [31:0] branch_addr;
    reg [15:0] immediate;
    reg [31:0] new_address;

    branchAddress dut(.branch_addr(branch_addr), .immediate(immediate));

    initial begin
        immediate = 16'b0111111111111111;
        #1
        new_address = 32'b00000000000000011111111111111100;
        if (branch_addr != new_address) $display("Error");
    end
endmodule