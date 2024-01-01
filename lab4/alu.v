`timescale 1ns / 1ps
`include "defines.vh"

module alu(
	input wire clk, rst,
	input wire [31:0] a,b,
	input wire [4:0] sa,
	input wire [7:0] ALUControl,
	output reg [31:0] result,
	output reg [31:0] hi_out,
	output reg [31:0] lo_out,
	output wire ready,
	output reg overflow,
	output reg zero
    );
	// div
	wire div_start,div_signed,div_ready;
	wire [63:0] div_result;
	assign div_signed = (ALUControl==`ALU_DIV) ? 1'b1: 1'b0;
	assign div_start = ((ALUControl==`ALU_DIV | ALUControl==`ALU_DIVU) & ~div_ready) ? 1'b1: 1'b0;
	div div(
		.clk(clk),
		.rst(rst),
		.signed_div_i(div_signed),
		.opdata1_i(a),
		.opdata2_i(b),
		.start_i(div_start),
		.annul_i(1'b0),
		.result_o(div_result),
		.ready_o(div_ready)
	);
	// is ready result?
	assign ready = (ALUControl==`ALU_DIV | ALUControl==`ALU_DIVU) ? div_ready: 1'b1;
	// others
	always @(*) begin
		case(ALUControl) 
			`ALU_AND: result <= a & b;
			`ALU_OR: result <= a | b;
			`ALU_XOR: result <= a ^ b;
			`ALU_NOR: result <= ~ (a | b);
			`ALU_LUI: result <= {b[15:0], 16'b0};
			`ALU_SLL: result <= b << sa;
			`ALU_SRL: result <= b >> sa;
			`ALU_SRA: result <= $signed(b) >>> sa;
			`ALU_SLLV: result <= b << a;
			`ALU_SRLV: result <= b >> a;
			`ALU_SRAV: result <= $signed(b) >>> a;
			`ALU_ADD: result <= a + b;
			`ALU_SUB: result <= a - b;
			`ALU_SLT: result <= ($signed(a) < $signed(b)) ? 32'b1:32'b0;
			`ALU_SLTU: result <= (a < b) ? 32'b1:32'b0;
			`ALU_MULT: {hi_out, lo_out} <= $signed(a) * $signed(b);
            `ALU_MULTU: {hi_out, lo_out} <= $unsigned(a) * $unsigned(b);
			`ALU_DIV: {hi_out, lo_out} <= div_result;
			`ALU_DIVU:{hi_out, lo_out} <= div_result;
			`ALU_DEFAULT: result <= 0;
			default: result <= 0;
		endcase
	end
	// zero
	always @(*) begin
		zero <= (result==32'b0);
	end
endmodule

