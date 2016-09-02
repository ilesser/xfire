// -----------------------------------------------------------------------------
//  Copyright (c) 2016 Microelectronics Lab. FIUBA.
//  All Rights Reserved.
//
//  The information contained in this file is confidential and proprietary.
//  Any reproduction, use or disclosure, in whole or in part, of this
//  program, including any attempt to obtain a human-readable version of this
//  program, without the express, prior written consent of Microelectronics Lab.
//  FIUBA is strictly prohibited.
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Load operands task for bkm_control_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// load_operands_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-15 - ilesser - Modified architecture to use a task to calculate
//                             the results.
//    - 2016-08-02 - ilesser - Changed the definition of W.
//    - 2016-07-23 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task load_operands;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input [`CNT_SIZE-1:0]   cnt;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   reg                     double_word;
   reg                     complex;
   real                    n;
   real                    du,                        dv;
   real                    u_n,                       v_n;
   real                    u_np1,                     v_np1;
   real                    lut_u,                     lut_v;
   real                    u_n_plus_d_u_n_r,          v_n_plus_d_v_n_r;
   real                    u_n_times_d_n_r,           v_n_times_d_n_r;
   real                    u_n_times_d_n_div_2_n_r,   v_n_times_d_n_div_2_n_r;
   real                    sign_u,                    sign_v;
   reg      [`WD-1:0]      dummy_X_n,                 dummy_Y_n;
   reg      [`WD-1:0]      dummy_lut_X_n,             dummy_lut_Y_n;
   reg      [`WD-1:0]      dummy_X_np1,               dummy_Y_np1;
   // -----------------------------------------------------

   begin

      // Assign values to testbench
      tb_mode     = cnt[`CNT_SIZE-1];
      tb_format   = cnt[`CNT_SIZE-2:`CNT_SIZE-3];
      tb_n        = cnt[4*`WC+4+`LOG2N-1:4*`WC+4];
      tb_d_u_n    = cnt[4*`WC+3         :4*`WC+2];
      tb_d_v_n    = cnt[4*`WC+1         :4*`WC+0];
      tb_u_n      = cnt[4*`WC-1         :3*`WC];
      tb_v_n      = cnt[3*`WC-1         :2*`WC];
      tb_lut_u_n  = cnt[2*`WC-1         :1*`WC];
      tb_lut_v_n  = cnt[1*`WC-1         :0*`WC];

      // Assign dummy values
      dummy_X_n      = {`WD{1'b0}};
      dummy_Y_n      = {`WD{1'b0}};
      dummy_lut_X_n  = {`WD{1'b0}};
      dummy_lut_Y_n  = {`WD{1'b0}};

      // Calculate the results
      bkm_step (
         // ----------------------------------
         // Data inputs
         // ----------------------------------
         tb_mode      ,
         tb_format    ,
         tb_n         ,
         tb_d_u_n     , tb_d_v_n     ,
         dummy_X_n    , dummy_Y_n    ,
         tb_u_n       , tb_v_n       ,
         dummy_lut_X_n, dummy_lut_Y_n,
         tb_lut_u_n   , tb_lut_v_n   ,
         // ----------------------------------
         // Data outputs
         // ----------------------------------
         dummy_X_np1  , dummy_Y_np1  ,
         tb_u_np1     , tb_v_np1
      );

      run_clk(1);

   end

// *****************************************************************************

endtask
