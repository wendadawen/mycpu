`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 11:26:03
// Design Name: 
// Module Name: hilo_reg
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


module hilo_reg(
	input wire clk,rst,
	input wire HiLoWrite_en,
	input wire [7:0] alucontrol,
	input  wire [31:0] hi_i,lo_i,
	output reg [31:0] hi_o,lo_o
    );
	always @(negedge clk) begin
		if(rst)	begin
			hi_o <= 0;
			lo_o <= 0;
		end
		else if(HiLoWrite_en & alucontrol == `EXE_MTHI_OP) begin
			hi_o <= hi_i;
		end
		else if(HiLoWrite_en & alucontrol == `EXE_MTLO_OP) begin
			lo_o <= lo_i;
		end
		
	end
	
endmodule
