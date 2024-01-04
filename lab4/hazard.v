`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/22 10:23:13
// Design Name: 
// Module Name: hazard
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


module hazard(
	//fetch stage
	output wire stallF,
	output wire[31:0] newPC,
	output wire flushF,
	//decode stage
	input wire[4:0] rsD,rtD,
	input wire branchD,jumpD, jrD,
	input wire[7:0] alucontrolD,
	output wire forwardaD,forwardbD,jrforwardaD,stallD,jrb_l_astall, jrb_l_bstall,
	output wire flushD,
	//execute stage
	input wire[4:0] rsE,rtE,
	input wire[4:0] writeregE,
	input wire regwriteE,
	input wire memtoregE,
	// 除法准备的信号
	input wire hilo_signal,
	input wire [7:0] alucontrolE,
	input wire div_ready,

	output reg[1:0] forwardaE,forwardbE,
	output wire flushE,stallE,
	//mem stage
	input wire[4:0] writeregM,
	input wire regwriteM,
	input wire memtoregM,
	input wire[31:0] except_type,
	input wire overflowM,
	output wire flushM,
	input wire [31:0] epc_o,
	//write back stage
	input wire[4:0] writeregW,
	input wire regwriteW,
	output wire flushW
    );

	wire lwstallD,branchstallD,jrstall, stall_divE;
	// newPC
	assign newPC = (except_type == 32'h0000_0001)? 32'hbfc00380:
                   (except_type == 32'h0000_0004)? 32'hbfc00380:
                   (except_type == 32'h0000_0005)? 32'hbfc00380:
                   (except_type == 32'h0000_0008)? 32'hbfc00380:
                   (except_type == 32'h0000_0009)? 32'hbfc00380:
                   (except_type == 32'h0000_000a)? 32'hbfc00380:
                   (except_type == 32'h0000_000c)? 32'hbfc00380:
                   (except_type == 32'h0000_000e)? epc_o:
                   32'b0;

	//forwarding sources to D stage (branch equality)
	assign forwardaD = (rsD != 0 & rsD == writeregM & regwriteM);
	assign forwardbD = (rtD != 0 & rtD == writeregM & regwriteM);
	
	//forwarding sources to E stage (ALU)

	always @(*) begin
		forwardaE = 2'b00;
		forwardbE = 2'b00;
		if(rsE != 0) begin
			/* code */
			if(rsE == writeregM & regwriteM) begin
				/* code */
				forwardaE = 2'b10;
			end else if(rsE == writeregW & regwriteW) begin
				/* code */
				forwardaE = 2'b01;
			end
		end
		if(rtE != 0) begin
			/* code */
			if(rtE == writeregM & regwriteM) begin
				/* code */
				forwardbE = 2'b10;
			end else if(rtE == writeregW & regwriteW) begin
				/* code */
				forwardbE = 2'b01;
			end
		end
	end

	// 除法阶段需要暂停流水线

	assign stall_divE = ((alucontrolE == `EXE_DIV_OP) | (alucontrolE == `EXE_DIVU_OP)) & ~div_ready;
	

	//stalls
	assign  lwstallD = memtoregE & (rtE == rsD | rtE == rtD);
	// branch 时数据前推也没有写入寄存器的时候，需要暂停流水线
	assign  branchstallD = branchD &
							(regwriteE & 
							(writeregE == rsD | writeregE == rtD) |
							memtoregM &
							(writeregM == rsD | writeregM == rtD));
	// jr时数据前推也没有写入寄存器，需要暂停流水线
	assign jrstall = jrD && regwriteE && (writeregE==rsD);

	// branch / jr 时数据前推
	assign jrb_l_astall = (jrD|branchD) && ((memtoregE && (writeregE==rsD)) || (memtoregM && (writeregM==rsD)));
	assign jrb_l_bstall = (jrD|branchD) && ((memtoregE && (writeregE==rtD)) || (memtoregM && (writeregM==rtD)));
	assign  stallF = stallD;
	assign  stallD = lwstallD | branchstallD | stall_divE | jrstall;
	
	assign  stallE = stall_divE;
	//stalling D stalls all previous stages
	assign flushF = (except_type != 0);
	assign flushE = lwstallD | branchstallD | (except_type != 0);
	assign flushD = (except_type != 0);
	assign flushM = (except_type != 0);
	assign flushW = (except_type != 0);
		//stalling D flushes next stage
	// Note: not necessary to stall D stage on store
  	//       if source comes from load;
  	//       instead, another bypass network could
  	//       be added from W to M
endmodule
