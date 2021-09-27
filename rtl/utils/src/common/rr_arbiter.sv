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

module rr_arbiter(
  in_req,
  out_grant,

  clk,
  rst_n
);

  parameter int NUM_REQUESTORS = 2;
  parameter int DATA_WIDTH = 32;

  decoupled_intr.slave in_req[NUM_REQUESTORS];
  decoupled_intr.master out_grant;

  input wire clk;
  input wire rst_n;

  decoupled_burst_intr #(.DATA_WIDTH(DATA_WIDTH)) rr_in_req[NUM_REQUESTORS]();
  decoupled_burst_intr #(.DATA_WIDTH(DATA_WIDTH)) rr_out_grant();

  genvar idx;

  for(idx = 0; idx < NUM_REQUESTORS; idx++) begin
    always_comb begin
      rr_in_req[idx].valid = in_req[idx].valid;
      rr_in_req[idx].last = '1;
      rr_in_req[idx].data = in_req[idx].data;
      in_req[idx].ready = rr_in_req[idx].ready;
    end
  end

  assign out_grant.valid = rr_out_grant.valid;
  assign out_grant.data = rr_out_grant.data;
  assign rr_out_grant.ready = out_grant.ready;

  rr_arbiter_locking #(
    .NUM_REQUESTORS(NUM_REQUESTORS),
    .DATA_WIDTH(DATA_WIDTH)
  )
  rr_arbiter_locking_inst(
    .in_req(rr_in_req),
    .out_grant(rr_out_grant),
    .clk,
    .rst_n
  );

endmodule
