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


module MIPS(clk,rst,InstF,ReadDataM,PCF,MemWriteM,MemReadM,EXResultM,WriteDataM);
    input clk;
    input rst;
    input [31:0] InstF;
    input [31:0] ReadDataM;

    output [31:0] PCF;
    output MemWriteM;
    output MemReadM;
    output [31:0] EXResultM;
    output [31:0] WriteDataM;

    
    wire [5:0] op,Funct;//Controller
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
    wire RegWriteW;
    wire MemtoRegW;
    wire [4:0] RsD,RtD;//Datapath
    wire [4:0] RsE,RtE;
    wire [4:0] WriteRegE,WriteRegM,WriteRegW;
    wire StallD;//HazardUnit
    wire StallF;
    wire FlushD;
    wire FlushE;
    wire ForwardAD,ForwardBD;
    wire [1:0] ForwardAE,ForwardBE;

    wire HiloWriteE,HilotoRegE,HiloSrcE;//HILO
    wire RetSrcM;

    wire MDUReadyE;//MDU
    wire StallE;

    Controller MIPS_Controller(clk,rst,StallE,FlushE,op,Funct,RtD,
    BranchD,JumpD,JumpSrcD,ALUControlE,AluSrcE,RegDstE,MemReadE,RegWriteE,LinkE,LinkDstE,RegWriteM,MemWriteM,MemReadM,RegWriteW,MemtoRegW,HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM);
    Datapath MIPS_Datapath(clk,rst,InstF,StallF,JumpD,JumpSrcD,StallD,FlushD,ForwardAD,ForwardBD,ALUControlE,AluSrcE,RegDstE,LinkE,LinkDstE,StallE,FlushE,ForwardAE,
                            ForwardBE,ReadDataM,RegWriteW,MemtoRegW,HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,
    PCF,op,Funct,RsD,RtD,PCSrcD,RsE,RtE,WriteRegE,EXResultM,WriteDataM,WriteRegM,WriteRegW,MDUReadyE);
    HazardUnit MIPS_HazardUnit(MemReadE,RegWriteE,RegWriteM,RegWriteW,RsD,RtD,PCSrcD,BranchD,JumpD,JumpSrcD,RsE,RtE,WriteRegE,WriteRegM,WriteRegW,MDUReadyE,
                            StallF,StallD,StallE,ForwardAD,ForwardBD,FlushD,FlushE,ForwardAE,ForwardBE);
endmodule
