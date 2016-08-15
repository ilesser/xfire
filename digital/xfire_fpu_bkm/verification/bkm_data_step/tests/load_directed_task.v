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
//    - 2016-08-15 - ilesser - Updated to use WD and WC.
//    - 2016-08-03 - ilesser - Copied from bkm_control_step test.
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
   input [`WD-1:0]     X_n;
   input [`WD-1:0]     Y_n;
   input [`WD-1:0]     lut_X_n;
   input [`WD-1:0]     lut_Y_n;
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

      dir_cnt[`CNT_SIZE-1]                = mode;
      dir_cnt[`CNT_SIZE-2:`CNT_SIZE-3]    = format;
      dir_cnt[4*`WD+4+`LOG2N-1:4*`WD+4]   = n;
      dir_cnt[4*`WD+3         :4*`WD+2]   = d_x_n;
      dir_cnt[4*`WD+1         :4*`WD+0]   = d_y_n;
      dir_cnt[4*`WD-1         :3*`WD]     = X_n;
      dir_cnt[3*`WD-1         :2*`WD]     = Y_n;
      dir_cnt[2*`WD-1         :1*`WD]     = lut_X_n;
      dir_cnt[1*`WD-1         :0*`WD]     = lut_Y_n;

      load_operands(dir_cnt);

   end

// *****************************************************************************

endtask

