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

import salu_instr_pkg::*;
import sgpr_pkg::*;

module simd(
  icache_rd_resp,
  clk,
  rst_n
);

  decoupled_intr.slave icache_rd_resp;

  decoupled_intr #(.DATA_WIDTH(SGPR_REQ_SIZE)) sgpr_rd_req();
  decoupled_intr #(.DATA_WIDTH(SGPR_REQ_SIZE)) sgpr_wr_req();
  decoupled_intr #(.DATA_WIDTH(SGPR_RESP_SIZE)) sgpr_rd_resp();
  decoupled_intr #(.DATA_WIDTH(SGPR_RESP_SIZE)) sgpr_wr_resp();
  decoupled_intr #(.DATA_WIDTH(SALU_INST_ISSUED_SIZE)) salu_issued();

  input wire clk;
  input wire rst_n;

  wavefront_controller wavefront_controller_inst(
    .icache_rd_resp,
    .sgpr_rd_req,
    .sgpr_rd_resp,
    .salu_issued,
    .clk,
    .rst_n
  );

  sgpr sgpr_inst(
    .sgpr_rd_req,
    .sgpr_wr_req,
    .sgpr_rd_resp,
    .sgpr_wr_resp,
    .clk,
    .rst_n
  );

  salu salu_inst(
    .salu_issued,
    .sgpr_wr_req,
    .clk,
    .rst_n
  );

endmodule
