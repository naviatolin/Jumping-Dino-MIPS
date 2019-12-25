`include "signextimm.v"

module signextTest();
    wire [31:0] signextimm;
    reg [15:0] immediate;

    signextend dut(.signextimm(signextimm), .immediate(immediate));

    initial begin
        immediate = 16'b0111111111111111;
        #1
        if (signextimm != 32'b00000000000000000111111111111111) $display("Error");
    end
endmodule