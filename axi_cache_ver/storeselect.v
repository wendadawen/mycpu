`timescale 1ns / 1ps
`include "defines.vh"
module storeselect (
    input wire [31:0] instr,
	input wire [31:0] alu_out_E,
    input wire [31:0] word_data,
    output reg [31:0] out
);
    wire [5:0] opcode;
	wire [1:0] offest;

	assign opcode = instr[31:26];
	assign offest = alu_out_E[1:0];

    always @(*) begin
		case(opcode)
			`OP_SW: out <= word_data;
			`OP_SH: begin
				case(offest)
					2'b10: out <= {word_data[15:8], word_data[7:0], 8'b0000_0000, 8'b0000_0000};
					// 2'b10: out <= {8'b0000_0000, word_data[15:8], word_data[7:0], 8'b0000_0000};
					2'b00: out <= {8'b0000_0000, 8'b0000_0000, word_data[15:8], word_data[7:0]};
					default: out <= word_data;
				endcase
			end
			`OP_SB: begin
				case(offest)
					2'b11: out <= {word_data[7:0], 8'b0000_0000, 8'b0000_0000, 8'b0000_0000};
					2'b10: out <= {8'b0000_0000, word_data[7:0], 8'b0000_0000, 8'b0000_0000};
					2'b01: out <= {8'b0000_0000, 8'b0000_0000, word_data[7:0], 8'b0000_0000};
					2'b00: out <= {8'b0000_0000, 8'b0000_0000, 8'b0000_0000, word_data[7:0]};
				endcase
			end
			default: out <= word_data;
		endcase
	end
endmodule