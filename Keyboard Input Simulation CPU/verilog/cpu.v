`include "ALU/alu.v"
`include "Addresses_and_Immediates/signextimm.v"
`include "Addresses_and_Immediates/branchaddr.v"
`include "Addresses_and_Immediates/jumpaddr.v"
`include "Instruction_Decoder_and_FSM/instructiondecoder.v"
`include "Instruction_Decoder_and_FSM/fsm.v"
`include "Memory/memory.v"
`include "Program_Counter/PC.v"
`include "Register_File/regfile.v"

`define JR_PC_ENABLE 3'd3
`define J_JAL_PC_ENABLE 3'd2
`define B_PC_Enable 3'd1

module CPU(
    input clk,
    input reset
);
    /* -------------------------------------------------------------------------- */
    /*         defining the wires and registers and instantiating modules         */
    /* -------------------------------------------------------------------------- */

    /* ------------------------------- definitions ------------------------------ */
    // PC definitions
    wire [31:0] PC; // needs to be wired into the memory such that the instruction comes from memory
    reg [31:0] PC_Last;
    reg [31:0] alternative_PC;
    wire [2:0] ALU_Signal;
    reg really_use_alternative_PC;

    // fsm definitions
    wire [1:0] choose_alternative_PC; 
    wire wr_en_reg;
    wire write_from_memory_to_reg;
    wire write_reg_31;
    wire write_pc8_to_reg;
    wire use_alternative_PC; // used in pc
    wire use_signextimm;
    wire use_zerosignextimm;
    wire wr_en_memory;
    wire write_to_rt;
    wire branch_equal;

    // memory definitions
    wire [31:0]  data_out;
    wire [31:0] instruction;
    
    // instruction decode definitions
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [5:0] funct;
    wire [15:0] immediate;
    wire [25:0] address;

    // creating constants definitions
    wire [31:0] signextimm;
    wire [31:0] branch_addr;
    wire [31:0] jump_addr;
    wire [31:0] zerosignextimm;

    // alu definitions
    reg [31:0] second_register;
    wire [31:0]	ReadData1;
    wire [31:0] ALU_result;
    
    // regfile definitions
    wire [31:0]	ReadData2;
    reg [4:0] ReadRegister2;
    reg [4:0] WriteRegister;
    reg [31:0] WriteData;

    // intermediate definitions
    reg [31:0] pc8_or_alu;
    reg [31:0] counter;
    reg interrupt_enable;
    reg reset_interrupt_enable;

    /* ----------------------------- program counter ---------------------------- */

    PC pc(
        .PC(PC), // is connected to PC in MEMORY
        .PC_last(PC_Last), // connected to PC
        .alternative_PC(alternative_PC), // connected to MUX below
        .use_alternative_PC(really_use_alternative_PC), // connected in mux below
        .clk(clk), // no need to be connected
        .reset(reset) // no need to be connected
    );

    /* --------------------------------- memory --------------------------------- */

    memory MEMORY(
        .PC(PC), // is connected to PC in pc
        .instruction(instruction), // connected to instruction decoder
        .data_out(data_out), // connected to mux
        .data_in(ReadData2), // connected to regfile
        .data_addr(ALU_result), // connected to ALU
        .clk(clk), // no need to be connected
        .wr_en(wr_en_memory) // connected to fsm
    );

    /* --------------------------- instruction decoder -------------------------- */

    instructionDecoder INSTRUCTIONDECODER(
        .opcode(opcode), // connected to fsm
        .rs(rs), // connected to regfile & mux
        .rt(rt), // connected to mux
        .rd(rd), // connected to mux
        .shamt(shamt), // no need to be connected
        .funct(funct), // connected to fsm
        .immediate(immediate), // connected to signextimm and branchaddr
        .address(address), // connected to jump addr
        .instruction(instruction) // connected to memory
    );

    /* ----------------------------------- fsm ---------------------------------- */
    FSM FSM(
        .wr_en_reg(wr_en_reg), // connected to regfile
        .ALU_Signal(ALU_Signal), // connected to ALU
        .write_from_memory_to_reg(write_from_memory_to_reg), // used as control signal in mux
        .write_reg_31(write_reg_31), // used as control signal in mux
        .write_pc8_to_reg(write_pc8_to_reg), // used as control signal in mux
        .use_alternative_PC(use_alternative_PC), // used to set really_use_alternative_PC
        .choose_alternative_PC(choose_alternative_PC), // used in case switch
        .use_signextimm(use_signextimm), // used in signextimm mux
        .use_zerosignextimm(use_zerosignextimm),
        .wr_en_memory(wr_en_memory), // connected to memory
        .write_to_rt(write_to_rt), // used in muxes 
        .branch_equal(branch_equal),
        .opcode(opcode), // connected to instruction decoder
        .funct(funct) // connected to instruction decoder
    );

    /* ----------------------------------- alu ---------------------------------- */
    ALU ALU(
        .result(ALU_result), // connected to memory and mux
        .operandA(ReadData1), // connected to regfile
        .operandB(second_register), // connected to mux
        .clk(clk),
        .command(ALU_Signal) // connected to fsm
    );

    /* --------------------------------- regfile -------------------------------- */
    regfile regfile(
        .ReadData1(ReadData1), // connected to case switch and alu
        .ReadData2(ReadData2), // connected to mux
        .WriteData(WriteData), // connected to muxes
        .ReadRegister1(rs), // connected to instruction decoder
        .ReadRegister2(ReadRegister2), // connected to muxes
        .WriteRegister(WriteRegister), // connected to muxes
        .RegWrite(wr_en_reg), // connected to fsm
        .Clk(clk) // no need to be connected
    );

    /* ------------------------------- signextimm ------------------------------- */
    signextend SIGNEXTEND(
        .signextimm(signextimm), // connected to mux
        .immediate(immediate) // connected to instruction decoder
    );

    /* ------------------------------- branchaddr ------------------------------- */
    branchAddress BRANCHADDRESS(
        .branch_addr(branch_addr), // connected to case statement
        .immediate(immediate) // connected to intruction decoder
    );

    /* -------------------------------- jumpaddr -------------------------------- */
    jumpAddress JUMPADDRESS(
        .jump_addr(jump_addr), // connected to case statement
        .address(address), // connected to instruction decoder
        .PC(PC) // connected to PC
    );

    /* ----------------------------- zerosignextimm ----------------------------- */
    zerosignextend ZEROSIGNEXTEND(
        .zerosignextimm(zerosignextimm),
        .immediate(immediate)
    );
    /* -------------------------------------------------------------------------- */
    /*                          Setting All The Muxes Up                          */
    /* -------------------------------------------------------------------------- */
    // deciding which registers to read and write from
    always @(negedge clk) begin
        if (really_use_alternative_PC == 1'b1) PC_Last = alternative_PC;
        else PC_Last = PC;
        $display("Interrupt Enable:", interrupt_enable);
        
    end
    always @(negedge clk, posedge clk) begin
        if (PC == 32'd36) begin
            // setting the interrupt enable for this cpu
            if (ReadData1 != 0 | ReadData1 != 77) begin
                interrupt_enable <= 1'b1;
            end
        end
        if (interrupt_enable == 1) begin
            if (ReadData2 == 1) begin
                alternative_PC <= 32'b0;
                really_use_alternative_PC <= 1'b1;
                PC_Last <= 32'b0;
                reset_interrupt_enable <= 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset_interrupt_enable == 1) begin
            reset_interrupt_enable <= 1'b0;
            really_use_alternative_PC <= 1'b0;
            interrupt_enable <=1'b0;
        end
    end

    // "write pc8 to reg" mux and "load word data?" mux
    always @(posedge clk, negedge clk, write_pc8_to_reg, ALU_result) begin
        if (write_pc8_to_reg == 1) begin
            pc8_or_alu <= PC + 32'd4;
        end
        else begin
            pc8_or_alu <= ALU_result;
        end
    end

    always @(posedge clk, negedge clk, write_from_memory_to_reg, data_out, pc8_or_alu) begin
        if (write_from_memory_to_reg) begin
            WriteData <= data_out;
        end
        else begin
            WriteData <= pc8_or_alu;
        end
    end

    // "Rs again [1] or Rt [0] for read register 2" mux and "Write to Rt [1] or Rd [0]?" combined mux
    // , write_to_rt, rs, write_reg_31, rt, rd
    always @(posedge clk, negedge clk, write_to_rt) begin
        if (write_to_rt) begin
            ReadRegister2 <= rs;
            if (write_reg_31 == 1) begin
                WriteRegister <= 32'd31;
            end
            else begin
                WriteRegister <= rt;
            end
        end
        else begin
            ReadRegister2 <= rt;
            if (write_reg_31 == 1) begin
                WriteRegister <= 32'd31;
            end
            else WriteRegister <= rd;
        end
    end

    // signextimm mux
    always @(posedge clk, negedge clk, use_signextimm, ReadData2) begin
        if (use_signextimm == 1) begin
            second_register <= signextimm;
        end
        else begin
            second_register <= ReadData2;
        end
    end

    // signextimm mux
    always @(posedge clk, negedge clk, use_zerosignextimm, ReadData2) begin
        if (use_zerosignextimm == 1) begin
            second_register <= zerosignextimm;
        end
        else begin
            second_register <= ReadData2;
        end
    end

    // choose alternate PC mux
    always @(posedge clk, negedge clk) begin
        case(choose_alternative_PC)
            `JR_PC_ENABLE: begin
                alternative_PC <= ReadData1;
                really_use_alternative_PC <= 1'b1;

            end

            `J_JAL_PC_ENABLE: begin
                alternative_PC <= jump_addr;
                really_use_alternative_PC <= 1'b1;
            end
            `B_PC_Enable: begin
                    case(branch_equal)
                        1'b1: begin
                            if (ALU_result == 32'b0) begin
                                alternative_PC <= PC + branch_addr + 32'd4;
                                PC_Last <= PC + branch_addr - 32'd4;
                                really_use_alternative_PC <= 1'b1;
                            end
                            else begin
                                alternative_PC <= PC_Last;
                                really_use_alternative_PC <= 1'b0;
                            end
                        end
                       1'b0: begin
                            if (counter == 32'b0) begin
                                alternative_PC <= PC_Last;
                                really_use_alternative_PC <= 1'b0;
                            end
                            else if (counter != 32'b0) begin
                                alternative_PC <= PC + branch_addr;
                                PC_Last <= PC + branch_addr - 32'd4;
                                really_use_alternative_PC <= 1'b1;
                            end
                        end
                    endcase
            end
            2'b0: begin
                alternative_PC <= 32'b0;
                really_use_alternative_PC <= 1'b0;
            end
        endcase
    end

    always @(negedge clk) begin
        counter <= ALU_result;
    end
              
endmodule