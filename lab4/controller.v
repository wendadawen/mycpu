`timescale 1ns / 1ps


module controller(
	input wire clk, rst, 

	// decode stage
	input wire [31:0] instr_D,
	output wire Branch1_D, Branch2_D, JumpJr_D,
	input wire [31:0] a1_D, b1_D,
	output wire [7:0] ALUControl_D,
	output wire Jump_D,
	
	// execute stage
	input wire Flush_E,
	output wire [1:0] MemtoReg_E, 
	output wire RegDst_E, RegWrite_E,
	output wire [7:0] ALUControl_E,
	output wire LoSrc_E, HiSrc_E,
	input wire Stall_E,
	output wire ALUSrcA_E,
	output wire [1:0] ALUSrcB_E,
	output wire WriteReg_E,
	output wire Jump_E,

	// mem stage
	output wire [1:0] MemtoReg_M, 
	output wire [3:0] MemWrite_M, 
	output wire RegWrite_M,
	input wire Flush_M,
	output wire Jump_M,

	// write back stage
	output wire [1:0] MemtoReg_W, 
	output wire RegWrite_W,
	output wire LoWrite_W, HiWrite_W,
	output wire [1:0] PCSrc_W,
	output wire Jump_W
);
	
	// decode stage
	wire [1:0] MemtoReg_D;
	wire [3:0] MemWrite_D;
	wire RegDst_D, RegWrite_D;
	wire [7:0] ALUControl_D;
	wire LoWrite_D, HiWrite_D;
	wire LoSrc_D, HiSrc_D;
	wire ALUSrcA_D;
	wire [1:0] ALUSrcB_D;
	wire WriteReg_D;
	wire is_branch;
	wire BranchBeq_D,BranchBne_D,BranchBgez_D,BranchBgtz_D,BranchBlez_D,BranchBltz_D,JumpJ_D;
	wire [1:0] PCSrc_D;

	// execute stage
	wire [3:0] MemWrite_E;
	wire WriteReg_E;
	wire LoWrite_E, HiWrite_E;
	wire [1:0] PCSrc_E;

	// mem stage
	wire WriteReg_M;
	wire LoWrite_M, HiWrite_M;
	wire [1:0] PCSrc_M;

	maindec md(
		instr_D,

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
	assign Branch1_D = BranchBeq_D|BranchBne_D;
	assign Branch2_D = BranchBgez_D|BranchBgtz_D|BranchBlez_D|BranchBltz_D;
	assign is_branch = (BranchBeq_D & (a1_D==b1_D)) | 
					(  BranchBne_D & (a1_D!=b1_D)) | 
					( BranchBgez_D & ($signed(a1_D)>=0)) | 
					( BranchBgtz_D & ($signed(a1_D)>0)) | 
					( BranchBlez_D & ($signed(a1_D)<=0)) | 
					( BranchBltz_D & ($signed(a1_D)<0));
	assign Jump_D = JumpJ_D | JumpJr_D | is_branch;
	assign PCSrc_D = ((JumpJ_D|JumpJr_D)==1'b0&is_branch==1'b0) ? 2'b00:
					( is_branch==1'b1) ? 2'b01:
					( JumpJ_D==1'b1) ? 2'b10: 2'b11;

	// pipeline registers
	flopenrc #(32) regE(
		clk, rst,
		~Stall_E, Flush_E, 
		{Jump_D, PCSrc_D, WriteReg_D, LoSrc_D, HiSrc_D, LoWrite_D, HiWrite_D, MemtoReg_D, MemWrite_D, ALUSrcA_D, ALUSrcB_D, RegDst_D, RegWrite_D, ALUControl_D},
		{Jump_E, PCSrc_E, WriteReg_E, LoSrc_E, HiSrc_E, LoWrite_E, HiWrite_E, MemtoReg_E, MemWrite_E, ALUSrcA_E, ALUSrcB_E, RegDst_E, RegWrite_E, ALUControl_E}
	);

	floprc #(32) regM(
		clk, rst,
		Flush_M,
		{Jump_E, PCSrc_E, LoWrite_E, HiWrite_E, WriteReg_E, MemtoReg_E, MemWrite_E, RegWrite_E},
		{Jump_M, PCSrc_M, LoWrite_M, HiWrite_M, WriteReg_M, MemtoReg_M, MemWrite_M, RegWrite_M}
	);

	flopr #(32) regW(
		clk, rst,
		{Jump_M, PCSrc_M, LoWrite_M, HiWrite_M, WriteReg_M, MemtoReg_M, RegWrite_M},
		{Jump_W, PCSrc_W, LoWrite_W, HiWrite_W,WriteReg_W, MemtoReg_W, RegWrite_W}
	);
endmodule

