`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	output wire[3:0] memwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM, 
	output wire [31:0] pcW,
	output wire regwriteW,
	output wire [4:0] writeregW,
	output wire [31:0] resultW,
	output wire memenM,
	output wire [31:0]pc_physicalF, // 要输出
	output wire [31:0]data_paddr,
	output wire cache
    );
	wire [31:0] instrD;
    wire stallD;
	wire [7:0] alucontrolD, alucontrolE;
	wire [5:0] opD,functD;
	wire [4:0] rtD;
	wire regdstE,alusrcE,pcsrcD, regwriteE,regwriteM;
	wire memtoregE,memtoregM,memtoregW;
	wire flushE,equalD;
	wire stallE;
	wire jumpD, jalD, jrD, balD;
	wire jumpE, jalE, jrE, balE;
	wire HiLoWriteD, HiLoWriteE, HiLoWriteM, HiLoWriteW;

	wire breakD,syscallD,reserve_instructionD,eretD;
	wire memenE;
	wire flushM;
	wire mtcp0M,mfcp0M;
	wire flushW;
	wire memenD;
	
	mmu mmu0(
		.inst_vaddr(pcF),
		.inst_paddr(pc_physicalF),
		.data_vaddr(aluoutM),
		.data_paddr(data_paddr),
		.no_dcache(cache) 
	);
	controller c(
		clk,
		rst,
		//decode stage
		instrD,
		opD,
		rtD,
		functD,
		stallD,
		pcsrcD,
		branchD,
		equalD,
		jumpD,
		jalD,
		jrD,
		balD,
		memenD,
		HiLoWriteD,
		breakD,
		syscallD,
		reserve_instructionD,
		eretD,
		alucontrolD,
		
		//execute stage
		flushE,
		memtoregE,
		alusrcE,
		regdstE,
		regwriteE,	
		alucontrolE,
		jumpE,
		jalE,
		jrE,
		balE,
		memenE,
		HiLoWriteE,
		//mem stage
		flushM,
		memtoregM,
		memenM,
		regwriteM,
		HiLoWriteM,
		mtcp0M,
		mfcp0M,
		//write back stage
		flushW,
		memtoregW,
		regwriteW,
		HiLoWriteW
		);

	datapath dp(
	.clk(clk),
	.rst(rst),
	//fetch stage
	.instrF(instrF),
	.pcF(pcF),
	
	//decode stage
	.pcsrcD(pcsrcD),
	.branchD(branchD),
	.jumpD(jumpD),
	.jalD(jalD),
	.jrD(jrD),
	.balD(balD),
	.memenD(memenD),
	.breakD(breakD),
	.syscallD(syscallD),
	.reserve_instructionD(reserve_instructionD),
	.eretD(eretD),
	.alucontrolD(alucontrolD),
	.equalD(equalD),
	.opD(opD),
	.functD(functD),
	.rtD(rtD),
	.instrD(instrD),
	.stallD(stallD),
	//execute stage
	.memtoregE(memtoregE),
	.alusrcE(alusrcE),
	.regdstE(regdstE),
	.regwriteE(regwriteE),
	.alucontrolE(alucontrolE),
	.jumpE(jumpE), 
	.jalE(jalE), 
	.jrE(jrE),
	.balE(balE),
	.memenE(memenE),
	.HiLoWriteE(HiLoWriteE),
	.flushE(flushE),
	.stallE(stallE),
	//mem stage
	.memtoregM(memtoregM),
	.regwriteM(regwriteM),
	.mtcp0M(mtcp0M),
	.mfcp0M(mfcp0M),
	.readdataM(readdataM),
	.aluout2M(aluoutM),
	.writedata2M(writedataM),
	.write_memM(memwriteM),
	.flushM(flushM),
	//writeback stage
	.memtoregW(memtoregW),
	.regwriteW(regwriteW),
	.flushW(flushW),
	.pcW(pcW),
	.writeregW(writeregW),
	.resultW(resultW)
    );
	
	
endmodule
