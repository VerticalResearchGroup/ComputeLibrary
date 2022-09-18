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

module salu #(
  parameter int TOTAL_PIPELINE_DEPTH = 2
)(
  salu_issued,
  sgpr_wr_req,
  clk,
  rst_n
);

  decoupled_intr.slave salu_issued;
  decoupled_intr.master sgpr_wr_req;

  input wire clk;
  input wire rst_n;

  logic salu_issued_valid;
  salu_issued_instr_t salu_issued_instr;

  logic [SALU_OP_CNT-1:0] salu_compute_ready;
  decoupled_intr #(.DATA_WIDTH(SALU_INST_ISSUED_SIZE)) salu_op [SALU_OP_CNT]();
  decoupled_intr #(.DATA_WIDTH(SALU_INST_ISSUED_SIZE)) salu_result [SALU_OP_CNT]();
  salu_issued_instr_t salu_result_data [SALU_OP_CNT];
  sgpr_req_t sgpr_wr_req_data [SALU_OP_CNT];
  decoupled_intr #(.DATA_WIDTH(SGPR_REQ_SIZE)) sgpr_wr_reqs [SALU_OP_CNT]();

  genvar idx;

  assign salu_issued.ready = |salu_compute_ready || !salu_issued_valid;

  always_ff@(posedge clk) begin
    if(!rst_n) begin
      salu_issued_instr <= '0;
      salu_issued_valid <= '0;
    end else begin
      if(!salu_issued_valid) begin
        salu_issued_valid <= salu_issued.valid;
      end else
      if(salu_issued_valid && |salu_compute_ready) begin
        salu_issued_valid <= salu_issued.valid;
      end
      if(salu_issued.valid) begin
        if((salu_issued_valid && |salu_compute_ready) || !salu_issued_valid)
          salu_issued_instr <= salu_issued.data;
      end
    end
  end

  // NOTE: Experiment to see if we can do a parameterized generate.
  for(idx = 0; idx < SALU_OP_CNT; idx++) begin
    salu_compute #(
      .OP_PARAMS(SALU_COMPUTE_PARAMS[idx]),
      .TOTAL_PIPELINE_DEPTH(TOTAL_PIPELINE_DEPTH)
    )
    salu_compute_inst(
      .salu_op(salu_op[idx]),
      .salu_result(salu_result[idx]),
      .clk,
      .rst_n
    );

    assign salu_op[idx].valid = salu_issued_valid;
    assign salu_op[idx].data = salu_issued_instr;
    assign salu_compute_ready[idx] = salu_op[idx].ready;
    assign salu_result_data[idx] = salu_result[idx].data;
    assign sgpr_wr_req_data[idx] = salu_result_data[idx].salu_params.wr_req;
    assign sgpr_wr_reqs[idx].valid = salu_result[idx].valid;
    assign sgpr_wr_reqs[idx].data = sgpr_wr_req_data[idx];
    assign salu_result[idx].ready = sgpr_wr_reqs[idx].ready;
  end

  rr_arbiter #(
    .NUM_REQUESTORS(SALU_OP_CNT),
    .DATA_WIDTH(SGPR_REQ_SIZE)
  )
  salu_result_arbiter(
    .in_req(sgpr_wr_reqs),
    .out_grant(sgpr_wr_req),
    .clk,
    .rst_n
  );

endmodule
