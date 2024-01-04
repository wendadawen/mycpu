`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
	input wire clk,
	input wire rst,
	//fetch stage
	input wire[31:0] instrF,
	output wire[31:0] pcF,
	
	//decode stage
	input wire pcsrcD,
	input wire branchD,
	input wire jumpD,
	input wire jalD,
	input wire jrD,
	input wire balD,
	input wire memenD,
	input wire breakD,
	input wire syscallD,
	input wire reserve_instructionD,
	input wire eretD,
	input wire[7:0] alucontrolD,
	output wire equalD,
	output wire[5:0] opD,
	output wire[5:0] functD,
	output wire[4:0] rtD,
	output wire[31:0] instrD,
	output wire stallD,
	//execute stage
	input wire memtoregE,
	input wire alusrcE,
	input wire regdstE,
	input wire regwriteE,
	input wire[7:0] alucontrolE,
	input wire jumpE, 
	input wire jalE, 
	input wire jrE,
	input wire balE,
	input wire memenE,
	input wire HiLoWriteE,
	output wire flushE,
	output wire stallE,
	//mem stage
	input wire memtoregM,
	input wire regwriteM,
	input wire mtcp0M,
	input wire mfcp0M,
	input wire[31:0] readdataM,
	output wire[31:0] aluout2M,
	output wire[31:0] writedata2M,
	output wire[3:0] write_memM,
	output wire flushM,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW,
	output wire flushW,
	output wire [31:0]pcW,
	output wire [4:0] writeregW,
	output wire [31:0] resultW
    );

 
	//fetch stage
	wire stallF;
	wire flushF;
	wire branchjumpF;
	wire [31:0] newPC;
	wire [31:0] pcnextFD,pcnextbrFD,pcplus4F, pcplus8F;
	//decode stage
	wire [31:0] pcbranchD, pcD, pcplus4D,pcplus8D, pcnext_temp;
	wire forwardaD,forwardbD;
	wire jrforwardaD; 
	wire branchjumpD, jrb_l_astall, jrb_l_bstall;
	wire [6:0]exceptD; // 一共7种例外
	wire [4:0] rsD,rdD, saD;
	wire flushD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D, srca2jD, srca3D, srcb3D;
	wire [15:0] offsetD;
	//execute stage
	wire [31:0] pcE, instrE, pcplus4E, pcplus8E;
	wire [1:0] forwardaE,forwardbE;
	wire [4:0] rsE, rtE, rdE, saE;
	wire [4:0] writeregE, writereg_jalrE, writereg2E;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
	wire [31:0] aluoutE, aluout2E;
	wire [15:0] offsetE;
	wire overflowE, branchjumpE;
	wire [6:0] exceptE;
	//mem stage
	wire [4:0] writeregM, rdM;
	wire [7:0] alucontrolM;
	wire overflowM, branchjumpM, addr_load_except_M, addr_store_except_M;
	wire [31:0] writedataM, pcM, aluout1M, srcbM;
	wire [31:0] aluoutM;
	wire [31:0] cp0out_data;
	wire [6:0] exceptM;
	wire [`RegBus] status_o;
	wire [`RegBus] cause_o;
	wire [`RegBus] excepttype_i;
	wire [`RegBus] bad_addr_i;
	wire [`RegBus] count_o;
	wire [`RegBus] compare_o;
	wire [`RegBus] epc_o;
	wire [`RegBus] config_o;
	wire [`RegBus] prid_o;
	wire [`RegBus] badvaddr;
	wire timer_int_o;
	//writeback stage
	wire addr_load_except_W;
	wire [7:0] alucontrolW;
	wire [31:0] aluoutW,readdataW, lw_resultW;
	// 与乘法和除法相关的两个寄存器
	wire[63:0] hilo_in, hilo_out;

	//hazard detection
	hazard h(
		//fetch stage
		stallF,
		newPC,
		flushF,
		//decode stage
		rsD,
		rtD,
		branchD,
		jumpD,
		jrD,
		alucontrolD,
		forwardaD,
		forwardbD,
		jrforwardaD,
		stallD,
		jrb_l_astall,
		jrb_l_bstall,
		flushD,
		//execute stage
		rsE,
		rtE,
		writeregE,
		regwriteE,
		memtoregE,
		HiLoWriteE,
		alucontrolE,
		ready_o,
		forwardaE,
		forwardbE,
		flushE,
		stallE,
		//mem stage
		writeregM,
		regwriteM,
		memtoregM,
		excepttype_i,
		overflowM,
		flushM,
		epc_o,
		//write back stage
		writeregW,
		regwriteW,
		flushW
		);

	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	// next PC = pcNext or j / jal
	mux2 #(32) pcjumpmux(pcnextbrFD, {pcplus4D[31:28],instrD[25:0],2'b00}, jumpD | jalD, pcnext_temp);
	// next PC = pcnext_temp or jr
	mux2 #(32) pcjrmux(pcnext_temp, srca2D, jrD, pcnextFD);

	// 判断是否是跳转指令
	assign branchjumpF = branchD | jumpD | jalD | jrD; // 分支指令的判断提前到译码阶段，一部分比较逻辑在译码时完成，而不用等到执行阶段。这样可以少一个气泡
	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

	//fetch stage logic
	pc #(32) pcreg(clk,rst,~stallF,flushF, pcnextFD, newPC, pcF); // 这里的newPC是出现异常而需要选择的地址bfc00380
	adder pcadd1(pcF,32'b100,pcplus4F); // 顺序读取的指令
	adder pcadd2(pcF, 32'b1000, pcplus8F); // jal / jalr / bltzal / bgezal 等指令需要的 GPR[31] ← PC + 8



	// fetch to decode stage pipeline
	flopenrc #(32) r1D(clk,rst,~stallD,flushD, pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	flopenrc #(32) r3D(clk,rst,~stallD,flushD,pcF,pcD);
	flopenrc #(32) r4D(clk,rst,~stallD,flushD,pcplus8F,pcplus8D);
	flopenrc #(1) r5D(clk,rst,~stallD,flushD,branchjumpF,branchjumpD);
	//decode stage
	

	signext se(instrD[15:0],opD,signimmD);
	sl2 immsh(signimmD,signimmshD);
	adder pcadd3(pcplus4D,signimmshD,pcbranchD); // 计算branch指令的跳转地址 = pc + sign_extend({offset, 00})
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D); 
	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	// 提前判断branch指令需要数据前推
	mux2 #(32) forwardbjrb_lamux(srca2D, readdataM, jrb_l_astall, srca3D);
	mux2 #(32) forwardbjrb_lbmux(srcb2D, readdataM, jrb_l_bstall, srcb3D);
	eqcmp comp(srca3D,srcb3D, alucontrolD, equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6];
	assign offsetD = instrD[15:0];
	// 收集异常
	assign exceptD[3:0] = {reserve_instructionD, breakD, syscallD, eretD};
	//execute stage
	flopenrc #(32) 	r8E(clk,rst,~stallE,flushE,pcD,pcE);
	flopenrc #(32) 	r9E(clk,rst,~stallE,flushE,instrD,instrE);
	flopenrc #(32) 	r10E(clk,rst,~stallE,flushE,pcplus4D,pcplus4E);
	flopenrc #(32) 	r11E(clk,rst,~stallE,flushE,pcplus8D,pcplus8E);
	flopenrc #(1) 	r12E(clk,rst,~stallE,flushE,branchjumpD,branchjumpE);
	flopenr #(16) r13E(clk,rst,~stallE,offsetD,offsetE);
	flopenrc #(4) 	r14E(clk,rst,~stallE,flushE,exceptD[3:0],exceptE[3:0]);
	flopenrc #(32) r1E(clk,rst,~stallE, flushE,srcaD,srcaE);
	flopenrc #(32) r2E(clk,rst,~stallE, flushE,srcbD,srcbE);
	flopenrc #(32) r3E(clk,rst,~stallE, flushE,signimmD,signimmE);
	flopenrc #(5) r4E(clk,rst,~stallE, flushE,rsD,rsE);
	flopenrc #(5) r5E(clk,rst,~stallE, flushE,rtD,rtE);
	flopenrc #(5) r6E(clk,rst,~stallE, flushE,rdD,rdE);
	flopenrc #(5) r7E(clk, rst, ~stallE, flushE, saD, saE);

	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
	mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);

	// 与除法相关的几个信号
	wire [63:0] div_result;
	wire signed_div_i, start_i, annul_i, ready_o; // 是否是有符号除法，开始信号，取消信号, 除法结果是否准备好
	assign  annul_i = 1'b0;
	assign signed_div_i =  (alucontrolE == `EXE_DIV_OP)? 1'b1: 1'b0;
	assign start_i = ((alucontrolE == `EXE_DIV_OP | alucontrolE == `EXE_DIVU_OP) & ~ready_o) ? 1'b1 : 1'b0;
	div div(
		.clk(clk),
		.rst(rst),
		.signed_div_i(signed_div_i),	
		.opdata1_i(srca2E),		
		.opdata2_i(srcb3E),		
		.start_i(start_i),		
		.annul_i(annul_i),		
		.result_o(div_result),		
		.ready_o(ready_o)			
	);
	alu alu(srca2E,srcb3E,saE, alucontrolE,aluoutE, overflowE, hilo_in, hilo_out, offsetE);
	// HILO 寄存器
	hilo_reg hilo(
		.clk(clk),
		.rst(rst),
		.flush(flushE),
		.HiLoWrite_en(HiLoWriteE),
		.alucontrol(alucontrolE),
		.div_result_ready(ready_o),
		.div_result(div_result),
		.hi_i(hilo_out[63:32]),
		.lo_i(hilo_out[31:0]),
		.hi_o(hilo_in[63:32]),
		.lo_o(hilo_in[31:0])
	);
	assign exceptE[4] = overflowE;

	mux2 #(5) wrmux(rtE,rdE,regdstE,writeregE);
	// JALR指令选择写寄存器, 默认的是31号寄存器
	assign writereg_jalrE = (alucontrolE == `EXE_JALR_OP & writeregE == 0) ? 5'b11111 : writeregE;
	mux2 #(5) wrmux2(writereg_jalrE,5'b11111,jalE | balE,writereg2E);	//选择Link类指令的写寄存器
	mux2 #(32) wrmux23(aluoutE,pcplus8E,jalE|jrE|balE,aluout2E);	//选择写寄存器堆的数据，ALU计算结果 or jal等指令的跳转地址 ==> 延迟槽
	//mem stage
	
	floprc #(32) r1M(clk,rst,flushM, srcb2E,writedataM);
	floprc #(32) r2M(clk,rst,flushM,aluout2E,aluout2M);
	floprc #(5) r3M(clk,rst,flushM,writereg2E,writeregM);
	floprc #(1) r4M(clk, rst, flushM, overflowE, overflowM);
	floprc #(8) r5M(clk,rst,flushM,alucontrolE,alucontrolM);
	floprc #(5) r6M(clk,rst,flushM,rdE,rdM);
	floprc #(32) r7M(clk,rst,flushM,srcb3E,srcbM);
	floprc #(32) r8M(clk,rst,flushM,pcE,pcM);
	floprc #(1) r9M(clk,rst,flushM,branchjumpE,branchjumpM);
	floprc #(5) r10M(clk,rst,flushM,exceptE[4:0],exceptM[4:0]);


	//writeback stage
	//选择写入dataram的数据来自Aluout 还是 CP0
	mux2 #(32) cp0selmux(aluout2M, cp0out_data, mfcp0M, aluoutM);

	// sb, sh, sw指令
	sw_instr_select sw_select(
		.addr_store_M(addr_store_except_M), 
		.addressM(aluout2M),      //写内存地址,末两位决定写地址
		.alucontrolM(alucontrolM),    //指令类型
		.memwriteM(write_memM)  //写地址
	);
	// 地址例外
	address_except address_except(
		.addrs(aluoutM),     //访存地址
		.alucontrolM(alucontrolM),//访存类型
		.load_address_except(addr_load_except_M),     //LH、LW指令地址错例外
		.store_address_except(addr_store_except_M)        //LH、LW指令地址错例外
	);

	assign exceptM[6:5] = {addr_store_except_M, addr_load_except_M};

	assign writedata2M =	(alucontrolM == `EXE_SB_OP)? 
							{{writedataM[7:0]},{writedataM[7:0]},{writedataM[7:0]},{writedataM[7:0]}}:
							(alucontrolM == `EXE_SH_OP)? 
							{{writedataM[15:0]},{writedataM[15:0]}}:
							(alucontrolM == `EXE_SW_OP)?
							{{writedataM[31:0]}}:
							writedataM;

	// M ---> W
		
	floprc #(32) r1W(clk,rst,flushM,aluoutM,aluoutW);
	floprc #(32) r2W(clk,rst,flushW, readdataM,readdataW);
	floprc #(5) r3W(clk,rst,flushW, writeregM,writeregW);
	floprc #(8) r4W(clk,rst,flushW, alucontrolM,alucontrolW);
	floprc #(32) r5W(clk,rst,flushW,pcM,pcW);
	floprc #(1) r6W(clk,rst,flushW,addr_load_except_M,addr_load_except_W);


	// 选择写回regfile的数据来自aluout还是dataram
	mux2 #(32) resmux(aluoutW, readdataW, memtoregW,lw_resultW);


	// lw等访问内存指令
	lw_instr_select lwselect(
		.address_exceptation(addr_load_except_W),
		.aluoutW(aluoutW), 
		.alucontrol(alucontrolW), 
		.lw_result(lw_resultW), 
		.result(resultW) 
	);


	// 处理例外
	except except(
		.rst(rst), 
		.pcM(pcM),
		.exceptM(exceptM),
		.cp0_status(status_o),
		.cp0_cause(cause_o),
		.aluout(aluoutM),
		.except_type(excepttype_i),
		.bad_addr(bad_addr_i)
	);

	cp0_reg cp0_reg(
		.clk(clk),
		.rst(rst),
		.we_i(mtcp0M),
		.waddr_i(rdM),
		.raddr_i(rdM),
		.data_i(srcbM),
		.int_i(0),

		.excepttype_i(excepttype_i),
		.current_inst_addr_i(pcM),
		.is_in_delayslot_i(branchjumpM),
		.bad_addr_i(bad_addr_i),

		.count_o(count_o),
		.data_o(cp0out_data),
		.compare_o(compare_o),
		.status_o(status_o),
		.cause_o(cause_o),
		.epc_o(epc_o),
		.config_o(config_o),
		.prid_o(prid_o),
		.badvaddr(badvaddr),
		.timer_int_o(timer_int_o)
    );
endmodule
