# Project-specific settings

## Assembly settings

# Assembly program (minus .asm extension)
#PROGRAM := array_loop
PROGRAM := interrupt
# Possible Program Options
#PROGRAM := ALU
#PROGRAM := Jumps_LW_SW
#PROGEAM := BEQ_BNE

# Memory image(s) to create from the assembly program
TEXTMEMDUMP := $(PROGRAM).text.hex
DATAMEMDUMP := $(PROGRAM).data.hex


## Verilog settings

# Top-level module/filename (minus .v/.t.v extension)
TOPLEVEL := cpu

# All circuits included by the toplevel $(TOPLEVEL).t.v
CIRCUITS := $(TOPLEVEL).v Addresses_and_Immediates/branchaddr.v Addresses_and_Immediates/jumpaddr.v Addresses_and_Immediates/signextimm.v ALU/alu.v Instruction_Decoder_and_FSM/fsm.v Instruction_Decoder_and_FSM/instructiondecoder.v Memory/memory.v Program_Counter/PC.v Register_File/regfile.v