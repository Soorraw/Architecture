`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 08:52:16
// Design Name: 
// Module Name: Maindec
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

module Maindec(op,Funct,RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump);//,ALUOp);
    input [5:0] op;
    input [5:0] Funct;
    // input [4:0] rt;

    output RegWrite;
    output RegDst;
    output AluSrc;
    output Branch;
    output MemWrite;
    output MemtoReg;
    output MemRead;
    output Jump;
    
    // output [1:0] ALUOp;

assign {RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump} =
    (op == `R_TYPE)?
        (0)?0:
        8'b1100_0000
    :(op == `ANDI || op == `XORI || op == `ORI || op == `LUI || 
        op == `ADDI || op == `ADDIU || op == `SLTI || op == `SLTIU)?8'b1010_0000
    

    :`NOISE;
    // (op==6'b00_0000)?10'b11_0000_0010://R-type
    // (op==6'b10_0011)?10'b10_1001_1000://lw
    // (op==6'b10_1011)?10'b0X_101X_0000://sw
    // (op==6'b00_0100)?10'b0X_010X_0001://beq
    // (op==6'b00_1000)?10'b10_1000_0000://addi
    // (op==6'b00_0010)?10'b0X_XX0X_01XX:10'bXX_XXXX_XXXX;//j
endmodule
