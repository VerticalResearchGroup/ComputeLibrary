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

module decoder(
  instr,

  salu_decoded,

  clk,
  rst_n
);

  decoupled_intr.slave instr;

  decoupled_intr.master salu_decoded;

  input wire clk;
  input wire rst_n;

  // FIXME: Placeholder until proper flow control is implemented.
  assign instr.ready = '1;

  valid_intr #(.DATA_WIDTH(INSTR_SIZE)) salu_intr();
  valid_intr #(.DATA_WIDTH(SALU_INST_PARAM_SIZE)) salu_op();

  assign salu_intr.valid = instr.valid;
  assign salu_intr.data = instr.data;

  assign salu_decoded.valid = salu_op.valid;
  assign salu_decoded.data = salu_op.data;

  salu_decoder salu_decoder_inst(
    .instr(salu_intr),
    .operation(salu_op),
    .clk,
    .rst_n
  );

endmodule
