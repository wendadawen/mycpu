`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: maindec
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

module maindec(
	input wire[5:0] op,
	input wire[5:0] funct,
	output wire memtoreg,
	output wire memwrite,
	output wire branch,
	output wire alusrc,
	output wire regdst,
	output wire regwrite,
	output wire jump,
	output wire HiLoWrite
    );

	reg[7:0] controls;
	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump, HiLoWrite} = controls;
	always @(*) begin
		case (op)
			`EXE_NOP: case (funct)
				// move instruction 
				`EXE_MFHI: controls <= 8'b11000001;
				`EXE_MFLO: controls <= 8'b11000001;
				`EXE_MTHI: controls <= 8'b00000001;
				`EXE_MTLO: controls <= 8'b00000001;
				default: controls <= 8'b11000000; // R-Type
			endcase
			`EXE_ANDI: controls <= 8'b10100000;
			`EXE_ORI: controls <= 8'b10100000;
			`EXE_XORI: controls <= 8'b10100000;
			`EXE_LUI: controls <= 8'b10100000;
			default:  controls <= 8'b00000000;//illegal op
		endcase
	end

	// 规定： 1 ? x : y
	// regwrite: 是否需要写回寄存器
	// regdst: 写回寄存器的地址rd， rt
	// alusrc: alu的第二个操作数是否来自立即数
	// branch: 是否是分支指令
	// memwrite: 是否需要写内存
	// memtoreg: 写回阶段写回寄存器堆的值是否来自内存
	// jump: 是否是跳转指令

	// regwrite 信号
	// always @(*) begin
	// 	case (op)
	// 		`EXE_ANDI, 
	// 		`EXE_ORI,
	// 		`EXE_XORI,
	// 		`EXE_LUI,
	// 		`EXE_AND,
	// 		`EXE_OR,
	// 		`EXE_XOR,
	// 		`EXE_NOR: regwrite <= 1'b1;
	// 		default: regwrite <= 1'b0;
	// 	endcase
	// end

	// // regdst 信号
	// always @(*) begin
	// 	case (op)
	// 		`EXE_ANDI,
	// 		`EXE_ORI,
	// 		`EXE_XORI,
	// 		`EXE_LUI: regdst <= 1'b0;
	// 		`EXE_AND,
	// 		`EXE_OR,
	// 		`EXE_XOR,
	// 		`EXE_NOR: regdst <= 1'b1;
	// 		default: regdst <= 1'b0;
	// 	endcase
	// end

	// // alusrc 信号
	// always @(*) begin
	// 	case (op)
	// 		`EXE_ANDI,
	// 		`EXE_ORI,
	// 		`EXE_XORI,
	// 		`EXE_LUI: alusrc <= 1'b1;
	// 		`EXE_AND,
	// 		`EXE_OR,
	// 		`EXE_XOR,
	// 		`EXE_NOR: alusrc <= 1'b0;
	// 		default: alusrc <= 1'b0;
	// 	endcase
	// end


	// // branch 信号
	// always @(*) begin
	// 	case (op)
	// 		`EXE_ANDI,
	// 		`EXE_ORI,
	// 		`EXE_XORI,
	// 		`EXE_LUI,
	// 		`EXE_AND,
	// 		`EXE_OR,
	// 		`EXE_XOR,
	// 		`EXE_NOR: branch <= 1'b0;
	// 		default: branch <= 1'b0;
	// 	endcase
	// end

	// // memwrite 信号
	// always @(*) begin
	// 	case (op)
	// 		`EXE_ANDI,
	// 		`EXE_ORI,
	// 		`EXE_XORI,
	// 		`EXE_LUI,
	// 		`EXE_AND,
	// 		`EXE_OR,
	// 		`EXE_XOR,
	// 		`EXE_NOR: memwrite <= 1'b0;
	// 		default: memwrite <= 1'b0;
	// 	endcase
	// end

	// // memtoreg 信号
	// always @(*) begin
	// 	case (op)
	// 		`EXE_ANDI,
	// 		`EXE_ORI,
	// 		`EXE_XORI,
	// 		`EXE_LUI,
	// 		`EXE_AND,
	// 		`EXE_OR,
	// 		`EXE_XOR,
	// 		`EXE_NOR: memtoreg <= 1'b0;
	// 		default: memtoreg <= 1'b0;
	// 	endcase
	// end


	// // jump 信号
	// always @(*) begin
	// 	case (op)
	// 		`EXE_ANDI,
	// 		`EXE_ORI,
	// 		`EXE_XORI,
	// 		`EXE_LUI,
	// 		`EXE_AND,
	// 		`EXE_OR,
	// 		`EXE_XOR,
	// 		`EXE_NOR: jump <= 1'b0;
	// 		default: jump <= 1'b0;
	// 	endcase
	// end
endmodule
