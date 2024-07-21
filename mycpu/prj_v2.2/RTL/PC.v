`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 22:12:11
// Design Name: 
// Module Name: PC
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


module PC(clk,rst,en,PC,Adel,PCF);
    input clk;
    input rst;
    input en;
    input [31:0] PC;
    output Adel;
    output reg [31:0] PCF=0;

    assign Adel = PC[1] | PC[0];
    always @(posedge clk or posedge rst) 
    begin
        if(rst)
            // PCF<=32'b0;
            PCF <= 32'hbfc00000;
        else if(en)
            PCF <= PC;
    end
endmodule
