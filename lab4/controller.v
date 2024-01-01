`timescale 1ns / 1ps


module controller(
	input wire clk, rst, 

	// decode stage
	input wire [5:0] opcode_D, funct_D,
	input wire [4:0] rt_D,
	output wire [1:0] PCSrc_D, 
	output wire Branch_D, JumpJr_D,
	input wire [31:0] a1_D, b1_D,
	
	// execute stage
	input wire Flush_E,
	output wire [1:0] MemtoReg_E, 
	output wire RegDst_E, RegWrite_E,
	output wire [7:0] ALUControl_E,
	output wire LoWrite_E, HiWrite_E,
	output wire LoSrc_E, HiSrc_E,
	input wire Stall_E,
	output wire ALUSrcA_E,
	output wire [1:0] ALUSrcB_E,

	// mem stage
	output wire [1:0] MemtoReg_M, 
	output wire MemWrite_M, RegWrite_M,
	input wire Flush_M,
	output wire WriteReg_M,

	// write back stage
	output wire [1:0] MemtoReg_W, 
	output wire RegWrite_W,
	output wire WriteReg_W
);
	
	// decode stage
	wire [1:0] MemtoReg_D;
	wire MemWrite_D, RegDst_D, RegWrite_D;
	wire [7:0] ALUControl_D;
	wire LoWrite_D, HiWrite_D;
	wire LoSrc_D, HiSrc_D;
	wire ALUSrcA_D;
	wire [1:0] ALUSrcB_D;
	wire WriteReg_D;
	wire BranchBeq_D,BranchBne_D,BranchBgez_D,BranchBgtz_D,BranchBlez_D,BranchBltz_D,JumpJ_D,Jump_D;

	// execute stage
	wire MemWrite_E;
	wire WriteReg_E;

	// mem stage
	wire WriteReg_M;

	maindec md(
		opcode_D,
		funct_D,
		rt_D,
		MemtoReg_D, 
		MemWrite_D,
		ALUSrcA_D,
		ALUSrcB_D,
		RegDst_D, 
		RegWrite_D,
		LoWrite_D, 
		HiWrite_D,
		LoSrc_D, 
		HiSrc_D,
		WriteReg_D,
		BranchBeq_D,
		BranchBne_D,
		BranchBgez_D,
		BranchBgtz_D,
		BranchBlez_D,
		BranchBltz_D,
		JumpJ_D,
		JumpJr_D,
		ALUControl_D
	);
	assign Branch_D = (BranchBeq_D & (a1_D==b1_D)) | 
					(  BranchBne_D & (a1_D!=b1_D)) | 
					( BranchBgez_D & ($signed(a1_D)>=0)) | 
					( BranchBgtz_D & ($signed(a1_D)>0)) | 
					( BranchBlez_D & ($signed(a1_D)<=0)) | 
					( BranchBltz_D & ($signed(a1_D)<0));
	assign Jump_D = JumpJ_D | JumpJr_D;
	assign PCSrc_D = (Jump_D==1'b0&Branch_D==1'b0) ? 2'b00:
					( Branch_D==1'b1) ? 2'b01:
					( JumpJ_D==1'b1) ? 2'b10: 2'b11;

	// pipeline registers
	flopenrc #(32) regE(
		clk, rst,
		~Stall_E, Flush_E, 
		{WriteReg_D, LoSrc_D, HiSrc_D, LoWrite_D, HiWrite_D, MemtoReg_D, MemWrite_D, ALUSrcA_D, ALUSrcB_D, RegDst_D, RegWrite_D, ALUControl_D},
		{WriteReg_E, LoSrc_E, HiSrc_E, LoWrite_E, HiWrite_E, MemtoReg_E, MemWrite_E, ALUSrcA_E, ALUSrcB_E, RegDst_E, RegWrite_E, ALUControl_E}
	);

	floprc #(32) regM(
		clk, rst,
		Flush_M,
		{WriteReg_E, MemtoReg_E, MemWrite_E, RegWrite_E},
		{WriteReg_M, MemtoReg_M, MemWrite_M, RegWrite_M}
	);

	flopr #(32) regW(
		clk, rst,
		{WriteReg_M, MemtoReg_M, RegWrite_M},
		{WriteReg_W, MemtoReg_W, RegWrite_W}
	);
endmodule

