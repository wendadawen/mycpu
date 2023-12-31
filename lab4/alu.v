`timescale 1ns / 1ps
`include "defines.vh"

module alu(
	input wire [31:0] a,b,
	input wire [4:0] sa,
	input wire [7:0] ALUControl,
	output reg [31:0] result,
	output reg overflow,
	output wire zero
    );

	always @(*) begin
		case(ALUControl) 
			`ALU_AND: result <= a & b;
			`ALU_OR: result <= a|b;
			`ALU_XOR: result <= a^b;
			`ALU_NOR: result <= ~(a|b);
			`ALU_LUI: result <= {b[15:0], 16'b0};
			`ALU_SLL: result <= b << sa;
			`ALU_SRL: result <= b >> sa;
			`ALU_SRA: result <= $signed(b) >>> sa;
			`ALU_SLLV: result <= b << a;
			`ALU_SRLV: result <= b >> a;
			`ALU_SRAV: result <= $signed(b) >>> a;
			`ALU_DEFAULT: result <= 0;
			default: result <= 0;
		endcase
	end
endmodule

