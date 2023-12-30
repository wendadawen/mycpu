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
	input wire[4:0] sa, // 移位指令的sa
	input wire[7:0] alucontrol,
	output reg[31:0] y,
	output reg overflow,
	input wire[63:0] hilo_in,
	output reg [63:0] hilo_out
    );

	always @(*) begin
		y = 32'h00000000;
		overflow = 0;
		hilo_out = 0;
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

			// shift instrucion 
			`EXE_SLL_OP: begin
				y = b << sa;
				overflow = 0;
			end
			`EXE_SRL_OP: begin
				y = b >> sa;
				overflow = 0;
			end
			`EXE_SRA_OP: begin
				y = ({32{b[31]}} << (6'd32 -{1'b0,sa})) | b >> sa; 
				overflow = 0;
			end
			`EXE_SLLV_OP: begin
				y = b << a[4:0];
				overflow = 0;
			end
			`EXE_SRLV_OP: begin
				y = b >> a[4:0];
				overflow = 0;
			end
			`EXE_SRAV_OP: begin
				y = ({32{b[31]}} << (6'd32 -{1'b0,a[4:0]})) | b >> a[4:0];
				overflow = 0; 
			end
			
			// move instruction
			`EXE_MFHI_OP: begin
				y = hilo_in[63:32];
				overflow = 0;
			end
			`EXE_MFLO_OP: begin
				y = hilo_in[31:0];
				overflow = 0;
			end
			`EXE_MTHI_OP: begin
				hilo_out = {a, hilo_in[31:0]};
				overflow = 0;
			end
			`EXE_MTLO_OP: begin
				hilo_out = {hilo_in[31:0], a};
				overflow = 0;
			end

			default: begin
				y = 32'b0;
				overflow = 0;
			end

		endcase

	end
endmodule
