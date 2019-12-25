/*----------------------------------------------------------------------------
 Unified instruction/data memory for CPU
   - Reads are combinational/instantaneous
   - Writes occur on rising edge of clock
   - Reads/write data are 32-bit (4 byte) words
   - Addresses (PC and data_addr) should be aligned to 32-bit words
     (i.e. the two LSB should be zero)
   - Simulated memory size is 16KiB (rather than the maximum addressible
     2^32 bytes), so the upper 18 bits of the addresses must be zero
----------------------------------------------------------------------------*/

module memory
(
    // Read port for instructions
    input  [31:0]  PC,        // Program counter (instruction address)
    output [31:0]  instruction,
    
    // Read/write port for data 
    output [31:0]  data_out,
    input  [31:0]  data_in,
    input  [31:0]  data_addr,
    input          clk,
    input          wr_en 
);

    // 16KiB memory, organized as 4096 element array of 32-bit words
    reg [31:0] mem [4095:0];

    // initial begin
    //     // $display("Loading Memory");
    //     $readmemh("../asm/addi.text.hex", mem);
    // end

    // initial begin
    //     // $display("Loading Memory");
    //     $readmemb("Memory/mem.mem", mem);
    // end

    // Alternative: 16KiB memory, organized as 16384 element array of bytes
    //   This is closer to the physical implementation but makes the Verilog
    //   messier since you need to access multiple bytes at once.
    // reg [7:0] mem [2**14-1:0];


    // Simplified memory "read ports"
    assign instruction = mem[ PC[13:2] ];
    assign data_out = mem[ data_addr[13:2] ];
    // Note: Discards the low 2 bits of the address (which should be zero)
    // since we implemented the memory as an array of words instead of bytes.
    // Discards upper 18 bits of address (which should be zero) because memory
    // is only 16 KiB (smaller than maximum addressible 2^32 bytes).

    // Data write port
    always @(posedge clk) begin
        if (wr_en) begin
            mem[ data_addr[13:2] ] = data_in;
        end
    end

    // Non-synthesizable debugging code for checking assertions about addresses
    always @(posedge clk) begin
        if ((| data_addr[1:0]) && wr_en) begin    // Lower address bits != 00
        $display("Warning: misaligned data_addr access, truncating: %h", data_addr);
    end
    if ((| data_addr[31:14]) && (wr_en)) begin  // Upper address bits non-zero
        $display("Error: data_addr outside implemented memory range: %h", data_addr);
        $stop();
    end
    end

    always @(posedge clk) begin
        if ((| PC[1:0]) && wr_en) begin    // Lower PC bits != 00
        $display("Warning: misaligned PC access, truncating: %h", PC);
    end
    if ((| PC[31:14]) && (wr_en)) begin  // Upper PC bits non-zero
        $display("Error: PC outside implemented memory range: %h", PC);
        $stop();
    end
    end

endmodule
