`timescale 1ns / 1ps

module maindec(
	input wire[5:0] opcode,     // 输入的指令操作码
	output wire[1:0] alu_op,  // ALU操作码
	
	//output wire MemRead, // MemRead = 0， 不涉及内存读取
	// PCSrc = 0， 不跳转分支
	output wire MemtoReg,  // MemtoReg = 0，从ALU结果中取值
	output wire MemWrite,  // MemWrite = 0，不涉及内存写入
	output wire Branch,    // Branch = 0，  不涉及分支
	output wire ALUSrc,    // ALUSrc = 0，  第二个操作数来自rs寄存器
	output wire RegDst,    // RegDst = 0，  不将结果存储到rd寄存器中
	output wire RegWrite,  // RegWrite = 0，不将结果写入寄存器
	output wire Jump       // Jump = 0，    不涉及跳转

);

	reg[8:0] controls;
	assign {RegWrite,RegDst,ALUSrc,Branch,MemWrite,MemtoReg,Jump,alu_op} = controls;  // 将控制信号赋值给输出端口

	always @(*) begin
		case (opcode)
			6'b000000:controls <= 9'b1_1_0_0_0_0_0_10;  // R-Type
			6'b100011:controls <= 9'b1_0_1_0_0_1_0_00;  // lw
			6'b101011:controls <= 9'b0_0_1_0_1_0_0_00;  // sw
			6'b000100:controls <= 9'b0_0_0_1_0_0_0_01;  // beq
			6'b001000:controls <= 9'b1_0_1_0_0_0_0_00;  // addi
			6'b000010:controls <= 9'b0_0_0_0_0_0_1_00;  // j
			default:  controls <= 9'b0_0_0_0_0_0_0_00;
		endcase
	end
endmodule
