`timescale 1ns / 1ps


module controller(
	input clk, rst, 

	/**************DEC****************/
	input instr_D,
	output Branch1_D, Branch2_D, JumpJr_D,
	input a1_D, b1_D,
	output ALUControl_D,
	output Jump_D,
	output JumpJ_D,
	output Invaild_D,
	output Branch_D,
	
	/**************EXE****************/
	input Flush_E,
	output MemtoReg_E, 
	output RegDst_E, RegWrite_E,
	output ALUControl_E,
	output LoSrc_E, HiSrc_E,
	input Stall_E,
	output ALUSrcA_E,
	output ALUSrcB_E,
	output WriteReg_E,
	output Jump_E,
	output Branch1_E,
	output Branch2_E,
	output Cp0Write_E,

	/**************MEM****************/
	output MemtoReg_M, 
	output MemWrite_M, 
	output RegWrite_M,
	input Flush_M,
	output Jump_M,
	input Stall_M,
	input except_type_M,
	input Cp0Write_M,
	output Branch1_M,
	output Branch2_M,

	/**************WB****************/
	output MemtoReg_W, 
	output RegWrite_W,
	output LoWrite_W, HiWrite_W,
	output PCSrc_W,
	output Jump_W,
	input Stall_W, Flush_W,
	output Cp0Write_W,
	output Branch1_W,
	output Branch2_W
);

	wire clk, rst;
	wire [31:0] instr_D, a1_D, b1_D;

	wire [7:0] ALUControl_D, ALUControl_E;
	wire [2:0] MemtoReg_D, MemtoReg_E, MemtoReg_M, MemtoReg_W;
	wire RegDst_D, RegDst_E;
	wire RegWrite_D, RegWrite_E, RegWrite_M, RegWrite_W;
	wire WriteReg_D, WriteReg_E, WriteReg_M;
	wire [3:0] MemWrite_D, MemWrite_E, MemWrite_M;
	wire [3:0] MemWrite1_M;
	wire LoWrite_D, LoWrite_E, LoWrite_M, LoWrite_W;
	wire HiWrite_D, HiWrite_E, HiWrite_M, HiWrite_W;
	wire ALUSrcA_D, ALUSrcA_E;
	wire [1:0] ALUSrcB_D, ALUSrcB_E;
	wire LoSrc_D, LoSrc_E;
	wire HiSrc_D, HiSrc_E;
	wire Cp0Write_D, Cp0Write_E, Cp0Write_M, Cp0Write_W;
	wire [1:0] PCSrc_D, PCSrc_E, PCSrc_M, PCSrc_W;
	wire BranchBeq_D,BranchBne_D,BranchBgez_D,BranchBgtz_D,BranchBlez_D,BranchBltz_D,JumpJ_D, JumpJr_D, Branch_D;
	wire Branch1_D, Branch2_D,Branch1_E, Branch2_E,Branch1_M, Branch2_M,Branch1_W, Branch2_W;
	wire Jump_D, Jump_E, Jump_M, Jump_W;
	wire Invaild_D;

	wire Stall_E;
	wire Flush_E, Flush_M;
	

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
		Invaild_D,
		Cp0Write_D,
		ALUControl_D
	);
	assign Branch1_D = BranchBeq_D|BranchBne_D;
	assign Branch2_D = BranchBgez_D|BranchBgtz_D|BranchBlez_D|BranchBltz_D;
	assign Branch_D = (BranchBeq_D & (a1_D==b1_D)) | 
					(  BranchBne_D & (a1_D!=b1_D)) | 
					( BranchBgez_D & ($signed(a1_D)>=0)) | 
					( BranchBgtz_D & ($signed(a1_D)>0)) | 
					( BranchBlez_D & ($signed(a1_D)<=0)) | 
					( BranchBltz_D & ($signed(a1_D)<0));
	assign Jump_D = JumpJ_D | JumpJr_D | Branch_D;
	assign PCSrc_D = ((JumpJ_D|JumpJr_D)==1'b0&Branch_D==1'b0) ? 2'b00:
					( Branch_D==1'b1) ? 2'b01:
					( JumpJ_D==1'b1) ? 2'b10: 2'b11;
	assign MemWrite_M = (except_type_M!=0) ? 4'b0000: MemWrite1_M;  // MEM and sw_ades error

	flopenrc #(32) regE(
		clk, rst,
		~Stall_E, Flush_E, inst_stall_F,data_stall_M,
		{Branch1_D, Branch2_D, Cp0Write_D, Jump_D, PCSrc_D, WriteReg_D, LoSrc_D, HiSrc_D, LoWrite_D, HiWrite_D, MemtoReg_D, MemWrite_D, ALUSrcA_D, ALUSrcB_D, RegDst_D, RegWrite_D, ALUControl_D},
		{Branch1_E, Branch2_E, Cp0Write_E, Jump_E, PCSrc_E, WriteReg_E, LoSrc_E, HiSrc_E, LoWrite_E, HiWrite_E, MemtoReg_E, MemWrite_E, ALUSrcA_E, ALUSrcB_E, RegDst_E, RegWrite_E, ALUControl_E}
	);

	flopenrc #(32) regM(
		clk, rst,
		~Stall_M, Flush_M,inst_stall_F,data_stall_M,
		{Branch1_E, Branch2_E, Cp0Write_E, Jump_E, PCSrc_E, LoWrite_E, HiWrite_E, WriteReg_E, MemtoReg_E, MemWrite_E , RegWrite_E},
		{Branch1_M, Branch2_M, Cp0Write_M, Jump_M, PCSrc_M, LoWrite_M, HiWrite_M, WriteReg_M, MemtoReg_M, MemWrite1_M, RegWrite_M}
	);

	flopenrc #(32) regW(
		clk, rst,
		~Stall_W, Flush_W, inst_stall_F,data_stall_M,
		{Branch1_M, Branch2_M, Cp0Write_M, Jump_M, PCSrc_M, LoWrite_M, HiWrite_M, WriteReg_M, MemtoReg_M, RegWrite_M},
		{Branch1_W, Branch2_W, Cp0Write_W, Jump_W, PCSrc_W, LoWrite_W, HiWrite_W, WriteReg_W, MemtoReg_W, RegWrite_W}
	);
endmodule
