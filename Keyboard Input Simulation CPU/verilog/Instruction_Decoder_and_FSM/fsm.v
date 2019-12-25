// r type opcode value
`define R_TYPE 6'b000000

// rtype function values to distinguish between them
`define ADD 6'h20
`define SUB 6'h22
`define SLT 6'h2A
`define JR 6'h08

// define j type instructions
`define JUMP 6'b000010
`define JAL 6'b000011

// define i type instructions
`define ADDI 6'b001000
`define XORI 6'b001110
`define BNE 6'b000101
`define BEQ 6'b000100
`define SW 6'b101011
`define LW 6'b100011

// ALU Stuff
`define ALU_ADD  3'd0
`define ALU_SUB  3'd1
`define ALU_XOR  3'd2
`define ALU_SLT  3'd3
`define ALU_AND  3'd4
`define ALU_NAND 3'd5
`define ALU_NOR  3'd6
`define ALU_OR   3'd7

// alternate_PC Mux Stuff
`define JR_PC_ENABLE 3'd3
`define J_JAL_PC_ENABLE 3'd2
`define B_PC_Enable 3'd1


module FSM
(
    output reg wr_en_reg,
    output reg [2:0] ALU_Signal,
    output reg write_from_memory_to_reg,
    output reg write_reg_31,
    output reg write_pc8_to_reg,
    output reg use_alternative_PC,
    output reg [1:0] choose_alternative_PC,
    output reg use_signextimm,
    output reg use_zerosignextimm,
    output reg wr_en_memory,
    output reg write_to_rt,
    output reg branch_equal,
    input [5:0] opcode,
    input [5:0] funct
    
);
    always @(opcode or funct) begin
        wr_en_reg <= 1'b0;
        ALU_Signal <= 3'b0;
        write_from_memory_to_reg <= 1'b0;
        write_reg_31 <= 1'b0;
        write_pc8_to_reg <= 1'b0;
        use_alternative_PC <= 1'b0;
        choose_alternative_PC <= 2'b0;
        use_signextimm <= 1'b0;
        use_zerosignextimm <= 1'b0;
        wr_en_memory <= 1'b0;
        write_to_rt <= 1'b0;
        branch_equal <= 1'b0;

        case(opcode)
            `R_TYPE: begin
                case(funct)
                    `ADD: begin
                        wr_en_reg <= 1'b1;
                        ALU_Signal <= `ALU_ADD;
                    end
                    `SUB: begin
                        wr_en_reg <= 1'b1;
                        ALU_Signal <= `ALU_SUB;
                    end
                    `SLT: begin
                        wr_en_reg <= 1'b1;
                        ALU_Signal <= `ALU_SLT;
                    end
                    `JR: begin
                        ALU_Signal <= `ALU_ADD;
                        use_alternative_PC <= 1'b1;
                        choose_alternative_PC <= `JR_PC_ENABLE;
                    end
                endcase
            end
            `JUMP: begin
                ALU_Signal <= `ALU_ADD;
                use_alternative_PC <= 1'b1;
                choose_alternative_PC <= `J_JAL_PC_ENABLE;
            end
            `JAL: begin
                wr_en_reg <= 1'b1;
                ALU_Signal <= `ALU_ADD;
                write_reg_31 <= 1'b1;
                write_pc8_to_reg <= 1'b1;
                use_alternative_PC <= 1'b1;
                choose_alternative_PC <= `J_JAL_PC_ENABLE;
            end
            `ADDI: begin
                wr_en_reg <= 1'b1;
                ALU_Signal <= `ALU_ADD;
                use_signextimm <= 1'b1;
                write_to_rt <= 1'b1;
            end
            `XORI: begin
                wr_en_reg <= 1'b1;
                ALU_Signal <= `ALU_XOR;
                use_zerosignextimm <= 1'b1;
                write_to_rt <= 1'b1;
            end
            `BNE: begin // set use_alternative_PC in the cpu: HIGH if if r[rs] == r[rt]
                ALU_Signal <= `ALU_XOR;
                choose_alternative_PC <= `B_PC_Enable;
                use_zerosignextimm <= 1'b1;
                use_alternative_PC <= 1'b1;
            end
            `BEQ: begin // set use_alternative_PC in the cpu: HIGH if r[rs] == r[rt]
                ALU_Signal <= `ALU_XOR;
                choose_alternative_PC <= `B_PC_Enable;
                use_alternative_PC <= 1'b1;
                use_zerosignextimm <= 1'b1;
                branch_equal <= 1'b1;
            end
            `SW: begin
                ALU_Signal <= `ALU_ADD;
                wr_en_memory <= 1'b1;
                use_signextimm <= 1'b1;
            end
            `LW: begin
                wr_en_reg <= 1'b1;
                ALU_Signal <= `ALU_ADD;
                write_to_rt <= 1'b1;
                write_from_memory_to_reg <= 1'b1;
                use_signextimm <= 1'b1;

            end
        endcase
    end
endmodule
