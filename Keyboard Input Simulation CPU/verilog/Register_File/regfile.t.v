//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire  	endtest;    	// Set High to signal test completion 
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData), 
    .ReadRegister1(ReadRegister1), 
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite), 
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10


  // Test Case 1: 
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1 Failed");
  end

  // Test Case 2: 
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  //   (Fails with example register file, but should pass with yours)
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
    dutpassed = 0;
    $display("Test Case 2 Failed");
  end

  // Test Case 3:
  //  Test if the write enable is broken/ignored.
  //  Attempt to write data to register 1 and register 2, verify with Read Port 1 and 2
  //  Fails if data actually gets written
  WriteRegister = 5'd2;
  WriteData = 32'd8;
  RegWrite = 0;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;
  if((ReadData1 == 8) || (ReadData2 == 8)) begin
    dutpassed = 0;
    $display("Write Enable Broken/Ignored");
  end

  // Test Case 4:
  //  Test if decoder is broken - all registers are written to.
  //  Write 8 to register 2, and read register 10, verify with Read Port 1 and 2
  WriteRegister = 5'd2;
  WriteData = 32'd8;
  RegWrite = 1;
  ReadRegister1 = 5'd10;
  ReadRegister2 = 5'd10;
  #5 Clk=1; #5 Clk=0;
  if((ReadData1 == 8) || (ReadData2 == 8)) begin
    dutpassed = 0;
    $display("Decoder Broken");
  end

  // Test Case 5:
  //  Test if register 0 is a register and not a constant value of 0.
  //  Attempt to write 8 to register 0, and read register 0, verify with Read Port 1 and 2
  WriteRegister = 5'd0;
  WriteData = 32'd8;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;
  if((ReadData1 !== 0) || (ReadData2 !== 0)) begin
    dutpassed = 0;
    $display("Decoder Broken");
  end

  // Test Case 6:
  //  Test if read ports are broken.
  //  Write different values on the first 5 registers (induction), read them and check that they are being written to/read correctly.
  WriteRegister = 5'd0;
  WriteData = 32'd0;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;
  if(ReadData1 !== 0) begin
    dutpassed = 0;
    $display("Port 1 Broken - 0");
  end
  if (ReadData2 !== 0) begin
    dutpassed = 0;
    $display("Port 2 Broken - 0");
  end

  WriteRegister = 5'd1;
  WriteData = 32'd1;
  RegWrite = 1;
  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0;
  if((ReadData1 !== 1) || (ReadData2 !== 1))begin
    dutpassed = 0;
    $display("Port 1 Broken - 1");
  end
  if (ReadData2 !== 1) begin
    dutpassed = 0;
    $display("Port 2 Broken - 1");
  end

  WriteRegister = 5'd2;
  WriteData = 32'd2;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;
  if(ReadData1 !== 2) begin
    dutpassed = 0;
    $display("Port 1 Broken - 2");
  end
  if (ReadData2 !== 2) begin
    dutpassed = 0;
    $display("Port 2 Broken - 2");
  end

  WriteRegister = 5'd3;
  WriteData = 32'd3;
  RegWrite = 1;
  ReadRegister1 = 5'd3;
  ReadRegister2 = 5'd3;
  #5 Clk=1; #5 Clk=0;
  if(ReadData1 !== 3) begin
    dutpassed = 0;
    $display("Port 1 Broken - 3");
  end
  if (ReadData2 !== 3) begin
    dutpassed = 0;
    $display("Port 2 Broken - 3");
  end

  WriteRegister = 5'd4;
  WriteData = 32'd4;
  RegWrite = 1;
  ReadRegister1 = 5'd4;
  ReadRegister2 = 5'd4;
  #5 Clk=1; #5 Clk=0;
  if(ReadData1 !== 4) begin
    dutpassed = 0;
    $display("Port 1 Broken - 4");
  end
  if (ReadData2 !== 4) begin
    dutpassed = 0;
    $display("Port 2 Broken - 4");
  end
  
// All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;
  
end



endmodule