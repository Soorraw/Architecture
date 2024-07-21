`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 13:08:20
// Design Name: 
// Module Name: MDU
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
module MDU(clk,rst,MDUControl,A,B,MDUResult);
    input clk,rst;
    input [4:0] MDUControl;
    input [31:0] A;
    input [31:0] B;

    output [63:0] MDUResult;

    assign MDUResult = 
    (MDUControl == `MULT_CONTROL) ? A & B:
    {32{1'b0}}; 
endmodule
