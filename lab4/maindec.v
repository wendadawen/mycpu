`timescale 1ns / 1ps

`include "defines.vh"

module maindec(
	input wire [31:0] instr,
	
	output reg [1:0] MemtoReg,
	output reg [3:0] MemWrite,
	output reg ALUSrcA,
	output reg [1:0] ALUSrcB,
	output reg RegDst,
	output reg RegWrite,
	output reg LoWrite,
	output reg HiWrite,
	output reg LoSrc,
	output reg HiSrc,
	output reg WriteReg,
	output reg BranchBeq,
	output reg BranchBne,
	output reg BranchBgez,
	output reg BranchBgtz,
	output reg BranchBlez,
	output reg BranchBltz,
	output reg JumpJ,
	output reg JumpJr,
	output reg [7:0] ALUControl
);

	wire [5:0] opcode;
	wire [5:0] funct;
	wire [4:0] rt;
	wire [1:0] offest;

	assign opcode = instr[31:26];
	assign funct = instr[5:0];
	assign rt = instr[20:16];
	assign offest = instr[1:0];

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
					`FUNCT_DIV:   ALUControl <= `ALU_DIV;
					`FUNCT_DIVU:  ALUControl <= `ALU_DIVU;
					`FUNCT_MULT:  ALUControl <= `ALU_MULT;
					`FUNCT_MULTU: ALUControl <= `ALU_MULTU;
					`FUNCT_ADD:   ALUControl <= `ALU_ADD;
					`FUNCT_ADDU:  ALUControl <= `ALU_ADD;
					`FUNCT_SUB:   ALUControl <= `ALU_SUB;
					`FUNCT_SUBU:  ALUControl <= `ALU_SUB;
					`FUNCT_SLT:   ALUControl <= `ALU_SLT;
					`FUNCT_SLTU:  ALUControl <= `ALU_SLTU;
					`FUNCT_JALR:  ALUControl <= `ALU_ADD;
					default: ALUControl <= `ALU_DEFAULT;
				endcase
			end
			`OP_ANDI:   ALUControl <= `ALU_AND;
			`OP_ORI:    ALUControl <= `ALU_OR;
			`OP_XORI:   ALUControl <= `ALU_XOR;
			`OP_LUI:    ALUControl <= `ALU_LUI;
			`OP_ADDI:   ALUControl <= `ALU_ADD;
			`OP_ADDIU:  ALUControl <= `ALU_ADD;
			`OP_SLTI:   ALUControl <= `ALU_SLT;
			`OP_SLTIU:  ALUControl <= `ALU_SLTU;
			`OP_JAL: 	ALUControl <= `ALU_ADD;
			`OP_SB: 	ALUControl <= `ALU_ADD;
			`OP_SH: 	ALUControl <= `ALU_ADD;
			`OP_SW: 	ALUControl <= `ALU_ADD;
			`OP_LB: 	ALUControl <= `ALU_ADD;
			`OP_LBU: 	ALUControl <= `ALU_ADD;
			`OP_LH: 	ALUControl <= `ALU_ADD;
			`OP_LHU: 	ALUControl <= `ALU_ADD;
			`OP_LW: 	ALUControl <= `ALU_ADD;
			`OP_BLTZAL, `OP_BGEZAL: begin 
				case(rt)
					`RT_BLTZAL: ALUControl = `ALU_ADD;
					`RT_BGEZAL: ALUControl <= `ALU_ADD;
					default: ALUControl <=`ALU_DEFAULT;
				endcase
			end
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
			`OP_LB,
			`OP_LBU,
			`OP_LH,
			`OP_LHU,
			`OP_LW: MemtoReg <= 2'b01;
			default: MemtoReg <= 2'b00;
		endcase
	end

	// MemWrite[3:0]
	always @(*) begin
		case(opcode)
			`OP_SW: MemWrite <= 4'b1111;
			`OP_SH: begin
				case(offest)
					2'b10: MemWrite <= 4'b1100;
					// 2'b10: MemWrite <= 4'b0110;
					2'b00: MemWrite <= 4'b0011;
					default: MemWrite <= 4'b0000;
				endcase
			end
			`OP_SB: begin
				case(offest)
					2'b11: MemWrite <= 4'b1000;
					2'b10: MemWrite <= 4'b0100;
					2'b01: MemWrite <= 4'b0010;
					2'b00: MemWrite <= 4'b0001;
				endcase
			end
			default: MemWrite <= 4'b0000;
		endcase
	end

	// ALUSrcB[1:0]
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_JALR: ALUSrcB <= 2'b10;
					default: ALUSrcB <= 2'b00;
				endcase
			end
			`OP_ANDI,
			`OP_ORI,
			`OP_XORI,
			`OP_LUI,
			`OP_ADDI,
			`OP_ADDIU,
			`OP_SLTI,
			`OP_SLTIU,
			`OP_SB,
			`OP_SH,
			`OP_SW,
			`OP_LB,
			`OP_LBU,
			`OP_LH,
			`OP_LHU,
			`OP_LW: ALUSrcB <= 2'b01;
			`OP_JAL: ALUSrcB <= 2'b10;
			`OP_BLTZAL, `OP_BGEZAL: begin 
				case(rt)
					`RT_BLTZAL,
					`RT_BGEZAL: ALUSrcB <= 2'b10;
					default: ALUSrcB <= 2'b00;
				endcase
			end
			default: ALUSrcB <= 2'b00;
		endcase
	end

	// ALUSrcA
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_JALR: ALUSrcA <= 1'b1;
					default: ALUSrcA <= 1'b0;
				endcase
			end
			`OP_JAL: ALUSrcA <= 1'b1;
			`OP_BLTZAL, `OP_BGEZAL: begin 
				case(rt)
					`RT_BLTZAL,
					`RT_BGEZAL: ALUSrcA <= 1'b1;
					default: ALUSrcA <= 1'b0;
				endcase
			end
			default: ALUSrcA <= 1'b0;
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
					`FUNCT_MFLO,
					`FUNCT_ADD,
					`FUNCT_ADDU,
					`FUNCT_SUB,
					`FUNCT_SUBU,
					`FUNCT_SLT,
					`FUNCT_SLTU,
					`FUNCT_JALR:   RegDst <= 1'b1;
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
					`FUNCT_MFLO,
					`FUNCT_ADD,
					`FUNCT_ADDU,
					`FUNCT_SUB,
					`FUNCT_SUBU,
					`FUNCT_SLT,
					`FUNCT_SLTU,
					`FUNCT_JALR:   RegWrite <= 1'b1;
					default: RegWrite <= 1'b0;
				endcase
			end
			`OP_ANDI,
			`OP_ORI,
			`OP_XORI,
			`OP_LUI,
			`OP_ADDI,
			`OP_ADDIU,
			`OP_SLTI,
			`OP_SLTIU,
			`OP_JAL,
			`OP_LB,
			`OP_LBU,
			`OP_LH,
			`OP_LHU,
			`OP_LW: RegWrite <= 1'b1;
			`OP_BLTZAL, `OP_BGEZAL: begin 
				case(rt)
					`RT_BLTZAL,
					`RT_BGEZAL: RegWrite <= 1'b1;
					default: RegWrite <= 1'b0;
				endcase
			end
			default: RegWrite <= 1'b0;
		endcase
	end

	// LoWrite
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_MTLO,
					`FUNCT_DIV,
					`FUNCT_DIVU,
					`FUNCT_MULT,
					`FUNCT_MULTU: LoWrite <= 1'b1;
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
					`FUNCT_MTHI,
					`FUNCT_DIV,
					`FUNCT_DIVU,
					`FUNCT_MULT,
					`FUNCT_MULTU: HiWrite <= 1'b1;
					default: HiWrite <= 1'b0;
				endcase
			end
			default: HiWrite <= 1'b0;
		endcase
	end

	// LoSrc
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_DIV,
					`FUNCT_DIVU,
					`FUNCT_MULT,
					`FUNCT_MULTU: LoSrc <= 1'b1;
					default: LoSrc <= 1'b0;
				endcase
			end
			default: LoSrc <= 1'b0;
		endcase
	end

	// HiSrc
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_DIV,
					`FUNCT_DIVU,
					`FUNCT_MULT,
					`FUNCT_MULTU: HiSrc <= 1'b1;
					default: HiSrc <= 1'b0;
				endcase
			end
			default: HiSrc <= 1'b0;
		endcase
	end

	
	// WriteReg
	always @(*) begin
		case(opcode) 
			`OP_R_TYPE: begin
				case(funct)
					default: WriteReg <= 1'b0;
				endcase
			end
			`OP_JAL: WriteReg <= 1'b1;
			`OP_BLTZAL, `OP_BGEZAL: begin 
				case(rt)
					`RT_BLTZAL,
					`RT_BGEZAL: WriteReg <= 1'b1;
					default: WriteReg <= 1'b0;
				endcase
			end
			default: WriteReg <= 1'b0;
		endcase
	end

	// JumpJr
	always @(*) begin
		case(opcode)
			`OP_R_TYPE: begin
				case(funct)
					`FUNCT_JR,
					`FUNCT_JALR: JumpJr <= 1'b1;
					default: JumpJr <= 1'b0;
				endcase
			end
			default: JumpJr <= 1'b0;
		endcase
		
	end

	// JumpJ
	always @(*) begin
		case(opcode)
			`OP_JAL,
			`OP_J: JumpJ <= 1'b1;
			default: JumpJ <= 1'b0;
		endcase
	end

	// BranchBlez
	always @(*) begin
		case(opcode)
			`OP_BLEZ: BranchBlez <= 1'b1;
			default: BranchBlez <= 1'b0;
		endcase
	end

	// BranchBgtz
	always @(*) begin
		case(opcode)
			`OP_BGTZ: BranchBgtz <= 1'b1;
			default: BranchBgtz <= 1'b0;
		endcase
	end

	// BranchBltz
	always @(*) begin
		case(opcode) 
			`OP_BLTZ: begin
				case(rt)
					`RT_BLTZ,`RT_BLTZAL: BranchBltz <= 1'b1;
					default: BranchBltz <= 1'b0;
				endcase
			end
			default: BranchBltz <= 1'b0;
		endcase
	end

	// BranchBgez
	always @(*) begin
		case(opcode) 
			`OP_BGEZ: begin
				case(rt)
					`RT_BGEZ,`RT_BGEZAL: BranchBgez <= 1'b1;
					default: BranchBgez <= 1'b0;
				endcase
			end
			default: BranchBgez <= 1'b0;
		endcase
	end

	// BranchBne
	always @(*) begin
		case(opcode)
			`OP_BNE: BranchBne <= 1'b1;
			default: BranchBne <= 1'b0;
		endcase
	end

	// BranchBeq
	always @(*) begin
		case(opcode)
			`OP_BEQ: BranchBeq <= 1'b1;
			default: BranchBeq <= 1'b0;
		endcase
	end

endmodule
