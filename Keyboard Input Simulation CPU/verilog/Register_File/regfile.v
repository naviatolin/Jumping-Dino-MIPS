//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------
`include "Register_File/register.v"
`include "Register_File/decoder.v"

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);
  wire [31:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31;
  wire[31:0] select_register;

  decoder1to32 decoder_0(select_register, RegWrite, WriteRegister);

  register32zero writing_information0(reg0, WriteData, select_register[0], Clk);
  register32 writing_information1(reg1, WriteData, select_register[1], Clk);
  register32 writing_information2(reg2, WriteData, select_register[2], Clk);
  register32 writing_information3(reg3, WriteData, select_register[3], Clk);
  register32 writing_information4(reg4, WriteData, select_register[4], Clk);
  register32 writing_information5(reg5, WriteData, select_register[5], Clk);
  register32 writing_information6(reg6, WriteData, select_register[6], Clk);
  register32 writing_information7(reg7, WriteData, select_register[7], Clk);
  register32 writing_information8(reg8, WriteData, select_register[8], Clk);
  register32 writing_information9(reg9, WriteData, select_register[9], Clk);
  register32 writing_information10(reg10, WriteData, select_register[10], Clk);
  register32 writing_information11(reg11, WriteData, select_register[11], Clk);
  register32 writing_information12(reg12, WriteData, select_register[12], Clk);
  register32 writing_information13(reg13, WriteData, select_register[13], Clk);
  register32 writing_information14(reg14, WriteData, select_register[14], Clk);
  register32 writing_information15(reg15, WriteData, select_register[15], Clk);
  register32 writing_information16(reg16, WriteData, select_register[16], Clk);
  register32 writing_information17(reg17, WriteData, select_register[17], Clk);
  register32 writing_information18(reg18, WriteData, select_register[18], Clk);
  register32 writing_information19(reg19, WriteData, select_register[19], Clk);
  register32 writing_information20(reg20, WriteData, select_register[20], Clk);
  register32 writing_information21(reg21, WriteData, select_register[21], Clk);
  register32 writing_information22(reg22, WriteData, select_register[22], Clk);
  register32 writing_information23(reg23, WriteData, select_register[23], Clk);
  register32 writing_information24(reg24, WriteData, select_register[24], Clk);
  register32 writing_information25(reg25, WriteData, select_register[25], Clk);
  register32 writing_information26(reg26, WriteData, select_register[26], Clk);
  register32 writing_information27(reg27, WriteData, select_register[27], Clk);
  register32 writing_information28(reg28, WriteData, select_register[28], Clk);
  register32 writing_information29(reg29, WriteData, select_register[29], Clk);
  register32 writing_information30(reg30, WriteData, select_register[30], Clk);
  register32 writing_information31(reg31, WriteData, select_register[31], Clk);
  
  mux32to1by32 reading_reg1(ReadData1, ReadRegister1, reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31);
  
  mux32to1by32 reading_reg2(ReadData2, ReadRegister2, reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31);
endmodule