`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 08:52:30
// Design Name: 
// Module Name: Aludec
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
module Aludec(op,Funct,ALUControl);
    input [5:0] op;
    input [5:0] Funct;
    output [4:0] ALUControl;

    assign ALUControl = 
    (op == `R_TYPE) ? 
        (Funct == `AND) ? `AND_CONTROL:
        (Funct == `OR) ? `OR_CONTROL:
        (Funct == `XOR) ? `XOR_CONTROL:
        (Funct == `NOR) ? `NOR_CONTROL:
        (Funct == `SLL) ? `SLL_CONTROL:
        (Funct == `SRL) ? `SRL_CONTROL:
        (Funct == `SRA) ? `SRA_CONTROL:       
        (Funct == `SLLV) ? `SLLV_CONTROL:
        (Funct == `SRLV) ? `SRLV_CONTROL:
        (Funct == `SRAV) ? `SRAV_CONTROL:
        (Funct == `ADD) ? `ADD_CONTROL:
        (Funct == `ADDU) ? `ADDU_CONTROL:
        (Funct == `SUB) ? `SUB_CONTROL:
        (Funct == `SUBU) ? `SUBU_CONTROL:
        (Funct == `SLT) ? `SLT_CONTROL:
        (Funct == `SLTU) ? `SLTU_CONTROL:
        (Funct == `MULT) ? `MULT_CONTROL:
        (Funct == `MULTU) ? `MULTU_CONTROL:
        
        `LOSE_CONTROL
    :(op == `ANDI) ? `AND_CONTROL
    :(op == `ORI) ? `OR_CONTROL
    :(op == `XORI) ? `XOR_CONTROL
    :(op == `LUI) ? `LUI_CONTROL
    :(op == `ADDI) ? `ADD_CONTROL
    :(op == `ADDIU) ? `ADDU_CONTROL
    :(op == `SLTI) ? `SLT_CONTROL
    :(op == `SLTIU) ? `SLTU_CONTROL
    :`LOSE_CONTROL;
    // assign ALUControl=(ALUOp==2'b00) ? 3'b010://Add
    //                   (ALUOp==2'b01) ? 3'b110://Sub
    //                   (ALUOp==2'b10&&Funct==6'b10_0000) ? 3'b010://Add
    //                   (ALUOp==2'b10&&Funct==6'b10_0010) ? 3'b110://Sub
    //                   (ALUOp==2'b10&&Funct==6'b10_0100) ? 3'b000://And
    //                   (ALUOp==2'b10&&Funct==6'b10_0101) ? 3'b001://Or
    //                   (ALUOp==2'b10&&Funct==6'b10_1010) ? 3'b111:3'bXXX;//SLT
endmodule
