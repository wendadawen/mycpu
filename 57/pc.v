`timescale 1ns / 1ps


module pc #(parameter WIDTH = 8)(
	input wire clk,rst,en,Flush,
	input wire[WIDTH-1:0] pc_new, d,
	output reg[WIDTH-1:0] q
);
	always @(posedge clk, posedge rst) begin
		if(rst) begin
			q <= 32'hbfc00000;
		end else if (Flush) begin
			q <= pc_new;
		end else if(en) begin
			q <= d;
		end else begin
			q <= q;
		end
	end
endmodule