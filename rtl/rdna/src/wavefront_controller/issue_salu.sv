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

module issue_salu(
  salu_decoded,
  sgpr_rd_req,
  sgpr_rd_resp,
  salu_issued,

  clk,
  rst_n
);

  decoupled_intr.slave salu_decoded;
  decoupled_intr.master sgpr_rd_req;
  decoupled_intr.slave sgpr_rd_resp;
  decoupled_intr.master salu_issued;

  input wire clk;
  input wire rst_n;

  logic salu_decoded_fire;
  logic sgpr_rd_req_fire;
  logic sgpr_rd_resp_fire;
  logic salu_issued_fire;

  typedef enum {
    ISSUER_SALU_IDLE, ISSUER_SALU_SGPR_RD, ISSUER_SALU_SGPR_RESP, ISSUER_SALU_SGPR_DISPATCH
  } issuer_salu_state_t;

  issuer_salu_state_t current_state;
  issuer_salu_state_t next_state;

  sgpr_req_t sgpr_rd_req_buffer;
  sgpr_resp_t sgpr_rd_resp_data;
  salu_issued_instr_t salu_issued_instr_buffer;

  assign salu_decoded.ready = current_state == ISSUER_SALU_IDLE;
  assign sgpr_rd_req.valid = current_state == ISSUER_SALU_SGPR_RD;
  assign sgpr_rd_req.data = sgpr_rd_req_buffer;
  assign sgpr_rd_resp.ready = current_state == ISSUER_SALU_SGPR_RESP;
  assign salu_issued.valid = current_state == ISSUER_SALU_SGPR_DISPATCH;
  assign salu_issued.data = salu_issued_instr_buffer;

  assign sgpr_rd_req_buffer = salu_issued_instr_buffer.salu_params.rd_req;
  assign sgpr_rd_resp_data = sgpr_rd_resp.data;

  assign salu_decoded_fire = salu_decoded.valid && salu_decoded.ready;
  assign sgpr_rd_req_fire = sgpr_rd_req.valid && sgpr_rd_req.ready;
  assign sgpr_rd_resp_fire = sgpr_rd_resp.valid && sgpr_rd_resp.ready;
  assign salu_issued_fire = salu_issued.valid && salu_issued.ready;

  always_ff@(posedge clk) begin
    if(!rst_n) begin
      current_state <= ISSUER_SALU_IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  always_ff@(posedge clk) begin
    case(current_state)

      ISSUER_SALU_IDLE: begin
        if(salu_decoded_fire) begin
          salu_issued_instr_buffer.salu_params <= salu_decoded.data;
        end
      end

      ISSUER_SALU_SGPR_RESP: begin
        if(sgpr_rd_resp_fire) begin
          salu_issued_instr_buffer.src_val <= sgpr_rd_resp_data;
        end
      end

    endcase
  end

  always_comb begin
    next_state = current_state;
    case(current_state)

      ISSUER_SALU_IDLE: begin
        if(salu_decoded_fire) begin
          next_state = ISSUER_SALU_SGPR_RD;
        end
      end

      ISSUER_SALU_SGPR_RD: begin
        if(sgpr_rd_req_fire) begin
          next_state = ISSUER_SALU_SGPR_RESP;
        end
      end

      ISSUER_SALU_SGPR_RESP: begin
        if(sgpr_rd_resp_fire) begin
          next_state = ISSUER_SALU_SGPR_DISPATCH;
        end
      end

      ISSUER_SALU_SGPR_DISPATCH: begin
        if(salu_issued_fire) begin
          next_state = ISSUER_SALU_IDLE;
        end
      end

    endcase
  end

endmodule
