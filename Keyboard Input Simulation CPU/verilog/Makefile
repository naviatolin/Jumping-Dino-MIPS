# Verilog compilation Makefile example

# Get TOPLEVEL and CIRCUITS variables from project settings
include ../settings.mk

ICARUS_OPTS := -Wall
IVERILOG    := iverilog $(ICARUS_OPTS)
LINT        := verilator --lint-only
SIM         := vvp


# Pattern rule for compiling vvp (Icarus assembly) from a testbench
%.vvp: %.t.v $(CIRCUITS)
	$(IVERILOG) -o $@ $<


# Shortcut (phony) targets for convenience
compile: $(TOPLEVEL).vvp

clean:
	-rm -f $(TOPLEVEL).vvp

.PHONY: compile clean