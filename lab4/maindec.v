`timescale 1ns / 1ps

`include "defines.vh"

module maindec(
	input wire[5:0] opcode,
	input wire[5:0] funct,
	
	output reg MemtoReg,
	output reg MemWrite,
	output reg Branch,
	output reg ALUSrcB,
	output reg RegDst,
	output reg RegWrite,
	output reg JumpJ,
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

	// MemtoReg
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					default: MemtoReg <= 1'b0;
				endcase
			end
			default: MemtoReg <= 1'b0;
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
					`FUNCT_NOR:   RegDst <= 1'b1;
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
					`FUNCT_NOR:   RegWrite <= 1'b1;
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

endmodule
