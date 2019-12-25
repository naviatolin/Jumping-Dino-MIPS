`include "cpu.v"

module cpu_test ();
	reg clk;
	reg reset;
	
	CPU cpu(.clk(clk),
			.reset(reset));

	// Generate (infinite) clock
	initial clk=0;
	always #10 clk = !clk;

	reg [1023:0] mem_text_fn;
    reg [1023:0] mem_data_fn;
    reg [1023:0] dump_fn;
    reg init_data = 1;      // Initializing .data segment is optional

	initial begin
		// Get command line arguments for memory image(s) and VCD dump file
		//   http://iverilog.wikia.com/wiki/Simulation
		//   http://www.project-veripage.com/plusarg.php
		if (! $value$plusargs("mem_text_fn=%s", mem_text_fn)) begin
			$display("ERROR: provide +mem_text_fn=[path to .text memory image] argument");
			$finish();
			end
		if (! $value$plusargs("mem_data_fn=%s", mem_data_fn)) begin
			$display("INFO: +mem_data_fn=[path to .data memory image] argument not provided; data memory segment uninitialized");
			init_data = 0;
			end

		if (! $value$plusargs("dump_fn=%s", dump_fn)) begin
			$display("ERROR: provide +dump_fn=[path for VCD dump] argument");
			$finish();
			end

		$readmemh(mem_text_fn, cpu.MEMORY.mem, 0);
        if (init_data) begin
	    $readmemh(mem_data_fn, cpu.MEMORY.mem, 2048);
        end

		reset = 0; #10;
		reset = 1; #10;
		reset = 0; #10;

		$display("... more execution (see waveform)");
		$display("Reg 0 %d", cpu.regfile.reg0);
		$display("Reg 1 %d ", cpu.regfile.reg1);
		$display("Reg 2 %d ", cpu.regfile.reg2);
		$display("Reg 3 %d ", cpu.regfile.reg3);
		$display("Reg 4 %d ", cpu.regfile.reg4);
		$display("Reg 5 %d ", cpu.regfile.reg5);
		$display("Reg 6 %d ", cpu.regfile.reg6);
		$display("Reg 7 %d ", cpu.regfile.reg7);
		$display("Reg 8 %d ", cpu.regfile.reg8);
		$display("Reg 9 %d ", cpu.regfile.reg9);
		$display("Reg 10 %d", cpu.regfile.reg10);
		$display("Reg 11 %d", cpu.regfile.reg11);
		$display("Reg 12 %d", cpu.regfile.reg12);
		$display("Reg 13 %d", cpu.regfile.reg13);
		$display("Reg 14 %d", cpu.regfile.reg14);
		$display("Reg 15 %d", cpu.regfile.reg15);
		$display("Reg 16 %d", cpu.regfile.reg16);
		$display("Reg 17 %d", cpu.regfile.reg17);
		$display("Reg 18 %d", cpu.regfile.reg18);
		$display("Reg 19 %d", cpu.regfile.reg19);
		$display("Reg 20 %d", cpu.regfile.reg20);
		$display("Reg 21 %d", cpu.regfile.reg21);
		$display("Reg 22 %d", cpu.regfile.reg22);
		$display("Reg 23 %d", cpu.regfile.reg23);
		$display("Reg 24 %d", cpu.regfile.reg24);
		$display("Reg 25 %d", cpu.regfile.reg25);
		$display("Reg 26 %d", cpu.regfile.reg26);
		$display("Reg 27 %d", cpu.regfile.reg27);
		$display("Reg 28 %d", cpu.regfile.reg28);
		$display("Reg 29 %d", cpu.regfile.reg29);
		$display("Reg 30 %d", cpu.regfile.reg30);
		$display("Reg 31 %d", cpu.regfile.reg31);

		repeat(17) begin
		$display("Time | PC | Instruction");
        $display("%4t | %2d | %h", $time, cpu.PC, cpu.instruction);
		#20;
        end
		if (mem_text_fn == 129534444256447587310217023988318102904) begin
			if (cpu.regfile.reg16 != 5) $display("Reg16 Error");
			if (cpu.regfile.reg17 != 5) $display("Reg17 Error");
			if (cpu.regfile.reg18 != 0) $display("Reg18 Error");
			if (cpu.regfile.reg19 != 10) $display("Reg19 Error");
			if (cpu.regfile.reg20 != 0) $display("Reg20 Error");
			if (cpu.regfile.reg21 != 0) $display("Reg21 Error");
		end
		
		if (mem_text_fn == 2389488741981182158142411817404794647713652509958361081208) begin
			if (cpu.regfile.reg16 != 5) $display("Reg16 Error");
			if (cpu.regfile.reg17 != 5) $display("Reg17 Error");
			if (cpu.regfile.reg18 != 25) $display("Reg18 Error");
			if (cpu.regfile.reg20 != 0) $display("Reg20 Error");
			if (cpu.regfile.reg25 != 20) $display("Reg25 Error");
			if (cpu.regfile.reg31 != 16) $display("Reg21 Error");
		end
		
		if (mem_text_fn == 556346201788270229290301147452210784511279523192) begin
			if (cpu.regfile.reg16 != 5) $display("Reg16 Error");
			if (cpu.regfile.reg17 != 5) $display("Reg17 Error");
			if (cpu.regfile.reg18 != 10) $display("Reg18 Error");
			if (cpu.regfile.reg19 != 0) $display("Reg19 Error");
			if (cpu.regfile.reg20 != 0) $display("Reg20 Error");
		end
		#1 $finish();
	end
endmodule
