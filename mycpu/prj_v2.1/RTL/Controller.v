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


module Controller(clk,rst,StallF,StallE,FlushE,opD,FunctD,RsD,RtD,
BranchD,JumpD,JumpSrcD,ALUControlE,AluSrcE,RegDstE,MemReadE,RegWriteE,LinkE,LinkDstE,RegWriteM,MemWriteM,MemReadM,RegWriteW,MemReadW,
HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,
BreakD,SyscallD,CP0WriteM,DelaySlotM);
    input clk;
    input rst;
    input StallF;
    input StallE;
    input FlushE;
    input [5:0] opD;//ID
    input [5:0] FunctD;
    input [4:0] RsD;
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
    output [1:0] RetSrcM;

    output BreakD;
    output SyscallD;
    output CP0WriteM;
    output DelaySlotM;

    wire RegWriteD;
    wire MemWriteD,MemWriteE;
    wire MemReadD;
    wire [4:0] ALUControlD;
    wire AluSrcD;
    wire RegDstD;
    wire LinkD;
    wire LinkDstD;
    
    wire [1:0] RetSrcD,RetSrcE;
    wire HiloWriteD,HilotoRegD,HiloSrcD;
    wire HiloWriteE,HilotoRegE;

    wire CP0WriteD,CP0WriteE;
    wire DelaySlotF,DelaySlotD,DelaySlotE;

    Maindec ControlMaindec(opD,FunctD,RsD,RtD,RegWriteD,RegDstD,RetSrcD,AluSrcD,MemWriteD,MemReadD,
                            HiloWriteD,HilotoRegD,HiloSrcD,
                            BranchD,JumpD,JumpSrcD,
                            LinkD,LinkDstD,
                            BreakD,SyscallD,CP0WriteD);
    Aludec ControlAludec(opD,FunctD,ALUControlD);

    assign DelaySlotF = (|BranchD) | JumpD;
    Flopenrc #(1) ControlReg_IF_ID(clk,rst,~StallF,{DelaySlotF},{DelaySlotD});
    Flopenrc #(19) ControlReg_ID_EX(clk,rst,FlushE,~StallE,
                                    {RegWriteD,RegDstD,AluSrcD,MemWriteD,MemReadD,ALUControlD,RetSrcD,LinkD,LinkDstD,HiloWriteD,HilotoRegD,HiloSrcD,CP0WriteD,DelaySlotD},
                                    {RegWriteE,RegDstE,AluSrcE,MemWriteE,MemReadE,ALUControlE,RetSrcE,LinkE,LinkDstE,HiloWriteE,HilotoRegE,HiloSrcE,CP0WriteE,DelaySlotE});
    Flopr #(9) ControlReg_EX_MEM(clk,rst,
                                {RegWriteE,MemWriteE,MemReadE,RetSrcE,HiloWriteE,HilotoRegE,CP0WriteE,DelaySlotE},
                                {RegWriteM,MemWriteM,MemReadM,RetSrcM,HiloWriteM,HilotoRegM,CP0WriteM,DelaySlotM});
    Flopr #(2) ControlReg_MEM_WB(clk,rst,
                                {RegWriteM,MemReadM},
                                {RegWriteW,MemReadW});
endmodule
