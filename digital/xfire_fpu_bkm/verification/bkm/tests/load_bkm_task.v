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
   input [`FSIZE-1:0]   flags;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

   #10;
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
   end
   else  begin
      $display("enable is 0");
   end

   #10;

   end

// *****************************************************************************

endtask

