
// 该模块的目的是为了实现lw等取数指令读取整字节数并实现无符号和有符号扩展
`timescale 1ns / 1ps
`include "defines.vh"

module lw_instr_select(
    input wire address_exceptation,
    input wire [31:0] aluoutW, // alu计算出来的访问内存的地址
    input wire [7:0] alucontrol,// 根据指令的类型来实现有无符号扩展
    input wire [31:0] lw_result, // 从内存中读取出来的整字数据
    output reg[31:0] result // 根据不同访存指令得到的数据
);

    always @(*) begin
        if(~address_exceptation) begin
            case (alucontrol)
                `EXE_LB_OP: case (aluoutW[1:0]) // 根据最后两位来判断读取的字节
                    2'b00: result = {{24{lw_result[7]}}, lw_result[7:0]};
                    2'b01: result = {{24{lw_result[15]}}, lw_result[15:8]};
                    2'b10: result = {{24{lw_result[23]}}, lw_result[23:16]};
                    2'b11: result = {{24{lw_result[31]}}, lw_result[31:24]};
                    default: result = lw_result;
                endcase
                `EXE_LBU_OP: case (aluoutW[1:0])
                    2'b00: result = {24'b0, lw_result[7:0]};
                    2'b01: result = {24'b0, lw_result[15:8]};
                    2'b10: result = {24'b0, lw_result[23:16]};
                    2'b11: result = {24'b0, lw_result[31:24]};
                    default: result = lw_result; 
                endcase
                `EXE_LH_OP: case(aluoutW[1:0])  //LH指令读取2字节并按符号扩展
                    2'b00: result = {{16{lw_result[15]}},lw_result[15:0]};
                    2'b10: result = {{16{lw_result[31]}},lw_result[31:16]};
                    default: result = lw_result;  
                endcase
                `EXE_LHU_OP: case(aluoutW[1:0])  //LH指令读取2字节并按无符号扩展
                    2'b00: result = {{16{1'b0}},lw_result[15:0]};
                    2'b10: result = {{16{1'b0}},lw_result[31:16]};
                    default: result = lw_result;  
                endcase
                default: result = lw_result;   //LW指令读取4字节
            endcase
        end
        else begin // 越界
            result = 32'b0;
        end
    end
endmodule