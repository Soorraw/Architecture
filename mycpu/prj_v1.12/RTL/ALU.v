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
    
    output reg [31:0] ALUResult;
    output IntegerOverflow;

    wire [31:0] minusB,AmB;
    wire [32:0] tmp;
    assign minusB = ~B + 1'b1;
    assign AmB = A + minusB;
    assign tmp = (ALUControl == `ADD_CONTROL)? {A[31],A} + {B[31],B}:
                (ALUControl == `SUB_CONTROL)? {A[31],A} + {minusB[31],minusB}:
                {32{1'b0}};
    assign IntegerOverflow = tmp[32] ^ tmp[31];

    always  @(*)
    begin
        case (ALUControl)
            `AND_CONTROL: ALUResult <= A & B;
            `OR_CONTROL: ALUResult <= A | B;
            `XOR_CONTROL: ALUResult <= A ^ B;
            `NOR_CONTROL: ALUResult <= ~(A | B);
            `LUI_CONTROL: ALUResult <= {B[15:0],{16{1'b0}}};
            `SLL_CONTROL: ALUResult <= B << sa;
            `SRL_CONTROL: ALUResult <= B >> sa;
            `SRA_CONTROL: ALUResult <= (B >> sa) | ({32{B[31]}} << (6'd32 - {1'b0,sa}));
            `SLLV_CONTROL: ALUResult <= B << A[4:0];
            `SRLV_CONTROL: ALUResult <= B >> A[4:0];
            `SRAV_CONTROL: ALUResult <= (B >> A[4:0]) | ({32{B[31]}} << (6'd32 - {1'b0,A[4:0]}));
            `ADD_CONTROL,`SUB_CONTROL: ALUResult <= tmp[31:0];
            `ADDU_CONTROL: ALUResult <= A + B;
            `SUBU_CONTROL: ALUResult <= A - B;
            `SLT_CONTROL: ALUResult <= AmB[31];
            `SLTU_CONTROL: ALUResult <= A < B;
            default: ALUResult <= {32{1'b0}};
        endcase
    end    

    // assign ALUResult=(ALUControl==3'b000)?A&B:
    //                 (ALUControl==3'b001)?A|B:
    //                 (ALUControl==3'b010)?A+B:
    //                 (ALUControl==3'b110)?A-B:
    //                 (ALUControl==3'b111)?A<B:32'b0;
    //assign Zero=(ALUResult==32'b0);
endmodule
