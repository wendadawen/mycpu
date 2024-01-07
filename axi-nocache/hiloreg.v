`timescale 1ns / 1ps

module hiloreg (
    input wire clk,
    input wire we,
    input wire [31:0] wd,
    output wire [31:0] rd
);
    reg [31:0] data;
    always @(negedge clk) begin
		if(we) begin
			data <= wd;
		end
	end
    assign rd = data;
endmodule