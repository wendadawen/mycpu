`timescale 1ns / 1ps


module controller(
	input wire clk, rst, 

	// decode stage
	input wire [31:0] instr_D,
	output wire [1:0] PCSrc_D, 
	output wire Branch1_D, Branch2_D, JumpJr_D,
	input wire [31:0] a1_D, b1_D,
	output wire Jump_D,
	output wire [7:0] ALUControl_D,
	
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
	output wire WriteReg_E,

	// mem stage
	output wire [1:0] MemtoReg_M, 
	output wire [3:0] MemWrite_M, 
	output wire RegWrite_M,
	input wire Flush_M,

	// write back stage
	output wire [1:0] MemtoReg_W, 
	output wire RegWrite_W
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

	// execute stage
	wire [3:0] MemWrite_E;
	wire WriteReg_E;

	// mem stage
	wire WriteReg_M;

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
	assign Jump_D = JumpJ_D | JumpJr_D;
	assign PCSrc_D = (Jump_D==1'b0&is_branch==1'b0) ? 2'b00:
					( is_branch==1'b1) ? 2'b01:
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

