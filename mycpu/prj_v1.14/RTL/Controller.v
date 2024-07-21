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
BranchD,JumpD,JumpSrcD,ALUControlE,AluSrcE,RegDstE,MemReadE,RegWriteE,LinkE,LinkDstE,opM,RegWriteM,MemWriteM,MemReadM,RegWriteW,MemtoRegW,
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
    output [5:0] opM;//MEM
    output RegWriteM;
    output MemWriteM;
    output MemReadM;
    output RegWriteW;//WB
    output MemtoRegW;

    output HiloWriteE,HilotoRegE,HiloSrcE;//HILO
    output RetSrcM;

    wire [5:0] opE;
    wire RegWriteD;
    wire MemtoRegD,MemtoRegE,MemtoRegM;
    wire MemWriteD,MemWriteE;
    wire MemReadD;
    wire [4:0] ALUControlD;
    wire AluSrcD;
    wire RegDstD;
    wire LinkD;
    wire LinkDstD;
    
    wire RetSrcD,HiloWriteD,HilotoRegD,HiloSrcD;
    wire RetSrcE,HiloWriteE,HilotoRegE;

    Maindec ControlMaindec(opD,FunctD,RtD,RegWriteD,RegDstD,RetSrcD,AluSrcD,MemWriteD,MemReadD,MemtoRegD,HiloWriteD,HilotoRegD,HiloSrcD,BranchD,JumpD,JumpSrcD,LinkD,LinkDstD);
    Aludec ControlAludec(opD,FunctD,ALUControlD);

    Flopenrc #(23) ControlReg_ID_EX(clk,rst,FlushE,~StallE,{opD,RegWriteD,RegDstD,AluSrcD,MemWriteD,MemReadD,MemtoRegD,ALUControlD,RetSrcD,LinkD,LinkDstD,HiloWriteD,HilotoRegD,HiloSrcD},
                                                {opE,RegWriteE,RegDstE,AluSrcE,MemWriteE,MemReadE,MemtoRegE,ALUControlE,RetSrcE,LinkE,LinkDstE,HiloWriteE,HilotoRegE,HiloSrcE});
    Flopr #(13) ControlReg_EX_MEM(clk,rst,{opE,RegWriteE,MemWriteE,MemReadE,MemtoRegE,RetSrcE,HiloWriteE,HilotoRegE},
                                        {opM,RegWriteM,MemWriteM,MemReadM,MemtoRegM,RetSrcM,HiloWriteM,HilotoRegM});
    Flopr #(2) ControlReg_MEM_WB(clk,rst,{RegWriteM,MemtoRegM},
                                        {RegWriteW,MemtoRegW});
endmodule
