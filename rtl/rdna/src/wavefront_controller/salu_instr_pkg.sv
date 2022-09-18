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

package salu_instr_pkg;

  import sgpr_pkg::*;

  typedef enum {
    sop2,
    sopk,
    sop1,
    sopc,
    sopp
  } salu_type_t;

  typedef enum {
    add_op,
    sub_op,
    min_op,
    max_op,
    sel_op,
    and_op,
    or_op,
    xor_op,
    andn_op,
    orn_op,
    nand_op,
    nor_op,
    xnor_op,
    lshl_op,
    lshr_op,
    ashr_op,
    bfm_op,
    mul_op,
    bfe_op,
    absdiff_op,
    lsh_add_op,
    pack_op,
    rsvd_op,
    mov_op,
    nop,
    getreg_op,
    setreg_op,
    call_op,
    waitcnt_op,
    loop_op,
    cmp_eq,
    cmp_neq,
    cmp_gt,
    cmp_gte,
    cmp_lt,
    cmp_lte
  } salu_op_t;

  parameter logic [1:0] SALU_SOP2 = 2'b10;
  parameter logic [3:0] SALU_SOPK = 4'b1011;

  typedef struct packed {
    logic [1:0] salu_type;
    logic [6:0] opcode;
    logic [6:0] dest;
    logic [1:0][7:0] src;
  } sop2_instr_t;

  typedef struct packed {
    logic [3:0] salu_type;
    logic [4:0] opcode;
    logic [6:0] sdst;
    logic [15:0] imm;
  } sopk_instr_t;

  typedef enum {
    nop_cnt,
    vs_cnt,
    vm_cnt,
    exp_cnt,
    lgk_cnt
  } waitcnt_type_t;

  typedef struct packed {
    salu_op_t salu_op;
    logic signedness;
    logic carry_in;
    logic carry_out;
    logic long_word;
    logic [2:0] shift_low_hi;
    waitcnt_type_t waitcnt_type;
  } salu_lookup_t;

  typedef struct packed {
    salu_lookup_t common_params;
    sgpr_req_t rd_req;
    sgpr_req_t wr_req;
    logic [31:0] imm;
  } salu_instr_params_t;

  typedef struct packed {
    salu_instr_params_t salu_params;
    sgpr_resp_t src_val;
  } salu_issued_instr_t;

  typedef struct packed {
    // TODO: Finish conversion.
    sgpr_req_t sgpr_wr_req;
  } salu_result_t;

  typedef struct packed {
    salu_op_t salu_op;
    int op_pipeline;
  } salu_compute_params_t;

  // Needs to be a parameter because it's being passed down as a parameter
  // in a generate block.

  parameter int SALU_IMPLEMENTED_OPS = 2;

  parameter salu_compute_params_t SALU_COMPUTE_PARAMS[SALU_IMPLEMENTED_OPS] = '{
    '{salu_op:add_op, op_pipeline:1},
    '{salu_op:sub_op, op_pipeline:1}
  };

  parameter int SOP2_INSTR_CNT = 55;
  parameter int SOPK_INSTR_CNT = 29;
  parameter int SALU_OP_CNT = SALU_IMPLEMENTED_OPS;
  parameter int SALU_INST_PARAM_SIZE = $bits(salu_instr_params_t);
  parameter int SALU_INST_ISSUED_SIZE = $bits(salu_issued_instr_t);
  parameter int SALU_RESULT_SIZE = $bits(salu_result_t);

  parameter int INSTR_SIZE = 32;

endpackage
