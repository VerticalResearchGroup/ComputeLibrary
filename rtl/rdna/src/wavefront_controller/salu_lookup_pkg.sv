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

package salu_lookup_pkg;
  import salu_instr_pkg::*;

  salu_lookup_t sop2_lookup_table[SOP2_INSTR_CNT] = '{
    '{salu_op:add_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:sub_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:add_op    , carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:sub_op    , carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:add_op    , carry_in:'1, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:sub_op    , carry_in:'1, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:min_op    , carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:min_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:max_op    , carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:max_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:sel_op    , carry_in:'1, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:sel_op    , carry_in:'1, carry_out:'0, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:rsvd_op   , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:rsvd_op   , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:and_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:and_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:or_op     , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:or_op     , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:xor_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:xor_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:andn_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:andn_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:orn_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:orn_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:nand_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:nand_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:nor_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:nor_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:xnor_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:xnor_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:lshl_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:lshl_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:lshr_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:lshr_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:ashr_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:ashr_op   , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:bfm_op    , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:bfm_op    , carry_in:'0, carry_out:'0, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:mul_op    , carry_in:'0, carry_out:'0, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:bfe_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:bfe_op    , carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:bfe_op    , carry_in:'0, carry_out:'1, signedness:'0, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:bfe_op    , carry_in:'0, carry_out:'1, signedness:'1, long_word:'1, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:rsvd_op   , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:absdiff_op, carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:rsvd_op   , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:lsh_add_op, carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d1, waitcnt_type:nop_cnt},
    '{salu_op:lsh_add_op, carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d2, waitcnt_type:nop_cnt},
    '{salu_op:lsh_add_op, carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d3, waitcnt_type:nop_cnt},
    '{salu_op:lsh_add_op, carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d4, waitcnt_type:nop_cnt},
    '{salu_op:pack_op   , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:pack_op   , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d1, waitcnt_type:nop_cnt},
    '{salu_op:pack_op   , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d2, waitcnt_type:nop_cnt},
    '{salu_op:mul_op    , carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d1, waitcnt_type:nop_cnt},
    '{salu_op:mul_op    , carry_in:'0, carry_out:'0, signedness:'1, long_word:'0, shift_low_hi:'d1, waitcnt_type:nop_cnt}
  };

  salu_compute_params_t salu_compute_params_lookup[] = '{
    '{salu_op:add_op, op_pipeline:1},
    '{salu_op:sub_op, op_pipeline:1}
  };

  salu_lookup_t sopk_lookup_table[SOPK_INSTR_CNT] = '{
    '{salu_op:mov_op,     carry_in:'0, carry_out:'0, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:nop,        carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:mov_op,     carry_in:'1, carry_out:'0, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_eq,     carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_neq,    carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_gt,     carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_gte,    carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_lt,     carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_lte,    carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_eq,     carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_neq,    carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_gt,     carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_gte,    carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_lt,     carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:cmp_lte,    carry_in:'0, carry_out:'1, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:add_op,     carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:mul_op,     carry_in:'0, carry_out:'1, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:nop,        carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt}, // Skipped index.
    '{salu_op:getreg_op,  carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:setreg_op,  carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:nop,        carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt}, // Skipped index.
    '{salu_op:setreg_op,  carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt}, // TODO: Needs to be analyzed further.
    '{salu_op:call_op,    carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt},
    '{salu_op:waitcnt_op, carry_in:'0, carry_out:'0, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:vs_cnt },
    '{salu_op:waitcnt_op, carry_in:'0, carry_out:'0, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:vm_cnt },
    '{salu_op:waitcnt_op, carry_in:'0, carry_out:'0, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:exp_cnt},
    '{salu_op:waitcnt_op, carry_in:'0, carry_out:'0, signedness:'1, long_word:'0, shift_low_hi:'d0, waitcnt_type:lgk_cnt},
    '{salu_op:loop_op,    carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt}, // TODO: Needs to be analyzed further.
    '{salu_op:loop_op,    carry_in:'0, carry_out:'0, signedness:'0, long_word:'0, shift_low_hi:'d0, waitcnt_type:nop_cnt}  // TODO: Needs to be analyzed further.
  };

endpackage
