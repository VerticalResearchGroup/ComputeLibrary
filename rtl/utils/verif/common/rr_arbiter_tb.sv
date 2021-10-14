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

module rr_arbiter_tb();

  localparam int NUM_REQUESTORS = 4;
  localparam int DATA_WIDTH = 32;

  decoupled_intr in_req[NUM_REQUESTORS]();
  decoupled_intr out_grant();

  logic [NUM_REQUESTORS-1:0] req_valid = '0;
  logic [DATA_WIDTH-1:0] req_data [NUM_REQUESTORS];

  logic clk = '0;
  logic rst_n = '0;

  int cycle_counter = 0;

  logic [$clog2(NUM_REQUESTORS)-1:0] req_idx = '0;

  genvar idx;

  always #2 clk = ~clk;

  for(idx = 0; idx < NUM_REQUESTORS; idx++) begin
    initial begin
      in_req[idx].data = $urandom();
    end
    always_comb begin
      in_req[idx].valid = req_valid[idx];
      req_data[idx] = in_req[idx].data;
    end
  end

  initial begin
    out_grant.ready = '1;
    #50 rst_n = '1;
  end

  always_ff@(posedge clk) begin
    if(rst_n) begin
      cycle_counter <= cycle_counter + 1;
      if(cycle_counter > 10) begin
        for(int i = 0; i < NUM_REQUESTORS; i++) begin
          //req_valid[i] <= $urandom();
          req_valid[i] <= '1;
        end
      end

      //if(out_grant.valid) begin
      //  assert(req_data[req_idx] == out_grant.data) else $fatal(1, "TEST FAILED: Mismatch between expected and actual selected output.");
      //end
    end
  end

  rr_arbiter #(
    .NUM_REQUESTORS(NUM_REQUESTORS),
    .DATA_WIDTH(DATA_WIDTH)
  )
  rr_arbiter_inst(
    .in_req,
    .out_grant,

    .clk,
    .rst_n
  );

endmodule
