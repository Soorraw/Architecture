`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/29 15:18:18
// Design Name: 
// Module Name: Goldschmidt
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


module Goldschmidt(clk,rst,Signed,A,B,Start,Result,Ready);
    input clk,rst;
    input Signed;
    input [31:0] A;
    input [31:0] B;
    input Start;
    output reg [63:0] Result;
    output reg Ready;

    parameter MAX_ITERATION = 3'd6;

    wire [31:0] divA,divB;
    reg Divon;
    reg [2:0] Count;
    reg [63:0] regA,regB;
    wire [31:0] mantissA,mantissB;
    wire [31:0] normQ;
    wire [63:0] tmpQ;
    wire [4:0] clzA,clzB;
    wire [63:0] TwoMinusYi;
    wire [127:0] Xi,Yi;
    reg [4:0] OffsetA,OffsetB;
    reg [31:0] Dividend;
    reg [31:0] Divisor;
    wire [31:0] mulD,mulQ,tmp;
    wire [31:0] Quotient;
    wire [31:0] Remainder;

    assign divA = (Signed && A[31] == 1'b1 )? ~A + 1'b1 : A;
    assign divB = (Signed && B[31] == 1'b1 )? ~B + 1'b1 : B; 
    CLZ CLZA(divA,clzA);
    CLZ CLZB(divB,clzB);
    assign mantissA = divA << clzA;
    assign mantissB = divB << clzB;
    assign TwoMinusYi = ~regB + 1'b1;
    assign Xi = regA * TwoMinusYi;
    assign Yi = regB * TwoMinusYi;

    always@(posedge clk or negedge clk or posedge rst)
    begin
        if(rst)
            Ready <= 1'b0;
        else if(clk)
        begin
            if(Start)
            begin
                if(Divon)
                begin
                    if(Count == MAX_ITERATION)
                    begin
                        Result <= {Remainder,Quotient};
                        Ready <= 1'b1;
                        Divon <= 1'b0;
                    end
                    else if(Count == MAX_ITERATION - 1)//余数
                        Count <= Count + 1'b1;
                    else begin
                        regA <= Xi[126:63];
                        regB <= Yi[126:63];
                        Count <= Count + 1'b1;
                    end
                end
                else begin
                    Divon <= 1'b1;
                    OffsetA <= clzA;
                    OffsetB <= clzB;
                    Dividend <= A;
                    Divisor <= B;
                    regA <= {1'b0,mantissA,31'b0};
                    regB <= {1'b0,mantissB,31'b0};
                    Count <= 3'b0;
                    Ready <= 1'b0;
                end
            end
        end
        else begin 
            if(~Start)
                Ready <= 1'b0;
        end
    end

    assign normQ = regA[63:32] + |regA[31:29];
    assign tmpQ = (OffsetA > OffsetB)? normQ >> (OffsetA - OffsetB) : normQ << (OffsetB - OffsetA);
    assign Quotient = (Signed && (Dividend[31] ^ Divisor[31]))? ~tmpQ[62:31] + 1'b1 : tmpQ[62:31];
    assign mulD = Divisor[31]? ~Divisor + 1'b1 : Divisor;
    assign mulQ = Quotient[31]? ~Quotient + 1'b1 : Quotient;
    assign tmp = mulD * mulQ;
    assign Remainder = Dividend + ((Divisor[31] ^ Quotient[31])? tmp : ~tmp + 1'b1);

endmodule
