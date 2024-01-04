`timescale 1ns / 1ps
`include "defines.vh"


module sw_instr_select (
    input wire addr_store_M, 
    input [31:0] addressM,      //写内存地址,末两位决定写地址
    input [7:0] alucontrolM,    //指令类型
    output reg [3:0] memwriteM  //写地址类型
);
    always @(*) begin
        if(addr_store_M) 
            memwriteM = 4'b0000;
        else begin    
            case(alucontrolM)
                `EXE_SB_OP: begin
                    case(addressM[1:0])
                        2'b11: memwriteM = 4'b1000;
                        2'b10: memwriteM = 4'b0100;
                        2'b01: memwriteM = 4'b0010;
                        2'b00: memwriteM = 4'b0001;
                        default: memwriteM = 4'b0000;
                    endcase
                end    
                `EXE_SH_OP: begin
                    case(addressM[1:0])
                        2'b00: memwriteM = 4'b0011;
                        2'b10: memwriteM = 4'b1100;
                        default: memwriteM = 4'b0000;
                    endcase
                end
                `EXE_SW_OP:
                    memwriteM = 4'b1111;
                default: memwriteM = 4'b0000;       
            endcase
        end
    end
endmodule