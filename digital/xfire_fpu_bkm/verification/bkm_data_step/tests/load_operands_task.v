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
// Load operands task for bkm_data_step block.
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
//    - 2016-08-03 - ilesser - Copied from bkm_control_step test.
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
   real                    dx,                        dy;
   real                    X_n,                       Y_n;
   real                    X_n_plus_d_x_n_r,          Y_n_plus_d_y_n_r;
   real                    X_n_times_d_n_r,           Y_n_times_d_n_r;
   real                    X_n_times_d_n_div_2_n_r,   Y_n_times_d_n_div_2_n_r;
   real                    X_np1,                     Y_np1;
   real                    lut_X,                     lut_Y;
   // -----------------------------------------------------

   begin

      tb_mode     = cnt[`CNT_SIZE-1];
      tb_format   = cnt[`CNT_SIZE-2:`CNT_SIZE-3];
      tb_n        = cnt[4*`W+4+`LOG2N-1:4*`W+4];
      tb_d_x_n    = cnt[4*`W+3         :4*`W+2];
      tb_d_y_n    = cnt[4*`W+1         :4*`W+0];
      tb_X_n      = cnt[4*`W-1         :3*`W];
      tb_Y_n      = cnt[3*`W-1         :2*`W];
      tb_lut_X    = cnt[2*`W-1         :1*`W];
      tb_lut_Y    = cnt[1*`W-1         :0*`W];

      double_word = tb_format[0];
      complex     = tb_format[1];

      n  = $itor(tb_n);

      dx =  tb_d_x_n == 2'b01 ?  1  :
            tb_d_x_n == 2'b11 ? -1  :
                                 0  ;

      dy =  tb_d_y_n == 2'b01 ?  1  :
            tb_d_y_n == 2'b11 ? -1  :
                                 0  ;

      if (double_word==1'b1) begin
         X_n   = $itor($signed(tb_X_n));
         Y_n   = $itor($signed(tb_Y_n));
         lut_X = $itor($signed(tb_lut_X));
         lut_Y = $itor($signed(tb_lut_Y));
      end
      else begin
         X_n   = $itor($signed(tb_X_n[`W/2-1:0]));
         Y_n   = $itor($signed(tb_Y_n[`W/2-1:0]));
         lut_X = $itor($signed(tb_lut_X[`W/2-1:0]));
         lut_Y = $itor($signed(tb_lut_Y[`W/2-1:0]));
      end

      if (tb_mode==`MODE_E) begin
      // E-mode
      // ------
      // Z = E
      // Z_{n+1} = Z_n * (1 + d_n * 2^-n)
      // Z_{n+1} = Z_n + Z_n * d_n * 2^-n
      // Z_{n+1} = (X_n + j Y_n) * (1 + dxn * 2^-n + j * dyn * 2^-n)
      // X_{n+1} = X_n * (1 + dxn * 2^-n) - Y_n * dyn * 2^-n)
      // Y_{n+1} = Y_n * (1 + dxn * 2^-n) + X_n * dyn * 2^-n)

         // Calculate X and Y

         X_n_plus_d_x_n_r        = X_n + dx;
         X_n_times_d_n_r         = (dx * X_n - dy * Y_n);

         Y_n_plus_d_y_n_r        = Y_n + dy;
         Y_n_times_d_n_r         = (dx * Y_n + dy * X_n);

         X_n_times_d_n_div_2_n_r = $rtoi(div_2_n(X_n_times_d_n_r, n));
         Y_n_times_d_n_div_2_n_r = $rtoi(div_2_n(Y_n_times_d_n_r, n));

         if (complex==1'b1) begin

            // Calculate X and Y
            //X_np1 = X_n * (1 + dx * 2**-n) - Y_n * dy * 2**-n;
            //Y_np1 = Y_n * (1 + dx * 2**-n) + X_n * dy * 2**-n;
            X_np1 = X_n + X_n_times_d_n_div_2_n_r;
            Y_np1 = Y_n + Y_n_times_d_n_div_2_n_r;

         end
         else begin

            // Calculate X and Y
            //X_np1 = X_n * (1 + dx * 2**-n);
            X_np1 = X_n + X_n_times_d_n_div_2_n_r;
            Y_np1 = 0;

         end

      end
      //else if (tb_mode==`MODE_L) begin
      else begin
      // L-mode
      // ------
      // Z = L
      // Z_{n+1} = Z_n - ln(1 + d_n * 2^-n)

         if (complex==1'b1) begin

            // Calculate X and Y
            X_np1 = X_n - lut_X;
            Y_np1 = Y_n - lut_Y;

         end
         else begin

            // Calculate X and Y
            X_np1 = X_n - lut_X;
            Y_np1 = 0;

         end

      end

      tb_X_np1 = X_np1;
      tb_Y_np1 = Y_np1;

      run_clk(1);

   end

// *****************************************************************************

endtask

function real div_2_n;
   input real x;
   input real n;
   real i,y;
   begin
      y = x;
      if (n>0) begin
         for (i=0; i<n; i=i+1) begin
            if ($rtoi(y)%2 == 0)
               y = y/2;
            else
               y = (y-1)/2;
         end
      end
      div_2_n = y;
   end
endfunction
