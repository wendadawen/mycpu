`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:27:24
// Design Name: 
// Module Name: aludec
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


module aludec(
	input wire[5:0] funct,
	input wire[5:0] aluop,
	input wire[4:0] rt,
	output reg[7:0] alucontrol
    );
	always @(*) begin
		case (aluop)
			`EXE_NOP: case(funct)
					// logic instruction
					`EXE_AND: alucontrol = `EXE_AND_OP; // and
					`EXE_OR: alucontrol = `EXE_OR_OP; // or
					`EXE_XOR: alucontrol = `EXE_XOR_OP; // xor
					`EXE_NOR: alucontrol = `EXE_NOR_OP; // nor
					// shift instrucion
					`EXE_SLL: alucontrol = `EXE_SLL_OP; // sll
					`EXE_SRL: alucontrol = `EXE_SRL_OP; // srl
					`EXE_SRA: alucontrol = `EXE_SRA_OP; // sra
					`EXE_SLLV: alucontrol = `EXE_SLLV_OP; // sllv
					`EXE_SRLV: alucontrol = `EXE_SRLV_OP; // srlv
					`EXE_SRAV: alucontrol = `EXE_SRAV_OP; // srav
					// move instruction 
					`EXE_MFHI: alucontrol = `EXE_MFHI_OP; // mfhi
					`EXE_MFLO: alucontrol = `EXE_MFLO_OP; // mflo
					`EXE_MTHI: alucontrol = `EXE_MTHI_OP; // mthi
					`EXE_MTLO: alucontrol = `EXE_MTLO_OP; // mtlo
					// algorithm instruction
					`EXE_ADD: alucontrol = `EXE_ADD_OP; // add
					`EXE_ADDU: alucontrol = `EXE_ADDU_OP; // addu
					`EXE_SUB: alucontrol = `EXE_SUB_OP; // sub
					`EXE_SUBU: alucontrol = `EXE_SUBU_OP; // subu
					`EXE_SLT: alucontrol = `EXE_SLT_OP; // slt
					`EXE_SLTU: alucontrol = `EXE_SLTU_OP; // sltu
					`EXE_DIV: alucontrol = `EXE_DIV_OP; // div
					`EXE_DIVU: alucontrol = `EXE_DIVU_OP; // divu
					`EXE_MULT: alucontrol = `EXE_MULT_OP; // mult
					`EXE_MULTU: alucontrol = `EXE_MULTU_OP; // multu

					// branch instruction
					`EXE_JR: alucontrol = `EXE_JR_OP; // jr
					`EXE_JALR: alucontrol = `EXE_JALR_OP; // jalr

					// default
					default: alucontrol = `EXE_NOP_OP;

			endcase
			`EXE_ANDI: alucontrol = `EXE_ANDI_OP; // andi
			`EXE_ORI: alucontrol = `EXE_ORI_OP; // ori
			`EXE_XORI: alucontrol = `EXE_XORI_OP; // xori
			`EXE_LUI: alucontrol = `EXE_LUI_OP; // lui
			// algorithim instruction
			`EXE_ADDI: alucontrol = `EXE_ADDI_OP; // addi
			`EXE_ADDIU: alucontrol = `EXE_ADDIU_OP; // addiu
			`EXE_SLTI: alucontrol = `EXE_SLTI_OP; // slti
			`EXE_SLTIU: alucontrol = `EXE_SLTIU_OP; // sltiu

			// branch instruction
			`EXE_BEQ: alucontrol = `EXE_BEQ_OP; // beq
			`EXE_BNE: alucontrol = `EXE_BNE_OP; // bne
			`EXE_BGTZ: alucontrol = `EXE_BGTZ_OP; // bgtz
			`EXE_BLEZ: alucontrol = `EXE_BLEZ_OP; // blez

			`EXE_REGIMM_INST: case(rt)
				`EXE_BGEZ: alucontrol = `EXE_BGEZ_OP; // bgez
				`EXE_BLTZ: alucontrol = `EXE_BLTZ_OP; // bltz
				`EXE_BLTZAL: alucontrol = `EXE_BLTZAL_OP; // bltzal
				`EXE_BGEZAL: alucontrol = `EXE_BGEZAL_OP; // bgezal
				default: alucontrol = `EXE_NOP_OP;
			endcase


			`EXE_J: alucontrol = `EXE_J_OP; // j
			`EXE_JAL: alucontrol = `EXE_JAL_OP; // jal


			// StoreAndLoad instruction
			`EXE_LB: alucontrol = `EXE_LB_OP; // lb ==> 读出的值符号扩展
			`EXE_LBU: alucontrol = `EXE_LBU_OP; // lbu ==> 读出的值0扩展
			`EXE_LH: alucontrol = `EXE_LH_OP; // lh
			`EXE_LHU: alucontrol = `EXE_LHU_OP; // lhu same as pair before
			`EXE_LW: alucontrol = `EXE_LW_OP; // lw
			`EXE_SB: alucontrol = `EXE_SB_OP; // sb
			`EXE_SH: alucontrol = `EXE_SH_OP; // sh
			`EXE_SW: alucontrol = `EXE_SW_OP; // sw

			default: alucontrol = `EXE_NOP_OP;
		endcase
	
	end
endmodule
