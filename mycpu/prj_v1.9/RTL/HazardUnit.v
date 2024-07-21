`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 22:05:42
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(BranchD,MemReadE,RegWriteE,RegWriteM,RegWriteW,RsD,RtD,PCSrcD,JumpD,RsE,RtE,WriteRegE,WriteRegM,WriteRegW,MDUReadyE,
                    StallF,StallD,StallE,ForwardAD,ForwardBD,FlushD,FlushE,ForwardAE,ForwardBE);
    input BranchD;
    input MemReadE;
    input RegWriteE;
    input RegWriteM;
    input RegWriteW;
    input [4:0] RsD,RtD;
    input PCSrcD,JumpD;
    input [4:0] RsE,RtE;
    input [4:0] WriteRegE;
    input [4:0] WriteRegM;
    input [4:0] WriteRegW;
    input MDUReadyE;//MDU


    output StallF;
    output StallD;
    output StallE;
    output ForwardAD,ForwardBD;
    output FlushD;
    output FlushE;
    output [1:0] ForwardAE,ForwardBE;

    wire lwstall;
    wire branchstall;

    //数据冒险
    assign ForwardAE=(RegWriteM & (WriteRegM!=0) & (WriteRegM==RsE))?10://EX冒险前推信号
                    (RegWriteW & (WriteRegW!=0) & (WriteRegW==RsE))?01:00;//MEM冒险前推信号
    assign ForwardBE=(RegWriteM & (WriteRegM!=0) & (WriteRegM==RtE))?10://EX冒险前推信号
                    (RegWriteW & (WriteRegW!=0) & (WriteRegW==RtE))?01:00;//MEM冒险前推信号
                    
    //lw冒险阻塞信号(充分不必要条件,在后一条指令为某些指令(见《指令及对应机器码》)时可能会造成不必要的阻塞,前述的前推控制信号大概也有类似问题)
    assign lwstall=((RtE!=0) & (RsD==RtE) | (RtD==RtE)) & MemReadE;
    
    //控制冒险
    assign branchstall=(BranchD & RegWriteE & (WriteRegE!=0) & ((WriteRegE==RsD) | (WriteRegE==RtD)));//EX冒险阻塞信号
    assign ForwardAD=(RegWriteM & (WriteRegM!=0) & (WriteRegM==RsD));//MEM冒险前推信号
    assign ForwardBD=(RegWriteM & (WriteRegM!=0) & (WriteRegM==RtD));

    //阻塞与刷新
    assign StallF = FlushE | (~MDUReadyE) ;//lw,beq和乘除法指令均需阻塞ID级和IF级指令
    assign StallD = StallF;
    assign StallE = ~MDUReadyE;//乘除法指令还需要阻塞EX级
    assign FlushD = PCSrcD | JumpD;//beq指令分支发生时或j指令执行时需要清空ID级指令
    assign FlushE = lwstall | branchstall;//lw数据冒险或beq(数据)控制冒险均在EX级判断,需清空ID级指令影响
endmodule
