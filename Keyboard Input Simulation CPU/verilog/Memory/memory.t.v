`include "memory.v"

module memTest();
    reg [31:0] PC; // input
	wire [31:0] instruction; // output

	wire [31:0] data_out; // output
	reg [31:0] data_in; // input
	reg [31:0] data_addr; // input

	reg clk; // input
	reg wr_en; // input

    memory dut(.PC(PC), .instruction(instruction), .data_out(data_out), .data_in(data_in), .data_addr(data_addr), .clk(clk), .wr_en(wr_en));

    initial clk = 0;
    always #1 clk = !clk;

    initial begin
        // testing writing 32'b1 to register 0
        @(negedge clk) begin
        PC = 32'b0;

        data_in = 32'b1;
        data_addr = 32'b1000;
        wr_en = 1'b1;
        end

        @(posedge clk) begin
        #1
        if (data_out != 32'b1) begin $display("writing to port is not working"); end
        end

        // reading an instruction from 32'b1 with different information in but write enable off
        @(negedge clk) begin
        PC = 32'b1000;

        data_in = 32'b0;
        data_addr = 32'b1000;
        wr_en = 1'b0;
        end

        @(posedge clk) begin
        #1
        if (instruction != 32'b1) begin $display("reading instruction from memory is not working"); end
        end

        // write and read from a completely different memory address
        @(negedge clk) begin
        PC = 32'b00;

        data_in = 32'b100;
        data_addr = 32'b1100;
        wr_en = 1'b1;
        end

        @(posedge clk) begin
        #1
        if (data_out != 32'b100) begin $display("reading data from memory is not working"); end
        end

        // now read the instruction located at that address
        @(negedge clk) begin
        PC = 32'b1100;

        data_in = 32'b00;
        data_addr = 32'b100;
        wr_en = 1'b0;
        end

        @(posedge clk) begin
        #1
        if (instruction != 32'b100) begin $display("reading instruction from memory is not working"); end
        end
        
        $finish();
    end
endmodule
