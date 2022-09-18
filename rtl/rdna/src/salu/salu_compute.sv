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

module salu_compute #(
  parameter salu_compute_params_t OP_PARAMS = '0,
  parameter int TOTAL_PIPELINE_DEPTH = 2
)(
  salu_op,
  salu_result,
  clk,
  rst_n
);

  decoupled_intr.slave salu_op;
  decoupled_intr.master salu_result;

  input wire clk;
  input wire rst_n;

  localparam int PIPELINE_BUFFER_DEPTH = OP_PARAMS.op_pipeline + 1;

  salu_issued_instr_t salu_op_data;
  salu_issued_instr_t salu_issued_instr_buffer[PIPELINE_BUFFER_DEPTH] = '{default:'0};
  sgpr_resp_t         salu_src_vals;
  salu_issued_instr_t salu_op_result;

  logic [63:0] op_result [OP_PARAMS.op_pipeline];

  // FIXME: Check to make sure this is properly synchronized with the data pipeline.
  logic [PIPELINE_BUFFER_DEPTH-1:0] results_valid = '0;

  genvar idx;

  assign salu_op_data = salu_op.data;
  assign salu_op.ready = (!results_valid[0] || salu_result.ready) && (salu_op.valid && salu_op_data.salu_params.common_params.salu_op == OP_PARAMS.salu_op);
  assign salu_src_vals = salu_issued_instr_buffer[0].src_val;

  always_comb begin
    salu_op_result = salu_issued_instr_buffer[OP_PARAMS.op_pipeline-1];
    salu_op_result.salu_params.wr_req.val = op_result[OP_PARAMS.op_pipeline-1];
  end

  assign salu_result.valid = results_valid[PIPELINE_BUFFER_DEPTH-1];
  assign salu_result.data = salu_op_result;

  always_ff@(posedge clk) begin
    if(!rst_n) begin
      salu_issued_instr_buffer[0] <= '0;
    end else begin
      if(salu_op.valid) begin
        salu_issued_instr_buffer[0] <= salu_op.data;
      end
    end
  end

  if(OP_PARAMS.op_pipeline > 1) begin
    for(idx = 0; idx < OP_PARAMS.op_pipeline; idx++) begin
      always_ff@(posedge clk) begin
        salu_issued_instr_buffer[idx] <= salu_issued_instr_buffer[idx-1];
      end
    end
  end

  // Keep track of which pipeline stages are "valid" at any given time
  // while allowing for a pipeline collapse to avoid bubbles.
  always_ff@(posedge clk) begin
    if(!rst_n) begin
      results_valid[0] <= '0;
    end else begin
      if(!results_valid[0] || salu_result.ready) begin
        results_valid[0] <= salu_op.valid && salu_op_data.salu_params.common_params.salu_op == OP_PARAMS.salu_op;
      end
    end
  end

  // FIXME: Need to set up stalling.
  if(PIPELINE_BUFFER_DEPTH > 1) begin
    for(idx = 1; idx < PIPELINE_BUFFER_DEPTH; idx++) begin
      always_ff@(posedge clk) begin
        results_valid[idx] <= results_valid[idx-1];
      end
    end
  end

  for(idx = 1; idx < PIPELINE_BUFFER_DEPTH; idx++) begin
    always_ff@(posedge clk) begin
      salu_issued_instr_buffer[idx] <= salu_issued_instr_buffer[idx-1];
    end
  end

// Conditionally generated operations.
if(OP_PARAMS.salu_op == add_op) begin
  logic [63:0] add_result;
  always_comb begin
    add_result = '0;
    if(salu_issued_instr_buffer[0].salu_params.common_params.carry_in) begin
      add_result = {63'd0, salu_src_vals.scc};
    end
    if(salu_issued_instr_buffer[0].salu_params.common_params.signedness) begin
      add_result = $signed(salu_src_vals.val[0]) + $signed(salu_src_vals.val[1]) + $signed(add_result);
    end else begin
      add_result = $unsigned(salu_src_vals.val[0]) + $unsigned(salu_src_vals.val[1]) + $unsigned(add_result);
    end
  end
  always_ff@(posedge clk) begin
    if(salu_result.ready || !results_valid[PIPELINE_BUFFER_DEPTH-1]) begin
      op_result[0] <= add_result;
    end
  end
end

if(OP_PARAMS.salu_op == sub_op) begin
  logic [63:0] sub_result;
  always_comb begin
    sub_result = '0;
    if(salu_issued_instr_buffer[0].salu_params.common_params.carry_in) begin
      sub_result = {63'd0, salu_src_vals.scc};
    end
    if(salu_issued_instr_buffer[0].salu_params.common_params.signedness) begin
      sub_result = $signed(salu_src_vals.val[0]) - $signed(salu_src_vals.val[1]) - $signed(sub_result);
    end else begin
      sub_result = $unsigned(salu_src_vals.val[0]) - $unsigned(salu_src_vals.val[1]) - $unsigned(sub_result);
    end
  end
  always_ff@(posedge clk) begin
    if(salu_result.ready || !results_valid[PIPELINE_BUFFER_DEPTH-1]) begin
      op_result[0] <= sub_result;
    end
  end
end

endmodule
