`timescale 1ns / 1ps

module datapath(
	input wire clk,rst,
	//fetch stage
	output wire[31:0] pc_F,
	input wire[31:0] instr_F,
	//decode stage
	input wire PCSrc_D,Branch_D,
	input wire Jump_D,
	output wire Equal_D,
	output wire[5:0] opcode_D,funct_D,
	//execute stage
	input wire MemtoReg_E,
	input wire AluSrc_E,RegDst_E,
	input wire RegWrite_E,
	input wire[7:0] ALUControl_E,
	output wire Flush_E,
	//mem stage
	input wire MemtoReg_M,
	input wire RegWrite_M,
	output wire[31:0] aluout_M,write_data_M,
	input wire[31:0] read_data_M,
	//writeback stage
	input wire MemtoReg_W,
	input wire RegWrite_W
    );
	
	//fetch stage
	wire Stall_F;
	//FD
	wire [31:0] pc_next_F, pc_plus4_F,pc_branch_D;
	//decode stage
	wire [31:0] pc_plus4_D,instr_D;
	wire ForwardA_D,ForwardB_D;
	wire [4:0] rs_D,rt_D,rd_D;
	wire Flush_D,Stall_D; 
	wire [31:0] sign_imm_D;
	wire [31:0] a_D,a2_D,b_D,b2_D;
	//execute stage
	wire [1:0] ForwardA_E,ForwardB_E;
	wire [4:0] rs_E,rt_E,rd_E;
	wire [4:0] write_reg_E;
	wire [31:0] sign_imm_E;
	wire [31:0] a_E,a2_E,b_E,b2_E,b3_E;
	wire [31:0] aluout_E;
	//mem stage
	wire [4:0] write_reg_M;
	//writeback stage
	wire [4:0] write_reg_W;
	wire [31:0] aluout_W,read_data_W,result_W;

	//Hazard
	hazard h(
		//fetch stage
		Stall_F,
		//decode stage
		rs_D,rt_D,
		Branch_D,
		ForwardA_D,ForwardB_D,
		Stall_D,
		//execute stage
		rs_E,rt_E,
		write_reg_E,
		RegWrite_E,
		MemtoReg_E,
		ForwardA_E,ForwardB_E,
		Flush_E,
		//mem stage
		write_reg_M,
		RegWrite_M,
		MemtoReg_M,
		//write back stage
		write_reg_W,
		RegWrite_W
		);

	

	//=============Fetch
	assign pc_next_F = (Jump_D) ? {pc_plus4_D[31:28],instr_D[25:0],2'b00}: 
						(PCSrc_D) ? pc_branch_D: pc_plus4_F; // 下一个PC
	assign pc_plus4_F = pc_F + 4;
	pc #(32) pcreg(clk,rst,~Stall_F,pc_next_F,pc_F);
	
	//============Decode
	//RegFile
	regfile rf(
		clk,
		RegWrite_W,
		rs_D,rt_D,write_reg_W, 
		result_W, 
		a_D,b_D 
		);

	flopenr #(32) r1D(clk,rst,~Stall_D,pc_plus4_F,pc_plus4_D);
	flopenrc #(32) r2D(clk,rst,~Stall_D,Flush_D,instr_F,instr_D);

	assign opcode_D = instr_D[31:26];
	assign funct_D = instr_D[5:0];
	assign rs_D = instr_D[25:21];
	assign rt_D = instr_D[20:16];
	assign rd_D = instr_D[15:11];

	signextend signextend(opcode_D, funct_D, instr_D[15:0], sign_imm_D);
	assign pc_branch_D = pc_plus4_D + {sign_imm_D[29:0],2'b00};
	assign a2_D = (ForwardA_D) ? aluout_M: a_D;
	assign b2_D = (ForwardB_D) ? aluout_M: b_D;
	assign Equal_D = (a2_D==b2_D)? 1: 0;


	//============Execute
	floprc #(32) r1E(clk,rst,Flush_E,a_D,a_E);
	floprc #(32) r2E(clk,rst,Flush_E,b_D,b_E);
	floprc #(32) r3E(clk,rst,Flush_E,sign_imm_D,sign_imm_E);
	floprc #(5)  r4E(clk,rst,Flush_E,rs_D,rs_E);
	floprc #(5)  r5E(clk,rst,Flush_E,rt_D,rt_E);
	floprc #(5)  r6E(clk,rst,Flush_E,rd_D,rd_E);

	mux3 #(32) forwardaemux(a_E,result_W,aluout_M,ForwardA_E,a2_E);  // 获取ALU的A
	mux3 #(32) forwardbemux(b_E,result_W,aluout_M,ForwardB_E,b2_E);  
	assign b3_E = (AluSrc_E) ? sign_imm_E: b2_E;  // 获取ALU的B

	alu alu(a2_E,b3_E,ALUControl_E,aluout_E);  // ALU计算
	assign write_reg_E = (RegDst_E) ? rd_E: rt_E;  // 判断写回数据地址

	//===================Memory
	flopr #(32) r1M(clk,rst,b2_E,write_data_M);
	flopr #(32) r2M(clk,rst,aluout_E,aluout_M);
	flopr #(5)  r3M(clk,rst,write_reg_E,write_reg_M);

	//===================Writeback
	flopr #(32) r1W(clk,rst,aluout_M,aluout_W);
	flopr #(32) r2W(clk,rst,read_data_M,read_data_W);
	flopr #(5)  r3W(clk,rst,write_reg_M,write_reg_W);
	assign result_W = (MemtoReg_W) ? read_data_W: aluout_W;
endmodule
