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
// Performs the calculations of a bkm.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
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
   input    [`WD-1:0]      X_in;
   input    [`WD-1:0]      Y_in;
   input    [`WC-1:0]      u_in;
   input    [`WC-1:0]      v_in;
   // ----------------------------------

   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output   [`WD-1:0]      X_out;
   output   [`WD-1:0]      Y_out;
   output   [`WC-1:0]      u_out;
   output   [`WC-1:0]      v_out;
   output   [`FSIZE-1:0]   flags;
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
   real  X_int,      Y_int;
   real  X_dec,      Y_dec;
   real  u_int,      v_int;
   real  u_dec,      v_dec;
   real  d_x,        d_y   [`N:0];
   real  X,          Y     [`N:0];
   real  lut_X,      lut_Y [`N:0];
   real  u,          v     [`N:0];
   real  lut_u,      lut_v [`N:0];
   // -----------------------------------------------------

   begin

      double_word = format[0];
      complex     = format[1];

      if (double_word==1'b1) begin
         // Get X and Y integer and decimal parts
         X_int = $itor($signed(X_in [`WD-1      :`WD-10]));
         Y_int = $itor($signed(Y_in [`WD-1      :`WD-10]));
         X_dec = $itor($signed(X_in [`WD-11     :     0]))  / 2**(`WD-10);
         Y_dec = $itor($signed(Y_in [`WD-11     :     0]))  / 2**(`WD-10);

         // Get u and v integer and decimal parts
         u_int = $itor($signed(tb_u [`WC-1      :     4]));
         v_int = $itor($signed(tb_v [`WC-1      :     4]));
         u_dec = $itor(       (tb_u [3          :     0]))  / 2**4;
         v_dec = $itor(       (tb_v [3          :     0]))  / 2**4;
      end
      else begin
         // Get u and v integer and decimal parts
         X_int = $itor($signed(X_in [`WD/2-1    :`WD-10]));
         Y_int = $itor($signed(Y_in [`WD/2-1    :`WD-10]));
         X_dec = $itor($signed(X_in [`WD/2-11   :     0]))  / 2**(`WD-10);
         Y_dec = $itor($signed(Y_in [`WD/2-11   :     0]))  / 2**(`WD-10);

         // Get u and v integer and decimal parts
         u_int = $itor($signed(tb_u [`WC/2-1    :     4]));
         v_int = $itor($signed(tb_v [`WC/2-1    :     4]));
         u_dec = $itor(       (tb_u [3          :     0]))  / 2**4;
         v_dec = $itor(       (tb_v [3          :     0]))  / 2**4;
      end // if (double_word==1'b1)

      // Create real numbers
      X[0]  = X_int + X_dec;
      Y[0]  = Y_int + Y_dec;
      u[0]  = u_int + u_dec;
      v[0]  = v_int + v_dec;

      for( n = 0; n < `N; n = n+1 ) begin


         // Get the d_n value
         get_d_n (
            // ----------------------------------
            // Data inputs
            // ----------------------------------
            format  ,
            u[n]    ,   v[n]    ,
            // ----------------------------------
            // Data outputs
            // ----------------------------------
            d_x[n]  ,    d_y[n]
         );

         // Get the lut values
         get_lut (
            // ----------------------------------
            // Data inputs
            // ----------------------------------
            mode    ,
            format  ,
            n       ,
            d_x[n]  ,    d_y[n] ,
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
            mode    ,
            format  ,
            n       ,
            d_x[n]  ,   d_y[n]  ,
            X[n]    ,   Y[n]    ,
            u[n]    ,   v[n]    ,
            lut_X[n],   lut_Y[n],
            lut_u[n],   lut_v[n],
            // ----------------------------------
            // Data outputs
            // ----------------------------------
            X[n+1]  ,   Y[n+1]  ,
            u[n+1]  ,   v[n+1]
         );

      X_out = X[`N];
      Y_out = Y[`N];
      u_out = u[`N];
      v_out = v[`N];
      flags = {`FISE{1'b0}};

   end

// *****************************************************************************

endtask

// *****************************************************************************
// Interface
// *****************************************************************************
task get_d_n;

      // ----------------------------------
      // Data inputs
      // ----------------------------------
      input             format;
      input    real     u, v;
      // ----------------------------------

      // ----------------------------------
      // Data outputs
      // ----------------------------------
      output   real     d_x, d_y;
      // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------


   begin
      if (mode==`MODE_E) begin
         // Calculate d_n for E mode
         d_x = u <= -0.625    ? -1  :
               u >=  0.375    ?  1  :
                                 0  ;
         d_y = v <= -0.8125   ? -1  :
               v >=  0.8125   ?  1  :
                                 0  ;
      end
      else if ( mode == `MODE_L ) begin
         // Calculate d_n for L mode
         d_x = u <= -0.500    ? -1  :
               u >=  0.500    ?  1  :
                                 0  ;
         d_y = v <= -0.500    ? -1  :
               v >=  0.500    ?  1  :
                                 0  ;
      end
   end

// *****************************************************************************

endtask
