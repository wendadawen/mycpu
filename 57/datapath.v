`timescale 1ns / 1ps
`include "defines.vh"
module datapath(
	input clk,rst,
	output stall,
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
	input JumpJ_D,
	input Invaild_D,
	input Branch_D,
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
	input Branch1_E,
	input Branch2_E,
	input Cp0Write_E,
	/**************MEM****************/
	input MemtoReg_M,
	input RegWrite_M,
	output alu_out_M,
	output write_data_M,
	input read_word_data_M,
	output Flush_M,
	input Jump_M,
	output Stall_M,
	output except_type_M,
	input Cp0Write_M,
	input Branch1_M,
	input Branch2_M,
	/**************WB****************/
	input MemtoReg_W,
	input RegWrite_W,
	output write_reg_W,
	output result_W,pc_W,
	input LoWrite_W, HiWrite_W,
	input PCSrc_W,
	input Jump_W,
	output Stall_W, Flush_W,
	input Cp0Write_W,
	input Branch1_W,
	input Branch2_W
);
	wire clk, rst;
	wire [31:0] pc_next_F;
	wire [31:0] pc_F, pc_D, pc_E, pc_M, pc_W;
	wire [31:0] pc_plus4_F, pc_plus4_D, pc_plus4_E, pc_plus4_M, pc_plus4_W;
	wire [31:0] instr_F, instr_D, instr_E, instr_M, instr_W;
	wire [31:0] read_word_data_M;
	wire [4:0] rs_D,rs_E;
	wire [4:0] rt_D,rt_E;
	wire [4:0] rd_D,rd_E,rd_M,rd_W;
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
	wire [5:0] opcode_D, opcode_M;
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
	wire [2:0] MemtoReg_E, MemtoReg_M, MemtoReg_W;
	wire [7:0] ALUControl_D, ALUControl_E;
	wire [1:0] PCSrc_W;
	wire Branch_D;
	wire Branch1_D;
	wire Branch2_D;
	wire JumpJr_D;
	wire JumpJ_D;
	wire Jump_D, Jump_E, Jump_M, Jump_W;

	wire [7:0] Exception_F, Exception_D, Exception_E, Exception_M;
	wire IsInDelayslot_F, IsInDelayslot_D, IsInDelayslot_E, IsInDelayslot_M;
	wire [31:0] cp0_status_M, cp0_cause_M, cp0_epc_M;
	wire Cp0Write_W;
	wire [31:0] cp0_read_data_M, cp0_read_data_W;
	wire [31:0] cp0_read_data1_M;
	wire [31:0] except_type_M, pc_new_M;
	wire [31:0] bad_addr_M;
	wire Syscall_D;
	wire Break_D;
	wire Eret_D;
	wire Invaild_D;
	wire Overflow_E;
	wire Adel_M;
	wire Ades_M;
	
	
	wire Stall_F, Stall_D, Stall_E, Stall_M, Stall_W;
	wire Flush_F, Flush_D, Flush_E, Flush_M, Flush_W;
	wire ForwardA_D,ForwardB_D;
	wire [1:0] ForwardA_E,ForwardB_E;
	wire  ForwardHi_M, ForwardLo_M, ForwardCp0_M;
	wire stall;


	//Hazard
	hazard h(
		stall,
		//fetch stage
		Stall_F, Flush_F,
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
		Stall_M,
		except_type_M,
		ForwardCp0_M,
		rd_M,
		Cp0Write_M,
		//write back stage
		write_reg_W,
		RegWrite_W,
		HiWrite_W, LoWrite_W,
		Jump_W,
		Flush_W,
		Stall_W,
		Cp0Write_W,
		rd_W
	);
	// regfile
	regfile rf(
		clk,
		RegWrite_W,
		rs_D,rt_D,write_reg_W, 
		result_W,
		a_D,b_D 
	);
	
	//===============================Fetch
	mux4 #(32) pcmux4(pc_plus4_F,pc_branch_W,pc_jump_W,a_W,PCSrc_W,pc_next_F);
	assign pc_plus4_F = pc_F + 4;
	pc #(32) pcreg(clk,rst,~Stall_F,Flush_F,pc_new_M,pc_next_F,pc_F);
	// TODO
	assign Exception_F = (pc_F[1:0]==2'b00) ? 8'b0000_0000: 8'b1000_0000;
	assign IsInDelayslot_F = Jump_W | ( ~Jump_D & (Branch1_D | Branch2_D));
	
	//===============================Decode
	flopenrc #(32) r1D(clk,rst,~Stall_D,Flush_D, pc_plus4_F,pc_plus4_D);
	flopenrc #(32) r2D(clk,rst,~Stall_D,Flush_D, instr_F,instr_D);
	flopenrc #(32) r3D(clk,rst,~Stall_D,Flush_D, pc_F,pc_D);
	flopenrc #(8) r4D(clk,rst,~Stall_D, Flush_D, Exception_F,Exception_D);
	flopenrc #(1) r5D(clk,rst,~Stall_D, Flush_D, IsInDelayslot_F,IsInDelayslot_D);

	assign opcode_D = instr_D[31:26];
	assign funct_D = instr_D[5:0];
	assign rs_D = instr_D[25:21];
	assign rt_D = instr_D[20:16];
	signextend signextend(opcode_D, funct_D, instr_D[15:0], sign_imm_D);
	assign pc_branch_D = pc_plus4_D + {sign_imm_D[29:0],2'b00};
	assign pc_jump_D = {pc_plus4_D[31:28],instr_D[25:0],2'b00};
	assign a1_D = (ForwardA_D) ? alu_out_M: a_D;
	assign b1_D = (ForwardB_D) ? alu_out_M: b_D;
	// TODO
	assign Syscall_D = (opcode_D==`OP_SYSCALL & funct_D==`FUNCT_SYSCALL);
	assign Break_D = (opcode_D==`OP_BREAK & funct_D==`FUNCT_BREAK);
	assign Eret_D = (instr_D==`INSTR_ERET);

	//===============================Execute
	flopenrc #(32) r1E(clk,rst,~Stall_E,Flush_E,a1_D,a_E);
	flopenrc #(32) r2E(clk,rst,~Stall_E,Flush_E,b1_D,b_E);
	flopenrc #(32) r3E(clk,rst,~Stall_E,Flush_E,sign_imm_D,sign_imm_E);
	flopenrc #(32)  r10E(clk,rst,~Stall_E,Flush_E,pc_plus4_D,pc_plus4_E);
	flopenrc #(32)  r11E(clk,rst,~Stall_E,Flush_E,instr_D,instr_E);
	flopenrc #(32)  r12E(clk,rst,~Stall_E,Flush_E,pc_D,pc_E);
	flopenrc #(32)  r13E(clk,rst,~Stall_E,Flush_E,pc_jump_D,pc_jump_E);
	flopenrc #(32)  r14E(clk,rst,~Stall_E,Flush_E,pc_branch_D,pc_branch_E);
	flopenrc #(1)  r15E(clk,rst,~Stall_E,Flush_E,IsInDelayslot_D,IsInDelayslot_E);
	flopenrc #(8)  r16E(clk,rst,~Stall_E,Flush_E,
						{Exception_D[7],Syscall_D,Break_D,Eret_D,Invaild_D,Exception_D[2:0]},
						Exception_E);

	mux3 #(32) forwardaemux(a_E,result_W,alu_out_M,ForwardA_E,a1_E); 
	mux3 #(32) forwardbemux(b_E,result_W,alu_out_M,ForwardB_E,b1_E);
	mux3 #(32) srcbmux3(b1_E, sign_imm_E, 32'b100, ALUSrcB_E, b2_E);
	assign rs_E = instr_E[25:21];
	assign rt_E = instr_E[20:16];
	assign rd_E = instr_E[15:11];
	assign sa_E = instr_E[10:6];
	alu alu(clk,rst,a2_E,b2_E,sa_E,ALUControl_E,alu_out_E, hi_out_E, lo_out_E, alu_ready_E, Overflow_E);
	assign write_reg_E = (WriteReg_E) ? 5'b11111:
						( RegDst_E  ) ? rd_E: rt_E;
	assign hi_write_data_E = (HiSrc_E) ? hi_out_E: a1_E; 
	assign lo_write_data_E = (LoSrc_E) ? lo_out_E: a1_E;
	assign a2_E = (ALUSrcA_E) ? pc_plus4_E: a1_E;
	// TODO
	storeselect storeselect(instr_E, b1_E, write_data_E);

	//=========================================Memory
	flopenrc #(32)  r1M(clk,rst,~Stall_M,Flush_M,write_data_E,write_data_M);
	flopenrc #(32)  r2M(clk,rst,~Stall_M,Flush_M,alu_out_E,alu_out_M);
	flopenrc #(5)   r3M(clk,rst,~Stall_M,Flush_M,write_reg_E,write_reg_M);
	flopenrc #(32)  r6M(clk,rst,~Stall_M,Flush_M,instr_E,instr_M);
	flopenrc #(32)  r7M(clk,rst,~Stall_M,Flush_M,pc_E,pc_M);
	flopenrc #(32)  r8M(clk,rst,~Stall_M,Flush_M,hi_write_data_E,hi_write_data_M);
	flopenrc #(32)  r9M(clk,rst,~Stall_M,Flush_M,lo_write_data_E,lo_write_data_M);
	flopenrc #(1)   r10M(clk,rst,~Stall_M,Flush_M,alu_ready_E,alu_ready_M);
	flopenrc #(32)  r11M(clk,rst,~Stall_M,Flush_M,a_E,a_M);
	flopenrc #(32)  r12M(clk,rst,~Stall_M,Flush_M,pc_jump_E,pc_jump_M);
	flopenrc #(32)  r13M(clk,rst,~Stall_M,Flush_M,pc_plus4_E,pc_plus4_M);
	flopenrc #(32)  r14M(clk,rst,~Stall_M,Flush_M,pc_branch_E,pc_branch_M);
	flopenrc #(1)   r15M(clk,rst,~Stall_M,Flush_M,IsInDelayslot_E,IsInDelayslot_M);
	flopenrc #(8)   r16M(clk,rst,~Stall_M,Flush_M,
					{Exception_E[7:3], Overflow_E,Exception_E[1:0]}
					,Exception_M);

	// TODO
	assign rd_M = instr_M[15:11];
	// TODO 
	loadselect loadselect(instr_M, read_word_data_M, read_data_M);
	// alu_ready, 防止除法未计算完毕写入hi lo
	hiloreg HI(clk, HiWrite_W & alu_ready_W, hi_write_data_W, hi_read_data_M);
	hiloreg LO(clk, LoWrite_W & alu_ready_W, lo_write_data_W, lo_read_data_M);
	// TODO 数据冒险 前推HI LO CP0寄存器到Mem阶段
	assign hi_read_data1_M = (ForwardHi_M) ? hi_write_data_W: hi_read_data_M;
	assign lo_read_data1_M = (ForwardLo_M) ? lo_write_data_W: lo_read_data_M;
	// assign cp0_read_data1_M = (ForwardCp0_M) ? alu_out_M: cp0_read_data_M;
	// TODO
	assign opcode_M = instr_M[31:26];
	assign Adel_M = ((opcode_M==`OP_LH|opcode_M==`OP_LHU)&alu_out_M[0]) | (opcode_M==`OP_LW&alu_out_M[1:0]!=2'b00);
	assign Ades_M = ( opcode_M==`OP_SH&alu_out_M[0]) | (opcode_M==`OP_SW&alu_out_M[1:0]!=2'b00);
	assign bad_addr_M = (Exception_M[7]) ? pc_M:
						(Adel_M | Ades_M) ? alu_out_M: 32'h0000_0000;
						
	// TODO
	exception exception(
		rst, stall,
		Exception_M, 
		Adel_M, Ades_M,
		cp0_status_M, cp0_cause_M, cp0_epc_M,
		Cp0Write_M, rd_M, alu_out_M,
		except_type_M, pc_new_M
	);
	// TODO
	cp0_reg CP0(
		.clk(clk),
		.rst(rst),
		.longest_stall(stall),
		
		// mfc0 mtc0
		.we_i(Cp0Write_M),
		.waddr_i(rd_M), 
		.raddr_i(rd_M),
		.data_i(alu_out_M),
		
		.int_i(6'b000000),
		
		.excepttype_i(except_type_M),
		.current_inst_addr_i(pc_M),
		.is_in_delayslot_i(IsInDelayslot_M),
		.bad_addr_i(bad_addr_M),

		.data_o(cp0_read_data_M),
		.status_o(cp0_status_M),
		.cause_o(cp0_cause_M),
		.epc_o(cp0_epc_M)
	);

	//=========================================Writeback
	flopenrc #(32)   r1W(clk,rst,~Stall_W,Flush_W,alu_out_M,alu_out_W);
	flopenrc #(32)   r2W(clk,rst,~Stall_W,Flush_W,read_data_M,read_data_W);
	flopenrc #(5)    r3W(clk,rst,~Stall_W,Flush_W,write_reg_M,write_reg_W);
	flopenrc #(32)   r4W(clk,rst,~Stall_W,Flush_W,hi_read_data1_M,hi_read_data_W);
	flopenrc #(32)   r5W(clk,rst,~Stall_W,Flush_W,lo_read_data1_M,lo_read_data_W);
	flopenrc #(32)   r6W(clk,rst,~Stall_W,Flush_W,pc_M,pc_W);
	flopenrc #(32)   r7W(clk,rst,~Stall_W,Flush_W,hi_write_data_M,hi_write_data_W);
	flopenrc #(32)   r8W(clk,rst,~Stall_W,Flush_W,lo_write_data_M,lo_write_data_W);
	flopenrc #(1)    r9W(clk,rst,~Stall_W,Flush_W,alu_ready_M,alu_ready_W);
	flopenrc #(32)  r10W(clk,rst,~Stall_W,Flush_W,a_M,a_W);
	flopenrc #(32)  r11W(clk,rst,~Stall_W,Flush_W,pc_jump_M,pc_jump_W);
	flopenrc #(32)  r12W(clk,rst,~Stall_W,Flush_W,pc_plus4_M,pc_plus4_W);
	flopenrc #(32)  r13W(clk,rst,~Stall_W,Flush_W,pc_branch_M,pc_branch_W);
	flopenrc #(32)  r14W(clk,rst,~Stall_W,Flush_W,instr_M,instr_W);
	flopenrc #(32)  r15W(clk,rst,~Stall_W,Flush_W,cp0_read_data_M,cp0_read_data_W);

	assign rd_W = instr_W[15:11];
	mux5 #(32) resultWmux5(alu_out_W,read_data_W,hi_read_data_W,lo_read_data_W,cp0_read_data_W,MemtoReg_W,result_W);
endmodule
