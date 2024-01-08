`timescale 1ns / 1ps
`include "defines.vh"
module loadselect (
    input wire [31:0] instr,
    input wire [31:0] word_data,
    output reg [31:0] out
);
    wire [5:0] opcode;
	wire [1:0] offest;

	assign opcode = instr[31:26];
	assign offest = instr[1:0];

    always @(*) begin
        case(opcode)
            `OP_LW: out <= word_data;
			`OP_LH:begin
				case(offest)
					2'b10: out <= {{16{word_data[31]}}, word_data[31:24], word_data[23:16]};
					// 2'b10: out <= {{16{word_data[23]}}, word_data[23:16], word_data[15:8]};
					2'b00: out <= {{16{word_data[15]}}, word_data[15:8], word_data[7:0]};
					default: out <= {32{1'b0}};
				endcase
			end
			`OP_LHU: begin
				case(offest)
					2'b10: out <= {{16{1'b0}}, word_data[31:24], word_data[23:16]};
					// 2'b10: out <= {{16{1'b0}}, word_data[23:16], word_data[15:8]};
					2'b00: out <= {{16{1'b0}}, word_data[15:8], word_data[7:0]};
					default: out <= {32{1'b0}};
				endcase
			end
			`OP_LB: begin
				case(offest)
					2'b11: out <= {{24{word_data[31]}}, word_data[31:24]};
					2'b10: out <= {{24{word_data[23]}}, word_data[23:16]};
					2'b01: out <= {{24{word_data[15]}}, word_data[15:8]};
					2'b00: out <= {{24{word_data[7]}},  word_data[7:0]};
				endcase
			end
			`OP_LBU: begin
				case(offest)
					2'b11: out <= {{24{1'b0}}, word_data[31:24]};
					2'b10: out <= {{24{1'b0}}, word_data[23:16]};
					2'b01: out <= {{24{1'b0}}, word_data[15:8]};
					2'b00: out <= {{24{1'b0}},  word_data[7:0]};
				endcase
			end
			default: out <= word_data;
        endcase
    end
endmodule