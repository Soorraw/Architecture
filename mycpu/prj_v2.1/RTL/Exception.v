`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/03 00:24:15
// Design Name: 
// Module Name: Exception
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
module Exception(rst,Except,Adel,Ades,Status,Cause,ExcepType);
    input rst;

    input Adel;
    input Ades;
    input [31:0] Status;
    input [31:0] Cause;
    output reg [4:0] ExcepType;

    wire [7:0] Screen;

    assign Screen = Status[15:8] & Cause[15:8];
    always@(*)
    begin
        if(rst)
            ExcepType <= `Ne;
        else if(Status[1] == 1'b0 && Status[0] == 1'b1 && Screen != 8'h0)
            ExcepType <= `Int;
        else if
    end
endmodule
