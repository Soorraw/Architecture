`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 14:17:37
// Design Name: 
// Module Name: HILO
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


module HILO(clk,rst,HiloWrite,HilotoReg,HiloSrc,ReadData1,MDUResult,Hilout);
    input clk,rst;
    input HiloWrite;
    input HilotoReg;
    input HiloSrc;
    input [31:0] ReadData1;
    input [63:0] MDUResult;

    output reg [31:0] Hilout;
    
    reg [31:0] Hi,Lo;
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            Hi <= 32'b0;
            Lo <= 32'b0;
        end
        else begin
            if(HilotoReg)
                Hilout <= Hi;
            else Hilout <= Lo;
 
            if(HiloWrite) 
            begin
                if(HiloSrc)
                begin
                    if(HilotoReg)
                        Hi <= ReadData1;
                    else Lo <= ReadData1;
                end
                else begin
                    {Hi,Lo} <= MDUResult;
                end
            end
        end
    end

endmodule
