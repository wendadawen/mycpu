`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
	input wire clk,
	input wire rst,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire pcsrcD,
	input wire branchD,
	input wire jumpD,
	input wire[7:0] alucontrolD,
	output wire equalD,
	output wire[5:0] opD,functD,
	output wire stallD,
	//execute stage
	input wire memtoregE,
	input wire alusrcE,regdstE,
	input wire regwriteE,
	input wire[7:0] alucontrolE,
	output wire flushE,stallE,
	input wire HiLoWriteE,
	//mem stage
	input wire memtoregM,
	input wire regwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW
    );

 
	//fetch stage
	wire stallF;
	//FD
	wire [31:0] pcnextFD,pcnextbrFD,pcplus4F,pcbranchD;
	//decode stage
	wire [31:0] pcplus4D;
	wire [31:0] instrD;
	wire forwardaD,forwardbD;
	wire [4:0] rsD,rtD,rdD, saD;
	wire flushD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	//execute stage
	wire [31:0] pcE, instrE, pcplus4E;
	wire [1:0] forwardaE,forwardbE;
	wire [4:0] rsE,rtE,rdE, saE;
	wire [4:0] writeregE;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
	wire [31:0] aluoutE;
	wire overflowE;
	//mem stage
	wire [4:0] writeregM;

	//writeback stage

	wire [4:0] writeregW;
	wire [31:0] aluoutW,readdataW,resultW;
	// 与乘法和除法相关的两个寄存器
	wire[63:0] hilo_in, hilo_out;

	//hazard detection
	hazard h(
		//fetch stage
		stallF,
		//decode stage
		rsD,
		rtD,
		branchD,
		forwardaD,
		forwardbD,
		stallD,
		flushD,
		//execute stage
		rsE,
		rtE,
		writeregE,
		regwriteE,
		memtoregE,
		forwardaE,
		forwardbE,
		flushE,
		stallE,
		alucontrolE,
		ready_o,
		//mem stage
		writeregM,
		regwriteM,
		memtoregM,
		//write back stage
		writeregW,
		regwriteW
		);

	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,
		{pcplus4D[31:28],instrD[25:0],2'b00},
		jumpD,pcnextFD);

	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

	//fetch stage logic
	pc #(32) pcreg(clk,rst,~stallF,pcnextFD,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);



	// fetch to decode stage pipeline
	flopenrc #(32) r1D(clk,rst,~stallD,flushD, pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	flopenrc #(32) r3D(clk,rst,~stallD,flushD,pcF,pcD);

	//decode stage
	

	signext se(instrD[15:0],opD,signimmD);
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D);
	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp(srca2D,srcb2D,equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6];
	//execute stage
	flopenrc #(32) 	r8E(clk,rst,~stallE,flushE,pcD,pcE);
	flopenrc #(32) 	r9E(clk,rst,~stallE,flushE,instrD,instrE);
	flopenrc #(32) 	r10E(clk,rst,~stallE,flushE,pcplus4D,pcplus4E);
	floprc #(32) r1E(clk,rst,flushE,srcaD,srcaE);
	floprc #(32) r2E(clk,rst,flushE,srcbD,srcbE);
	floprc #(32) r3E(clk,rst,flushE,signimmD,signimmE);
	floprc #(5) r4E(clk,rst,flushE,rsD,rsE);
	floprc #(5) r5E(clk,rst,flushE,rtD,rtE);
	
	floprc #(5) r6E(clk,rst,flushE,rdD,rdE);
	floprc #(5) r7E(clk, rst, flushE, saD, saE);

	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
	mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);
	// 与除法相关的几个信号
	wire [63:0] div_result;
	wire signed_div_i, start_i, annul_i, ready_o; // 是否是有符号除法，开始信号，取消信号, 除法结果是否准备好
	assign  annul_i = 1'b0;
	assign signed_div_i =  (alucontrolE == `EXE_DIV_OP)? 1'b1: 1'b0;
	assign start_i = ((alucontrolE == `EXE_DIV_OP | alucontrolE == `EXE_DIVU_OP)& ~ready_o) ? 1'b1 : 1'b0;
	div div(
		.clk(clk),
		.rst(rst),
		.signed_div_i(signed_div_i),	
		.opdata1_i(srca2E),		
		.opdata2_i(srcb3E),		
		.start_i(start_i),		
		.annul_i(annul_i),		
		.result_o(div_result),		
		.ready_o(ready_o)			
	);
	alu alu(srca2E,srcb3E,saE, alucontrolE,aluoutE, overflowE, hilo_in, hilo_out);
	// HILO 寄存器
	hilo_reg hilo(
		.clk(clk),
		.rst(rst),
		.HiLoWrite_en(HiLoWriteE),
		.alucontrol(alucontrolE),
		.div_result_ready(ready_o),
		.div_result(div_result),
		.hi_i(hilo_out[63:32]),
		.lo_i(hilo_out[31:0]),
		.hi_o(hilo_in[63:32]),
		.lo_o(hilo_in[31:0])
	);
	mux2 #(5) wrmux(rtE,rdE,regdstE,writeregE);

	//mem stage
	
	flopr #(32) r1M(clk,rst,srcb2E,writedataM);
	flopr #(32) r2M(clk,rst,aluoutE,aluoutM);
	
	flopr #(5) r3M(clk,rst,writeregE,writeregM);

	//writeback stage
	flopr #(32) r1W(clk,rst,aluoutM,aluoutW);
	flopr #(32) r2W(clk,rst,readdataM,readdataW);
	flopr #(5) r3W(clk,rst,writeregM,writeregW);
	mux2 #(32) resmux(aluoutW, readdataW, memtoregW,resultW);


endmodule
