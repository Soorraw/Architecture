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
module MDU(clk,rst,clear,en,MDUControl,A,B,MDUResult,MDUReady);
    input clk,rst;
    input clear;
    input en;
    input [4:0] MDUControl;
    input [31:0] A;
    input [31:0] B;

    output reg [63:0] MDUResult;
    output MDUReady;

    wire [31:0] mutA,mutB;//MUL
    wire [63:0] tmp;
    
    assign mutA = (MDUControl == `MULT_CONTROL && A[31] == 1'b1 )? ~A + 1'b1 : A;
    assign mutB = (MDUControl == `MULT_CONTROL && B[31] == 1'b1 )? ~B + 1'b1 : B;
    assign tmp = mutA * mutB;
    
    reg DivStart;//DIV
    wire DivAnnul;
    wire DivEn;
    wire DivSigned;
    wire [63:0] DivResult;
    wire DivReady;

    // assign DivAnnul = 1'b0;//暂不考虑DivAnnul
    // Restoring DIVE(clk,rst,DivSigned,A,B,DivStart,DivAnnul,DivResult,DivReady);   
    assign DivAnnul = clear;
    assign DivEn = en;
    Goldschmidt DIVE(clk,rst,DivSigned,A,B,DivStart,DivEn,DivAnnul,DivResult,DivReady);
    assign DivSigned = (MDUControl == `DIV_CONTROL);

    always@(*)
    begin
        case(MDUControl)
            `MULT_CONTROL: MDUResult <= (A[31] ^ B[31])? ~tmp + 1'b1 : tmp;
            `MULTU_CONTROL: MDUResult <= tmp;
            `DIV_CONTROL,`DIVU_CONTROL:
            begin
                DivStart <= ~DivReady;
                MDUResult <= DivResult;
            end            
            default:begin
                DivStart <= 1'b0;
                MDUResult <= {64{1'b0}};
            end
        endcase
    end    
    assign MDUReady = (MDUControl == `DIV_CONTROL || MDUControl == `DIVU_CONTROL)? DivReady : 1'b1;
endmodule
