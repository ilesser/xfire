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
// Performs the calculations of bkm_steps.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_steps_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-05 - ilesser - Changed io ports to real type.
//    - 2016-08-22 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task bkm_steps;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input                   mode;
   input    [1:0]          format;
   input    real           X_in;
   input    real           Y_in;
   input    real           u_in;
   input    real           v_in;
   // ----------------------------------

   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output   real           X_out;
   output   real           Y_out;
   output   real           u_out;
   output   real           v_out;
   output   [`FSIZE-1:0]   flags;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   reg         double_word;
   reg         complex;
   real        X_int,      Y_int;
   real        X_frac,     Y_frac;
   real        u_int,      v_int;
   real        u_frac,     v_frac;
   real        d_x      [1:`N];
   real        d_y      [1:`N];
   reg   [1:0] d_x_bin  [1:`N];
   reg   [1:0] d_y_bin  [1:`N];
   real        X        [1:`N];
   real        Y        [1:`N];
   real        u        [1:`N];
   real        v        [1:`N];
   real        lut_X    [1:`N];
   real        lut_Y    [1:`N];
   real        lut_u    [1:`N];
   real        lut_v    [1:`N];
   integer     n;
   // -----------------------------------------------------

   begin

      double_word = format[0];
      complex     = format[1];

      X[1]  = X_in;
      Y[1]  = Y_in;
      u[1]  = u_in;
      v[1]  = v_in;

      for( n = 1; n < `N; n = n+1 ) begin


         // Get the d_n value
         get_d_n (
            // ----------------------------------
            // Data inputs
            // ----------------------------------
            mode,
            u[n],       v[n],
            // ----------------------------------
            // Data outputs
            // ----------------------------------
            d_x[n],     d_y[n],
            d_x_bin[n], d_y_bin[n]
         );

         // Get the lut values
         lut (
            // ----------------------------------
            // Data inputs
            // ----------------------------------
            mode,
            format,
            n,
            d_x_bin[n], d_y_bin[n],
            // ----------------------------------
            // Data outputs
            // ----------------------------------
            lut_X[n],   lut_Y[n],
            lut_u[n],   lut_v[n]
         );


         // Calculate the steps of the algorithm
         bkm_step (
            // ----------------------------------
            // Data inputs
            // ----------------------------------
            mode,
            format,
            n,
            d_x_bin[n], d_y_bin[n],
            X[n],       Y[n],
            u[n],       v[n],
            lut_X[n],   lut_Y[n],
            lut_u[n],   lut_v[n],
            // ----------------------------------
            // Data outputs
            // ----------------------------------
            X[n+1],     Y[n+1],
            u[n+1],     v[n+1]
         );

         #1;

      end

      X_out = X[`N];
      Y_out = Y[`N];
      u_out = u[`N];
      v_out = v[`N];
      flags = {`FSIZE{1'b0}};

   end

// *****************************************************************************

endtask

