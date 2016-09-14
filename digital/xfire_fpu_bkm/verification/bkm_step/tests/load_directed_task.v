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
// Load directed operands task for bkm_step block.
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
//    - 2016-09-14 - ilesser - Updated to use real number model.
//    - 2016-08-11 - ilesser - Updated for WD and WC.
//    - 2016-07-13 - ilesser - Initial version.
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
   input [`LOG2N-1:0] n;
   input [1:0]        d_x_n;
   input [1:0]        d_y_n;
   input real         X_n;
   input real         Y_n;
   input real         u_n;
   input real         v_n;
   input real         lut_X_n;
   input real         lut_Y_n;
   input real         lut_u_n;
   input real         lut_v_n;
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

      // Apply values to testbench
      tb_mode     = mode   ;
      tb_format   = format ;
      tb_n        = n      ;
      tb_d_x_n    = d_x_n  ;
      tb_d_y_n    = d_y_n  ;
      tb_X_n      = X_n    ;
      tb_Y_n      = Y_n    ;
      tb_u_n      = u_n    ;
      tb_v_n      = v_n    ;
      tb_lut_X_n  = lut_X_n;
      tb_lut_Y_n  = lut_Y_n;
      tb_lut_u_n  = lut_u_n;
      tb_lut_v_n  = lut_v_n;

      // Calculate the results
      bkm_step (
         // ----------------------------------
         // Data inputs
         // ----------------------------------
         tb_mode,
         tb_format,
         tb_n,
         tb_d_x_n,   tb_d_y_n,
         tb_X_n,     tb_Y_n,
         tb_u_n,     tb_v_n,
         tb_lut_X_n, tb_lut_Y_n,
         tb_lut_u_n, tb_lut_v_n,
         // ----------------------------------
         // Data outputs
         // ----------------------------------
         tb_X_np1,   tb_Y_np1,
         tb_u_np1,   tb_v_np1
      );

      run_clk(1);

   end

// *****************************************************************************

endtask

