`timescale 1ns / 1ps
`include "defines.vh"

module exception(
	input wire rst, longest_stall,
    // adel syscall break eret reverseInstr overflow  [1:0]
    input wire [7:0] Exception,
    input wire adel, ades,
    input wire [31:0] cp0_status1, cp0_cause1, cp0_epc1,
    input wire Cp0Write_M,
    input wire [4:0] rd_M,
    input wire [31:0] alu_out_M,
    output reg [31:0] exception_type, pc_new_M
);

    reg [31:0] cp0_status, cp0_cause, cp0_epc;

    always @(*) begin
        if (longest_stall) begin
            cp0_epc <= cp0_epc1;
            cp0_status <= cp0_status1;
            cp0_cause <= cp0_cause1;
            // cp0_epc <= cp0_epc;
            // cp0_status <= cp0_status;
            // cp0_cause <= cp0_cause;
        end else begin
            // if (Cp0Write_M & (rd_M==5'b01100)) begin
            //     cp0_status <= alu_out_M;
            // end else begin
            //     cp0_status <= cp0_status1;
            // end
            // if (Cp0Write_M & (rd_M==5'b01110)) begin
            //     cp0_epc <= alu_out_M;
            // end else begin
            //     cp0_epc <= cp0_epc1;
            // end
            // if (Cp0Write_M & (rd_M==5'b01101)) begin
            //     cp0_cause <= alu_out_M;
            // end else begin
            //     cp0_cause <= cp0_cause1;
            // end
            cp0_epc <= cp0_epc1;
            cp0_status <= cp0_status1;
            cp0_cause <= cp0_cause1;
        end
    end
    // 0: 79 ,exception_type: 79 , 删除：过
    always @(*) begin
        if (rst) begin exception_type <= 32'b0;pc_new_M <= 32'h0000_0000; end
        // else if (longest_stall) begin exception_type <= 32'h0000_0000;pc_new_M <= 32'hbfc0_0380; end
        else if (((cp0_cause[15:8]&cp0_status[15:8]) != 8'h00) && (cp0_status[1] == 1'b0) && (cp0_status[0] == 1'b1)) begin exception_type <= 32'h00000001;pc_new_M <= 32'hbfc0_0380;end
        else if (Exception[7] == 1'b1 | adel) begin exception_type <= 32'h00000004;pc_new_M <= 32'hbfc0_0380;end
        else if (ades) begin exception_type <= 32'h00000005;pc_new_M <= 32'hbfc0_0380;end//ades
        else if (Exception[6] == 1'b1) begin exception_type <= 32'h00000008;pc_new_M <= 32'hbfc0_0380;end//syscall
        else if (Exception[5] == 1'b1) begin exception_type <= 32'h00000009;pc_new_M <= 32'hbfc0_0380;end//break
        else if (Exception[4] == 1'b1) begin exception_type <= 32'h0000000e;pc_new_M <= cp0_epc; end//eret
        else if (Exception[3] == 1'b1) begin exception_type <= 32'h0000000a;pc_new_M <= 32'hbfc0_0380;end//ri
        else if (Exception[2] == 1'b1) begin exception_type <= 32'h0000000c;pc_new_M <= 32'hbfc0_0380;end//ov
        else begin exception_type <= 32'h0000_0000; pc_new_M <= 32'h0000_0000; end
    end

endmodule
