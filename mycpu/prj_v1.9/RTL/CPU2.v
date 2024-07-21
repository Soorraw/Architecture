`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/17 10:08:15
// Design Name: 
// Module Name: CPU2
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


module CPU2();
    reg clk;
    reg rst;

    wire [31:0] InstF;
    wire [31:0] ReadDataM;
    wire [31:0] PCF;
    wire MemWriteM;
    wire MemReadM;
    wire [31:0] ALUResultM;
    wire [31:0] WriteDataM;

    always #20 clk=~clk;
    initial 
    begin
        clk<=0;
        rst<=0;
    end

	always @(negedge clk) begin
		if(MemWriteM) begin
			/* code */
			if(ALUResultM=== 84 & WriteDataM === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end else if(ALUResultM !== 80) begin
				/* code */
				$display("Simulation Failed");
				$stop;
			end
		end
	end

    MIPS CPU2_MIPS(clk,rst,InstF,ReadDataM,PCF,MemWriteM,MemReadM,ALUResultM,WriteDataM);
    InstMem CPU2_InstMem(.clka(~clk),.ena(1),.addra(PCF),.douta(InstF));
    DataMem CPU2_DataMem(.clka(~clk),.ena(MemWriteM|MemReadM),.rsta(rst),.wea({4{MemWriteM}}),.addra(ALUResultM),.dina(WriteDataM),.douta(ReadDataM));
endmodule
