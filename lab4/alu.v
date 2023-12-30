`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:52:16
// Design Name: 
// Module Name: alu
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


module alu(
	input wire[31:0] a,
	input wire[31:0] b,
	input wire[7:0] alucontrol,
	output reg[31:0] y,
	output reg overflow,
	output wire zero
    );

	always @(*) begin
		y = 32'h00000000;
		overflow = 0;
		case (alucontrol)
			`EXE_AND_OP: begin
				y = a & b;
				overflow = 0;
			end
			`EXE_OR_OP: begin
				y = a | b;
				overflow = 0;
			end
			`EXE_XOR_OP: begin
				y = a ^ b;
				overflow = 0;
			end
			`EXE_NOR_OP: begin
				y = ~(a | b);
				overflow = 0;
			end
			`EXE_ANDI_OP: begin
				y = a & b;
				overflow = 0;
			end
			`EXE_ORI_OP: begin
				y = a | b;
				overflow = 0;
			end
			`EXE_XORI_OP: begin
				y = a ^ b;
				overflow = 0;
			end
			`EXE_LUI_OP: begin // 将rt的高16位为立即数，后16位为0
				y = {b[15:0], 16'b0};
				overflow = 0;
			end
			default: begin
				y = 32'b0;
				overflow = 0;
			end
		endcase

	end
	assign zero = 1'b0;
endmodule
