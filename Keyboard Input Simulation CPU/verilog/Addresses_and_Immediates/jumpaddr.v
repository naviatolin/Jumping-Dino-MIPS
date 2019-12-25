module jumpAddress (
	output [31:0] jump_addr,
	input [25:0] address,
    input [31:0] PC
);
    reg [31:0] modified_PC;
    reg [31:0] jump_addr;
    
    always @* begin
        modified_PC <= PC+32'd4;
        jump_addr <= {modified_PC[31:28], address, 2'b0};
    end

endmodule