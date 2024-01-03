`timescale 1ns / 1ps

`include "defines.vh"

module hazard(
	//fetch stage
	output wire Stall_F,
	//decode stage
	input wire [4:0] rs_D,rt_D,
	input wire Branch1_D,Branch2_D,
	output wire ForwardA_D,ForwardB_D,
	output wire Stall_D,
	input wire JumpJr_D,
	output wire Flush_D,
	input wire Jump_D,
	input wire [31:0] instr_D,
	input wire [7:0] ALUControl_D,
	//execute stage
	input wire [4:0] rs_E,rt_E,
	input wire [4:0] write_reg_E,
	input wire RegWrite_E,
	input wire [1:0] MemtoReg_E,
	output reg [1:0] ForwardA_E,ForwardB_E,
	output wire Flush_E,
	input wire alu_ready_E,
	output wire Stall_E,
	
	//mem stage
	input wire [4:0] write_reg_M,
	input wire RegWrite_M,
	input wire [1:0] MemtoReg_M,
	output wire Flush_M,
	output wire ForwardHi_M, ForwardLo_M,

	//write back stage
	input wire[4:0] write_reg_W,
	input wire RegWrite_W,
	output wire HiWrite_W, LoWrite_W
);
	wire [6:0] opcode_D = instr_D[31:26];

	wire lw_stall_D,branch1_stall_D,branch2_stall_D,alu_stall_E,jr_stall_D;

	assign ForwardA_D = (rs_D != 0 & rs_D == write_reg_M & RegWrite_M);
	assign ForwardB_D = (rt_D != 0 & rt_D == write_reg_M & RegWrite_M);
	
	// (sub add add)  OR  (lw add) 
	always @(*) begin
		ForwardA_E = 2'b00;
		ForwardB_E = 2'b00;
		if(rs_E != 0) begin
			if(RegWrite_M & rs_E==write_reg_M) begin
				ForwardA_E = 2'b10;
			end else if(RegWrite_W & rs_E==write_reg_W) begin
				ForwardA_E = 2'b01;
			end
		end
		if(rt_E != 0) begin
			if(RegWrite_M & rt_E==write_reg_M) begin
				ForwardB_E = 2'b10;
			end else if(RegWrite_W & rt_E==write_reg_W) begin
				ForwardB_E = 2'b01;
			end
		end
	end
	// div mfhi mflo
	assign ForwardHi_M = HiWrite_W;
	assign ForwardLo_M = LoWrite_W;

	//stalls
	assign lw_stall_D = (MemtoReg_E!=2'b00) & (rt_E==rs_D | rt_E==rt_D) & (rt_E!=0);
	assign branch1_stall_D = Branch1_D & (
				RegWrite_E & (write_reg_E==rs_D&rs_D!=0 | write_reg_E==rt_D&rt_D!=0) |
				(MemtoReg_M!=2'b00) & (write_reg_M==rs_D&rs_D!=0 | write_reg_M==rt_D&rt_D!=0)
				);
	assign branch2_stall_D = Branch2_D & (
				RegWrite_E & write_reg_E==rs_D&rs_D!=0 |
				(MemtoReg_M!=2'b00) & write_reg_M==rs_D&rs_D!=0
				);
	assign alu_stall_E = ~alu_ready_E;
	assign jr_stall_D = JumpJr_D & (
				RegWrite_E & write_reg_E==rs_D&rs_D!=0 |
				(MemtoReg_M!=2'b00) & write_reg_M==rs_D&rs_D!=0
				);

	assign Stall_E = alu_stall_E;
	assign Stall_D = Stall_E | lw_stall_D | branch1_stall_D | jr_stall_D | branch2_stall_D;
	assign Stall_F = Stall_D;
	
	assign Flush_M = Stall_E;
	assign Flush_E = Stall_D & ~Flush_M;
	assign Flush_D = Stall_F & ~Flush_E & ~Flush_M;
endmodule
