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
// Load operands task for bkm_steps block.
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
//    - 2016-08-15 - ilesser - Initial version.
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
   reg      double_word;
   reg      complex;
   integer  i;
   real     nc, nd;
   real     dx,                        dy;
   real     X_n,                       Y_n;
   real     X_n_times_d_n_r,           Y_n_times_d_n_r;
   real     X_n_times_d_n_div_2_n_r,   Y_n_times_d_n_div_2_n_r;
   real     X_np1,                     Y_np1;
   real     lut_X_n,                   lut_Y_n;
   real     du,                        dv;
   real     u_n,                       v_n;
   real     u_np1,                     v_np1;
   real     lut_u_n,                   lut_v_n;
   real     u_n_plus_d_u_n_r,          v_n_plus_d_v_n_r;
   real     u_n_times_d_n_r,           v_n_times_d_n_r;
   real     u_n_times_d_n_div_2_n_r,   v_n_times_d_n_div_2_n_r;
   // -----------------------------------------------------

   begin

      // Apply stymulus to testbench
      tb_mode     = cnt[`CNT_SIZE-1];
      tb_format   = cnt[`CNT_SIZE-2:`CNT_SIZE-3];
      tb_X_in     = cnt[2*`WC+2*`WD-1           :2*`WC+1*`WD];
      tb_Y_in     = cnt[2*`WC+1*`WD-1           :2*`WC+0*`WD];
      tb_u_in     = cnt[2*`WC+0*`WD-1           :1*`WC+0*`WD];
      tb_v_in     = cnt[1*`WC+0*`WD-1           :0*`WC+0*`WD];



      // Calculate the results
      bkm(  tb_mode,
            tb_format,
            tb_X_in,
            tb_Y_in,
            tb_u_in,
            tb_v_in,
            tb_X_out,
            tb_Y_out,
            tb_u_out,
            tb_v_out,
            tb_flags
         );

      // Wait N clocks for results
      run_clk(`N);

   end

// *****************************************************************************

endtask
