`timescale 1ns / 1ps
// 说明
// except[6:0] = {0: eret, 1: syscall, 2: break, 3: reserve, 4: overflow, 5: adelM, 6: adesM}
//ExcCode:
	// 0x00 中断
	// 0x04 读数据或者取指令地址例外
	// 0x05 写数据地址例外
	// 0x08 系统调用例外 
	// 0x09 断点例外
	// 0x0a 保留指令例外
	// 0x0c 算数溢出例外
module except (
    input wire rst, 
    input wire [31:0] pcM,
    input wire [6:0] exceptM,
    input wire [31:0] cp0_status,
    input wire [31:0] cp0_cause,
    input wire [31:0] aluout,
    output wire [31:0] except_type,
    output wire [31:0] bad_addr
);
    	// exception type
	assign except_type = (rst)? 32'h0000_0000:
	                      ((cp0_cause[15:8] & cp0_status[15:8]) != 8'h00 && cp0_status[1] == 1'b0 && cp0_status[0] == 1'b1)? 32'h0000_0001: // interrupt
						  (pcM[1:0]!=2'b00)? 32'h0000_0004: // AdEL
						  (exceptM[0])? 32'h0000_000e: // eret
						  (exceptM[1])? 32'h0000_0008: // syscall
						  (exceptM[2])? 32'h0000_0009: // break
						  (exceptM[3])? 32'h0000_000a: // reserve
						  (exceptM[4])? 32'h0000_000c: // overflow
						  (exceptM[5])? 32'h0000_0004: // adelM
						  (exceptM[6])? 32'h0000_0005: // adesM
						  32'h0;

    // bad address 地址错误例外只有三种可能，分别为取指令地址错误，内存存取数据地址错误
	assign bad_addr = (rst)? 32'h0:
					  ((cp0_cause[15:8] & cp0_status[15:8]) != 8'h00 && cp0_status[1] == 1'b0 && cp0_status[0] == 1'b1)? 32'h0:
					  (pcM[1:0]!=2'b00)? pcM:
					  (exceptM[0])? 32'h0:
					  (exceptM[1])? 32'h0:
					  (exceptM[2])? 32'h0:
					  (exceptM[3])? 32'h0:
					  (exceptM[4])? 32'h0:
					  (exceptM[5])? aluout:
					  (exceptM[6])? aluout:
					  32'h0;                      
endmodule