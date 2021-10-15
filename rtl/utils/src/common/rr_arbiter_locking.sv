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

module rr_arbiter_locking(
  in_req,
  out_grant,

  clk,
  rst_n
);

  parameter int NUM_REQUESTORS = 2;
  parameter int DATA_WIDTH = 32;

  decoupled_burst_intr.slave in_req[NUM_REQUESTORS];
  decoupled_burst_intr.master out_grant;

  input wire clk;
  input wire rst_n;

  logic [NUM_REQUESTORS-1:0] valid;
  logic [NUM_REQUESTORS-1:0] last;
  logic [NUM_REQUESTORS-1:0] ready;
  logic [DATA_WIDTH-1:0] data [NUM_REQUESTORS];

  logic [$clog2(NUM_REQUESTORS)-1:0] current_free;
  logic [$clog2(NUM_REQUESTORS)-1:0] current_free_next;
  logic [$clog2(NUM_REQUESTORS)-1:0] itr_idx;

  genvar idx;

  for(idx = 0; idx < NUM_REQUESTORS; idx++) begin
    always_comb begin
      valid[idx] = in_req[idx].valid;
      last[idx] = in_req[idx].last;
      data[idx] = in_req[idx].data;
      in_req[idx].ready = ready[idx];
    end
  end

  always_comb begin
    ready = '0;
    current_free_next = current_free;
    out_grant.valid = '0;
    out_grant.data = '0;
    for(int i = 0; i < NUM_REQUESTORS; i++) begin
      itr_idx = i + current_free;
      if(valid[itr_idx] && !(|ready)) begin
        if(out_grant.ready && last[itr_idx]) begin
          current_free_next = itr_idx + 'd1;
        end
        ready[itr_idx] = out_grant.ready;
        out_grant.valid = '1;
        out_grant.data = data[itr_idx];
      end
    end
  end

  always_ff@(posedge clk) begin
    if(!rst_n) begin
      current_free <= '0;
    end else begin
      current_free <= current_free_next;
    end
  end

endmodule
