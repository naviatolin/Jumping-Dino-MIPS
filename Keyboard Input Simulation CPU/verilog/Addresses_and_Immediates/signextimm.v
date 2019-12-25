module signextend (
	output [31:0] signextimm,
	input [15:0] immediate
);
    reg [31:0] signext;
    reg [31:0] signextimm;
    
    always @* begin
        signext <= {16{immediate[15]}};
        signextimm <= {signext,immediate};
    end

endmodule

module zerosignextend (
	output [31:0] zerosignextimm,
	input [15:0] immediate
);
    reg [31:0] zerosignext;
    reg [31:0] zerosignextimm;
    
    always @* begin
        zerosignext <= {16'b0};
        zerosignextimm <= {zerosignext,immediate};
    end

endmodule