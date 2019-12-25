module branchAddress (
	output reg [31:0] branch_addr,
	input [15:0] immediate
);
    reg [31:0] extension;
    reg [31:0] branchAddr;
    
    always @* begin
        extension <= {14{immediate[15]}};
        branch_addr <= {extension,immediate, 2'b0};
    end

endmodule