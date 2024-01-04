`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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


module controller(
	input wire clk,
	input wire rst,
	//decode stage
	input wire[31:0] instrD,
	input wire[5:0] opD,
	input wire[4:0] rtD,
	input wire[5:0] functD,
	input wire stallD, 
	output wire pcsrcD,
	output wire branchD,
	input wire equalD,
	output wire jumpD,
	output wire jalD, 
	output wire jrD,
	output wire balD,
	output wire memenD,
	output wire HiLoWriteD,
	output wire breakD,
	output wire syscallD,
	output wire reserve_instructionD,
	output wire eretD,
	output wire[7:0] alucontrolD,
	//execute stage
	input wire flushE,
	output wire memtoregE,
	output wire alusrcE,
	output wire regdstE,
	output wire regwriteE,	
	output wire[7:0] alucontrolE,
	output wire jumpE,
	output wire jalE,
	output wire jrE,
	output wire balE,
	output wire memenE,
	output wire HiLoWriteE,
	//mem stage
	input wire flushM,
	output wire memtoregM,
	output wire memenM,
	output wire regwriteM,
	output wire HiLoWriteM,
	output wire mtcp0M, mfcp0M,
	//write back stage
	input wire flushW,
	output wire memtoregW,
	output wire regwriteW,
	output wire HiLoWriteW
	);
	
	//decode stage
	wire memtoregD;

	wire alusrcD;
	wire regdstD;
	wire regwriteD;
	
	wire mtcp0D;
	wire mfcp0D;

	//execute stage

	wire mtcp0E, mfcp0E;

	maindec md(
		instrD,
		opD,
		rtD,
		functD,
		memtoregD,
		memenD,
		branchD,
		alusrcD,
		regdstD,
		regwriteD,
		jumpD,
		jalD,
		jrD,
		balD,
		HiLoWriteD,


		breakD,
		syscallD,
		reserve_instructionD,
		eretD,
		mtcp0D,
		mfcp0D
		);
		
	aludec ad(
		.funct(functD),
		.aluop(opD), 
		.rt(rtD),
		.alucontrol(alucontrolD)
		);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	flopenrc #(19) regE(
		clk,
		rst,
		~stallD,
		flushE,
		{memtoregD,memenD,alusrcD,regdstD,regwriteD,alucontrolD, jumpD, jalD, jrD, balD, mtcp0D, mfcp0D},
		{memtoregE,memenE,alusrcE,regdstE,regwriteE,alucontrolE, jumpE, jalE, jrE, balE, mtcp0E, mfcp0E}
		);
	// HiLoWrite D --> E
	flopr #(1) hiloregDE(
		clk, rst,
		HiLoWriteD,
		HiLoWriteE
	);
	floprc #(6) regM(
		clk,
		rst,
		flushM,
		{memtoregE,memenE,regwriteE, HiLoWriteE, mtcp0E, mfcp0E},
		{memtoregM,memenM,regwriteM, HiLoWriteM, mtcp0M, mfcp0M}
		);
	floprc #(3) regW(
		clk,
		rst,
		flushW,
		{memtoregM,regwriteM, HiLoWriteM},
		{memtoregW,regwriteW, HiLoWriteW}
		);
endmodule
