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

module sgpr_rd_controller(
  sgpr_rd_req,
  sgpr_rd_resp,
  sgpr_ram_rd_req,
  sgpr_ram_rd_resp,
  clk,
  rst_n
);

  decoupled_intr.slave sgpr_rd_req;
  decoupled_intr.master sgpr_rd_resp;

  valid_intr.master sgpr_ram_rd_req;
  valid_intr.slave sgpr_ram_rd_resp;

  input wire clk;
  input wire rst_n;

  sgpr_req_t sgpr_rd_req_data; 
  sgpr_resp_t sgpr_rd_resp_data;
  sgpr_req_t sgpr_ram_rd_req_data;

  genvar idx;

  assign sgpr_rd_req.ready = '1;
  assign sgpr_rd_req_data = sgpr_rd_req.data;

  // TODO: Add SCC.

  assign sgpr_rd_resp.valid = sgpr_ram_rd_resp.valid;
  assign sgpr_rd_resp.data = sgpr_rd_resp_data;

  assign sgpr_ram_rd_req.valid = sgpr_rd_req.valid;
  assign sgpr_ram_rd_req.data = sgpr_ram_rd_req_data;

  always_comb begin
    sgpr_ram_rd_req_data = sgpr_rd_req_data;
    for(int i = 0; i < RD_PORT_CNT; i++) begin
      sgpr_ram_rd_req_data.addr[i] = sgpr_rd_req_data.addr[i] + sgpr_rd_req_data.base;
    end
  end

  assign sgpr_rd_resp_data = sgpr_ram_rd_resp.data;

endmodule
