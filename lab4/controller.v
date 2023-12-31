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
	input wire[5:0] opD,
	input wire[5:0] functD,
	input wire stallD, 
	output wire pcsrcD,
	output wire branchD,
	output wire equalD,
	output wire jumpD,
	
	output wire HiLoWriteD,
	output wire[7:0] alucontrolD,
	//execute stage
	input wire flushE,
	output wire memtoregE,
	output wire alusrcE,
	output wire regdstE,
	output wire regwriteE,	
	output wire[7:0] alucontrolE,
	
	output wire HiLoWriteE,


	//mem stage
	output wire memtoregM,
	output wire memwriteM,
	output wire regwriteM,
	
	output wire HiLoWriteM,
	
	//write back stage
	output wire memtoregW,
	output wire regwriteW,

	output wire HiLoWriteW
	);
	
	//decode stage
	wire memtoregD;
	wire memwriteD,alusrcD,regdstD,regwriteD;

	//execute stage
	wire memwriteE;
	wire jumpD;

	maindec md(
		opD,
		functD,
		memtoregD,
		memwriteD,
		branchD,
		alusrcD,
		regdstD,
		regwriteD,
		jumpD,
		HiLoWriteD
		);
		
	aludec ad(
		.funct(functD),
		.aluop(opD), 
		.alucontrol(alucontrolD)
		);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	flopenrc #(13) regE(
		clk,
		rst,
		~stallD,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE}
		);
	// HiLoWrite D --> E
	flopr #(1) hiloregDE(
		clk, rst,
		HiLoWriteD,
		HiLoWriteE
	);
	flopr #(4) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE, HiLoWriteE},
		{memtoregM,memwriteM,regwriteM, HiLoWriteM}
		);
	flopr #(3) regW(
		clk,rst,
		{memtoregM,regwriteM, HiLoWriteM},
		{memtoregW,regwriteW, HiLoWriteW}
		);
endmodule
