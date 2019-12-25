// ALU from previous labs
`timescale 1 ns / 1 ps

`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7


`include "addsub.v" 
`include "ornor.v" 
`include "and-nand.v" 
`include "xor.v" 




module isZero32bit(
    output result,
    input[31:0] in
);
    wire[15:0] holder;
    wire[7:0] secondHolder;
    wire[3:0] thirdHolder;
    wire[1:0] fourthHolder;
    
    generate //first one here takes reduces from 32 -> 16 
	    genvar i;
	    for(i=0;i<16;i=i+1)begin
		    nor #30 norset0(holder[i],in[i*2],in[i*2+1]);
	    end
    endgenerate

    generate //second takes it from 16 -> 8
	    genvar j;
	    for(j=0;j<8;j=j+1)begin
		    and #30 andset1(secondHolder[j],holder[j*2],holder[2*j+1]);
	    end
    endgenerate

    generate //third takes it from 8 -> 4
	    genvar k;
	    for(k=0;k<4;k=k+1)begin
		    and #30 andset2(thirdHolder[k],secondHolder[k*2],secondHolder[2*k+1]);
	    end
    endgenerate

    generate //second takes it from 4 -> 2
	    genvar m;
	    for(m=0;m<2;m=m+1)begin
		    and #30 andset3(fourthHolder[m],thirdHolder[m*2],thirdHolder[2*m+1]);
	    end
    endgenerate

    and #30 lastandgate(result,fourthHolder[0],fourthHolder[1]);
endmodule

module one24Mux
(
    output out0, out1, out2, out3,
    input address0, address1, enable
);
    wire ninvA;
    wire ninvB;
    not #10 Ainv(ninvA,address0);
    not #10 Binv(ninvB,address1);
    and #30 andgate0(out0,ninvA,ninvB,enable);
    and #30 andgate1(out1,ninvB,address0,enable);
    and #30 andgate2(out2,ninvA,address1,enable);
    and #30 andgate3(out3,address0,address1,enable);

endmodule


module four21Mux 
( 
    output out, 
    input s0, s1, 
    input in0, in1, in2, in3 
); 
    wire ns0; 
    wire ns1; 
    wire and0; 
    wire and1; 
    wire and2; 
    wire and3; 
    not #10 nope0(ns0,s0); 
    not #10 nope1(ns1,s1); 
    and #30 andgate0(and0,in0,ns0,ns1); 
    and #30 andgate1(and1,in1,s0,ns1); 
    and #30 andgate2(and2,in2,ns0,s1); 
    and #30 andgate3(and3,in3,s0,s1); 
    or  #30 orgate(out,and0,and1,and2,and3); 
       
endmodule


module ALUcontrolLUT
(
output reg[1:0]  functionSelect,
output reg       invert,
output reg       ifSLT,
input[2:0]       ALUcommand
);

  always @(ALUcommand) begin
    case (ALUcommand)
      3'd0:  begin functionSelect =2'd0; invert=0; ifSLT = 0; end
      3'd1:  begin functionSelect =2'd0; invert=1; ifSLT = 0; end
      3'd2:  begin functionSelect =2'd1; invert=0; ifSLT = 0; end
      3'd3:  begin functionSelect =2'd0; invert=1; ifSLT = 1; end
      3'd4:  begin functionSelect =2'd2; invert=0; ifSLT = 0; end
      3'd5:  begin functionSelect =2'd2; invert=1; ifSLT = 0; end
      3'd6:  begin functionSelect =2'd3; invert=1; ifSLT = 0; end
      3'd7:  begin functionSelect =2'd3; invert=0; ifSLT = 0; end
    endcase
  end
endmodule



module ALU32bit
(
output[31:0]  result,
output        carryout,
output        zero,
output        overflow,
input[31:0]   operandA,
input[31:0]   operandB,
input[2:0]    command
);
	
	wire[1:0] functionSelect;
	wire invert;
	wire ifSLT;
	
	wire[31:0] addSubHolder;
	wire[31:0] xorHolder;
	wire[31:0] andNandHolder;
	wire[31:0] ornorHolder;
	wire carryoutHolder;
	wire overflowHolder;
	

	// Control module for MUXs later
	ALUcontrolLUT con(.functionSelect(functionSelect),
			  .invert(invert),
			  .ifSLT(ifSLT),
			  .ALUcommand(command));
	
	// All of the processes run in parrallel 
	// Not good for energy but good for first pass
	FullAdderSubtractor32bit adder(.sum(addSubHolder),
				   .carryout(carryoutHolder),
				   .overflow(overflowHolder),
				   .a(operandA),
				   .b(operandB),
				   .carryin(invert),
			   	   .sltFlag(ifSLT));

	XOR32bit largexorgate(.result(xorHolder),
			 .operandA(operandA),
			 .operandB(operandB));

	AndNand32bit largeandgate(.result(andNandHolder),
				  .a(operandA),
				  .b(operandB),
				  .inv(invert));

	ornor32bit largeornorgate(.aornorb(ornorHolder),
				  .a(operandA),
				  .b(operandB),
				  .inv(invert));


	generate //now we create the 32 muxs to choose which module to output from
	genvar i;
	for(i=0;i<32;i=i+1)begin
		four21Mux muxres(.out(result[i]),
			  .s0(functionSelect[0]),
		  	  .s1(functionSelect[1]),
			  .in0(addSubHolder[i]),
			  .in1(xorHolder[i]),
			  .in2(andNandHolder[i]),
			  .in3(ornorHolder[i]));
	end
	endgenerate
	
	//Now to deal with carryout, which we only care about for
	//addition/subtraction
	four21Mux muxcarryout(.out(carryout),
			      .s0(functionSelect[0]),
			      .s1(functionSelect[1]),
			      .in0(carryoutHolder),
			      .in1(1'd0),
			      .in2(1'd0),
			      .in3(1'd0));
	//Same goes for overflow
	four21Mux muxoverflow(overflow,
			      functionSelect[0],
			      functionSelect[1],
			      overflowHolder,
			      1'd0,1'd0,1'd0);
	
	//Zero is only valid if there is no overflow
        wire zeroHolder;
	isZero32bit zeroCheck(zeroHolder,result);
	wire invZero;
	not #10 nope(invZero,zeroHolder);
	nor #20 norgatezero(zero,invZero,overflow);


endmodule

