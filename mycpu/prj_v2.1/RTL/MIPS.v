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


module MIPS(clk,rst,
PCF,InstF,
ReadDataM,MemEnableM,MemWenM,MemAddrM,WriteDataM,
PCW,RegWriteW,WriteRegW,WriteData3W);
    input clk;
    input rst;
    //inst
    input [31:0] InstF;
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
    wire ForwardAD,ForwardBD;
    wire [1:0] ForwardAE,ForwardBE;

    wire HiloWriteE,HilotoRegE,HiloSrcE;//HILO
    wire [1:0] RetSrcM;

    wire MDUReadyE;//MDU
    wire StallE;

    wire BreakD;
    wire SyscallD;
    wire CP0WriteM;
    wire DelaySlotM;

    Controller MIPS_Controller(clk,rst,StallF,StallE,FlushE,opD,FunctD,RsD,RtD,
    BranchD,JumpD,JumpSrcD,ALUControlE,AluSrcE,RegDstE,MemReadE,RegWriteE,LinkE,LinkDstE,RegWriteM,MemWriteM,MemReadM,RegWriteW,MemReadW,
    HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,BreakD,SyscallD,CP0WriteM,DelaySlotM);
    Datapath MIPS_Datapath(clk,rst,InstF,StallF,JumpD,JumpSrcD,StallD,FlushD,ForwardAD,ForwardBD,ALUControlE,AluSrcE,RegDstE,LinkE,LinkDstE,StallE,FlushE,ForwardAE,
                            ForwardBE,MemWriteM,MemReadM,ReadDataM,RegWriteW,MemReadW,HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,BreakD,SyscallD,CP0WriteM,DelaySlotM,
    PCF,opD,FunctD,RsD,RtD,PCSrcD,RsE,RtE,WriteRegE,MemEnableM,MemWenM,MemAddrM,WriteDataM,WriteRegM,WriteRegW,MDUReadyE,
    PCW,WriteData3W);
    HazardUnit MIPS_HazardUnit(MemReadE,RegWriteE,MemReadM,RegWriteM,RegWriteW,RsD,RtD,PCSrcD,BranchD,JumpD,JumpSrcD,RsE,RtE,WriteRegE,WriteRegM,WriteRegW,MDUReadyE,
                            StallF,StallD,StallE,ForwardAD,ForwardBD,FlushD,FlushE,ForwardAE,ForwardBE);
endmodule
