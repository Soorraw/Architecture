`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 01:06:42
// Design Name: 
// Module Name: Regfile
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


module Regfile(clk,RegWrite,ReadReg1,ReadReg2,WriteReg,WriteData,ReadData1,ReadData2);
    input clk;
    input RegWrite;
    input [4:0] ReadReg1,ReadReg2,WriteReg;
    input [31:0] WriteData;
    output [31:0] ReadData1,ReadData2;

    reg [31:0] Registers [31:0];
    always@(posedge clk)
    begin
        if(RegWrite)
            Registers[WriteReg]<=WriteData;
    end

    assign ReadData1=(ReadReg1==0)?0:Registers[ReadReg1];
    assign ReadData2=(ReadReg2==0)?0:Registers[ReadReg2];
endmodule
