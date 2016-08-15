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
      //load_directed( `MODE_E, `FORMAT_REAL_DW,  `LOG2N'd0,  `W'd0,   `W'd0,   `W'd0,   `W'd0,   `W'd0,   `W'd0,   `W'd0,   `W'd0);

      // operands     mode     format            n             d_x_n    d_y_n     X_n      Y_n      u_n      v_n
      //load_directed( `MODE_E, `FORMAT_REAL_W  , `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_REAL_DW , `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_W , `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_REAL_W  , `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_REAL_DW , `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_W , `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);

      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd001, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd002, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd003, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd004, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd005, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd014, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd015, `W'd000, `W'd000);

      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd001, `W'd000, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd001, `W'd001, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd001, `W'd002, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd001, `W'd003, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd001, `W'd004, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd001, `W'd005, `W'd000, `W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W'd001, `W'd014, `W'd000, `W'd000);


      // operands     mode     format            n             d_x_n    d_y_n     X_n      Y_n      u_n      v_n
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd004, `W'd006, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd005, `W'd001, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd005, `W'd003, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd005, `W'd005, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd005, `W'd007, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd005, `W'd009, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd001, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd003, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd005, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd007, `W'd000, `W'd000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd009, `W'd000, `W'd000);

      //arst        = 1'b1;
      //run_clk(1);
      //run_clk(1);
      //arst        = 1'b0;
      //run_clk(1);

      // Test E mode for dw complex args
      //repeat(2**(2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);
      //repeat(2**(2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);
      //repeat(2**(2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd002,   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);
      //repeat(2**(2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd003,   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);
      //repeat(2**(2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd004,   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);
      //repeat(2**(2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd005,   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);
      //repeat(2**(2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd006,   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);
      //repeat(2**(2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd007,   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);

      //repeat(2**(`LOG2N+2+2+2*`W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, cnt[2*`W+4+`LOG2N-1:2*`W+4],   cnt[2*`W+3:2*`W+2],   cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);




      // Test L mode for dw complex args
      //repeat(2**(2+2+2*`W))
         // operands     mode     format            n             d_x_n                d_y_n             X_n             Y_n           u_n      v_n
         //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   cnt[2*`W+3:2*`W+2],  cnt[2*`W+1:2*`W], cnt[2*`W-1:`W], cnt[`W-1:0], `W'd000, `W'd000);
   end

// *****************************************************************************

endtask

