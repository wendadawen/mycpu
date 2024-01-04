`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/23 22:57:01
// Design Name: 
// Module Name: eqcmp
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


module eqcmp(
	input wire [31:0] a,b,
	input wire [7:0] alucontrol,
	output wire y
    );
	reg res;

	assign y = res;

	always@ (*) begin
		case (alucontrol)
			`EXE_BEQ_OP: res <= (a == b) ? 1:0;
			`EXE_BGTZ_OP: res <= ((a[31] == 0) && (a != 32'b0)) ? 1:0;
			`EXE_BLEZ_OP: res <= ((a[31] == 1) || (a == 32'b0)) ? 1:0;
			`EXE_BNE_OP: res <= (a != b) ? 1:0; 
			`EXE_BLTZ_OP: res <= (a[31] == 1) ? 1:0;
			`EXE_BLTZAL_OP: res <= (a[31] == 1) ? 1:0;
			`EXE_BGEZ_OP: res <= (a[31] == 0) ? 1:0;
			`EXE_BGEZAL_OP: res <= (a[31] == 0) ? 1:0;
		default: res <= 0;
		endcase
	end
endmodule
