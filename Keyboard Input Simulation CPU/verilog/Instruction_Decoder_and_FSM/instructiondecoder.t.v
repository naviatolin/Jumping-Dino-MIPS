`include "instructiondecoder.v"

module instructionDecodertest();
    reg clk;
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [5:0] funct;
    wire [15:0] immediate;
    wire [25:0] address;
    reg [31:0] instruction;

    initial clk = 0;
    always #1 clk = !clk;

    instructionDecoder dut (.opcode(opcode), .rs(rs), .rt(rt), .rd(rd), .shamt(shamt), .funct(funct), .immediate(immediate), .address(address), .instruction(instruction));
    
    initial begin
        // Try R-Type Instruction Decode
        @(negedge clk) instruction = 32'b00000011111000001110000011101011;

       
        @(posedge clk) begin
            if (opcode != 6'b000000) $display("Opcode Problem R-Type");
            if (rs != 5'b11111) $display ("Rs Problem R-Type");
            if (rt != 5'b00000) $display ("Rt Problem R-Type");
            if (rd != 5'b11100) $display ("Rd Problem R-Type");
            if (shamt != 5'b00011) $display ("Shamt Problem R-Type");
            if (funct != 6'b101011) $display ("Funct Problem R-Type");
        end

        // Try Jump
        @(negedge clk) instruction = 32'b00001010100101110000110011101001;

       
        @(posedge clk) begin
            if (address != 26'b10100101110000110011101001) $display("Address Problem Jump");
        end

        // Try Jump and Link
        @(negedge clk) instruction = 32'b00001110100101110000110011101001;

       
        @(posedge clk) begin
            if (address != 26'b10100101110000110011101001) $display("Address Problem Jump And Link");
        end

        // Try I Type Instructions
        @(negedge clk) instruction = 32'b10001111111000000101010110100110;

       #1
        @(posedge clk) begin
            if (rs != 5'b11111) $display("Rs Problem I-Type");
            if (rt != 5'b00000) $display("Rt Problem I-Type");
            if (immediate != 16'b0101010110100110) $display("Immediate Problem I-Type");
        end

        
        $finish();
    end
endmodule

