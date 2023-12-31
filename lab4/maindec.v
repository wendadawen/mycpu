`timescale 1ns / 1ps

`include "defines.vh"

module maindec(
	input wire[5:0] opcode,
	input wire[5:0] funct,
	
	output reg [1:0] MemtoReg,
	output reg MemWrite,
	output reg Branch,
	output reg ALUSrcB,
	output reg RegDst,
	output reg RegWrite,
	output reg JumpJ,
	output reg LoWrite,
	output reg HiWrite,
	output reg [7:0] ALUControl
);
	// ALUControl
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_AND:   ALUControl <= `ALU_AND;
					`FUNCT_OR:    ALUControl <= `ALU_OR;
					`FUNCT_XOR:   ALUControl <= `ALU_XOR;
					`FUNCT_NOR:   ALUControl <= `ALU_NOR;
					`FUNCT_SLL:   ALUControl <= `ALU_SLL;
					`FUNCT_SRL:   ALUControl <= `ALU_SRL;
					`FUNCT_SRA:   ALUControl <= `ALU_SRA;
					`FUNCT_SLLV:  ALUControl <= `ALU_SLLV;
					`FUNCT_SRLV:  ALUControl <= `ALU_SRLV;
					`FUNCT_SRAV:  ALUControl <= `ALU_SRAV;
					default: ALUControl <= `ALU_DEFAULT;
				endcase
			end
			`OP_ANDI:   ALUControl <= `ALU_AND;
			`OP_ORI:    ALUControl <= `ALU_OR;
			`OP_XORI:   ALUControl <= `ALU_XOR;
			`OP_LUI:    ALUControl <= `ALU_LUI;
			default:    ALUControl <= `ALU_DEFAULT;
		endcase
	end

	// MemtoReg[1:0]
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_MFHI: MemtoReg <= 2'b10;
					`FUNCT_MFLO: MemtoReg <= 2'b11;
					default: MemtoReg <= 2'b00;
				endcase
			end
			default: MemtoReg <= 2'b00;
		endcase
	end

	// MemWrite
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					
					default: MemWrite <= 1'b0;
				endcase
			end
			
			default: MemWrite <= 1'b0;
		endcase
	end

	// Branch
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					
					default: Branch <= 1'b0;
				endcase
			end
			
			default: Branch <= 1'b0;
		endcase
	end

	// ALUSrcB
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					default: ALUSrcB <= 1'b0;
				endcase
			end
			`OP_ANDI,
			`OP_ORI,
			`OP_XORI,
			`OP_LUI: ALUSrcB <= 1'b1;
			default: ALUSrcB <= 1'b0;
		endcase
	end

	// RegDst
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct) 
					`FUNCT_AND,
					`FUNCT_OR,
					`FUNCT_XOR,
					`FUNCT_NOR,
					`FUNCT_SLL,
					`FUNCT_SRL,
					`FUNCT_SRA,
					`FUNCT_SLLV,
					`FUNCT_SRLV,
					`FUNCT_SRAV,
					`FUNCT_MFHI,
					`FUNCT_MFLO:   RegDst <= 1'b1;
					default: RegDst <= 1'b0;
				endcase
			end
			default: RegDst <= 1'b0;
		endcase
	end

	// RegWrite
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_AND,
					`FUNCT_OR,
					`FUNCT_XOR,
					`FUNCT_NOR,
					`FUNCT_SLL,
					`FUNCT_SRL,
					`FUNCT_SRA,
					`FUNCT_SLLV,
					`FUNCT_SRLV,
					`FUNCT_SRAV,
					`FUNCT_MFHI,
					`FUNCT_MFLO:   RegWrite <= 1'b1;
					default: RegWrite <= 1'b0;
				endcase
			end
			`OP_ANDI,
			`OP_ORI,
			`OP_XORI,
			`OP_LUI: RegWrite <= 1'b1;
			default: RegWrite <= 1'b0;
		endcase
	end

	// JumpJ
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct)
					default: JumpJ <= 1'b0;
				endcase
			end
			default: JumpJ <= 1'b0;
		endcase
	end

	// LoWrite
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_MTLO: LoWrite <= 1'b1;
					default: LoWrite <= 1'b0;
				endcase
			end
			default: LoWrite <= 1'b0;
		endcase
	end

	// HiWrite
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_MTHI: HiWrite <= 1'b1;
					default: HiWrite <= 1'b0;
				endcase
			end
			default: HiWrite <= 1'b0;
		endcase
	end

endmodule
