`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 22:05:42
// Design Name: 
// Module Name: Datapath
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

`include "defines2.vh"
module Datapath(clk,rst,Int,Inst,StallF,JumpD,JumpSrcD,StallD,FlushD,ForwardAD,ForwardBD,ALUControlE,AluSrcE,RegDstE,LinkE,LinkDstE,StallE,FlushE,ForwardAE,
                ForwardBE,StallM,FlushM,MemWriteM,MemReadM,ReadDataM,StallW,FlushW,RegWriteW,MemReadW,HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,BreakD,SyscallD,
                ReserveD,CP0WriteM,DelaySlotM,
InstEnableF,PCF,opD,FunctD,RsD,RtD,EretD,PCSrcD,RsE,RtE,WriteRegE,MemEnableM,MemWenM,MemAddrM,TWriteDataM,WriteRegM,WriteRegW,MDUReadyE,
PCW,WriteData3W,
ExceptDealM);
    input clk;
    input rst;
    input [5:0] Int;
    input [31:0] Inst;
    input StallF;//IF

    input JumpD;//ID
    input JumpSrcD;
    input StallD;
    input FlushD;
    input ForwardAD,ForwardBD;
    input [4:0] ALUControlE;//EX
    input AluSrcE;
    input RegDstE;
    input LinkE;
    input LinkDstE;
    input StallE;
    input FlushE;
    input [1:0] ForwardAE,ForwardBE;
    input StallM;//MEM
    input FlushM;
    input MemWriteM;
    input MemReadM;
    input [31:0] ReadDataM;
    input StallW;//WB
    input FlushW;
    input RegWriteW;
    input MemReadW;

    input HiloWriteE,HilotoRegE,HiloSrcE;//HILO
    input [1:0] RetSrcM;
    input BreakD;//Exception
    input SyscallD;
    input ReserveD;
    input CP0WriteM;//CP0
    input DelaySlotM;

    output InstEnableF;//IF
    output [31:0] PCF;
    output [5:0] opD,FunctD;
    output [4:0] RsD,RtD;//ID
    output EretD;
    output PCSrcD;
    output [4:0] RsE,RtE;//EX
    output [4:0] WriteRegE;
    output MemEnableM;//MEM
    output [3:0] MemWenM;
    output [31:0] MemAddrM;
    output [31:0] TWriteDataM;
    output [4:0] WriteRegM;
    output [4:0] WriteRegW;//WB
    output MDUReadyE;//MDU

    output [31:0] PCW;//debug
    output [31:0] WriteData3W;

    output ExceptDealM;

    wire [31:0] PC;//IF
    wire [31:0] InstF;
    wire [31:0] PCPlus4F;
    wire [31:0] Branch_Addr;
    wire [31:0] Jump_Addr;
    wire [31:0] PCD;//ID
    wire [31:0] InstD;
    wire [31:0] PCPlus4D;
    wire [4:0] RdD;
    wire EqualD;
    wire [31:0] SrcAD,BeqSrcBD;
    wire [31:0] ReadData1D,ReadData2D;
    wire [31:0] ExtendD;
    wire [4:0] saD;
    wire [31:0] PCE;//EX
    wire [5:0] opE;
    wire [31:0] ReadData1E,ReadData2E;
    wire [4:0] RdE;
    wire [31:0] ExtendE;
    wire [4:0] saE;
    wire [31:0] WriteDataE;
    wire [31:0] SrcAE,SrcBE;
    wire [31:0] ALUResultE;
    wire [31:0] EXResultE;
    wire [31:0] PCM;//MEM
    wire [5:0] opM;
    wire [4:0] RdM;
    wire [2:0] SelM;
    wire [31:0] MEMResultM;
    wire [31:0] TReadDataM;
    wire [31:0] WriteDataM;
    wire [31:0] EXResultM;
    wire [31:0] ReadDataW;//WB
    wire [31:0] MEMResultW;
    wire [4:0] WriteRegW;

    wire [31:0] HiloutM;//HILO
    wire [31:0] HiloutW;
    wire HiloStallM;

    wire [63:0] MDUResultE;//MDU

    wire [31:0] ExcepTypeF,ExcepTypeD,ExcepTypeE,ExcepTypeM;//Exception & CP0
    wire AdelF;
    wire IntegerOverflowE;
    wire AdelM;
    wire AdesM;
    wire EretM;
    wire [31:0] Badaddr;
    wire [4:0] EXcCode;
    wire [31:0] CP0outM;
    wire [31:0] BadVAddr;
    wire [31:0] Count;
    wire [31:0] Status;
    wire [31:0] Cause;
    wire [31:0] EPC;

    PC PCRegF(clk,rst,~StallF,PC,AdelF,PCF);//IF
    
    assign InstEnableF = ~AdelF;
    assign InstF = (InstEnableF)? Inst : 32'b0;
    assign ExcepTypeF = 32'b0;
    assign PCPlus4F = PCF + 32'd4;//IF
    assign PC = (EretM)? EPC :
                (ExceptDealM)? 32'hbfc00380 :
                (JumpD)? ((JumpSrcD)? SrcAD : Jump_Addr) :
                (PCSrcD)? Branch_Addr : PCPlus4F;

    Flopenrc #(128) PiplineReg_IF_ID(clk,rst,FlushD,~StallD,{PCF,InstF,PCPlus4F,{ExcepTypeF[31:5],AdelF,ExcepTypeF[3:0]}},
                                                            {PCD,InstD,PCPlus4D,ExcepTypeD});//IF_ID
    Regfile RegfileD(~clk,rst,RegWriteW,RsD,RtD,WriteRegW,WriteData3W,ReadData1D,ReadData2D);//ID
    BranchCompare BranchCompareD(opD,RtD,SrcAD,BeqSrcBD,PCSrcD);

    assign opD = InstD[31:26];//ID
    assign FunctD = InstD[5:0];
    assign RsD = InstD[25:21];
    assign RtD = InstD[20:16];
    assign RdD = InstD[15:11];
    assign SrcAD = (ForwardAD)? MEMResultM : ReadData1D;
    assign BeqSrcBD = (ForwardBD)? MEMResultM : ReadData2D;
    
    assign ExtendD = (opD[3:2] == 2'b11) ? {{16{1'b0}},InstD[15:0]} : {{16{InstD[15]}},InstD[15:0]};
    assign saD = InstD[10:6];
    assign Branch_Addr = PCPlus4D + {ExtendD[30:0],2'b00};
    assign Jump_Addr = {PCPlus4D[31:28],InstD[25:0],2'b00};
    
    assign EretD = (InstD == `ERET);

    Flopenrc #(186) PiplineReg_ID_EX(clk,rst,FlushE,~StallE,
                                    {PCD,opD,RsD,RtD,RdD,ExtendD,saD,ReadData1D,ReadData2D,{ExcepTypeD[31:15],EretD,ExcepTypeD[13:11],ReserveD,BreakD,SyscallD,ExcepTypeD[7:0]}},
                                    {PCE,opE,RsE,RtE,RdE,ExtendE,saE,ReadData1E,ReadData2E,ExcepTypeE});//ID_EX
    ALU ALUE(ALUControlE,SrcAE,SrcBE,saE,ALUResultE,IntegerOverflowE);
    MDU MDUE(~clk,rst,FlushE,~StallE,ALUControlE,SrcAE,SrcBE,MDUResultE,MDUReadyE);

    assign SrcAE = (ForwardAE == 2'b00)? ReadData1E:
                    (ForwardAE == 2'b01)? WriteData3W:
                    (ForwardAE == 2'b10)? MEMResultM : 32'b0;
    assign WriteDataE = (ForwardBE == 2'b00)? ReadData2E:
                        (ForwardBE == 2'b01)? WriteData3W:
                        (ForwardBE == 2'b10)? MEMResultM : 32'b0;
    assign SrcBE = (AluSrcE)? ExtendE : WriteDataE;
    assign WriteRegE = (RegDstE)? ((LinkDstE)? 32'd31 : RdE) : RtE;
    assign EXResultE = (LinkE)? PCPlus4D : ALUResultE;

    Flopenrc #(144) PiplineReg_EX_MEM(clk,rst,FlushM,~StallM,{PCE,opE,EXResultE,WriteDataE,WriteRegE,RdE,{ExcepTypeE[31:13],IntegerOverflowE,ExcepTypeE[11:0]}},
                                            {PCM,opM,EXResultM,WriteDataM,WriteRegM,RdM,ExcepTypeM});//EX_MEM
    HILO Hilo_EX_MEM(clk,rst,~HiloStallM,HiloWriteE,HilotoRegE,HiloSrcE,SrcAE,MDUResultE,HiloutM);//MEM流水线刷新的时候,Hilo应该是阻塞
    Translator TranslatorM(opM,MemWriteM,MemReadM,MemEnableM,MemWenM,EXResultM,MemAddrM,ReadDataM,TReadDataM,WriteDataM,TWriteDataM,AdelM,AdesM);
    Exception ExceptionM(rst,ExcepTypeM,AdelM,AdesM,EXcCode);
    CP0 CP0M(~clk,rst,~StallM,CP0WriteM,RdM,SelM,WriteDataM,Int,EXcCode,Badaddr,DelaySlotM,PCM,
            CP0outM,BadVAddr,Count,Status,Cause,EPC,ExceptDealM);//如果需要前推的话理论上就只有半个周期可供运算了
    
    assign HiloStallM = StallM || FlushM;
    assign SelM = 3'b0;
    assign EretM = (ExceptDealM && (EXcCode == `Eret));
    assign Badaddr = (AdelM || AdesM)? EXResultM : PCM;
    assign MEMResultM = (RetSrcM[1])? CP0outM :
                        (RetSrcM[0])? HiloutM : EXResultM;

    Flopenrc #(133) PiplineReg_MEM_WB(clk,rst,FlushW,~StallW,
                                    {PCM,TReadDataM,MEMResultM,WriteRegM,HiloutM},
                                    {PCW,ReadDataW,MEMResultW,WriteRegW,HiloutW});//MEM_WB

    assign WriteData3W = (MemReadW)? ReadDataW : MEMResultW;
endmodule
