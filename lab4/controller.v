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
	output wire pcsrcD,
	output wire branchD,
	output wire equalD,
	output wire jumpD,
	
	//execute stage
	input wire flushE,
	output wire memtoregE,
	output wire alusrcE,
	output wire regdstE,
	output wire regwriteE,	
	output wire[7:0] alucontrolE,

	//mem stage
	output wire memtoregM,
	output wire memwriteM,
	output wire regwriteM,
	//write back stage
	output wire memtoregW,
	output wire regwriteW
    );
	
	//decode stage
	wire memtoregD,memwriteD,alusrcD,
		regdstD,regwriteD;
	wire[7:0] alucontrolD;

	//execute stage
	wire memwriteE;

	maindec md(
		opD,
		memtoregD,
		memwriteD,
		branchD,
		alusrcD,
		regdstD,
		regwriteD,
		jumpD
		);
		
	aludec ad(
		.funct(functD),
		.aluop(opD), 
		.alucontrol(alucontrolD)
		);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	floprc #(13) regE(
		clk,
		rst,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE}
		);
	flopr #(8) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE},
		{memtoregM,memwriteM,regwriteM}
		);
	flopr #(8) regW(
		clk,rst,
		{memtoregM,regwriteM},
		{memtoregW,regwriteW}
		);
endmodule
