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
// Loads bkm input ports.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// load_bkm.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-23 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task load_bkm;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input                mode;
   input [1:0]          format;
   input [W-1:0]        E_x;
   input [W-1:0]        E_y;
   input [W-1:0]        L_x;
   input [W-1:0]        L_y;
   input [W-1:0]        X;
   input [W-1:0]        Y;
   input [`FSIZE-1:0]   F;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   reg         err_x;
   reg         err_y;
   reg         err_f;
   // -----------------------------------------------------

   begin

      tb_mode     = mode;
      tb_format   = format;
      tb_E_x      = E_x;
      tb_E_y      = E_y;
      tb_L_x      = L_x;
      tb_L_y      = L_y;

      if (tb_enable == 1'b1 ) begin
         tb_start = 1'b1;
         run_clk(1);
         tb_start = 1'b0;
         run_clk(2*W);
         // TODO: run until done is high
      end
      else  begin
         `WARN_MSG(enable is 0);
      end

      err_x = (bkm_x != X);
      err_y = (bkm_y != Y);
      err_f = (bkm_flags != F);

      //$display("X = %h  Y = %h   F = %b", X, Y, F);
      //$display("x = %h  y = %h   f = %b", bkm_x, bkm_y, bkm_flags);
      //$display("err_x = %b err_y = %b  err_f = %b", err_x, err_y, err_f );

   //if ( bkm_done == 1'b1 ) begin
      if ( err_x || err_y || err_f ) begin
         if ( err_x ) begin
            `ERR_MSG2(X - Expected result: %h\n\t\t  Obtained result: %h\t, X, bkm_x);
            $display("");
         end
         if ( err_y ) begin
            `ERR_MSG2(Y - Expected result: %h\n\t\t  Obtained result: %h\t, Y, bkm_y);
            $display("");
         end
         if ( err_f ) begin
            `ERR_MSG2(F - Expected result: %h\n\t\t  Obtained result: %h\t, F, bkm_flags);
            $display("");
         end
      end
   //end

   end

// *****************************************************************************

endtask

