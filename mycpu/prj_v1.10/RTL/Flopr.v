`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/15 20:19:41
// Design Name: 
// Module Name: Flopr
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


module Flopr #(parameter WIDTH=32)(clk,rst,Datain,Dataout);
    input clk;
    input rst;
    input [WIDTH-1:0] Datain;
    output reg [WIDTH-1:0] Dataout=0;

    always @(posedge clk or posedge rst) 
    begin
        if(rst)
            Dataout<=0;
        else Dataout<=Datain;
    end
endmodule
