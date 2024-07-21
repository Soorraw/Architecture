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
    output reg [4:0] ALUControl;

    always  @(*)
    begin
        case (op)
            `R_TYPE:
                case (Funct)
                    `AND: ALUControl <= `AND_CONTROL;
                    `OR: ALUControl <= `OR_CONTROL;
                    `XOR: ALUControl <= `XOR_CONTROL;
                    `NOR: ALUControl <= `NOR_CONTROL;
                    `SLL: ALUControl <= `SLL_CONTROL;
                    `SRL: ALUControl <= `SRL_CONTROL;
                    `SRA: ALUControl <= `SRA_CONTROL;       
                    `SLLV: ALUControl <= `SLLV_CONTROL;
                    `SRLV: ALUControl <= `SRLV_CONTROL;
                    `SRAV: ALUControl <= `SRAV_CONTROL;
                    `ADD: ALUControl <= `ADD_CONTROL;
                    `ADDU: ALUControl <= `ADDU_CONTROL;
                    `SUB: ALUControl <= `SUB_CONTROL;
                    `SUBU: ALUControl <= `SUBU_CONTROL;
                    `SLT: ALUControl <= `SLT_CONTROL;
                    `SLTU: ALUControl <= `SLTU_CONTROL;
                    `MULT: ALUControl <= `MULT_CONTROL;
                    `MULTU: ALUControl <= `MULTU_CONTROL;
                    default ALUControl <= `LOSE_CONTROL;
                endcase
            `ANDI: ALUControl <= `AND_CONTROL;
            `ORI: ALUControl <= `OR_CONTROL;
            `XORI: ALUControl <= `XOR_CONTROL;
            `LUI: ALUControl <= `LUI_CONTROL;
            `ADDI: ALUControl <= `ADD_CONTROL;
            `ADDIU: ALUControl <= `ADDU_CONTROL;
            `SLTI: ALUControl <= `SLT_CONTROL;
            `SLTIU: ALUControl <= `SLTU_CONTROL;
            default: ALUControl <= `LOSE_CONTROL;
        endcase
    end
        
        

    // assign ALUControl=(ALUOp==2'b00: 3'b010://Add
    //                   (ALUOp==2'b01: 3'b110://Sub
    //                   (ALUOp==2'b10&&Funct==6'b10_0000: 3'b010://Add
    //                   (ALUOp==2'b10&&Funct==6'b10_0010: 3'b110://Sub
    //                   (ALUOp==2'b10&&Funct==6'b10_0100: 3'b000://And
    //                   (ALUOp==2'b10&&Funct==6'b10_0101: 3'b001://Or
    //                   (ALUOp==2'b10&&Funct==6'b10_1010: 3'b111:3'bXXX;//SLT
endmodule
