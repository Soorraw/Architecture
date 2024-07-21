`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/15 20:19:41
// Design Name: 
// Module Name: Flopenrc
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


module Flopenrc #(parameter WIDTH=32)(clk,rst,clear,en,Datain,Dataout);
    input clk;
    input rst;
    input clear;
    input en;
    input [WIDTH-1:0] Datain;
    output reg [WIDTH-1:0] Dataout=0;

    always@(posedge clk or posedge rst)
    begin
        if(rst)
            Dataout<=0;
        else if(clear & en)//流水线刷新必须保证当前流水线未被阻塞,否则将导致指令丢失
            Dataout<=0;
        else if(en)
            Dataout<=Datain;
    end
endmodule
