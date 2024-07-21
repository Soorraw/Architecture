module mycpu_top(
    input clk,
    input resetn,  //low active
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

// 一个例子
	
	
    wire [31:0] inst_vaddr,inst_paddr;
    wire [31:0] data_vaddr,data_paddr;
    wire no_dcache;
    MIPS MIPS(
        .clk(~clk),
        .rst(~resetn),
        .Int(ext_int),

        //instr
        .inst_sram_en(inst_sram_en),
        .inst_sram_wen(inst_sram_wen),
        .inst_sram_addr(inst_vaddr),
        .inst_sram_wdata(inst_sram_wdata),
        .inst_sram_rdata(inst_sram_rdata),

        //data
        .data_sram_en(data_sram_en),
        .data_sram_wen(data_sram_wen),
        .data_sram_addr(data_vaddr),
        .data_sram_wdata(data_sram_wdata),
        .data_sram_rdata(data_sram_rdata),

        //debug
        .debug_wb_pc(debug_wb_pc),
        .debug_wb_rf_wen(debug_wb_rf_wen),
        .debug_wb_rf_wnum(debug_wb_rf_wnum),
        .debug_wb_rf_wdata(debug_wb_rf_wdata)
    );

    MMU MMU(inst_vaddr,inst_paddr,data_vaddr,data_paddr,no_dcache);
    assign inst_sram_addr = inst_paddr;
    assign data_sram_addr = data_paddr;

endmodule
