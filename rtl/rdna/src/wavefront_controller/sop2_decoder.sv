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
import salu_lookup_pkg::*;

module sop2_decoder(
  instr,
  operation,
  clk,
  rst_n
);

  valid_intr.slave instr;
  valid_intr.master operation;

  input wire clk;
  input wire rst_n;

  salu_instr_params_t instruction_parameters;
  sop2_instr_t instruction;
  salu_lookup_t lookup_vals;

  assign instruction = instr.data;
  assign lookup_vals = sop2_lookup_table[instruction.opcode];

  assign instruction_parameters.common_params = lookup_vals;
  assign instruction_parameters.rd_req.addr[0] = instruction.src[0];
  assign instruction_parameters.rd_req.addr[1] = instruction.src[1];
  // TODO: Incorporate base address once wavefronts are actually supported.
  assign instruction_parameters.rd_req.base = '0;
  assign instruction_parameters.wr_req.sgpr_op = sgpr_write;
  assign instruction_parameters.wr_req.addr[0] = instruction.dest;
  assign instruction_parameters.wr_req.base = '0;

  always_ff@(posedge clk) begin
    if(!rst_n) begin
      operation.valid <= '0;
      operation.data <= '0;
    end else begin
      operation.valid <= instruction.salu_type == SALU_SOP2 && instr.valid;
      operation.data <= instruction_parameters;
    end
  end

endmodule
