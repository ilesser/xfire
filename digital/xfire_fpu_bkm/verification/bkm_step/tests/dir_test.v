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
// Directed test for bkm_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// dir_test.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-06 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task dir_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      ena         = 1'b0;
      arst        = 1'b0;
      srst        = 1'b0;
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      // operands     mode     format            n           X_n      Y_n      u_n      v_n      X_np1    Y_np1    u_np1    v_np1
      //load_directed( `MODE_E, `FORMAT_REAL_64,  `LOG2N'd0,  `W'd0,   `W'd0,   `W'd0,   `W'd0,   `W'd0,   `W'd0,   `W'd0,   `W'd0);

      // operands     mode     format            n             d_n       X_n      Y_n      u_n      v_n
      load_directed( `MODE_L, `FORMAT_CMPLX_64, `LOG2N'd000,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_REAL_32,  `LOG2N'd000,   2'b00,   `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_REAL_64,  `LOG2N'd000,   2'b00,   `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_32, `LOG2N'd000,   2'b00,   `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_64, `LOG2N'd000,   2'b00,   `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_REAL_32,  `LOG2N'd000,   2'b00,   `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_REAL_64,  `LOG2N'd000,   2'b00,   `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_32, `LOG2N'd000,   2'b00,   `W'd000, `W'd000, `W'd000, `W'd000);
   end

// *****************************************************************************

endtask

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
   input [1:0]        d_n;
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
      dir_cnt[4*`W+2+`LOG2N-1:4*`W+2]  = n;
      dir_cnt[4*`W+1:4*`W]             = d_n;
      dir_cnt[4*`W-1:3*`W]             = X_n;
      dir_cnt[3*`W-1:2*`W]             = Y_n;
      dir_cnt[2*`W-1:1*`W]             = u_n;
      dir_cnt[1*`W-1:0*`W]             = v_n;

      load_operands(dir_cnt);

   end

// *****************************************************************************

endtask

