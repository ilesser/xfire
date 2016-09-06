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
// Performs the calculations of a bkm_step.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_step_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-05 - ilesser - Fixes bug #15.
//    - 2016-09-05 - ilesser - Changed bkm_step_task inputs to real type.
//    - 2016-08-15 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task bkm_step;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input                   mode;
   input    [1:0]          format;
   input    [`LOG2N-1:0]   n;
   input    [1:0]          d_x_n;
   input    [1:0]          d_y_n;
   input    real           X_n;
   input    real           Y_n;
   input    real           u_n;
   input    real           v_n;
   input    real           lut_X_n;
   input    real           lut_Y_n;
   input    real           lut_u_n;
   input    real           lut_v_n;
   // ----------------------------------

   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output   real           X_np1;
   output   real           Y_np1;
   output   real           u_np1;
   output   real           v_np1;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   reg   double_word;
   reg   complex;
   real  dx,                        dy;
   real  X_n_times_d_n_r,           Y_n_times_d_n_r;
   real  X_n_times_d_n_div_2_n_r,   Y_n_times_d_n_div_2_n_r;
   real  du,                        dv;
   real  u_n_plus_d_u_n_r,          v_n_plus_d_v_n_r;
   real  u_n_times_d_n_r,           v_n_times_d_n_r;
   real  u_n_times_d_n_div_2_n_r,   v_n_times_d_n_div_2_n_r;
   // -----------------------------------------------------

   begin

      double_word = format[0];
      complex     = format[1];

      dx =  d_x_n == 2'b01 ?  1  :
            d_x_n == 2'b11 ? -1  :
                              0  ;

      dy =  d_y_n == 2'b01 ?  1  :
            d_y_n == 2'b11 ? -1  :
                              0  ;

      du = dx;
      dv = dy;

      if (mode==`MODE_E) begin
      // E-mode
      // ------
      // Z = E
      // w = 2^1 * L
      // Z_{n+1} = Z_n * (1 + d_n * 2^-n)
      // Z_{n+1} = (X_n + j Y_n) * (1 + dxn * 2^-n + j * dyn * 2^-n)
      // X_{n+1} = X_n * (1 + dxn * 2^-n) - Y_n * dyn * 2^-n)
      // Y_{n+1} = Y_n * (1 + dxn * 2^-n) + X_n * dyn * 2^-n)
      // w_{n+1} = 2 w_n - 2^(n+1) * ln(1 + d_n * 2^-n)

         // Calculate X and Y

         X_n_times_d_n_r         = (dx * X_n - dy * Y_n);

         Y_n_times_d_n_r         = (dx * Y_n + dy * X_n);

         // TODO: this will create a 1 LSB error
         X_n_times_d_n_div_2_n_r = X_n_times_d_n_r / 2.0**n;
         Y_n_times_d_n_div_2_n_r = Y_n_times_d_n_r / 2.0**n;

         if (complex==1'b1) begin

            // Calculate X and Y
            X_np1 = X_n + X_n_times_d_n_div_2_n_r;
            Y_np1 = Y_n + Y_n_times_d_n_div_2_n_r;

            // Calculate u and v
            u_np1 = 2 * u_n - lut_u_n;
            v_np1 = 2 * v_n - lut_v_n;

         end
         else begin

            // Calculate X and Y
            X_np1 = X_n + X_n_times_d_n_div_2_n_r;
            Y_np1 = 0;

            // Calculate u and v
            u_np1 = 2 * u_n - lut_u_n;
            v_np1 = 0;

         end

      end
      else begin
      // L-mode
      // ------
      // Z = L
      // w = 2^1 * (E-1)
      // Z_{n+1} = Z_n - ln(1 + d_n * 2^-n)
      // w_{n+1} = 2 * [ w_n + d_n + d_n * w_n * 2^-n ]

      // d_n * w_n = (dx + j dy) * (u + j v) = (dx*u-dy*v) + j (dx*v+dy*u)


         // Calculate u and v
         u_n_plus_d_u_n_r        = u_n + du;
         u_n_times_d_n_r         = (du * u_n - dv * v_n);

         v_n_plus_d_v_n_r        = v_n + dv;
         v_n_times_d_n_r         = (du * v_n + dv * u_n);

         u_n_times_d_n_div_2_n_r = $rtoi( u_n_times_d_n_r / 2.0**n);
         v_n_times_d_n_div_2_n_r = $rtoi( v_n_times_d_n_r / 2.0**n);


         if (complex==1'b1) begin

            // Calculate X and Y
            X_np1 = X_n - lut_X_n;
            Y_np1 = Y_n - lut_Y_n;

            // Calculate u and v
            u_np1 = 2*( u_n_plus_d_u_n_r + u_n_times_d_n_div_2_n_r );
            v_np1 = 2*( v_n_plus_d_v_n_r + v_n_times_d_n_div_2_n_r );

         end
         else begin

            // Calculate X and Y
            X_np1 = X_n - lut_X_n;
            Y_np1 = 0;

            // Calculate u and v
            u_np1 = 2*( u_n_plus_d_u_n_r + u_n_times_d_n_div_2_n_r );
            v_np1 = 0;

         end

      end // if (mode==`MODE_E) begin

   end

// *****************************************************************************

endtask
