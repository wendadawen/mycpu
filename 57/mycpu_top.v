module mycpu_top(
    input clk,
    input resetn,
    input [5:0] ext_int,

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
    //debug
    output [31:0] debug_wb_pc,
    output [3 :0] debug_wb_rf_wen,
    output [4 :0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
);

    wire [31:0] inst_vaddr,inst_paddr;
    wire [31:0] data_vaddr,data_paddr;
    wire no_dcache;
    mmu mmu(inst_vaddr,inst_paddr,data_vaddr,data_paddr,no_dcache);

    wire [31:0] pc;
	wire [31:0] instr;
	wire [3:0] memwrite;
	wire [31:0] aluout, writedata, readdata;
    wire [31:0] pc_W;
	wire RegWrite_W;
	wire [4:0] write_reg_W;
	wire [31:0] result_W;
    wire stall;
    mips mips(
        .clk(~clk),
        .rst(~resetn),
        
        .pcF(pc),
        .instrF(instr),
        
        //data
        .memwriteM(memwrite),
        .aluoutM(aluout),
        .writedataM(writedata),
        .readdataM(readdata),
        
        //debug
        .stall(stall),
        .pc_W(debug_wb_pc),
        .RegWrite_W(RegWrite_W),
        .write_reg_W(write_reg_W),
        .result_W(result_W)
    );

    assign inst_sram_en      = 1'b1;
    assign inst_sram_wen     = 4'b0;
    assign inst_sram_addr    = inst_paddr;
    assign inst_sram_wdata   = 32'b0;
    assign instr             = inst_sram_rdata;

    assign inst_vaddr        = pc;
    assign data_vaddr        = {aluout[31:2], 2'b00};

    assign data_sram_en      = 1'b1;
    assign data_sram_wen     = memwrite;
    assign data_sram_addr    = data_paddr;
    assign data_sram_wdata   = writedata;
    assign readdata          = data_sram_rdata;

    assign debug_wb_pc       = pc_W;
    assign debug_wb_rf_wen   = {4{RegWrite_W & ~stall}};
    assign debug_wb_rf_wnum  = write_reg_W;
    assign debug_wb_rf_wdata = result_W;

    //ascii
    instdec instdec(
        .instr(instr)
    );


endmodule
