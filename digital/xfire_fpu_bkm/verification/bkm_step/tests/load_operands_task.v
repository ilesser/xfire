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
// Load operands task for bkm_step block.
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
//    - 2016-07-06 - ilesser - Initial version.
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
   real                    dx,      dy;
   real                    X_n,     Y_n;
   real                    u_n,     v_n;
   real                    X_np1,   Y_np1;
   real                    u_np1,   v_np1;
   real                    lut_X,   lut_Y;
   real                    lut_u,   lut_v;
   // -----------------------------------------------------

   begin

      tb_mode     = cnt[`CNT_SIZE-1];
      tb_format   = cnt[`CNT_SIZE-2:`CNT_SIZE-3];
      tb_n        = cnt[2*`W+4+`LOG2N-1:2*`W+4];
      tb_d_x_n    = cnt[2*`W+3:2*`W+2];
      tb_d_y_n    = cnt[2*`W+1:2*`W+0];
      tb_X_n      = cnt[2*`W-1:1*`W];
      tb_Y_n      = cnt[1*`W-1:0*`W];
      tb_u_n      = cnt[2*`W-1:1*`W];
      tb_v_n      = cnt[1*`W-1:0*`W];
      // TODO: make them variable
      tb_lut_X    = `W'd0;
      tb_lut_Y    = `W'd0;
      tb_lut_u    = `W'd0;
      tb_lut_v    = `W'd0;

      double_word = tb_format[0];
      complex     = tb_format[1];

      n  = $itor($signed(tb_n));

      dx =  tb_d_x_n == 2'b01 ?  1  :
            tb_d_x_n == 2'b11 ? -1  :
                                 0  ;

      dy =  tb_d_y_n == 2'b01 ?  1  :
            tb_d_y_n == 2'b11 ? -1  :
                                 0  ;

      if (double_word==1'b1) begin
         X_n   = $itor($signed(tb_X_n));
         Y_n   = $itor($signed(tb_Y_n));
         u_n   = $itor($signed(tb_u_n));
         v_n   = $itor($signed(tb_v_n));
         lut_X = $itor($signed(tb_lut_X));
         lut_Y = $itor($signed(tb_lut_Y));
         lut_u = $itor($signed(tb_lut_u));
         lut_v = $itor($signed(tb_lut_v));
      end
      else begin
         X_n   = $itor($signed(tb_X_n[`W/2-1:0]));
         Y_n   = $itor($signed(tb_Y_n[`W/2-1:0]));
         u_n   = $itor($signed(tb_u_n[`W/2-1:0]));
         v_n   = $itor($signed(tb_v_n[`W/2-1:0]));
         lut_X = $itor($signed(tb_lut_X[`W/2-1:0]));
         lut_Y = $itor($signed(tb_lut_Y[`W/2-1:0]));
         lut_u = $itor($signed(tb_lut_u[`W/2-1:0]));
         lut_v = $itor($signed(tb_lut_v[`W/2-1:0]));
      end

      if (tb_mode==`MODE_E) begin
      // E-mode
      // ------
      // Z = E
      // w = 2^1 * L
      // Z_{n+1} = Z_n * (1 + d_n * 2^-n)
      // Z_{n+1} = (X_n + j Y_n) * (1 + dxn * 2^-n + j * dyn * 2^-n)
      // X_{n+1} = X_n * (1 + dxn * 2^-n) - Y_n * dyn * 2^-n)
      // Y_{n+1} = Y_n * (1 + dxn * 2^-n) + X_n * dyn * 2^-n)
      // w_{n+1} = 2 w_n - 2^(n+1) * ln(1 + d_n * 2^-n)

         if (complex==1'b1) begin

            // Calculate X and Y
            X_np1 = X_n * (1 + dx * 2**-n) - Y_n * dy * 2**-n;
            Y_np1 = Y_n * (1 + dx * 2**-n) + X_n * dy * 2**-n;

            // Calculate u and v
            u_np1 = 2 * (u_n - lut_u);
            v_np1 = 2 * (v_n - lut_v);

         end
         else begin

            // Calculate X and Y
            X_np1 = X_n * (1 + dx * 2**-n);
            Y_np1 = 0;

            // Calculate u and v
            u_np1 = 2 * (u_n - lut_u);
            v_np1 = 0;

         end

      end
      //else if (tb_mode==`MODE_L) begin
      else begin
      // L-mode
      // ------
      // Z = L
      // w = 2^1 * (E-1)
      // Z_{n+1} = Z_n - ln(1 + d_n * 2^-n)
      // w_{n+1} = 2 * [ w_n + d_n + d_n * w_n * 2^-n ]

      // d_n * w_n = (dx + j dy) * (u + j v) = (dx*u-dy*v) + j (dx*v+dy*u)

         if (complex==1'b1) begin

            // Calculate X and Y
            X_np1 = X_n - lut_X;
            Y_np1 = Y_n - lut_Y;

            // Calculate u and v
            u_np1 = 2*(u_n + dx + (dx * u_n - dy * v_n) * 2**(-n));
            v_np1 = 2*(v_n + dy + (dx * v_n + dy * u_n) * 2**(-n));

         end
         else begin

            // Calculate X and Y
            X_np1 = X_n - lut_X;
            Y_np1 = 0;

            // Calculate u and v
            u_np1 = 2*(u_n + dx + dx * u_n * 2**(-n));
            v_np1 = 0;

         end

      end

      //tb_X_np1 = (X_np1);
      tb_Y_np1 = (Y_np1);
      tb_u_np1 = (u_np1);
      tb_v_np1 = (v_np1);

      tb_X_np1 = $rtoi(X_np1+1.0-1.0);
      //tb_X_np1 = (X_np1+1.0-1.0);
      //tb_Y_np1 = (Y_np1+1.0-1.0);
      //tb_u_np1 = (u_np1+1.0-1.0);
      //tb_v_np1 = (v_np1+1.0-1.0);

      run_clk(1);

   end

// *****************************************************************************

endtask

