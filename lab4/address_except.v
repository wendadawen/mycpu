`timescale 1ns / 1ps
`include "defines.vh"

//	LH指令的访存地址不是2的整数倍或LW指令的访存地址不是4的整数倍会触发地址错例外
//  SH指令的访存地址不是2的整数倍或SW指令的访存地址不是4的整数倍会触发地址错例外


module address_except (
    input [31:0] addrs,     //访存地址
    input [7:0] alucontrolM,//访存类型
    output reg load_address_except,       //LH、LW指令地址错例外
    output reg store_address_except        //LH、LW指令地址错例外
);
    always@(*) begin
        load_address_except <= 1'b0;      
        store_address_except <= 1'b0;
        case (alucontrolM)
            `EXE_LH_OP: if (addrs[1:0] != 2'b00 & addrs[1:0] != 2'b10 ) begin
                load_address_except <= 1'b1;
            end
            `EXE_LHU_OP: if ( addrs[1:0] != 2'b00 & addrs[1:0] != 2'b10 ) begin
                load_address_except <= 1'b1;
            end
            `EXE_LW_OP: if ( addrs[1:0] != 2'b00 ) begin
                load_address_except <= 1'b1;
            end
            `EXE_SH_OP: if (addrs[1:0] != 2'b00 & addrs[1:0] != 2'b10 ) begin
                store_address_except <= 1'b1;
            end
            `EXE_SW_OP: if ( addrs[1:0] != 2'b00 ) begin
                store_address_except <= 1'b1;
            end
            default: begin
                load_address_except <= 1'b0;
                store_address_except <= 1'b0;
            end
        endcase
    end
endmodule
