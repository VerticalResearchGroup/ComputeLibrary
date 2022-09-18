//
// Copyright 2021 Ziliang Guo
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
// 3. Neither the name of the copyright holder nor the names of its contributors may
// be used to endorse or promote products derived from this software without specific
// prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

`timescale 1ns / 1ps

import sgpr_pkg::*;

module sgpr_mem #(
  parameter int RD_LATENCY = 2,
  parameter string SIM_MEM_INIT_FILE = "sgpr_incr.mem"
)(
  sgpr_ram_rd_req,
  sgpr_ram_rd_resp,
  sgpr_ram_wr_req,
  clk,
  rst_n
);

  valid_intr.slave sgpr_ram_rd_req;
  valid_intr.master sgpr_ram_rd_resp;

  valid_intr.slave sgpr_ram_wr_req;

  sgpr_req_t sgpr_ram_rd_req_data;
  sgpr_resp_t sgpr_ram_rd_resp_data;
  sgpr_req_t sgpr_ram_wr_req_data;

  input wire clk;
  input wire rst_n;

  // RDNA2 SGPR is 120 entries * 20 wavefronts deep, so 2560 in total. Round
  // up since BRAMs are all 1024 entries deep.
  localparam int ADDR_SIZE = 12;
  localparam int DATA_WIDTH = 32;
  localparam int MEM_SIZE = (2 ** ADDR_SIZE) * DATA_WIDTH;

  logic [ADDR_SIZE-1:0] rd_addr[RD_PORT_CNT];
  logic [ADDR_SIZE-1:0] wr_addr;

  logic [RD_LATENCY-1:0] resp_valid_buffer = '0;

  genvar idx;

  assign sgpr_ram_wr_req_data = sgpr_ram_wr_req.data;
  assign wr_addr = {4'd0, sgpr_ram_wr_req_data.addr[0]};

  always_ff@(posedge clk) begin
    if(!rst_n) begin
      resp_valid_buffer <= '0;
    end else begin
      resp_valid_buffer <= {resp_valid_buffer[RD_LATENCY-2:0], sgpr_ram_rd_req.valid};
    end
  end

  assign sgpr_ram_rd_req_data = sgpr_ram_rd_req.data;
  assign sgpr_ram_rd_resp.valid = resp_valid_buffer[RD_LATENCY-1];
  assign sgpr_ram_rd_resp.data = sgpr_ram_rd_resp_data;

  // TODO: Fix SCC handling.
  assign sgpr_ram_rd_resp_data.scc = '0;

  for(idx = 0; idx < RD_PORT_CNT; idx++) begin
    assign rd_addr[idx] = {4'd0, sgpr_ram_rd_req_data.addr[idx]};
    assign sgpr_ram_rd_resp_data.val[idx][63:32] = '0;

    xpm_memory_sdpram #(
      .ADDR_WIDTH_A(ADDR_SIZE),
      .ADDR_WIDTH_B(ADDR_SIZE),
      .AUTO_SLEEP_TIME(0),
      .BYTE_WRITE_WIDTH_A(DATA_WIDTH),
      .CASCADE_HEIGHT(0),
      .CLOCKING_MODE("common_clock"),
      .ECC_MODE("no_ecc"),
      .MEMORY_INIT_FILE(SIM_MEM_INIT_FILE),
      .MEMORY_INIT_PARAM("0"),
      .MEMORY_OPTIMIZATION("true"),
      .MEMORY_PRIMITIVE("auto"),
      .MEMORY_SIZE(MEM_SIZE),
      .MESSAGE_CONTROL(0),
      .READ_DATA_WIDTH_B(DATA_WIDTH),
      .READ_LATENCY_B(RD_LATENCY),
      .READ_RESET_VALUE_B("0"),
      .RST_MODE_A("SYNC"),
      .RST_MODE_B("SYNC"),
      .SIM_ASSERT_CHK(0),
      .USE_EMBEDDED_CONSTRAINT(0),
      .USE_MEM_INIT(0),
      .WAKEUP_TIME("disable_sleep"),
      .WRITE_DATA_WIDTH_A(DATA_WIDTH),
      .WRITE_MODE_B("no_change")
    )
    sgpr_bank(
      .dbiterrb(),
      .doutb(sgpr_ram_rd_resp_data.val[idx][31:0]),
      .addra(wr_addr),
      .addrb(rd_addr[idx]),
      .clka(clk),
      .clkb(clk),
      .dina(sgpr_ram_wr_req_data.val[31:0]),
      //.ena(sgpr_ram_wr_req.valid),
      //.enb(sgpr_ram_rd_req.valid),
      .ena('1),
      .enb('1),
      .injectdbiterra('0),
      .injectsbiterra('0),
      // FIXME: Synchronize this based on read latency.
      .regceb('1),
      .rstb(~rst_n),
      .sleep('0),
      .wea(sgpr_ram_wr_req.valid)
    );
  end

endmodule
