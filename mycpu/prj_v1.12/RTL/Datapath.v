`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 22:05:42
// Design Name: 
// Module Name: Datapath
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


module Datapath(clk,rst,InstF,StallF,JumpD,JumpSrcD,StallD,FlushD,ForwardAD,ForwardBD,ALUControlE,AluSrcE,RegDstE,LinkE,LinkDstE,StallE,FlushE,ForwardAE,
                ForwardBE,ReadDataM,RegWriteW,MemtoRegW,HiloWriteE,HilotoRegE,HiloSrcE,RetSrcM,
PCF,op,Funct,RsD,RtD,PCSrcD,RsE,RtE,WriteRegE,EXResultM,WriteDataM,WriteRegM,WriteRegW,MDUReadyE);
    input clk;
    input rst;
    input [31:0] InstF;//IF
    input StallF;

    input JumpD;//ID
    input JumpSrcD;
    input StallD;
    input FlushD;
    input ForwardAD,ForwardBD;
    input [4:0] ALUControlE;//EX
    input AluSrcE;
    input RegDstE;
    input LinkE;
    input LinkDstE;
    input StallE;
    input FlushE;
    input [1:0] ForwardAE,ForwardBE;
    input [31:0] ReadDataM;//MEM
    input RegWriteW;//WB
    input MemtoRegW;

    input HiloWriteE,HilotoRegE,HiloSrcE;//HILO
    input RetSrcM;

    output [31:0] PCF;//IF
    output [5:0] op,Funct;
    output [4:0] RsD,RtD;//ID
    output PCSrcD;
    output [4:0] RsE,RtE;//EX
    output [4:0] WriteRegE;
    output [31:0] EXResultM;//MEM
    output [31:0] WriteDataM;
    output [4:0] WriteRegM;
    output [4:0] WriteRegW;//WB
    output MDUReadyE;//MDU

    wire [31:0] PC;//IF
    wire [31:0] PCPlus4F;
    wire [31:0] Branch_Addr;
    wire [31:0] Jump_Addr;
    wire [31:0] InstD;//ID
    wire [31:0] PCPlus4D;
    wire [4:0] RdD;
    wire EqualD;
    wire [31:0] SrcAD,BeqSrcBD;
    wire [31:0] ReadData1D,ReadData2D;
    wire [31:0] ExtendD;
    wire [4:0] saD;
    wire [31:0] ReadData1E,ReadData2E;//EX
    wire [4:0] RdE;
    wire [31:0] ExtendE;
    wire [4:0] saE;
    wire [31:0] WriteDataE;
    wire [31:0] SrcAE,SrcBE;
    wire [31:0] ALUResultE;
    wire [31:0] EXResultE;
    wire [31:0] EXResultM;
    wire [31:0] MEMResultM;//MEM
    wire [31:0] ReadDataW;//WB
    wire [31:0] MEMResultW;
    wire [4:0] WriteRegW;
    wire [31:0] WriteData3W;

    
    wire [31:0] HiloutM;//HILO
    wire [31:0] HiloutW;

    wire [63:0] MDUResultE;//MDU

    PC PCRegF(clk,rst,~StallF,PC,PCF);//IF

    assign PCPlus4F = PCF + 32'd4;//IF
    assign PC = (JumpD)? ((JumpSrcD)? SrcAD : Jump_Addr):
                (PCSrcD)? Branch_Addr : PCPlus4F;
    
    Flopenrc #(64) PiplineReg_IF_ID(clk,rst,FlushD,~StallD,{InstF,PCPlus4F},{InstD,PCPlus4D});//IF_ID
    Regfile RegfileD(~clk,rst,RegWriteW,RsD,RtD,WriteRegW,WriteData3W,ReadData1D,ReadData2D);//ID
    BranchCompare BranchCompareD(op,RtD,SrcAD,BeqSrcBD,PCSrcD);

    assign op = InstD[31:26];//ID
    assign Funct = InstD[5:0];
    assign RsD = InstD[25:21];
    assign RtD = InstD[20:16];
    assign RdD = InstD[15:11];
    assign SrcAD = (ForwardAD)? MEMResultM : ReadData1D;
    assign BeqSrcBD = (ForwardBD)? MEMResultM : ReadData2D;
    
    assign ExtendD = (op[3:2] == 2'b11) ? {{16{1'b0}},InstD[15:0]} : {{16{InstD[15]}},InstD[15:0]};
    assign saD = InstD[10:6];
    assign Branch_Addr = PCPlus4D + {ExtendD[30:0],2'b00};
    assign Jump_Addr = {PCPlus4D[31:28],InstD[25:0],2'b00};
    
    Flopenrc #(116) PiplineReg_ID_EX1(clk,rst,FlushE,~StallE,{RsD,RtD,RdD,ExtendD,saD,ReadData1D,ReadData2D},{RsE,RtE,RdE,ExtendE,saE,ReadData1E,ReadData2E});//ID_EX
    ALU ALUE(ALUControlE,SrcAE,SrcBE,saE,ALUResultE);
    MDU MDUE(~clk,rst,ALUControlE,SrcAE,SrcBE,MDUResultE,MDUReadyE);

    assign SrcAE = (ForwardAE == 2'b00)? ReadData1E:
                    (ForwardAE == 2'b01)? WriteData3W:
                    (ForwardAE == 2'b10)? MEMResultM : 32'b0;
    assign WriteDataE = (ForwardBE == 2'b00)? ReadData2E:
                        (ForwardBE == 2'b01)? WriteData3W:
                        (ForwardBE == 2'b10)? MEMResultM : 32'b0;
    assign SrcBE = (AluSrcE)? ExtendE : WriteDataE;
    assign WriteRegE = (RegDstE)? ((LinkDstE)? 32'd31 : RdE) : RtE;
    assign EXResultE = (LinkE)? PCPlus4D : ALUResultE;

    Flopr #(69) PiplineReg_EX_MEM(clk,rst,{EXResultE,WriteDataE,WriteRegE},{EXResultM,WriteDataM,WriteRegM});//EX_MEM
    HILO Hilo_EX_MEM(clk,rst,HiloWriteE,HilotoRegE,HiloSrcE,ReadData1E,MDUResultE,HiloutM);

    assign MEMResultM = (RetSrcM)? HiloutM : EXResultM;

    Flopr #(101) PiplineReg_MEM_WB(clk,rst,{ReadDataM,MEMResultM,WriteRegM,HiloutM},{ReadDataW,MEMResultW,WriteRegW,HiloutW});//MEM_WB

    assign WriteData3W = (MemtoRegW)? ReadDataW : MEMResultW;
endmodule
