`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/03 00:24:15
// Design Name: 
// Module Name: ExcepTypeion
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
module ExcepTypeion(rst,ExcepType,Adel,Ades,Status,Cause,EXcCode,ExcepTypeDeal);
    input rst;
    input [31:0] ExcepType;
    input Adel;
    input Ades;
    input [31:0] Status;
    input [31:0] Cause;
    output reg [4:0] EXcCode;
    output ExcepTypeDeal;

    wire [7:0] Screen;
    wire Interrupt;

    assign Screen = Status[15:8] & Cause[15:8];
    assign Interrupt = (Status[1] == 1'b0 && Status[0] == 1'b1 && Screen != 8'h0);
    assign ExcepTypeDeal = Interrupt || (|ExcepType) || Adel || Ades;

    always@(*)
    begin
        if(rst)
            EXcCode <= `Ne;
        else begin
            if(Interrupt)//中断
                EXcCode <= `Int;
            else if(ExcepType[4] || Adel)//读地址例外
                EXcCode <= `AdEL;
            else if(ExcepType[5] || Ades)//写地址例外
                EXcCode <= `AdES;
            else if(ExcepType[8])//系统调用
                EXcCode <= `Sys;
            else if(ExcepType[9])//断点
                EXcCode <= `Bp;
            else if(ExcepType[10])//保留指令
                EXcCode <= `RI;
            else if(ExcepType[12])//算术溢出
                EXcCode <= `Ov;
            else if(ExcepType[14])//ERET
                EXcCode <= `Eret;
            else EXcCode <= `Ne;
        end
    end
endmodule
