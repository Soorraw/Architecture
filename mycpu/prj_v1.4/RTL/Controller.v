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


module Controller(clk,rst,clear,op,Funct,BranchD,JumpD,ALUControlE,AluSrcE,RegDstE,MemReadE,RegWriteE,RegWriteM,MemWriteM,MemReadM,RegWriteW,MemtoRegW);
    input clk;
    input rst;
    input clear;
    input [5:0] op;//ID
    input [5:0] Funct;
    output BranchD;//ID
    output JumpD;
    output [4:0] ALUControlE;//EX
    output AluSrcE;
    output RegDstE;
    output MemReadE;
    output RegWriteE;
    output RegWriteM;
    output MemWriteM;//MEM
    output MemReadM;
    output RegWriteW;//WB
    output MemtoRegW;
    wire [1:0] ALUOp;

    wire RegWriteD;
    wire MemtoRegD,MemtoRegE,MemtoRegM;
    wire MemWriteD,MemWriteE;
    wire MemReadD;
    wire [4:0] ALUControlD;
    wire AluSrcD;
    wire RegDstD;

    Maindec ControlMaindec(op,Funct,RegWriteD,RegDstD,AluSrcD,BranchD,MemWriteD,MemtoRegD,MemReadD,JumpD);//,ALUOp);
    Aludec ControlAludec(op,Funct,ALUControlD);

    Floprc #(11) ControlReg_ID_EX(clk,rst,clear,{RegWriteD,RegDstD,AluSrcD,MemWriteD,MemtoRegD,MemReadD,ALUControlD},{RegWriteE,RegDstE,AluSrcE,MemWriteE,MemtoRegE,MemReadE,ALUControlE});
    Flopr #(4) ControlReg_EX_MEM(clk,rst,{RegWriteE,MemWriteE,MemtoRegE,MemReadE},{RegWriteM,MemWriteM,MemtoRegM,MemReadM});
    Flopr #(2) ControlReg_MEM_WB(clk,rst,{RegWriteM,MemtoRegM},{RegWriteW,MemtoRegW});
endmodule
