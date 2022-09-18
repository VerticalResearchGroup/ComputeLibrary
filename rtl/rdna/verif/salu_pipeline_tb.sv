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

module salu_pipeline_tb();

  logic clk = '0;
  logic rst_n = '0;

  int cycle_counter = 0;

  always #2 clk = ~clk;

  initial begin
    repeat(50)@(posedge clk);
    rst_n = '1;
  end

  decoupled_intr #(.DATA_WIDTH(INSTR_SIZE)) instr();

  sop2_instr_t salu_sop2_instr = '0;

  assign instr.data = salu_sop2_instr;

  initial begin
    instr.valid = '0;
  end

  always_ff@(posedge clk) begin
    if(!rst_n) begin
      cycle_counter <= 0;
    end else begin
      cycle_counter <= cycle_counter + 1;
      instr.valid = '0;
      if(cycle_counter == 10) begin
        instr.valid = '1;
        salu_sop2_instr.salu_type <= 'b10;
        salu_sop2_instr.opcode <= '0;
        salu_sop2_instr.dest <= 'd1;
        salu_sop2_instr.src[0] <= 'd2;
        salu_sop2_instr.src[1] <= 'd3;
      end
    end
  end

  simd simd_inst(
    .icache_rd_resp(instr),
    .clk,
    .rst_n
  );

endmodule
