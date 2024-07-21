`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/13 23:18:06
// Design Name: 
// Module Name: ALU
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
module ALU(ALUControl,A,B,sa,ALUResult,IntegerOverflow);
    input [4:0] ALUControl;
    input [31:0] A;
    input [31:0] B;
    input [4:0] sa;
    output [31:0] ALUResult;
    output IntegerOverflow;

    wire [32:0] tmp,minusB;
    assign minusB = ~B + 1'b1;
    assign tmp = (ALUControl == `ADD_CONTROL) ? {A[31],A} + {B[31],B}
                :(ALUControl == `SUB_CONTROL) ? {A[31],A} + {minusB[31],minusB}
                :{32{1'b0}};
    assign IntegerOverflow = tmp[32] ^ tmp[31];

    assign ALUResult = 
    (ALUControl == `AND_CONTROL) ? A & B:
    (ALUControl == `OR_CONTROL) ? A | B:
    (ALUControl == `XOR_CONTROL) ? A ^ B:
    (ALUControl == `NOR_CONTROL) ? ~(A | B):
    (ALUControl == `LUI_CONTROL) ? {B[15:0],{16{1'b0}}}:
    (ALUControl == `SLL_CONTROL) ? B << sa:
    (ALUControl == `SRL_CONTROL) ? B >> sa:
    (ALUControl == `SRA_CONTROL) ? (B >> sa) | ({32{B[31]}} << (6'd32 - {1'b0,sa})):
    (ALUControl == `SLLV_CONTROL) ? B << A[4:0]:
    (ALUControl == `SRLV_CONTROL) ? B >> A[4:0]:
    (ALUControl == `SRAV_CONTROL) ? (B >> A[4:0]) | ({32{B[31]}} << (6'd32 - {1'b0,A[4:0]})):
    (ALUControl == `ADD_CONTROL || ALUControl == `SUB_CONTROL) ? tmp[31:0]:
    (ALUControl == `ADDU_CONTROL) ? A + B:
    (ALUControl == `SUBU_CONTROL) ? A + minusB:
    (ALUControl == `SLT_CONTROL) ? A < B:
    (ALUControl == `SLTU_CONTROL) ? {A[31],A} < {B[31],B}:
    {32{1'b0}};
    // assign ALUResult=(ALUControl==3'b000)?A&B:
    //                 (ALUControl==3'b001)?A|B:
    //                 (ALUControl==3'b010)?A+B:
    //                 (ALUControl==3'b110)?A-B:
    //                 (ALUControl==3'b111)?A<B:32'b0;
    //assign Zero=(ALUResult==32'b0);
endmodule
