`include "alu.v"

module aluTest();
    reg clk;
    wire [31:0] result;
    reg [31:0] operandA;
    reg [31:0] operandB;
    reg [2:0] command;

    initial clk = 0;
    always #1 clk = !clk;

    ALU dut (.result(result), .operandA(operandA), .operandB(operandB), .command(command));
    
    initial begin
        // Try add
        @(negedge clk) begin
            operandA <= 32'b00000000000000000000000000000000;
            operandB <= 32'b11111111111111111111111111111111;
            command <= 3'd0;
        end

       
        @(posedge clk) begin
            if (result != 32'b11111111111111111111111111111111) $display("Issue with Add");
        end

        // Try sub
        @(negedge clk) begin
            operandA <= 32'b11111111111111111111111111111111;
            operandB <= 32'b11111111111111111111111111111111;
            command <= 3'd1;
        end

       
        @(posedge clk) begin
            if (result != 32'b00000000000000000000000000000000) $display("Issue with Sub");
        end

        // Try xor
        @(negedge clk) begin
            operandA <= 32'b11111111111111111111111111111111;
            operandB <= 32'b00000000001111111111111111111111;
            command <= 3'd2;
        end

       
        @(posedge clk) begin
            if (result != 32'b11111111110000000000000000000000) $display("Issue with xor");
        end

        // Try slt
        @(negedge clk) begin
            operandA <= 32'b11111111111111111111111111111111;
            operandB <= 32'b00000000001111111111111111111111;
            command <= 3'd3;
        end

       
        @(posedge clk) begin
            if (result != 32'b00000000000000000000000000000001) $display("Issue with Slt");
        end

        // Try and
        @(negedge clk) begin
            operandA <= 32'b11111111111111111111111111111111;
            operandB <= 32'b00000000001111111111111111111111;
            command <= 3'd4;
        end

       
        @(posedge clk) begin
            if (result != 32'b00000000001111111111111111111111) $display("Issue with and");
        end

        // Try nand
        @(negedge clk) begin
            operandA <= 32'b11111111111111111111111111111111;
            operandB <= 32'b00000000001111111111111111111111;
            command <= 3'd5;
        end

       
        @(posedge clk) begin
            if (result != 32'b11111111110000000000000000000000) $display("Issue with nand");
        end

        // Try nor
        @(negedge clk) begin
            operandA <= 32'b11111111111111111111111111111111;
            operandB <= 32'b00000000001111111111111111111111;
            command <= 3'd6;
        end

       
        @(posedge clk) begin
            if (result != 32'b00000000000000000000000000000000) $display("Issue with nor");
        end

        // Try or
        @(negedge clk) begin
            operandA <= 32'b11011111111111111111111111111111;
            operandB <= 32'b00000000001111111111111111111111;
            command <= 3'd7;
        end

       
        @(posedge clk) begin
            if (result != 32'b11011111111111111111111111111111) $display("Issue with or");
        end

        

        
        $finish();
    end
endmodule

