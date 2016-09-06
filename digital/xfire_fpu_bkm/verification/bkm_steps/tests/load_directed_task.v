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
// Load directed operands task for bkm_steps block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// load_directed_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-05 - ilesser - Defined structure for directed loading.
//    - 2016-08-15 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task load_directed;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input              mode;
   input [1:0]        format;
   input real         X_in;
   input real         Y_in;
   input real         u_in;
   input real         v_in;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   reg   [`CNT_SIZE-1:0] dir_cnt;
   // -----------------------------------------------------

   begin

      tb_mode     = mode;
      tb_format   = format;
      tb_X_in     = X_in;
      tb_Y_in     = Y_in;
      tb_u_in     = u_in;
      tb_v_in     = v_in;

      // Calculate the result of N steps
      bkm_steps(
         // ----------------------------------
         // Data inputs
         // ----------------------------------
         tb_mode,
         tb_format,
         tb_X_in,
         tb_Y_in,
         tb_u_in,
         tb_v_in,
         // ----------------------------------
         // Data outputs
         // ----------------------------------
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

