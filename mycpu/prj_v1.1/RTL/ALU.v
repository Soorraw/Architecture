`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/13 23:18:06
// Design Name: 
// Module Name: ALU
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
module ALU(ALUControl,A,B,ALUResult);//,Zero);
    input [4:0] ALUControl;
    input [31:0] A;
    input [31:0] B;
    output [31:0] ALUResult;
    //output Zero;


    assign ALUResult = 
    (ALUControl == `AND_CONTROL) ? A & B:
    (ALUControl == `OR_CONTROL) ? A | B:
    (ALUControl == `XOR_CONTROL) ? A ^ B:
    (ALUControl == `NOR_CONTROL) ? ~(A | B):
    (ALUControl == `LUI_CONTROL) ? {B[15:0],{16{1'b0}}}    
    :{32{1'b0}};
    // assign ALUResult=(ALUControl==3'b000)?A&B:
    //                 (ALUControl==3'b001)?A|B:
    //                 (ALUControl==3'b010)?A+B:
    //                 (ALUControl==3'b110)?A-B:
    //                 (ALUControl==3'b111)?A<B:32'b0;
    //assign Zero=(ALUResult==32'b0);
endmodule
