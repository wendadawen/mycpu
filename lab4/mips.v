`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	output wire memwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM 
    );
    wire stallD;
	wire [7:0] alucontrolD, alucontrolE;
	wire [5:0] opD,functD;
	wire regdstE,alusrcE,pcsrcD, regwriteE,regwriteM,regwriteW;
	wire memtoregE,memtoregM,memtoregW;
	wire flushE,equalD;
	wire stallE;

	wire HiLoWriteD, HiLoWriteE, HiLoWriteM, HiLoWriteW;
	controller c(
		clk,
		rst,
		//decode stage
		opD,
		functD,
		stallD,
		pcsrcD,
		branchD,
		equalD,
		jumpD,
		HiLoWriteD,
		alucontrolD,
		
		//execute stage
		flushE,
		memtoregE,
		alusrcE,
		regdstE,
		regwriteE,	
		alucontrolE,
		HiLoWriteE,
		//mem stage
		memtoregM,
		memwriteM,
		regwriteM,
		HiLoWriteM,
		//write back stage
		memtoregW,
		regwriteW,
		HiLoWriteW
		);
	datapath dp(
		clk,
		rst,
		//fetch stage
		pcF,
		instrF,
		//decode stage
		pcsrcD,
		branchD,
		jumpD,
		alucontrolD,
		equalD,
		opD,
		functD,
		stallD,
		//execute stage
		memtoregE,
		alusrcE,
		regdstE,
		regwriteE,
		alucontrolE,
		flushE,
		stallE,
		HiLoWriteE,
		//mem stage
		memtoregM,
		regwriteM,
		aluoutM,
		writedataM,
		readdataM,
		//writeback stage
		memtoregW,
		regwriteW
	    );
	
endmodule
