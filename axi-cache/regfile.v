`timescale 1ns / 1ps

module regfile(
	input wire clk,
	input wire we3, //写使能信号
	input wire[4:0] ra1,ra2,wa3, //读地址 ra1, ra2，写地址 wa3
	input wire[31:0] wd3, //写数据
	output wire[31:0] rd1,rd2 //读数据
    );
	

	reg [31:0] rf[31:0];

	always @(negedge clk) begin
		if(we3) begin
			rf[wa3] <= wd3;
		end
	end

	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
	assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
