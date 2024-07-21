`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/31 17:57:05
// Design Name: 
// Module Name: Translator
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
module Translator(op,addr,sram_en,wdata,sram_wdata,sram_rdata,rdata);
    input [5:0] op;
    input [1:0] addr;
    output reg [3:0] sram_en;
    
    input [31:0] wdata;
    output reg [31:0] sram_wdata;

    input [31:0] sram_rdata;
    output reg [31:0] rdata;

    always@(*)
    begin
        case(op)
        `SW:
            begin
                sram_wdata <= wdata;
                sram_en <= 4'b1111;
            end
        `SH:
            begin
                sram_wdata <= {2{wdata[15:0]}};
                case(addr)
                2'b00: sram_en <= 4'b0011;
                2'b10: sram_en <= 4'b1100;
                default: sram_en <= 4'b0;
                endcase
            end
        `SB:
            begin
                sram_wdata <= {4{wdata[7:0]}};
                case(addr)
                2'b00: sram_en <= 4'b0001;
                2'b01: sram_en <= 4'b0010;
                2'b10: sram_en <= 4'b0100;
                2'b11: sram_en <= 4'b1000;
                default: sram_en <= 4'b0;
                endcase
            end
        default: sram_en <= 4'b0;
        endcase
    end

    always@(*)
    begin
        case(op)
        `LW: rdata <= sram_rdata;
        `LH:
            case(addr)
            2'b00: rdata <= {{16{sram_rdata[15]}},sram_rdata[15:0]};
            2'b10: rdata <= {{16{sram_rdata[31]}},sram_rdata[31:16]};
            default: rdata <= 32'b0;
            endcase
        `LHU:
            case(addr)
            2'b00: rdata <= {{16{1'b0}},sram_rdata[15:0]};
            2'b10: rdata <= {{16{1'b0}},sram_rdata[31:16]};
            default: rdata <= 32'b0;
            endcase
        `LB:
            case(addr)
            2'b00: rdata <= {{24{sram_rdata[7]}},sram_rdata[7:0]};
            2'b01: rdata <= {{24{sram_rdata[15]}},sram_rdata[15:8]};
            2'b10: rdata <= {{24{sram_rdata[23]}},sram_rdata[23:16]};
            2'b11: rdata <= {{24{sram_rdata[31]}},sram_rdata[31:24]};
            default: rdata <= 32'b0;
            endcase
        `LBU:
            case(addr)
            2'b00: rdata <= {{24{1'b0}},sram_rdata[7:0]};
            2'b01: rdata <= {{24{1'b0}},sram_rdata[15:8]};
            2'b10: rdata <= {{24{1'b0}},sram_rdata[23:16]};
            2'b11: rdata <= {{24{1'b0}},sram_rdata[31:24]};
            default: rdata <= 32'b0;
            endcase
        default: rdata <= 32'b0;
        endcase        
    end

endmodule
