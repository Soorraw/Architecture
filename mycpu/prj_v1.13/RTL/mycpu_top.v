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
	wire [31:0] pc;
	wire [31:0] instr;
	
    wire [5:0] op;
    wire memwrite;
    wire memread;
	wire regwrite;
    wire [31:0] pcw;

    wire [31:0] aluout, writedata, readdata;
    MIPS mips(
        .clk(clk),
        .rst(~resetn),
        //instr
        // .inst_en(inst_en),
        .PCF(pc),                    //pcF
        .InstF(instr),              //instrF
        //data
        .opM(op),
        .MemWriteM(memwrite),
        .MemReadM(memread),
        .EXResultM(aluout),
        .WriteDataM(writedata),
        .ReadDataM(readdata),
        //debug
        .PCW(pcw),
        .RegWriteW(regwrite),
        .WriteRegW(debug_wb_rf_wnum),
        .WriteData3W(debug_wb_rf_wdata)
    );
    assign debug_wb_pc = pcw + 32'hbfc00000;
    assign debug_wb_rf_wen = {4{regwrite}};

    assign inst_sram_en = 1'b1;     //如果有inst_en，就用inst_en
    assign inst_sram_wen = 4'b0;
    assign inst_sram_addr = pc;
    assign inst_sram_wdata = 32'b0;
    assign instr = inst_sram_rdata;

    //如果有data_en，就用data_en
    // assign data_sram_en = 1'b1;
    // assign data_sram_wen = {4{memwrite}};
    // assign data_sram_addr = aluout;
    // assign data_sram_wdata = writedata;
    // assign readdata = data_sram_rdata;

    assign data_sram_en = memwrite | memread;
    assign data_sram_addr = aluout;
    Translator data_sram_Translator(op,data_sram_addr[1:0],data_sram_wen,writedata,data_sram_wdata,data_sram_rdata,readdata);

    //ascii
    // instdec instdec(
    //     .instr(instr)
    // );

endmodule
