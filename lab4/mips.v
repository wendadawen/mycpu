`timescale 1ns / 1ps


module mips(
	input wire clk,rst,
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	output wire memwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM
);
	
	wire [5:0] opD,functD;
	wire [4:0] rt_D;
	wire regdstE,JumpJr_D;
	wire [1:0] pcsrcD;
	wire [1:0] memtoregE,memtoregM,memtoregW;
	wire regwriteE,regwriteM,regwriteW;
	wire [7:0] alucontrolE;
	wire LoWrite_E, HiWrite_E;
	wire LoSrc_E, HiSrc_E;
	wire flushE;
	wire ALUSrcA_E;
	wire [1:0] ALUSrcB_E;
	wire Stall_E, Flush_M;
	wire WriteReg_W;
	wire [31:0] a1_D, b1_D;
	wire WriteReg_M;

	controller c(
		clk,rst,
		//decode stage
		opD,functD,rt_D,
		pcsrcD,branchD,JumpJr_D,
		a1_D, b1_D,
		
		//execute stage
		flushE,
		memtoregE,
		regdstE,regwriteE,	
		alucontrolE,
		LoWrite_E, HiWrite_E,
		LoSrc_E, HiSrc_E,
		Stall_E,
		ALUSrcA_E,ALUSrcB_E,

		//mem stage
		memtoregM,memwriteM,
		regwriteM,
		Flush_M,
		WriteReg_M,

		//write back stage
		memtoregW,regwriteW,
		WriteReg_W
	);
	datapath dp(
		clk,rst,
		//fetch stage
		pcF,
		instrF,
		//decode stage
		pcsrcD,branchD,
		JumpJr_D,
		opD,functD,rt_D,
		a1_D, b1_D,
		//execute stage
		memtoregE,
		regdstE,
		regwriteE,
		alucontrolE,
		flushE,
		LoWrite_E, HiWrite_E,
		LoSrc_E, HiSrc_E,
		Stall_E,
		ALUSrcA_E,ALUSrcB_E,
		//mem stage
		memtoregM,
		regwriteM,
		aluoutM,writedataM,
		readdataM,
		Flush_M,
		WriteReg_M,
		//writeback stage
		memtoregW,
		regwriteW,
		WriteReg_W
	);
	
endmodule
