`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/17 10:08:15
// Design Name: 
// Module Name: MIPS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MIPS(
    input clk,
    input rst,
    input [5:0] Int,
    
    //inst
    output inst_sram_en,
    output [3 :0] inst_sram_wen,
    output [31:0] inst_sram_addr,
    output [31:0] inst_sram_wdata,
    input [31:0] inst_sram_rdata,
    
    //data
    output data_sram_en,
    output [3 :0] data_sram_wen,
    output [31:0] data_sram_addr,
    output [31:0] data_sram_wdata,
    input [31:0] data_sram_rdata,

    //debug
    output [31:0] debug_wb_pc,
    output [3 :0] debug_wb_rf_wen,
    output [4 :0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
    );

    wire [5:0] opD,FunctD;//Controller
    wire [1:0] BranchD;
    wire LinkE;
    wire LinkDstE;
    wire PCSrcD;
    wire JumpD;
    wire JumpSrcD;
    wire [4:0] ALUControlE;
    wire AluSrcE;
    wire RegDstE;
    wire MemReadE;
    wire RegWriteE;
    wire RegWriteM;
    wire MemWriteM;
    wire MemReadM;
    wire MemReadW;
    wire RegWriteW;
    wire [31:0] Inst;//Datapath
    wire InstEnableF;
    wire [31:0] PCF;
    wire [4:0] RsD,RtD;
    wire [4:0] RsE,RtE;
    wire [31:0] ReadDataM;
    wire MemEnableM;
    wire [3:0] MemWenM;
    wire [31:0] MemAddrM;
    wire [31:0] TWriteDataM;
    wire [4:0] WriteRegE,WriteRegM,WriteRegW;
    wire [31:0] PCW;
    wire [31:0] WriteData3W;
    wire StallD;//HazardUnit
    wire StallF;
    wire FlushD;
    wire FlushE;
    wire FlushM;
    wire FlushW;
    wire ForwardAD,ForwardBD;
    wire [1:0] ForwardAE,ForwardBE;

    wire HiloWriteE,HilotoRegE,HiloSrcE;//HILO
    wire [1:0] RetSrcM;

    wire MDUReadyE;//MDU
    wire StallE;

    wire EretD;
    wire BreakD;
    wire SyscallD;
    wire ReserveD;
    wire CP0WriteM;
    wire DelaySlotM;
    wire ExceptDealM;

    Controller Controller(clk,rst,StallD,FlushD,StallE,FlushE,FlushM,FlushW,opD,FunctD,RsD,RtD,EretD,
    BranchD,JumpD,JumpSrcD,ALUControlE,AluSrcE,RegDstE,MemReadE,RegWriteE,LinkE,LinkDstE,RegWriteM,MemWriteM,MemReadM,RegWriteW,MemReadW,
    HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,BreakD,SyscallD,ReserveD,CP0WriteM,DelaySlotM);
    Datapath Datapath(clk,rst,Int,Inst,StallF,JumpD,JumpSrcD,StallD,FlushD,ForwardAD,ForwardBD,ALUControlE,AluSrcE,RegDstE,LinkE,LinkDstE,StallE,FlushE,ForwardAE,
                            ForwardBE,FlushM,MemWriteM,MemReadM,ReadDataM,FlushW,RegWriteW,MemReadW,HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,
                            BreakD,SyscallD,ReserveD,CP0WriteM,DelaySlotM,
    InstEnableF,PCF,opD,FunctD,RsD,RtD,EretD,PCSrcD,RsE,RtE,WriteRegE,MemEnableM,MemWenM,MemAddrM,TWriteDataM,WriteRegM,WriteRegW,MDUReadyE,PCW,WriteData3W,ExceptDealM);
    HazardUnit HazardUnit(MemReadE,RegWriteE,MemReadM,RegWriteM,RegWriteW,RsD,RtD,PCSrcD,BranchD,JumpD,JumpSrcD,RsE,RtE,WriteRegE,WriteRegM,WriteRegW,MDUReadyE,ExceptDealM,
    StallF,StallD,StallE,ForwardAD,ForwardBD,FlushD,FlushE,FlushM,FlushW,ForwardAE,ForwardBE);

    //debug
    assign debug_wb_pc = PCW;
    assign debug_wb_rf_wen = {4{RegWriteW}};
    assign debug_wb_rf_wnum = WriteRegW;
    assign debug_wb_rf_wdata = WriteData3W;


    //Datapath通过Translator向外提供Sram类型的接口

    //inst
    assign inst_sram_en = InstEnableF;
    assign inst_sram_wen = 4'b0;
    assign inst_sram_addr = PCF;
    assign inst_sram_wdata = 32'b0;
    assign Inst = inst_sram_rdata;

    //data
    assign data_sram_en = MemEnableM;
    assign data_sram_wen = MemWenM;
    assign data_sram_addr = MemAddrM;
    assign data_sram_wdata = TWriteDataM;
    assign ReadDataM = data_sram_rdata;



endmodule
