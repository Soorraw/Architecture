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


module HILO(clk,rst,HiloWrite,HilotoReg,HiloSrc,Hiloin,Hilout);
    input clk,rst;
    input HiloWrite;
    input HilotoReg;
    input HiloSrc;
    input [63:0] Hiloin;

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
                        Hi <= Hiloin[31:0];
                    else Lo <= Hiloin[31:0];
                end
                else begin
                    Hi <= Hiloin[63:32];
                    Lo <= Hiloin[31:0];
                end
            end
        end
    end

endmodule
