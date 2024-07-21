`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/01/07 20:04:11
// Design Name:
// Module Name: DataCache
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


module DataCache (
    input clk,
    input rst,

    //cpu
    input cpu_data_req,
    input cpu_data_wr,
    input [1:0] cpu_data_size,
    input [31:0] cpu_data_addr,
    input [31:0] cpu_data_wdata,
    output [31:0] cpu_data_rdata,
    output cpu_data_addr_ok,
    output cpu_data_data_ok,

    //axi
    output cache_data_req,
    output cache_data_wr,
    output [1:0] cache_data_size,
    output [31:0] cache_data_addr,
    output [31:0] cache_data_wdata,
    input [31:0] cache_data_rdata,
    input cache_addr_ok,  //cache_data_addr_ok->cache_addr_ok(该信号不止与DataCache相关)
    input cache_data_data_ok
);
  //Cache的规格
  parameter ASSOCIATIVITY_WIDTH = 1;
  parameter INDEX_WIDTH = 10 - ASSOCIATIVITY_WIDTH;
  parameter OFFSET_WIDTH = 2;
  localparam TAG_WIDTH = 32 - INDEX_WIDTH - OFFSET_WIDTH;
  localparam CACHE_DEEPTH = 1 << INDEX_WIDTH;
  localparam GROUP_WIDTH = 1 << ASSOCIATIVITY_WIDTH;

  reg cache_valid[CACHE_DEEPTH-1:0][GROUP_WIDTH-1:0];
  reg cache_dirty[CACHE_DEEPTH-1:0][GROUP_WIDTH-1:0];
  reg [TAG_WIDTH-1:0] cache_tag[CACHE_DEEPTH-1:0][GROUP_WIDTH-1:0];
  reg [31:0] cache_block[CACHE_DEEPTH-1:0][GROUP_WIDTH-1:0];
  //本次访问的地址解析
  wire [TAG_WIDTH-1:0] tag;
  wire [INDEX_WIDTH-1:0] index;
  wire [OFFSET_WIDTH-1:0] offset;

  assign tag = cpu_data_addr[31:INDEX_WIDTH+OFFSET_WIDTH];
  assign index = cpu_data_addr[INDEX_WIDTH+OFFSET_WIDTH-1:OFFSET_WIDTH];
  assign offset = cpu_data_addr[OFFSET_WIDTH-1:0];
  //判断是否命中
  wire [ASSOCIATIVITY_WIDTH-1:0] target;
  wire [GROUP_WIDTH-1:0] hits;
  wire hit;

  genvar i;
  generate
    for (i = 0; i < GROUP_WIDTH; i = i + 1) begin : Hits
      assign hits[i] = cache_valid[index][i] & (tag == cache_tag[index][i]);
    end
  endgenerate

  assign target = (hits == 2'b10) ? 1'b1 : 1'b0;
  assign hit = |hits;
  //替换策略
  reg [ASSOCIATIVITY_WIDTH-1:0] replace[CACHE_DEEPTH-1:0];

  integer j;
  always @(negedge clk) begin
    if (rst) begin
      // for(j=0;j<CACHE_DEEPTH;j=j+1)
      // begin
      //     replace[j]<=0;
      // end
      replace <= '{default: '0};
    end else if (hit) begin
      replace[index] <= ~target;
    end
  end
  //掩码和处理后的写入数据
  wire [ 3:0] mask;
  wire [31:0] write_data;
  wire [31:0] rwrite_data;
  assign mask=(cpu_data_size==2'b00)?1'b1<<offset:(cpu_data_size==2'b01)?2'b11<<offset:4'b1111;
  assign write_data=(cache_block[index][target] & ~{{8{mask[3]}},{8{mask[2]}},{8{mask[1]}},{8{mask[0]}}}) |
                         (cpu_data_wdata & {{8{mask[3]}},{8{mask[2]}},{8{mask[1]}},{8{mask[0]}}});
  assign rwrite_data=(cache_data_rdata & ~{{8{mask[3]}},{8{mask[2]}},{8{mask[1]}},{8{mask[0]}}}) |
                         (cpu_data_wdata & {{8{mask[3]}},{8{mask[2]}},{8{mask[1]}},{8{mask[0]}}});
  //FSM
  localparam IDLE = 2'b00, RM = 2'b01, WB = 2'b10;
  reg [1:0] state;
  reg [ASSOCIATIVITY_WIDTH-1:0] store_target;

  always @(posedge clk or posedge rst) begin
    if (rst) state <= IDLE;
    else begin
      case (state)
        IDLE: state <= (cpu_data_req & ~hit) ? RM : IDLE;
        RM: state <= (~cache_data_data_ok) ? RM : (cache_dirty[index][store_target]) ? WB : IDLE;
        WB: state <= (~cache_data_data_ok) ? WB : (cpu_data_req & ~hit) ? RM : IDLE;
        default state <= IDLE;
      endcase
    end
  end
  //地址发送成功后拉低请求信号
  wire cache_data_addr_ok;
  reg  send_req = 1'b1;
  assign cache_data_addr_ok = cache_data_req & cache_addr_ok;

  always @(posedge clk or posedge rst) begin
    if (rst) send_req <= 1'b1;
    else begin
      send_req <= (cache_data_addr_ok) ? 1'b0 : (cache_data_data_ok) ? 1'b1 : send_req;
    end
  end
  //写缓冲区
  reg store_dirty;
  reg store_write;
  reg [31:0] store_buffer;
  reg [31:0] store_addr;
  wire [INDEX_WIDTH-1:0] store_index;
  wire [TAG_WIDTH-1:0] store_tag;

  assign store_tag = store_addr[31:INDEX_WIDTH+OFFSET_WIDTH];
  assign store_index = store_addr[INDEX_WIDTH+OFFSET_WIDTH-1:OFFSET_WIDTH];
  assign store_offset = store_addr[OFFSET_WIDTH-1:0];

  always @(negedge clk) begin
    if (state == RM) begin
      if (cpu_data_wr) begin
        store_buffer <= rwrite_data;
        store_dirty  <= 1'b1;
      end else begin
        store_buffer <= cache_data_rdata;
        store_dirty  <= 1'b0;
      end
      store_write  <= cache_data_data_ok;
      store_target <= replace[store_index];
    end else begin
      if (cpu_data_req) begin
        store_buffer <= write_data;
        store_addr   <= cpu_data_addr;
        if (hit) store_target <= target;
      end
      store_dirty <= 1'b1;
      store_write <= cpu_data_req & cpu_data_wr & hit;
    end
  end

  integer k;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      store_buffer   <= 32'b0;
      //   for (j = 0; j < CACHE_DEEPTH; j = j + 1)
      //     for (k = 0; k < GROUP_WIDTH; k = k + 1) begin
      //       cache_valid[j][k] <= 0;
      //       cache_dirty[j][k] <= 0;
      //       cache_tag[j][k]   <= 0;
      //     end
      cache_valid[0] <= '{default: '0};
      cache_valid[1] <= '{default: '0};
      cache_dirty[0] <= '{default: '0};
      cache_dirty[1] <= '{default: '0};
      cache_tag[0]   <= '{default: '0};
      cache_tag[1]   <= '{default: '0};
    end else if (store_write) begin
      cache_dirty[store_index][store_target] <= store_dirty;
      cache_valid[store_index][store_target] <= 1'b1;
      cache_tag[store_index][store_target]   <= store_tag;
      cache_block[store_index][store_target] <= store_buffer;
    end
  end
  //写回缓冲区
  reg [31:0] write_buffer;
  reg [31:0] write_addr;

  always @(negedge clk or posedge rst) begin
    if (rst) begin
      write_buffer <= 32'b0;
      write_addr   <= 32'b0;
    end else if ((state == RM) & cache_dirty[store_index][store_target]) begin
      write_buffer <= cache_block[store_index][store_target];
      write_addr   <= {cache_tag[store_index][store_target], store_index, 2'b00};
    end
  end
  //MIPS Core接口
  assign cpu_data_addr_ok = (cpu_data_req & hit) | cache_data_addr_ok;
  assign cpu_data_data_ok = (cpu_data_req & hit) | ((state == RM) & cache_data_data_ok);
  assign cpu_data_rdata = (hit) ? cache_block[index][store_target] : cache_data_rdata;
  //AXI接口
  assign cache_data_req = (state != IDLE) & send_req;
  assign cache_data_wr = (state == WB);
  assign cache_data_wdata = write_buffer;
  assign cache_data_size = (state == WB) ? 2'b10 : cpu_data_size;
  assign cache_data_addr = (state == WB) ? write_addr : cpu_data_addr;
endmodule
