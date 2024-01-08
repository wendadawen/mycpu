`timescale 1ns / 1ps
`include "defines.vh"

module mips(
	input  wire         clk,rst,
	input  wire [5 : 0] ext_int,

	output wire [31: 0] inst_sram_addr,
	output wire         inst_sram_en,
	input  wire [31: 0] inst_sram_rdata,
	input  wire         inst_stall,

	output wire         data_sram_en,
    output wire [31: 0] data_sram_addr,
    input  wire [31: 0] data_sram_rdata,
    output wire [3 : 0] data_sram_wen,
    output wire [31: 0] data_sram_wdata,
    input  wire         data_stall,

	output wire         longest_stall,

	output wire [31: 0] debug_wb_pc,
	output wire [3 : 0] debug_wb_rf_wen,
	output wire [4 : 0] debug_wb_rf_wnum,
	output wire [31: 0] debug_wb_rf_wdata
);

	wire [31:0] pc_F, pc_M;
	wire [31:0] instr_F, instr_M;
	wire [3: 0] MemWrite_M;
	wire [31:0] alu_out_M,write_data_M;
	wire [31:0] read_data_M;
	
	wire [31:0] pc_W;
	wire RegWrite_W;
	wire [4:0] write_reg_W;
	wire [31:0] result_W;
	
	wire [31:0] instr_D;
	wire RegDst_E,JumpJr_D;
	wire [1:0] PCSrc_W;
	wire [2:0] MemtoReg_E,MemtoReg_M,MemtoReg_W;
	wire RegWrite_E,RegWrite_M,RegWrite_W;
	wire [7:0] ALUControl_E;
	wire LoWrite_E, HiWrite_E;
	wire LoSrc_E, HiSrc_E;
	wire Flush_E;
	wire ALUSrcA_E;
	wire [1:0] ALUSrcB_E;
	wire WriteReg_E;
	wire Stall_E, Flush_M;
	wire [31:0] a1_D, b1_D;
	wire Jump_D;
	wire [7:0] ALUControl_D;
	wire Jump_E, Jump_M, Jump_W;
	wire LoWrite_W, HiWrite_W;
	wire JumpJ_D;
	wire Invaild_D;
	wire Cp0Write_W;
	wire [31:0] except_type_M;
	wire Branch_D;
	wire Branch1_D, Branch2_D,Branch1_E, Branch2_E,Branch1_M, Branch2_M,Branch1_W, Branch2_W;
	wire inst_stall_F, data_stall_M;
	wire alu_stall_E;
	wire Stall_F;
	wire Cp0Write_E;
	controller c(
		clk,rst,

		/**************DEC****************/
		instr_D,
		Branch1_D,Branch2_D,JumpJr_D,
		a1_D, b1_D,
		ALUControl_D,
		Jump_D,
		JumpJ_D,
		Invaild_D,
		Branch_D,

		/**************EXE****************/
		Flush_E,
		MemtoReg_E,
		RegDst_E,RegWrite_E,	
		ALUControl_E,
		LoSrc_E, HiSrc_E,
		Stall_E,
		ALUSrcA_E,ALUSrcB_E,
		WriteReg_E,
		Jump_E,
		Branch1_E, Branch2_E,
		Cp0Write_E,

		/**************MEM****************/
		MemtoReg_M,MemWrite_M,
		RegWrite_M,
		Flush_M,
		Jump_M,
		Stall_M,
		except_type_M,
		Cp0Write_M,
		Branch1_M, Branch2_M,

		/**************WB****************/
		MemtoReg_W,RegWrite_W,
		LoWrite_W, HiWrite_W,
		PCSrc_W,
		Jump_W,
		Stall_W, Flush_W,
		Cp0Write_W,
		Branch1_W, Branch2_W
	);
	datapath dp(
		clk,rst,
		longest_stall,
		/**************FET****************/
		pc_F,
		instr_F,
		inst_stall_F,
		Stall_F,
		/**************DEC****************/
		Branch1_D,Branch2_D,
		JumpJr_D,
		instr_D,
		a1_D, b1_D,
		ALUControl_D,
		Jump_D,
		JumpJ_D,
		Invaild_D,
		Branch_D,
		/**************EXE****************/
		MemtoReg_E,
		RegDst_E,
		RegWrite_E,
		ALUControl_E,
		Flush_E,
		LoSrc_E, HiSrc_E,
		Stall_E,
		ALUSrcA_E,ALUSrcB_E,
		WriteReg_E,
		Jump_E,
		Branch1_E, Branch2_E,
		alu_stall_E,
		Cp0Write_E, 
		/**************MEM****************/
		MemtoReg_M,
		RegWrite_M,
		alu_out_M,
		write_data_M,
		read_data_M,
		Flush_M,
		Jump_M,
		Stall_M,
		except_type_M,
		Cp0Write_M,
		Branch1_M, Branch2_M,
		data_stall_M,
		instr_M,
		/**************WB****************/
		MemtoReg_W,
		RegWrite_W,
		write_reg_W,
		result_W,
		pc_W,
		LoWrite_W, HiWrite_W,
		PCSrc_W,
		Jump_W,
		Stall_W, Flush_W,
		Cp0Write_W,
		Branch1_W, Branch2_W
	);

	// instr
	assign inst_sram_addr          = pc_F;
	assign inst_sram_en            = ~rst;
	assign instr_F                 = inst_sram_rdata;
	assign inst_stall_F            = inst_stall;

	// data
	assign data_sram_en            = (MemWrite_M!=0) | (MemtoReg_M==3'b001);
    assign data_sram_addr          = alu_out_M;
    assign read_data_M             = data_sram_rdata;
    assign data_sram_wen           = MemWrite_M;
    assign data_sram_wdata         = write_data_M;
    assign data_stall_M            = data_stall;

	// debug
	assign debug_wb_pc             = pc_W;
	assign debug_wb_rf_wen         = {4{RegWrite_W & ~longest_stall}};
	assign debug_wb_rf_wnum        = write_reg_W;
	assign debug_wb_rf_wdata       = result_W;

	
endmodule
