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
   input [`W-1:0]     X_n;
   input [`W-1:0]     Y_n;
   input [`W-1:0]     u_n;
   input [`W-1:0]     v_n;
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

      dir_cnt[`CNT_SIZE-1]             = mode;
      dir_cnt[`CNT_SIZE-2:`CNT_SIZE-3] = format;
      dir_cnt[2*`W+4+`LOG2N-1:2*`W+4]  = n;
      dir_cnt[2*`W+3:2*`W+2]           = d_x_n;
      dir_cnt[2*`W+1:2*`W+0]           = d_y_n;
      dir_cnt[2*`W-1:1*`W]             = X_n;
      dir_cnt[1*`W-1:0*`W]             = Y_n;
      //dir_cnt[2*`W-1:1*`W]             = u_n;
      //dir_cnt[1*`W-1:0*`W]             = v_n;

      load_operands(dir_cnt);

   end

// *****************************************************************************

endtask

