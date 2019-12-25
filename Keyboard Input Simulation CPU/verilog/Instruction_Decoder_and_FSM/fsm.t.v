`include "fsm.v"

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

module fsmTest();
    wire wr_en_reg;
    wire [2:0] ALU_Signal;
    wire write_from_memory_to_reg;
    wire write_reg_31;
    wire write_pc8_to_reg;
    wire use_alternative_PC;
    wire [1:0] choose_alternative_PC;
    wire use_signextimm;
    wire use_zerosignextimm;
    wire wr_en_memory;
    wire write_to_rt;
    wire branch_equal;
    reg [5:0] opcode;
    reg [5:0] funct;

    FSM fsmdut (.wr_en_reg(wr_en_reg), .ALU_Signal(ALU_Signal), .write_from_memory_to_reg(write_from_memory_to_reg), .write_reg_31(write_reg_31), .write_pc8_to_reg(write_pc8_to_reg), .use_alternative_PC(use_alternative_PC), .choose_alternative_PC(choose_alternative_PC), .use_signextimm(use_signextimm), .use_zerosignextimm(use_zerosignextimm), .wr_en_memory(wr_en_memory), .write_to_rt(write_to_rt), .branch_equal(branch_equal), .opcode(opcode), .funct(funct));

    initial begin
        // Testing Add
        opcode = 6'b000000; 
        funct = 6'h20;
        #1
        if (wr_en_reg != 1'b1) begin $display("ADD: Not Working"); end
        if (ALU_Signal != `ALU_ADD) begin $display("ADD ALU: Not Working"); end

        // Testing Sub
        opcode = 6'b000000; 
        funct = 6'h22;
        #1
        if (wr_en_reg != 1'b1) begin $display("SUB: Not Working"); end
        if (ALU_Signal != `ALU_SUB) begin $display("SUB ALU: Not Working"); end

        // Testing SLT
        opcode = 6'b000000; 
        funct = 6'h2A;
        #1
        if (wr_en_reg != 1'b1) begin $display("SLT: Not Working"); end
        if (ALU_Signal != `ALU_SLT) begin $display("SLT ALU: Not Working"); end
        
        // Testing JR
        opcode = 6'b000000; 
        funct = 6'h08;
        #1
        if (use_alternative_PC != 1'b1) $display("JR PC USE: Not Working");
        if (choose_alternative_PC != `JR_PC_ENABLE) $display("JR PC CHOOSE: Not Working");
        if (ALU_Signal != `ALU_ADD) $display("JR ALU: Not Working");

        // Testing Jump
        opcode = 6'b000010; 
        funct = 6'h08;
        #1
        if (use_alternative_PC != 1'b1) $display("J PC USE: Not Working");
        if (choose_alternative_PC != `J_JAL_PC_ENABLE) $display("J PC CHOOSE: Not Working");
        if (ALU_Signal != `ALU_ADD) $display("J ALU: Not Working");

        // Testing JAL
        opcode = 6'b000011;
        funct = 6'h08;
        #1
        if (wr_en_reg != 1'b1) $display("JAL REG WRITE EN: Not working");
        if (write_reg_31 != 1'b1) $display("JAL REG 31: Not working");
        if (write_pc8_to_reg != 1'b1) $display("JAL PC8 TO REG: Not working");
        if (use_alternative_PC != 1'b1) $display("JAL PC USE: Not Working");
        if (choose_alternative_PC != `J_JAL_PC_ENABLE) $display("JAL PC CHOOSE: Not Working");
        if (ALU_Signal != `ALU_ADD) $display("JAL ALU: Not Working");
        

        // Testing ADDI
        opcode = 6'b001000;
        funct = 6'h08;
        #1
        if (use_signextimm != 1'b1) $display("ADDI USE SIGNEXTIMM: Not working");
        if (write_to_rt != 1'b1) $display("ADDI WRITE TO RT: Not working");
        if (wr_en_reg != 1'b1) $display("ADDI Write: Not Working");
        if (ALU_Signal != `ALU_ADD) $display("ADDI ALU: Not Working");

        // Testing XORI
        opcode = 6'b001110;
        funct = 6'h08;
        #1
        if (use_zerosignextimm != 1'b1) $display("XORI USE SIGN EXT IMM: Not Working");
        if (write_to_rt != 1'b1) $display("XORI WRITE TO RT: Not working");
        if (wr_en_reg != 1'b1) $display("XORI Write: Not Working");
        if (ALU_Signal != `ALU_XOR) $display("XORI ALU: Not Working");

        // Testing BNE
        opcode = 6'b000101;
        funct = 6'h08;
        #1
        if (use_alternative_PC != 1'b1) $display("BNE PC USE: Not Working");
        if (choose_alternative_PC != `B_PC_Enable) $display("BNE PC CHOOSE: Not Working");
        if (ALU_Signal != `ALU_XOR) $display("BNE ALU: Not Working");

        // Testing BEQ
        opcode = 6'b000100;
        funct = 6'h08;
        #1

        if (use_alternative_PC != 1'b1) $display("BEQ PC USE: Not Working");
        if (choose_alternative_PC != `B_PC_Enable) $display("BEQ PC CHOOSE: Not Working");
        if (branch_equal != 1'b1) $display("BEQ BRANCH EQUAL: Not Working");
        if (ALU_Signal != `ALU_XOR) $display("BEQ ALU: Not Working");

        // Testing SW
        opcode = 6'b101011;
        funct = 6'h08;
        #1
        if (wr_en_memory != 1'b1) $display("SW WR EN MEMORY: Not Working");
        if (use_signextimm != 1'b1) $display("SW SIGN EXT IMM: Not Working");
        if (ALU_Signal != `ALU_ADD) $display("SW ALU: Not Working");

        // Testing LW
        opcode = 6'b100011;
        funct = 6'h08;
        #1
        if (write_to_rt != 1'b1) $display("LW WRITE TO RT: Not Working");
        if (write_from_memory_to_reg != 1'b1) $display("LW WRITE FROM MEMORY TO REG: Not Working");
        if (use_signextimm != 1'b1) $display("LW USE SIGN EXT IMM: Not Working");
        if (wr_en_reg != 1'b1) $display("LW Write: Not Working");
        if (ALU_Signal != `ALU_ADD) $display("LW ALU: Not Working");
        $finish();
    end

        
endmodule

