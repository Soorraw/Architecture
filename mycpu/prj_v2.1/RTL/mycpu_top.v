module mycpu_top(
    input clk,
    input resetn,  //low active

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
	
	
    // wire [5:0] op;
    // wire memwrite;
    // wire memread;
    // wire [31:0] writedata, readdata;
    wire [31:0] instr;
    wire regwrite;
    wire [31:0] inst_vaddr,inst_paddr;
    wire [31:0] data_vaddr,data_paddr;
    wire no_dcache;
    MIPS mips(
        .clk(~clk),
        .rst(~resetn),
        
        //instr
        // .inst_en(inst_en),
        .PCF(inst_vaddr),                    //pcF
        .InstF(instr),              //instrF
        
        //data
        .ReadDataM(data_sram_rdata),
        .MemEnableM(data_sram_en),
        .MemWenM(data_sram_wen),
        .MemAddrM(data_vaddr),
        .WriteDataM(data_sram_wdata),
        
        //debug
        .PCW(debug_wb_pc),
        .RegWriteW(regwrite),
        .WriteRegW(debug_wb_rf_wnum),
        .WriteData3W(debug_wb_rf_wdata)
    );
    assign debug_wb_rf_wen = {4{regwrite}};

    MMU mmu(inst_vaddr,inst_paddr,data_vaddr,data_paddr,no_dcache);

    assign inst_sram_en = 1'b1;     //如果有inst_en，就用inst_en
    assign inst_sram_wen = 4'b0;
    assign inst_sram_addr = inst_paddr;
    assign inst_sram_wdata = 32'b0;
    assign instr = inst_sram_rdata;

    assign data_sram_addr = data_paddr;    //如果有data_en，就用data_en
    
    // assign data_sram_en = 1'b1;
    // assign data_sram_wen = {4{memwrite}};
    // assign data_sram_addr = aluout;
    // assign data_sram_wdata = writedata;
    // assign readdata = data_sram_rdata;

    // assign data_sram_en = memwrite | memread;
    // assign data_sram_addr = {data_paddr[31:2],2'b00};
    // Translator translator(op,data_vaddr[1:0],data_sram_wen,writedata,data_sram_wdata,data_sram_rdata,readdata);

    //ascii
    // instdec instdec(
    //     .instr(instr)
    // );

endmodule
