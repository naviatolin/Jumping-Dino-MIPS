`timescale 1 ns / 1 ps

`define NOT not #10
`define AND and #30
`define OR or #30
`define XOR xor #30

module two21Mux
(
    output res,
    input in0,
    input in1,
    input s0
);
    // takes in 2 inputs and spits out 1 output
    wire ns0;
    wire out0;
    wire out1;

    not #10 notgate0(ns0,s0);

    and #30 andgate0(out0,in0,ns0);
    and #30 andgate1(out1,in1,s0);

    or #30 orgate0(res,out0,out1);
endmodule


module FullAdder         //MOdule for a full adder
(
    output sum,
    output carryout,
    input a,
    input b,
    input carryin
);
	//Full adder for 1 bit operations
	
	wire out0;
	wire out1;
	wire out2;

	xor #20 xorgate0(out0,a,b);
	xor #20 xorgate1(sum,carryin,out0);

	and #30 andgate0(out1,out0,carryin);
	and #30 andgate1(out2,a,b);

	or #30 orgate0(carryout,out2,out1);

endmodule

module FullAdder32bit
(
	output signed[31:0] sum,
	output carryout,
	output overflow,
	input signed [31:0] a,
	input signed [31:0] b,
	input carryin
);

	wire[30:0] cout;
	
	FullAdder add0(sum[0],cout[0],a[0],b[0],carryin);
	FullAdder add1(sum[1],cout[1],a[1],b[1],cout[0]);
	FullAdder add2(sum[2],cout[2],a[2],b[2],cout[1]);
	FullAdder add3(sum[3],cout[3],a[3],b[3],cout[2]);
	FullAdder add4(sum[4],cout[4],a[4],b[4],cout[3]);
	FullAdder add5(sum[5],cout[5],a[5],b[5],cout[4]);
	FullAdder add6(sum[6],cout[6],a[6],b[6],cout[5]);
	FullAdder add7(sum[7],cout[7],a[7],b[7],cout[6]);
	FullAdder add8(sum[8],cout[8],a[8],b[8],cout[7]);
	FullAdder add9(sum[9],cout[9],a[9],b[9],cout[8]);
	FullAdder add10(sum[10],cout[10],a[10],b[10],cout[9]);
	FullAdder add11(sum[11],cout[11],a[11],b[11],cout[10]);
	FullAdder add12(sum[12],cout[12],a[12],b[12],cout[11]);
	FullAdder add13(sum[13],cout[13],a[13],b[13],cout[12]);
	FullAdder add14(sum[14],cout[14],a[14],b[14],cout[13]);
	FullAdder add15(sum[15],cout[15],a[15],b[15],cout[14]);
	FullAdder add16(sum[16],cout[16],a[16],b[16],cout[15]);
	FullAdder add17(sum[17],cout[17],a[17],b[17],cout[16]);
	FullAdder add18(sum[18],cout[18],a[18],b[18],cout[17]);
	FullAdder add19(sum[19],cout[19],a[19],b[19],cout[18]);
	FullAdder add20(sum[20],cout[20],a[20],b[20],cout[19]);
	FullAdder add21(sum[21],cout[21],a[21],b[21],cout[20]);
	FullAdder add22(sum[22],cout[22],a[22],b[22],cout[21]);
	FullAdder add23(sum[23],cout[23],a[23],b[23],cout[22]);
	FullAdder add24(sum[24],cout[24],a[24],b[24],cout[23]);
	FullAdder add25(sum[25],cout[25],a[25],b[25],cout[24]);
	FullAdder add26(sum[26],cout[26],a[26],b[26],cout[25]);
	FullAdder add27(sum[27],cout[27],a[27],b[27],cout[26]);
	FullAdder add28(sum[28],cout[28],a[28],b[28],cout[27]);
	FullAdder add29(sum[29],cout[29],a[29],b[29],cout[28]);
	FullAdder add30(sum[30],cout[30],a[30],b[30],cout[29]);
	FullAdder add31(sum[31],carryout,a[31],b[31],cout[30]);
	
	or #20 orgate(overflow,carryout,0);

endmodule


module FullAdderSubtractor32bit
(
	output signed[31:0] sum,
	output carryout,
	output overflow,
	input signed [31:0] a,
	input signed [31:0] b,
	input carryin,
	input sltFlag
);
	//This module is able to add and subtract any 32-bit signed number
	//Inputs: signed a,b & carryin,sltFlag
	//Outputs: signed sum & carryout,overflow
	
	//Instantiate variables to hold values
	wire[30:0] cout;
	wire[31:0] bpost;
	wire[31:0] sumHolder; //hold sum since sltFlag demands a 1 or 0
	wire carryoutHolder;

	xor #640 maybeflip[31:0](bpost,b,carryin);//carryin is selective invert

	FullAdder add0(sumHolder[0],cout[0],a[0],bpost[0],carryin);
	FullAdder add1(sumHolder[1],cout[1],a[1],bpost[1],cout[0]);
	FullAdder add2(sumHolder[2],cout[2],a[2],bpost[2],cout[1]);
	FullAdder add3(sumHolder[3],cout[3],a[3],bpost[3],cout[2]);
	FullAdder add4(sumHolder[4],cout[4],a[4],bpost[4],cout[3]);
	FullAdder add5(sumHolder[5],cout[5],a[5],bpost[5],cout[4]);
	FullAdder add6(sumHolder[6],cout[6],a[6],bpost[6],cout[5]);
	FullAdder add7(sumHolder[7],cout[7],a[7],bpost[7],cout[6]);
	FullAdder add8(sumHolder[8],cout[8],a[8],bpost[8],cout[7]);
	FullAdder add9(sumHolder[9],cout[9],a[9],bpost[9],cout[8]);
	FullAdder add10(sumHolder[10],cout[10],a[10],bpost[10],cout[9]);
	FullAdder add11(sumHolder[11],cout[11],a[11],bpost[11],cout[10]);
	FullAdder add12(sumHolder[12],cout[12],a[12],bpost[12],cout[11]);
	FullAdder add13(sumHolder[13],cout[13],a[13],bpost[13],cout[12]);
	FullAdder add14(sumHolder[14],cout[14],a[14],bpost[14],cout[13]);
	FullAdder add15(sumHolder[15],cout[15],a[15],bpost[15],cout[14]);
	FullAdder add16(sumHolder[16],cout[16],a[16],bpost[16],cout[15]);
	FullAdder add17(sumHolder[17],cout[17],a[17],bpost[17],cout[16]);
	FullAdder add18(sumHolder[18],cout[18],a[18],bpost[18],cout[17]);
	FullAdder add19(sumHolder[19],cout[19],a[19],bpost[19],cout[18]);
	FullAdder add20(sumHolder[20],cout[20],a[20],bpost[20],cout[19]);
	FullAdder add21(sumHolder[21],cout[21],a[21],bpost[21],cout[20]);
	FullAdder add22(sumHolder[22],cout[22],a[22],bpost[22],cout[21]);
	FullAdder add23(sumHolder[23],cout[23],a[23],bpost[23],cout[22]);
	FullAdder add24(sumHolder[24],cout[24],a[24],bpost[24],cout[23]);
	FullAdder add25(sumHolder[25],cout[25],a[25],bpost[25],cout[24]);
	FullAdder add26(sumHolder[26],cout[26],a[26],bpost[26],cout[25]);
	FullAdder add27(sumHolder[27],cout[27],a[27],bpost[27],cout[26]);
	FullAdder add28(sumHolder[28],cout[28],a[28],bpost[28],cout[27]);
	FullAdder add29(sumHolder[29],cout[29],a[29],bpost[29],cout[28]);
	FullAdder add30(sumHolder[30],carryoutHolder,a[30],bpost[30],cout[29]);//most sig bit for 32-bit signed ader
	FullAdder add31(sumHolder[31],cout[30],a[31],bpost[31],carryoutHolder);
	// Sum is complete here

	wire exnoroutput;
	wire xoroutput;
	
	wire exnorHolder;
	
	//computer overflow.
	xor #20 xorgate0(exnorHolder,a[31],bpost[31]);
	not #10 nope0(exnoroutput,exnorHolder);

	xor #20 xorgate1(xoroutput,bpost[31],sumHolder[31]);

	and #30 andgate0(overflow,exnoroutput,xoroutput);
	
	//if not SLT - pass through sum
	two21Mux mux00(carryout,carryoutHolder,1'd0,sltFlag);
	two21Mux mux0(sum[0],sumHolder[0],sumHolder[31],sltFlag);

	generate
	genvar i;
	for(i=1;i<32;i=i+1)begin
		two21Mux muxes(sum[i],
			       sumHolder[i],
			       1'b0,
			       sltFlag);
	end
	endgenerate

endmodule