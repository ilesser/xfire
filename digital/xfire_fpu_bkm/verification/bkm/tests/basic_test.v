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
// Basic test for bkm block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// basic_test.v
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
task basic_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      $monitor("Time = %8t x = %h y = %h flags = %b done = %b\n",$time, x, y, flags, done);
      $dumpfile("../waves/tb_bkm_basic_test.vcd");
      $dumpvars();

      tb_stop    = 1'b0;
      tb_enable  = 1'b1;
      tb_arst    = 1'b0;
      tb_srst    = 1'b0;
      tb_start   = 1'b0;
      tb_start   = 1'b0;
      #1;
      run_clk(5);
      tb_arst    = 1'b1;
      run_clk(2);
      tb_arst    = 1'b0;

      //          mode     format            E_x         E_y         L_x         L_y         X_out       Y_out       flags
      load_bkm( `MODE_E, `FORMAT_REAL_32, {W,{1'b0}}, {W,{1'b0}}, {W,{1'b0}}, {W,{1'b0}}, {W,{1'b0}}, {W,{1'b0}}, {`FSIZE,{1'b0}} );

      tb_stop = 1'b1;
   end

// *****************************************************************************

endtask

