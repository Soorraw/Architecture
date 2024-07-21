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

module Maindec(op,Funct,RegWrite,RegDst,RetSrc,AluSrc,MemWrite,MemRead,MemtoReg,HiloWrite,HilotoReg,HiloSrc,Branch,Jump);
    input [5:0] op;
    input [5:0] Funct;
    // input [4:0] rt;

    output RegWrite;
    output RegDst;
    output RetSrc;
    output AluSrc;
    output MemWrite;
    output MemRead;
    output MemtoReg;
    output HiloWrite;
    output HilotoReg;
    output HiloSrc;
    output Branch;
    output Jump;

    reg [11:0] Controls;
// RegWrite:写寄存器堆
// RegDst:目的寄存器号来源,0->Rt字段,1->Rd字段
// AluSrc:第二个ALU操作数源,0->第二个寄存器堆输出,1->立即数符号扩展
// RetSrc:MEM级Result源,0->ALU计算结果,1->HILO寄存器
// MemWrite:写数据存储器
// MemRead:读数据存储器
// MemtoReg:写入寄存器数据源,0->来自Result,1->来自数据存储器
// HiloWrite:写HILO寄存器
// HilotoReg:读/写HILO寄存器源,0->Lo字段,1->Hi字段
// HiloSrc:写HILO寄存器源,0->ALU,1->数据移动指令
// Branch:Branch指令
// Jump:Jump指令
assign {RegWrite,RegDst,AluSrc,RetSrc,
        MemWrite,MemRead,MemtoReg,
        HiloWrite,HilotoReg,HiloSrc,
        Branch,Jump} = Controls;
always @(*) 
begin
    case (op)
        `R_TYPE:
            case (Funct)
                `MFHI: Controls <= 12'b11X1_000_01X_00;
                `MFLO: Controls <= 12'b11X1_000_00X_00;
                `MTHI: Controls <= 12'b0XXX_000_111_00;
                `MTLO: Controls <= 12'b0XXX_000_101_00;
                `MULT,`MULTU,`DIV,`DIVU: Controls <= 12'b0X0X_000_1X0_00;
                default: Controls <= 12'b1100_000_XXX_00;
            endcase 
        `ANDI,`XORI,`ORI,`LUI,`ADDI,`ADDIU,`SLTI,`SLTIU: Controls <= 12'b1010_000_0X0_00;
        default: Controls <= `NOISE;
    endcase
end
    // (op==6'b00_0000)?10'b11_0000_0010://R-type
    // (op==6'b10_0011)?10'b10_1001_1000://lw
    // (op==6'b10_1011)?10'b0X_101X_0000://sw
    // (op==6'b00_0100)?10'b0X_010X_0001://beq
    // (op==6'b00_1000)?10'b10_1000_0000://addi
    // (op==6'b00_0010)?10'b0X_XX0X_01XX:10'bXX_XXXX_XXXX;//j
endmodule
