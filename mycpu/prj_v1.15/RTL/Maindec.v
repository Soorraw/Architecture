`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 08:52:15
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

module Maindec(op,Funct,rt,RegWrite,RegDst,RetSrc,AluSrc,MemWrite,MemRead,HiloWrite,HilotoReg,HiloSrc,Branch,Jump,JumpSrc,Link,LinkDst);
    input [5:0] op;
    input [5:0] Funct;
    input [4:0] rt;

    output RegWrite;
    output RegDst;
    output RetSrc;
    output AluSrc;
    output MemWrite;
    output MemRead;
    output HiloWrite;
    output HilotoReg;
    output HiloSrc;
    output [1:0] Branch;
    output Jump;
    output JumpSrc;
    output Link;
    output LinkDst;

    reg [14:0] Controls;
// RegWrite:写寄存器堆
// RegDst:目的寄存器号来源,0->Rt字段,1->Rd字段
// AluSrc:第二个ALU操作数源,0->第二个寄存器堆输出,1->立即数符号扩展
// RetSrc:MEMResultM源,0->EXResultM,1->HILO寄存器
// MemWrite:写数据存储器
// MemRead:读数据存储器,写入寄存器数据源(等效MemtoReg),0->来自Result,1->来自数据存储器()
// HiloWrite:写HILO寄存器
// HilotoReg:读/写HILO寄存器源,0->Lo字段,1->Hi字段
// HiloSrc:写HILO寄存器源,0->ALU,1->数据移动指令
// Branch:高位为1表示为BLTZ或BGEZ指令,低位为1表示为其他非Link类型的Branch指令
// Jump:Jump指令
// JumpSrc:Jump的地址源,0->立即数,1->rs寄存器
// Link:ResultE源,0->来自ALUResultE,1->来自Xal(r)指令指定的PC值
// LinkDst:WriteRegE源,0->来自目的寄存器号(rd),1->$ra
assign {RegWrite,RegDst,AluSrc,RetSrc,
        MemWrite,MemRead,
        HiloWrite,HilotoReg,HiloSrc,
        Branch,
        Jump,JumpSrc,
        Link,LinkDst} = Controls;
always @(*) 
begin
    case (op)
        `R_TYPE:
            case (Funct)
                `MFHI: Controls <= 15'b11X1_00_01X_00_00_00;
                `MFLO: Controls <= 15'b11X1_00_00X_00_00_00;
                `MTHI: Controls <= 15'b0XXX_00_111_00_00_00;
                `MTLO: Controls <= 15'b0XXX_00_101_00_00_00;
                `MULT,`MULTU,`DIV,`DIVU: Controls <= 15'b0X0X_00_1X0_00_00_00;
                `JR: Controls <= 15'b0XXX_00_0XX_00_11_00;
                `JALR: Controls <= 15'b11X0_00_0XX_00_11_10;
                default: Controls <= 15'b1100_00_0XX_00_00_00;
            endcase 
        `ANDI,`XORI,`ORI,`LUI,`ADDI,`ADDIU,`SLTI,`SLTIU: Controls <= 15'b1010_00_0XX_00_00_00;
        `BEQ,`BNE,`BLEZ,`BGTZ: Controls <= 15'b0XXX_00_0XX_01_00_00;
        `REGIMM_INST: Controls <= (rt == `BLTZ || rt == `BGEZ)? 15'b0XXX_00_0XX_10_0X_0X :15'b11X0_00_0XX_10_00_11;
        `J: Controls <= 15'b0XXX_00_0XX_00_10_00;
        `JAL: Controls <= 15'b11X0_00_0XX_00_10_11;
        `SW,`SH,`SB: Controls <= 15'b0X1X_10_0XX_00_00_00;
        `LW,`LH,`LHU,`LB,`LBU: Controls <= 15'b1010_01_0XX_00_00_00;
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
