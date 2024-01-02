`timescale 1ns / 1ps


module mips(
	input wire clk,rst,
	output wire [31:0] pcF,
	input wire [31:0] instrF,
	output wire [3:0] memwriteM,
	output wire [31:0] aluoutM,writedataM,
	input wire [31:0] readdataM

	// // debug
	// output wire [31:0] pc_W,
	// output wire RegWrite_W,
	// output wire write_reg_W,
	// output wire [31:0] result_W
);
	
	wire [31:0] instr_D;
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
	wire WriteReg_E;
	wire Stall_E, Flush_M;
	wire [31:0] a1_D, b1_D;
	wire Jump_D;

	controller c(
		clk,rst,

		//decode stage
		instr_D,
		pcsrcD,branchD,JumpJr_D,
		a1_D, b1_D,
		Jump_D,
		
		//execute stage
		flushE,
		memtoregE,
		regdstE,regwriteE,	
		alucontrolE,
		LoWrite_E, HiWrite_E,
		LoSrc_E, HiSrc_E,
		Stall_E,
		ALUSrcA_E,ALUSrcB_E,
		WriteReg_E,

		//mem stage
		memtoregM,memwriteM,
		regwriteM,
		Flush_M,

		//write back stage
		memtoregW,regwriteW
	);
	datapath dp(
		clk,rst,
		//fetch stage
		pcF,
		instrF,
		//decode stage
		pcsrcD,branchD,
		JumpJr_D,
		instr_D,
		a1_D, b1_D,
		Jump_D,
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
		WriteReg_E,
		//mem stage
		memtoregM,
		regwriteM,
		aluoutM,writedataM,
		readdataM,
		Flush_M,
		//writeback stage
		memtoregW,
		regwriteW
	);
	
endmodule
