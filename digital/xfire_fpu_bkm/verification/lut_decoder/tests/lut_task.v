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
// Gets the lut values for the BKM algorithm.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// lut_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-31 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task lut;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input                   mode;
   input    [1:0]          format;
   input    [`LOG2N-1:0]   n_bin;
   input    [1:0]          d_x_n, d_y_n;
   // ----------------------------------

   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output   real           lut_X_n, lut_Y_n;
   output   real           lut_u_n, lut_v_n;
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
   real  n;
   real  dx,      dy;
   // -----------------------------------------------------

   begin

      // Decompose format
      double_word = format[0];
      complex     = format[1];

      // Calculate n real value;
      n = $itor(n_bin+1);

      // Get d_n values
      dx =  d_x_n == 2'b01 ?  1  :
            d_x_n == 2'b11 ? -1  :
                              0  ;

      dy =  d_y_n == 2'b01 ?  1  :
            d_y_n == 2'b11 ? -1  :
                              0  ;

      if ( mode == `MODE_E ) begin
         lut_X_n =        0.0;
         lut_Y_n =        0.0;
      end
      else begin
         lut_X_n =        0.5 * $ln( 1 + dx * 2.0**(-n+1) + (dx*dx + dy*dy) * 2.0**(-2*n) );
         lut_Y_n =              dy * $atan( 2.0**(-n) / (1 + dx * 2.0**(-n)) );
      end

      if ( mode == `MODE_E ) begin
         lut_u_n = 2.0**n     * $ln( 1 + dx * 2.0**(-n+1) + (dx*dx + dy*dy) * 2.0**(-2*n) );
         lut_v_n = 2.0**(n+1) * dy * $atan( 2.0**(-n) / (1 + dx * 2.0**(-n)) );
      end
      else begin
         lut_u_n = 0.0;
         lut_v_n = 0.0;
      end

   end

// *****************************************************************************

endtask

