`timescale 1ns / 1ps

module signextend (
    input wire [5:0] opcode,
    input wire [5:0] funct,
    input wire [15:0] in,
    output wire [31:0] out
);
    assign out = (opcode == 6'b000_000)?
                    {{16{in[15]}},in[15:0]}:
                    {{16{1'b0}},in[15:0]};

endmodule