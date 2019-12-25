`include "PC.v"

module PCtest();
    reg clk;
    wire [31:0] PC;
    reg [31:0] PC_last;
    reg [31:0] alternative_PC;
    reg use_alternative_PC;

    initial clk = 0;
    always #1 clk = !clk;

    PC dut (.PC(PC), .PC_last(PC_last), .alternative_PC(alternative_PC), .use_alternative_PC(use_alternative_PC), .clk(clk));
    initial begin
        // reset the PC with 0
        @(negedge clk) begin
            PC_last = 32'd4;
            alternative_PC = 32'd0;
            use_alternative_PC = 1;
        end

       #1
        @(posedge clk) begin
            if (PC != alternative_PC) $display("Fail at using alternative PC to reset the PC");
            else $display ("Reset PC Works!");
        end

        // test adding 4 to PC
        @(negedge clk) begin
            PC_last = 32'd0;
            alternative_PC = 32'd0;
            use_alternative_PC = 0;
        end

        #1
        @(posedge clk) begin
            if (PC != 32'd4) $display("Fail at adding 4 to PC");
            else $display ("Adding 4 to PC works!");
        end

        // reset the PC with 8
        @(negedge clk) begin
            PC_last = 32'd4;
            alternative_PC = 32'd8;
            use_alternative_PC = 1;
        end

       #1
        @(posedge clk) begin
            if (PC != alternative_PC) $display("Fail at using alternative PC to reset the PC");
            else $display ("Alternative PC Works!");
        end

        $finish();
    end
endmodule

