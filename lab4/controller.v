`timescale 1ns / 1ps


module controller(
	input wire clk, rst, 

	// decode stage
	input wire [5:0] opcode_D, funct_D, Equal_D,
	output wire PCSrc_D, Branch_D, Jump_D,
	
	// execute stage
	input wire Flush_E,
	output wire [1:0] MemtoReg_E, 
	output wire ALUSrc_E,
	output wire RegDst_E, RegWrite_E,
	output wire [7:0] ALUControl_E,
	output wire LoWrite_E, HiWrite_E,

	// mem stage
	output wire [1:0] MemtoReg_M, 
	output wire MemWrite_M, RegWrite_M,

	// write back stage
	output wire [1:0] MemtoReg_W, 
	output wire RegWrite_W
    );
	
	// decode stage
	wire [1:0] MemtoReg_D;
	wire MemWrite_D, ALUSrc_D, RegDst_D, RegWrite_D;
	wire [7:0] ALUControl_D;
	wire LoWrite_D, HiWrite_D;

	// execute stage
	wire MemWrite_E;

	// mem stage

	maindec md(
		opcode_D,
		funct_D,

		MemtoReg_D, 
		MemWrite_D,
		Branch_D, 
		ALUSrc_D,
		RegDst_D, 
		RegWrite_D,
		Jump_D,
		LoWrite_D,
		HiWrite_D,
		ALUControl_D
		);
	assign PCSrc_D = Branch_D & Equal_D;

	// pipeline registers
	floprc #(32) regE(
		clk, rst,
		Flush_E,
		{LoWrite_D, HiWrite_D, MemtoReg_D, MemWrite_D, ALUSrc_D, RegDst_D, RegWrite_D, ALUControl_D},
		{LoWrite_E, HiWrite_E, MemtoReg_E, MemWrite_E, ALUSrc_E, RegDst_E, RegWrite_E, ALUControl_E}
	);

	flopr #(32) regM(
		clk, rst,
		{MemtoReg_E, MemWrite_E, RegWrite_E},
		{MemtoReg_M, MemWrite_M, RegWrite_M}
	);

	flopr #(32) regW(
		clk, rst,
		{MemtoReg_M, RegWrite_M},
		{MemtoReg_W, RegWrite_W}
	);
endmodule

