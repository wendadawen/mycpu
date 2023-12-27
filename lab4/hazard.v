`timescale 1ns / 1ps



module hazard(
	//fetch stage
	output wire Stall_F,
	//decode stage
	input wire[4:0] rs_D,rt_D,
	input wire Branch_D,
	output wire ForwardA_D,ForwardB_D,
	output wire Stall_D,
	//execute stage
	input wire[4:0] rs_E,rt_E,
	input wire[4:0] write_reg_E,
	input wire RegWrite_E,
	input wire MemtoReg_E,
	output reg[1:0] ForwardA_E,ForwardB_E,
	output wire Flush_E,
	//mem stage
	input wire[4:0] write_reg_M,
	input wire RegWrite_M,
	input wire MemtoReg_M,

	//write back stage
	input wire[4:0] write_reg_W,
	input wire RegWrite_W
    );

	wire lw_stall_D,branch_stall_D;

	// 分支提前造成的数据前推
	assign ForwardA_D = (rs_D != 0 & rs_D == write_reg_M & RegWrite_M);
	assign ForwardB_D = (rt_D != 0 & rt_D == write_reg_M & RegWrite_M);
	
	// sub add add  OR  lw add 
	always @(*) begin
		ForwardA_E = 2'b00;
		ForwardB_E = 2'b00;
		if(rs_E != 0) begin
			if(rs_E == write_reg_M & RegWrite_M) begin
				ForwardA_E = 2'b10;
			end else if(rs_E == write_reg_W & RegWrite_W) begin
				ForwardA_E = 2'b01;
			end
		end
		if(rt_E != 0) begin
			if(rt_E == write_reg_M & RegWrite_M) begin
				ForwardB_E = 2'b10;
			end else if(rt_E == write_reg_W & RegWrite_W) begin
				ForwardB_E = 2'b01;
			end
		end
	end
	
	//stalls
	assign #1 lw_stall_D = MemtoReg_E & (rt_E == rs_D | rt_E == rt_D);
	assign #1 branch_stall_D = Branch_D & (
				RegWrite_E & (write_reg_E == rs_D | write_reg_E == rt_D) |
				MemtoReg_M & (write_reg_M == rs_D | write_reg_M == rt_D)
				);
	assign #1 Stall_D = lw_stall_D | branch_stall_D;
	assign #1 Stall_F = lw_stall_D | branch_stall_D;
	assign #1 Flush_E = lw_stall_D | branch_stall_D;
endmodule
