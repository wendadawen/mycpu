`timescale 1ns / 1ps

module datapath(
	input wire clk,rst,
	//fetch stage
	output wire [31:0] pc_F,
	input wire [31:0] instr_F,
	//decode stage
	input wire Branch1_D,Branch2_D,
	input wire JumpJr_D,
	output wire [31:0] instr_D,
	output wire [31:0] a1_D, b1_D,
	input wire [7:0] ALUControl_D,
	input wire Jump_D,
	//execute stage
	input wire [1:0]MemtoReg_E,
	input wire RegDst_E,
	input wire RegWrite_E,
	input wire[7:0] ALUControl_E,
	output wire Flush_E,
	input wire LoSrc_E, HiSrc_E,
	output wire Stall_E,
	input wire ALUSrcA_E,
	input wire [1:0] ALUSrcB_E,
	input wire WriteReg_E,
	input wire Jump_E,
	//mem stage
	input wire [1:0]MemtoReg_M,
	input wire RegWrite_M,
	output wire [31:0] alu_out_M,write_data_M,
	input wire [31:0] read_word_data_M,
	output wire Flush_M,
	input wire Jump_M,
	//writeback stage
	input wire [1:0]MemtoReg_W,
	input wire RegWrite_W,
	output wire [4:0] write_reg_W,
	output wire [31:0] result_W,pc_W,
	input wire LoWrite_W, HiWrite_W,
	input wire [1:0] PCSrc_W,
	input wire Jump_W
);
	
	//fetch stage
	wire Stall_F;
	wire [31:0] pc_next_F, pc_plus4_F;

	//decode stage
	wire [31:0] pc_plus4_D,instr_D;
	wire ForwardA_D,ForwardB_D;
	wire [4:0] rs_D,rt_D,rd_D;
	wire Stall_D; 
	wire [31:0] sign_imm_D;
	wire [31:0] a_D,b_D;
	wire [4:0] sa_D;
	wire [31:0] pc_branch_D, pc_jump_D;
	wire [5:0] opcode_D, funct_D;
	wire Flush_D;
	wire [31:0] pc_D;
	wire [31:0] hi_write_data_D, lo_write_data_D;

	//execute stage
	wire [1:0] ForwardA_E,ForwardB_E;
	wire [4:0] rs_E,rt_E,rd_E;
	wire [4:0] write_reg_E;
	wire [31:0] sign_imm_E;
	wire [31:0] a_E,a1_E,b_E,b1_E,b2_E;
	wire [31:0] alu_out_E;
	wire [4:0] sa_E;
	wire [31:0] hi_write_data_E, lo_write_data_E, hi_out_E, lo_out_E;
	wire alu_ready_E;
	wire [31:0] pc_plus4_E, a2_E;
	wire [31:0] write_data_E;
	wire [31:0] instr_E;
	wire [31:0] pc_E;
	wire [31:0] pc_jump_E, pc_branch_E;

	//mem stage
	wire [4:0] write_reg_M;
	wire [31:0] hi_read_data_M, lo_read_data_M;
	wire [31:0] read_data_M;
	wire [31:0] instr_M;
	wire [31:0] pc_M;
	wire alu_ready_M;
	wire [31:0] hi_write_data_M, lo_write_data_M;
	wire [31:0] hi_read_data1_M, lo_read_data1_M;
	wire  ForwardHi_M, ForwardLo_M;
	wire [31:0] a_M;
	wire [31:0] pc_jump_M;
	wire [31:0] pc_plus4_M, pc_branch_M;

	//writeback stage
	wire [4:0] write_reg_W;
	wire [31:0] alu_out_W,read_data_W,result_W;
	wire [31:0] hi_read_data_W, lo_read_data_W;
	wire [31:0] pc_W;
	wire alu_ready_W;
	wire [31:0] hi_write_data_W, lo_write_data_W;
	wire [31:0] a_W;
	wire [31:0] pc_jump_W;
	wire [31:0] pc_plus4_W, pc_branch_W;
	

	//Hazard
	hazard h(
		//fetch stage
		Stall_F,
		//decode stage
		rs_D,rt_D,
		Branch1_D,Branch2_D,
		ForwardA_D,ForwardB_D,
		Stall_D,
		JumpJr_D,
		Flush_D,
		instr_D,
		ALUControl_D,
		Jump_D,
		//execute stage
		rs_E,rt_E,
		write_reg_E,
		RegWrite_E,
		MemtoReg_E,
		ForwardA_E,ForwardB_E,
		Flush_E,
		alu_ready_E,
		Stall_E,
		Jump_E,
		//mem stage
		write_reg_M,
		RegWrite_M,
		MemtoReg_M,
		Flush_M,
		ForwardHi_M, ForwardLo_M,
		Jump_M,
		//write back stage
		write_reg_W,
		RegWrite_W,
		HiWrite_W, LoWrite_W,
		Jump_W
	);
	
	//===============================Fetch
	mux4 #(32) pcmux4(pc_plus4_F,pc_branch_W,pc_jump_W,a_W,PCSrc_W,pc_next_F);
	assign pc_plus4_F = pc_F + 4;
	pc #(32) pcreg(clk,rst,~Stall_F,pc_next_F,pc_F);
	
	//===============================Decode
	regfile rf(
		clk,
		RegWrite_W,
		rs_D,rt_D,write_reg_W, 
		result_W,
		a_D,b_D 
	);

	flopenrc #(32) r1D(clk,rst,~Stall_D,Flush_D, pc_plus4_F,pc_plus4_D);
	flopenrc #(32) r2D(clk,rst,~Stall_D,Flush_D, instr_F,instr_D);
	flopenrc #(32) r3D(clk,rst,~Stall_D,Flush_D, pc_F,pc_D);

	assign opcode_D = instr_D[31:26];
	assign funct_D = instr_D[5:0];
	assign rs_D = instr_D[25:21];
	assign rt_D = instr_D[20:16];
	assign rd_D = instr_D[15:11];
	assign sa_D = instr_D[10:6];

	signextend signextend(opcode_D, funct_D, instr_D[15:0], sign_imm_D);
	assign pc_branch_D = pc_plus4_D + {sign_imm_D[29:0],2'b00};
	assign pc_jump_D = {pc_plus4_D[31:28],instr_D[25:0],2'b00};
	assign a1_D = (ForwardA_D) ? alu_out_M: a_D;
	assign b1_D = (ForwardB_D) ? alu_out_M: b_D;

	//===============================Execute
	flopenrc #(32) r1E(clk,rst,~Stall_E,Flush_E,a1_D,a_E);
	flopenrc #(32) r2E(clk,rst,~Stall_E,Flush_E,b_D,b_E);
	flopenrc #(32) r3E(clk,rst,~Stall_E,Flush_E,sign_imm_D,sign_imm_E);
	flopenrc #(5)  r4E(clk,rst,~Stall_E,Flush_E,rs_D,rs_E);
	flopenrc #(5)  r5E(clk,rst,~Stall_E,Flush_E,rt_D,rt_E);
	flopenrc #(5)  r6E(clk,rst,~Stall_E,Flush_E,rd_D,rd_E);
	flopenrc #(5)  r7E(clk,rst,~Stall_E,Flush_E,sa_D,sa_E);
	flopenrc #(32)  r10E(clk,rst,~Stall_E,Flush_E,pc_plus4_D,pc_plus4_E);
	flopenrc #(32)  r11E(clk,rst,~Stall_E,Flush_E,instr_D,instr_E);
	flopenrc #(32)  r12E(clk,rst,~Stall_E,Flush_E,pc_D,pc_E);
	flopenrc #(32)  r13E(clk,rst,~Stall_E,Flush_E,pc_jump_D,pc_jump_E);
	flopenrc #(32)  r14E(clk,rst,~Stall_E,Flush_E,pc_branch_D,pc_branch_E);

	mux3 #(32) forwardaemux(a_E,result_W,alu_out_M,ForwardA_E,a1_E); 
	mux3 #(32) forwardbemux(b_E,result_W,alu_out_M,ForwardB_E,b1_E);
	mux3 #(32) srcbmux3(b1_E, sign_imm_E, 32'b100, ALUSrcB_E, b2_E);
	alu alu(clk,rst,a2_E,b2_E,sa_E,ALUControl_E,alu_out_E, hi_out_E, lo_out_E, alu_ready_E);
	assign write_reg_E = (WriteReg_E) ? 5'b11111:
						( RegDst_E  ) ? rd_E: rt_E;
	assign hi_write_data_E = (HiSrc_E) ? hi_out_E: a1_E; 
	assign lo_write_data_E = (LoSrc_E) ? lo_out_E: a1_E;
	assign a2_E = (ALUSrcA_E) ? pc_plus4_E: a1_E;
	// TODO
	storeselect storeselect(instr_E, b1_E, write_data_E);

	//=========================================Memory
	floprc #(32) r1M(clk,rst,Flush_M,write_data_E,write_data_M);
	floprc #(32) r2M(clk,rst,Flush_M,alu_out_E,alu_out_M);
	floprc #(5)  r3M(clk,rst,Flush_M,write_reg_E,write_reg_M);
	floprc #(32)  r6M(clk,rst,Flush_M,instr_E,instr_M);
	floprc #(32)  r7M(clk,rst,Flush_M,pc_E,pc_M);
	floprc #(32)  r8M(clk,rst,Flush_M,hi_write_data_E,hi_write_data_M);
	floprc #(32)  r9M(clk,rst,Flush_M,lo_write_data_E,lo_write_data_M);
	floprc #(1)  r10M(clk,rst,Flush_M,alu_ready_E,alu_ready_M);
	floprc #(32)  r11M(clk,rst,Flush_M,a_E,a_M);
	floprc #(32)  r12M(clk,rst,Flush_M,pc_jump_E,pc_jump_M);
	floprc #(32)  r13M(clk,rst,Flush_M,pc_plus4_E,pc_plus4_M);
	floprc #(32)  r14M(clk,rst,Flush_M,pc_branch_E,pc_branch_M);
	// TODO 
	loadselect loadselect(instr_M, read_word_data_M, read_data_M);
	// alu_ready, 防止除法未计算完毕写入hi lo寄存�?
	hiloreg HI(clk, HiWrite_W & alu_ready_W, hi_write_data_W, hi_read_data_M);
	hiloreg LO(clk, LoWrite_W & alu_ready_W, lo_write_data_W, lo_read_data_M);
	// TODO 数据冒险 前推HI LO寄存器到Mem阶段的�?? （div mfhi mflo�?
	assign hi_read_data1_M = (ForwardHi_M) ? hi_write_data_W: hi_read_data_M;
	assign lo_read_data1_M = (ForwardLo_M) ? lo_write_data_W: lo_read_data_M;

	//=========================================Writeback
	flopr #(32) r1W(clk,rst,alu_out_M,alu_out_W);
	flopr #(32) r2W(clk,rst,read_data_M,read_data_W);
	flopr #(5)  r3W(clk,rst,write_reg_M,write_reg_W);
	flopr #(32)  r4W(clk,rst,hi_read_data1_M,hi_read_data_W);
	flopr #(32)  r5W(clk,rst,lo_read_data1_M,lo_read_data_W);
	flopr #(32)  r6W(clk,rst,pc_M,pc_W);
	flopr #(32)  r7W(clk,rst,hi_write_data_M,hi_write_data_W);
	flopr #(32)  r8W(clk,rst,lo_write_data_M,lo_write_data_W);
	flopr #(1)  r9W(clk,rst,alu_ready_M,alu_ready_W);
	flopr #(32)  r10W(clk,rst,a_M,a_W);
	flopr #(32)  r11W(clk,rst,pc_jump_M,pc_jump_W);
	flopr #(32)  r12W(clk,rst,pc_plus4_M,pc_plus4_W);
	flopr #(32)  r13W(clk,rst,pc_branch_M,pc_branch_W);

	mux4 #(32) resultWmux4(alu_out_W,read_data_W,hi_read_data_W,lo_read_data_W,MemtoReg_W,result_W);
endmodule
