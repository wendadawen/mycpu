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
	input wire[31:0] instruction, // 为了唯一的eret指令引入的信号
	input wire[5:0] op,
	input wire[4:0] rt,
	input wire[5:0] funct,
	output wire memtoreg,
	output wire memen,
	output wire branch,
	output wire alusrc,
	output wire regdst,
	output wire regwrite,
	output wire jump,
	output wire jal,
	output wire jr,
	output wire bal,
	output wire HiLoWrite,

	output wire breakk, // 断点例外
	output wire syscall, // 系统调用例外
	output wire reserve_instruction, // 保留指令例外
	output wire eret, //eret指令信号
	output wire mtcp0,  // mtc0指令信号
	output wire mfcp0 // mfc0指令信号
	 
    );

	reg[16:0] controls;
	assign {regwrite,regdst,alusrc,branch,memen,memtoreg,jump,jal, jr, bal, HiLoWrite, breakk, syscall, reserve_instruction, eret, mtcp0, mfcp0} = controls;
	always @(*) begin
		case (op)
			`EXE_NOP: case (funct)
				// move instruction 
				`EXE_MFHI,
				`EXE_MFLO: controls <= 17'b110000_0000_1_000000;
				`EXE_MTHI,
				`EXE_MTLO,
				// algorithm instruction
				// div 和 divu
				`EXE_DIV,
				`EXE_DIVU,
				// mult 和 multu
				`EXE_MULT,
				`EXE_MULTU: controls <= 17'b000000_0000_1_000000;

				// jr, jalr
				`EXE_JR: controls <= 17'b000000_0010_0_000000;
				`EXE_JALR: controls <= 17'b110000_0010_0_000000;

				`EXE_BREAK: controls <= 17'b000000_0000_0_100000;
				`EXE_SYSCALL: controls <= 17'b000000_0000_0_010000;
				default: controls <= 17'b110000_0000_0_000000; // R-Type
			endcase

			`EXE_ANDI,
			`EXE_ORI,
			`EXE_XORI,
			`EXE_LUI,

			// algorithm instruction
			`EXE_ADDI,
			`EXE_ADDIU,
			`EXE_SLTI,
			`EXE_SLTIU: controls <= 17'b101000_0000_0_000000;
			
			// branch isntruction
			`EXE_BEQ: controls <= 17'b000100_0000_0_000000;
			`EXE_BNE: controls <= 17'b000100_0000_0_000000;
			// bgez, bltz, bgezal, bltzal 需要rt指令来判断
			`EXE_REGIMM_INST: case (rt)
				`EXE_BGEZ: controls <= 17'b000100_0000_0_000000;
				`EXE_BGEZAL: controls <= 17'b100100_0001_0_000000;
				`EXE_BLTZ: controls <= 17'b000100_0000_0_000000; 
				`EXE_BLTZAL: controls <= 17'b100100_0001_0_000000;
				default: controls <= 17'b0;
			endcase
			`EXE_BGTZ: controls <= 17'b000100_0000_0_000000; 
			`EXE_BLEZ: controls <= 17'b000100_0000_0_000000; 
			 
			`EXE_J: controls <= 17'b000000_1000_0_000000;
			`EXE_JAL: controls <= 17'b100000_0100_0_000000;


			// StoreAndLoad Instruction
			// 加上符号扩展后的立即数 offset !!!!
			`EXE_LB, 
			`EXE_LBU,
			`EXE_LH, 
			`EXE_LHU,
			`EXE_LW: controls <= 17'b101011_0000_0_000000;

			`EXE_SB,
			`EXE_SH,
			`EXE_SW: controls <= 17'b001010_0000_0_000000;


			// 3条特殊指令: eret, mtc0, mfc0
			6'b010000: begin
				if(instruction == `EXE_ERET)	controls <= 17'b000000_0000_0_000100;
				else if(instruction[25:21] == 5'b00100)	controls <= 17'b000000_0000_0_000010;
				else if(instruction[25:21] == 5'b00000) controls <= 17'b100000_0000_0_000001;
				// 保留指令例外
				else controls <= 17'b000000_0000_0_001000;
			end
			default:  controls <= 17'b000000_0000_0_001000;//illegal op or reserve instruction
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
