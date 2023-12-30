`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:29:33
// Design Name: 
// Module Name: signext
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


module signext(
	input wire[15:0] a,
	input wire [5: 0] opcode,
	output wire[31:0] y
    );
	reg [31:0] res;
	assign y = res;
	always @(*) begin
		case (opcode[5: 2])
			4'b0000: begin
				res <= {{16{a[15]}},a};
			end
			4'b0011: begin
				res <= {16'b0, a};
			end
			default: res <=  {{16{a[15]}},a};
		endcase	
	end
endmodule
