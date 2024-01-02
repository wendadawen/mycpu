`timescale 1ns / 1ps
`include "defines.vh"
module signextend (
    input wire [5:0] opcode,
    input wire [5:0] funct,
    input wire [15:0] in,
    output reg [31:0] out
);
    always @(*) begin
        case(opcode) 
            `OP_ANDI, `OP_ORI, `OP_XORI, `OP_LUI: out <= {{16{1'b0}},in[15:0]};
            default: out <=  {{16{in[15]}},in[15:0]};
        endcase
    end

endmodule