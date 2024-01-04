`timescale 1ns / 1ps
`include "defines.vh"

module exception(
	input wire rst,
    // adel syscall break eret reverseInstr overflow  [1:0]
    input wire [7:0] Exception,
    input wire adel, ades,
    input wire [31:0] cp0_status, cp0_cause, cp0_epc,
    output wire [31:0] exception_type, pc_new_M
);	
assign exception_type = (rst)? 32'b0:
                    (((cp0_cause[15:8]&cp0_status[15:8]) != 8'h00) && (cp0_status[1] == 1'b0) && (cp0_status[0] == 1'b1))? 32'h00000001: //int
                    (Exception[7] == 1'b1 | adel)? 32'h00000004://adel
                    (ades)? 32'h00000005://ades
                    (Exception[6] == 1'b1)? 32'h00000008://syscall
                    (Exception[5] == 1'b1)? 32'h00000009://break
                    (Exception[4] == 1'b1)? 32'h0000000e://eret
                    (Exception[3] == 1'b1)? 32'h0000000a://ri
                    (Exception[2] == 1'b1)? 32'h0000000c://ov
                    32'h0000_0000;

assign pc_new_M = (exception_type == 32'h00000001)? 32'hbfc0_0380:
                (exception_type == 32'h00000004)? 32'hbfc0_0380:
                (exception_type == 32'h00000005)? 32'hbfc0_0380:
                (exception_type == 32'h00000008)? 32'hbfc0_0380:
                (exception_type == 32'h00000009)? 32'hbfc0_0380:
                (exception_type == 32'h0000000a)? 32'hbfc0_0380:
                (exception_type == 32'h0000000c)? 32'hbfc0_0380:
                (exception_type == 32'h0000000e)? cp0_epc: 32'h0000_0000;

endmodule
