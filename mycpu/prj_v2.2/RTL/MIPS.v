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


module MIPS(clk,rst,Int,
Inst,InstEnableF,PCF,
ReadDataM,MemEnableM,MemWenM,MemAddrM,WriteDataM,
PCW,RegWriteW,WriteRegW,WriteData3W);
    input clk;
    input rst;
    input [5:0] Int;
    //inst
    input [31:0] Inst;
    output InstEnableF;
    output [31:0] PCF;

    //data
    input [31:0] ReadDataM;
    output MemEnableM;
    output [3:0] MemWenM;
    output [31:0] MemAddrM;
    output [31:0] WriteDataM;//Datapath内称TWriteDataM,对外部屏蔽细节

    output [31:0] PCW;
    output RegWriteW;
    output [4:0] WriteRegW;
    output [31:0] WriteData3W;
    
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
    wire [4:0] RsD,RtD;//Datapath
    wire [4:0] RsE,RtE;
    wire [4:0] WriteRegE,WriteRegM;
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
    wire GoHandlerM;

    Controller MIPS_Controller(clk,rst,StallD,FlushD,StallE,FlushE,FlushM,FlushW,opD,FunctD,RsD,RtD,EretD,
    BranchD,JumpD,JumpSrcD,ALUControlE,AluSrcE,RegDstE,MemReadE,RegWriteE,LinkE,LinkDstE,RegWriteM,MemWriteM,MemReadM,RegWriteW,MemReadW,
    HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,BreakD,SyscallD,ReserveD,CP0WriteM,DelaySlotM);
    Datapath MIPS_Datapath(clk,rst,Int,Inst,StallF,JumpD,JumpSrcD,StallD,FlushD,ForwardAD,ForwardBD,ALUControlE,AluSrcE,RegDstE,LinkE,LinkDstE,StallE,FlushE,ForwardAE,
                            ForwardBE,FlushM,MemWriteM,MemReadM,ReadDataM,FlushW,RegWriteW,MemReadW,HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,
                            BreakD,SyscallD,ReserveD,CP0WriteM,DelaySlotM,
    InstEnableF,PCF,opD,FunctD,RsD,RtD,EretD,PCSrcD,RsE,RtE,WriteRegE,MemEnableM,MemWenM,MemAddrM,WriteDataM,WriteRegM,WriteRegW,MDUReadyE,
    PCW,WriteData3W,
    GoHandlerM);
    HazardUnit MIPS_HazardUnit(MemReadE,RegWriteE,MemReadM,RegWriteM,RegWriteW,RsD,RtD,PCSrcD,BranchD,JumpD,JumpSrcD,RsE,RtE,WriteRegE,WriteRegM,WriteRegW,MDUReadyE,
                                GoHandlerM,
    StallF,StallD,StallE,ForwardAD,ForwardBD,FlushD,FlushE,FlushM,FlushW,ForwardAE,ForwardBE);
endmodule
