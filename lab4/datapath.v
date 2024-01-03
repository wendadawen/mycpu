`timescale 1ns / 1ps

module datapath(
	input clk,rst,
	/**************FET****************/
	output pc_F,
	input instr_F,
	/**************DEC****************/
	input Branch1_D,
	input Branch2_D,
	input JumpJr_D,
	output instr_D,
	output a1_D,
	output b1_D,
	input ALUControl_D,
	input Jump_D,
	/**************EXE****************/
	input MemtoReg_E,
	input RegDst_E,
	input RegWrite_E,
	input ALUControl_E,
	output Flush_E,
	input LoSrc_E, 
	input HiSrc_E,
	output Stall_E,
	input ALUSrcA_E,
	input ALUSrcB_E,
	input WriteReg_E,
	input Jump_E,
	/**************MEM****************/
	input MemtoReg_M,
	input RegWrite_M,
	output alu_out_M,
	output write_data_M,
	input read_word_data_M,
	output Flush_M,
	input Jump_M,
	/**************WB****************/
	input MemtoReg_W,
	input RegWrite_W,
	output write_reg_W,
	output result_W,pc_W,
	input LoWrite_W, HiWrite_W,
	input PCSrc_W,
	input Jump_W
);
	wire clk, rst;
	wire [31:0] pc_next_F;
	wire [31:0] pc_F, pc_D, pc_E, pc_M, pc_W;
	wire [31:0] pc_plus4_F, pc_plus4_D, pc_plus4_E, pc_plus4_M, pc_plus4_W;
	wire [31:0] instr_F, instr_D, instr_E, instr_M;
	wire [31:0] read_word_data_M;
	wire [4:0] rs_D,rs_E;
	wire [4:0] rt_D,rt_E;
	wire [4:0] rd_D,rd_E;
	wire [31:0] sign_imm_D, sign_imm_E;
	wire [31:0] a_D,a_E, a_M, a_W;
	wire [31:0] b_D, b_E;
	wire [31:0] a1_D, a1_E;
	wire [31:0] a2_E;
	wire [31:0] b1_D, b1_E;
	wire [31:0] b2_E;
	wire [4:0] sa_D, sa_E;
	wire [31:0] pc_branch_D, pc_branch_E, pc_branch_M, pc_branch_W;
	wire [31:0] pc_jump_D, pc_jump_E, pc_jump_M, pc_jump_W;
	wire [5:0] opcode_D;
	wire [5:0] funct_D;
	wire [31:0] hi_write_data_D, hi_write_data_E, hi_write_data_M, hi_write_data_W;
	wire [31:0] lo_write_data_D, lo_write_data_E, lo_write_data_M, lo_write_data_W;
	wire [4:0] write_reg_E, write_reg_M, write_reg_W;
	wire [31:0] alu_out_E, alu_out_M, alu_out_W;
	wire [31:0] hi_out_E;
	wire [31:0] lo_out_E;
	wire alu_ready_E, alu_ready_M, alu_ready_W;
	wire [31:0] write_data_E, write_data_M;
	wire [31:0] hi_read_data_M, hi_read_data_W;
	wire [31:0] lo_read_data_W, lo_read_data_M;
	wire [31:0] read_data_M, read_data_W;
	wire [31:0] hi_read_data1_M, lo_read_data1_M;
	wire [31:0] result_W;
	
	wire WriteReg_E;
	wire RegDst_E;
	wire RegWrite_E, RegWrite_M, RegWrite_W;
	wire LoWrite_W,HiWrite_W;
	wire LoSrc_E, HiSrc_E;
	wire ALUSrcA_E;
	wire [1:0] ALUSrcB_E;
	wire [1:0] MemtoReg_E, MemtoReg_M, MemtoReg_W;
	wire [7:0] ALUControl_D, ALUControl_E;
	wire [1:0] PCSrc_W;
	wire Branch1_D;
	wire Branch2_D;
	wire JumpJr_D;
	wire Jump_D, Jump_E, Jump_M, Jump_W;
	
	wire Stall_F, Stall_D, Stall_E;
	wire ForwardA_D,ForwardB_D;
	wire [1:0] ForwardA_E,ForwardB_E;
	wire Flush_D, Flush_E, Flush_M;
	wire  ForwardHi_M, ForwardLo_M;


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
	flopenrc #(32) r2E(clk,rst,~Stall_E,Flush_E,b1_D,b_E);
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
