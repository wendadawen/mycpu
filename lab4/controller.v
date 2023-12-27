`timescale 1ns / 1ps


module controller(
	input wire clk, rst,  // 时钟信号和复位信号

	// decode stage
	input wire [5:0] opcode_D, funct_D, Equal_D,  // 解码阶段的输入信号
	output wire PCSrc_D, Branch_D, Jump_D,  // 解码阶段的输出信号
	
	// execute stage
	input wire Flush_E,  // 执行阶段的 flush 信号
	output wire MemtoReg_E, ALUSrc_E,  // 执行阶段的输出信号
	output wire RegDst_E, RegWrite_E,  // 执行阶段的输出信号
	output wire [2:0] ALUControl_E,  // 执行阶段的输出信号

	// mem stage
	output wire MemtoReg_M, MemWrite_M, RegWrite_M,  // 存储器阶段的输出信号

	// write back stage
	output wire MemtoReg_W, RegWrite_W  // 写回阶段的输出信号
    );
	
	// decode stage
	wire [1:0] aluop_D;
	wire MemtoReg_D, MemWrite_D, ALUSrc_D, RegDst_D, RegWrite_D;  // 解码阶段的中间信号
	wire [2:0] ALUControl_D;  // ALU 控制信号

	// execute stage
	wire MemWrite_E;  // 执行阶段的中间信号

	maindec md(
		opcode_D,
		aluop_D,

		MemtoReg_D, 
		MemWrite_D,
		Branch_D, 
		ALUSrc_D,
		RegDst_D, 
		RegWrite_D,
		Jump_D
		);
	aludec ad(funct_D, aluop_D, ALUControl_D);  // ALU 控制信号的解码过程
	assign PCSrc_D = Branch_D & Equal_D;  // 计算 PCSrc_D 信号的赋值

	// pipeline registers
	floprc #(8) regE(
		clk, rst,
		Flush_E,
		{MemtoReg_D, MemWrite_D, ALUSrc_D, RegDst_D, RegWrite_D, ALUControl_D},
		{MemtoReg_E, MemWrite_E, ALUSrc_E, RegDst_E, RegWrite_E, ALUControl_E}
		);  // 执行阶段的流水线寄存器

	flopr #(8) regM(
		clk, rst,
		{MemtoReg_E, MemWrite_E, RegWrite_E},
		{MemtoReg_M, MemWrite_M, RegWrite_M}
		);  // 存储器阶段的流水线寄存器

	flopr #(8) regW(
		clk, rst,
		{MemtoReg_M, RegWrite_M},
		{MemtoReg_W, RegWrite_W}
		);  // 写回阶段的流水线寄存器
endmodule

