`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/15 19:05:10
// Design Name: 
// Module Name: Controller
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


module Controller(clk,rst,StallE,FlushE,opD,FunctD,RtD,
BranchD,JumpD,JumpSrcD,ALUControlE,AluSrcE,RegDstE,MemReadE,RegWriteE,LinkE,LinkDstE,RegWriteM,MemWriteM,MemReadM,RegWriteW,MemReadW,
HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM);
    input clk;
    input rst;
    input StallE;
    input FlushE;
    input [5:0] opD;//ID
    input [5:0] FunctD;
    input [4:0] RtD;

    output [1:0] BranchD;//ID
    output JumpD;
    output JumpSrcD;
    output [4:0] ALUControlE;//EX
    output AluSrcE;
    output RegDstE;
    output MemReadE;
    output RegWriteE;
    output LinkE;
    output LinkDstE;
    output RegWriteM;//MEM
    output MemWriteM;
    output MemReadM;
    output RegWriteW;//WB
    output MemReadW;

    output HiloWriteE,HilotoRegE,HiloSrcE;//HILO
    output RetSrcM;

    wire RegWriteD;
    wire MemWriteD,MemWriteE;
    wire MemReadD;
    wire [4:0] ALUControlD;
    wire AluSrcD;
    wire RegDstD;
    wire LinkD;
    wire LinkDstD;
    
    wire RetSrcD,HiloWriteD,HilotoRegD,HiloSrcD;
    wire RetSrcE,HiloWriteE,HilotoRegE;

    Maindec ControlMaindec(opD,FunctD,RtD,RegWriteD,RegDstD,RetSrcD,AluSrcD,MemWriteD,MemReadD,HiloWriteD,HilotoRegD,HiloSrcD,BranchD,JumpD,JumpSrcD,LinkD,LinkDstD);
    Aludec ControlAludec(opD,FunctD,ALUControlD);

    Flopenrc #(16) ControlReg_ID_EX(clk,rst,FlushE,~StallE,{RegWriteD,RegDstD,AluSrcD,MemWriteD,MemReadD,ALUControlD,RetSrcD,LinkD,LinkDstD,HiloWriteD,HilotoRegD,HiloSrcD},
                                                {RegWriteE,RegDstE,AluSrcE,MemWriteE,MemReadE,ALUControlE,RetSrcE,LinkE,LinkDstE,HiloWriteE,HilotoRegE,HiloSrcE});
    Flopr #(6) ControlReg_EX_MEM(clk,rst,{RegWriteE,MemWriteE,MemReadE,RetSrcE,HiloWriteE,HilotoRegE},
                                        {RegWriteM,MemWriteM,MemReadM,RetSrcM,HiloWriteM,HilotoRegM});
    Flopr #(2) ControlReg_MEM_WB(clk,rst,{RegWriteM,MemReadM},
                                        {RegWriteW,MemReadW});
endmodule
