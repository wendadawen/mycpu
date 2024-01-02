`timescale 1ns / 1ps

module datapath(
	input wire clk,rst,
	//fetch stage
	output wire [31:0] pc_F,
	input wire [31:0] instr_F,
	//decode stage
	input wire [1:0] PCSrc_D,
	input wire Branch_D,
	input wire JumpJr_D,
	output wire [31:0] instr_D,
	output wire [31:0] a1_D, b1_D,
	input wire Jump_D,
	//execute stage
	input wire [1:0]MemtoReg_E,
	input wire RegDst_E,
	input wire RegWrite_E,
	input wire[7:0] ALUControl_E,
	output wire Flush_E,
	input wire LoWrite_E, HiWrite_E,
	input wire LoSrc_E, HiSrc_E,
	output wire Stall_E,
	input wire ALUSrcA_E,
	input wire [1:0] ALUSrcB_E,
	input wire WriteReg_E,
	//mem stage
	input wire [1:0]MemtoReg_M,
	input wire RegWrite_M,
	output wire [31:0] alu_out_M,write_data_M,
	input wire [31:0] read_word_data_M,
	output wire Flush_M,
	input wire WriteReg_M,
	//writeback stage
	input wire [1:0]MemtoReg_W,
	input wire RegWrite_W,
	input wire WriteReg_W
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
	wire [31:0] a_D,a1_D,b_D,b1_D;
	wire [4:0] sa_D;
	wire [31:0] hi_read_data_D, lo_read_data_D;
	wire [31:0] pc_branch_D, pc_jump_D;
	wire [4:0] write_regs_D;
	wire [5:0] opcode_D, funct_D;
	wire Flush_D;

	//execute stage
	wire [1:0] ForwardA_E,ForwardB_E;
	wire [4:0] rs_E,rt_E,rd_E;
	wire [4:0] write_reg_E;
	wire [31:0] sign_imm_E;
	wire [31:0] a_E,a1_E,b_E,b1_E,b2_E;
	wire [31:0] alu_out_E;
	wire [4:0] sa_E;
	wire [31:0] hi_read_data_E, lo_read_data_E;
	wire [31:0] hi_write_data_E, lo_write_data_E, hi_out_E, lo_out_E;
	wire alu_ready_E;
	wire [31:0] pc_plus4_E, a2_E;
	wire [31:0] write_data_E;
	wire [31:0] instr_E;

	//mem stage
	wire [4:0] write_reg_M;
	wire [31:0] hi_read_data_M, lo_read_data_M;
	wire [31:0] read_data_M;
	wire [31:0] instr_M;

	//writeback stage
	wire [4:0] write_reg_W;
	wire [31:0] alu_out_W,read_data_W,result_W;
	wire [31:0] hi_read_data_W, lo_read_data_W;

	//Hazard
	hazard h(
		//fetch stage
		Stall_F,
		//decode stage
		rs_D,rt_D,
		Branch_D,
		ForwardA_D,ForwardB_D,
		Stall_D,
		JumpJr_D,
		Flush_D,
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
		WriteReg_E,
		//mem stage
		write_reg_M,
		RegWrite_M,
		MemtoReg_M,
		Flush_M,
		WriteReg_M,
		//write back stage
		write_reg_W,
		RegWrite_W,
		WriteReg_W
	);
	
	//===============================Fetch
	mux4 #(32) pcmux4(pc_plus4_F,pc_branch_D,pc_jump_D,a1_D,PCSrc_D,pc_next_F);
	assign pc_plus4_F = pc_F + 4;
	pc #(32) pcreg(clk,rst,~Stall_F,pc_next_F,pc_F);
	
	//===============================Decode
	regfile rf(
		clk,
		RegWrite_W,
		rs_D,rt_D,write_regs_D, 
		result_W,
		a_D,b_D 
	);

	flopenrc #(32) r1D(clk,rst,~Stall_D,Flush_D, pc_plus4_F,pc_plus4_D);
	flopenrc #(32) r2D(clk,rst,~Stall_D,Flush_D, instr_F,instr_D);

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
	hiloreg HI(clk, HiWrite_E & alu_ready_E, hi_write_data_E, hi_read_data_D);
	hiloreg LO(clk, LoWrite_E & alu_ready_E, lo_write_data_E, lo_read_data_D);
	assign write_regs_D = (WriteReg_W) ? 5'b11111: write_reg_W;


	//===============================Execute
	flopenrc #(32) r1E(clk,rst,~Stall_E,Flush_E,a_D,a_E);
	flopenrc #(32) r2E(clk,rst,~Stall_E,Flush_E,b_D,b_E);
	flopenrc #(32) r3E(clk,rst,~Stall_E,Flush_E,sign_imm_D,sign_imm_E);
	flopenrc #(5)  r4E(clk,rst,~Stall_E,Flush_E,rs_D,rs_E);
	flopenrc #(5)  r5E(clk,rst,~Stall_E,Flush_E,rt_D,rt_E);
	flopenrc #(5)  r6E(clk,rst,~Stall_E,Flush_E,rd_D,rd_E);
	flopenrc #(5)  r7E(clk,rst,~Stall_E,Flush_E,sa_D,sa_E);
	flopenrc #(32)  r8E(clk,rst,~Stall_E,Flush_E,hi_read_data_D,hi_read_data_E);
	flopenrc #(32)  r9E(clk,rst,~Stall_E,Flush_E,lo_read_data_D,lo_read_data_E);
	flopenrc #(32)  r10E(clk,rst,~Stall_E,Flush_E,pc_plus4_D,pc_plus4_E);
	flopenrc #(32)  r11E(clk,rst,~Stall_E,Flush_E,instr_D,instr_E);

	mux3 #(32) forwardaemux(a_E,result_W,alu_out_M,ForwardA_E,a1_E); 
	mux3 #(32) forwardbemux(b_E,result_W,alu_out_M,ForwardB_E,b1_E);
	mux3 #(32) srcbmux3(b1_E, sign_imm_E, 32'b100, ALUSrcB_E, b2_E);
	alu alu(clk,rst,a2_E,b2_E,sa_E,ALUControl_E,alu_out_E, hi_out_E, lo_out_E, alu_ready_E);
	assign write_reg_E = (RegDst_E) ? rd_E: rt_E;
	assign hi_write_data_E = (HiSrc_E) ? hi_out_E: a1_E; 
	assign lo_write_data_E = (LoSrc_E) ? lo_out_E: a1_E;
	assign a2_E = (ALUSrcA_E) ? pc_plus4_E: a1_E;
	storeselect storeselect(instr_E, b1_E, write_data_E);

	//=========================================Memory
	floprc #(32) r1M(clk,rst,Flush_M,write_data_E,write_data_M);
	floprc #(32) r2M(clk,rst,Flush_M,alu_out_E,alu_out_M);
	floprc #(5)  r3M(clk,rst,Flush_M,write_reg_E,write_reg_M);
	floprc #(32)  r4M(clk,rst,Flush_M,hi_read_data_E,hi_read_data_M);
	floprc #(32)  r5M(clk,rst,Flush_M,lo_read_data_E,lo_read_data_M);
	floprc #(32)  r6M(clk,rst,Flush_M,instr_E,instr_M);

	loadselect loadselect(instr_M, read_word_data_M, read_data_M);

	//=========================================Writeback
	flopr #(32) r1W(clk,rst,alu_out_M,alu_out_W);
	flopr #(32) r2W(clk,rst,read_data_M,read_data_W);
	flopr #(5)  r3W(clk,rst,write_reg_M,write_reg_W);
	flopr #(32)  r4W(clk,rst,hi_read_data_M,hi_read_data_W);
	flopr #(32)  r5W(clk,rst,lo_read_data_M,lo_read_data_W);
	mux4 #(32) resultWmux4(alu_out_W,read_data_W,hi_read_data_W,lo_read_data_W,MemtoReg_W,result_W);
endmodule
