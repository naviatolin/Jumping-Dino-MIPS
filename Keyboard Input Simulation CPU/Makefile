include settings.mk

GTKWAVE := gtkwave
SIM     := vvp

# Final waveform to produce is the combination of machine and program
WAVEFORM := $(TOPLEVEL)-$(PROGRAM).vcd
WAVEOPTS := filters/$(WAVEFORM:vcd=gtkw)


# Build memory images, compile Verilog, run simulation to produce VCD trace
$(WAVEFORM): settings.mk
	$(MAKE) -C asm $(TEXTMEMDUMP) $(DATAMEMDUMP)
	$(MAKE) -C verilog $(TOPLEVEL).vvp
	$(SIM) verilog/$(TOPLEVEL).vvp +mem_text_fn=asm/$(TEXTMEMDUMP) \
                                       +mem_data_fn=asm/$(DATAMEMDUMP) \
                                       +dump_fn=$@


# Open waveform with saved formatting and filter options
scope: $(WAVEFORM) $(WAVEOPTS)
	$(GTKWAVE) $(WAVEOPTS)


# Remove generated files, including from subdirectories
clean: 
	$(MAKE) -C asm clean
	$(MAKE) -C verilog clean
	rm -f $(WAVEFORM)
.PHONY: scope clean