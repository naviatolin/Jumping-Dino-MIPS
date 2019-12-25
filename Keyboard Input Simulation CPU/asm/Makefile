# Generate machine code memory image from MIPS assembly

# Get PROGRAM and *MEMDUMP from project settings
include ../settings.mk
ALLMEM := $(TEXTMEMDUMP) $(DATAMEMDUMP)

# MARS is pre-installed (/usr/local/bin/mars) on VM. Non-VM users should use
# MARS_PATH := java -jar path/to/Mars4_5.jar
MARS_PATH := java -jar /Users/pranaviboyalakuntla/Documents/Mars4.jar
MARS_OPTS := a  mc CompactTextAtZero
MARS      := $(MARS_PATH) $(MARS_OPTS)


# Pattern rule for generating .text memory dump from MIPS assembly
%.text.hex: %.asm
	$(MARS) dump .text HexText $@  $<

# Pattern rule for generating .data memory dump from MIPS assembly
%.data.hex: %.asm
	$(MARS) dump .data HexText $@  $<


# Shortcut (phony) targets for convenience
assemble: $(ALLMEM)

clean:
	-rm -f $(ALLMEM)


.PHONY: assemble clean