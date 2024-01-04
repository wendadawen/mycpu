`timescale 1ns / 1ps

module mycpu_top(
    input clk,
    input resetn,  //low active
    input wire [5:0] ext_int,
    //cpu inst sram
    output        inst_sram_en   ,
    output [3 :0] inst_sram_wen  ,
    output [31:0] inst_sram_addr ,
    output [31:0] inst_sram_wdata,
    input  [31:0] inst_sram_rdata,
    //cpu data sram
    output        data_sram_en   ,
    output [3 :0] data_sram_wen  ,
    output [31:0] data_sram_addr ,
    output [31:0] data_sram_wdata,
    input  [31:0] data_sram_rdata,

    //debug 信号
    output wire [31:0] debug_wb_pc,
	output wire [3:0] debug_wb_rf_wen,
	output wire [4:0] debug_wb_rf_wnum,
	output wire [31:0] debug_wb_rf_wdata
);

// 一个例子
	wire [31:0] pc;
	wire [31:0] instr;
	wire [3:0] memwrite;
	wire [31:0] aluout, writedata, readdata;
    // 添加的信号
    wire [31:0] pcW;
    wire regwriteW, memenM;
    wire [4:0] writereg2W;
    wire [31:0] result2W;
    wire [31:0]pc_physicalF;
    wire [31:0]data_paddr;
    wire cache;
    mips mips(
        .clk(~clk),
        .rst(~resetn),
        //instr
        // .inst_en(inst_en),
        .pcF(pc),                    //pcF
        .instrF(instr),              //instrF
        //data
        // .data_en(data_en),
        .memwriteM(memwrite),
        .aluoutM(aluout),
        .writedataM(writedata),
        .readdataM(readdata),
        .pcW(pcW),
        .regwriteW(regwriteW),
        .writeregW(writereg2W),
        .resultW(result2W),
        .memenM(memenM),
        .pc_physicalF(pc_physicalF), // 要输出
        .data_paddr(data_paddr),
        .cache(cache)
    );

    assign inst_sram_en = 1'b1;     //如果有inst_en，就用inst_en
    assign inst_sram_wen = 4'b0;
    assign inst_sram_addr = pc_physicalF;
    assign inst_sram_wdata = 32'b0;
    assign instr = inst_sram_rdata;

    assign data_sram_en = memenM;     // 这个使能信号继续向上查找
    assign data_sram_wen = memwrite;
    assign data_sram_addr = data_paddr;
    assign data_sram_wdata = writedata;
    assign readdata = data_sram_rdata;

    assign	debug_wb_pc			= pcW;
	assign	debug_wb_rf_wen		= {4{regwriteW}};
	assign	debug_wb_rf_wnum	= writereg2W;
	assign	debug_wb_rf_wdata	= result2W;

    //ascii
    // instdec instdec(
    //     .instr(instr)
    // );

endmodule