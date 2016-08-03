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
// Directed test for bkm_control_step block.
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
//    - 2016-08-02 - ilesser - Changed the definition of W.
//    - 2016-07-23 - ilesser - Initial version.
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
      load        = 1'b0;
      cnt_step    = 1;
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      // operands     mode     format            n             d_u_n    d_v_n     u_n      v_n
      //load_directed( `MODE_E, `FORMAT_REAL_W  , `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);
      //load_directed( `MODE_E, `FORMAT_REAL_DW , `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_W , `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);
      //load_directed( `MODE_L, `FORMAT_REAL_W  , `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);
      //load_directed( `MODE_L, `FORMAT_REAL_DW , `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_W , `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);

      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd001);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd002);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd003);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd004);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd005);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd014);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd000, ``W'd015);

      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd001, ``W'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd001, ``W'd001);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd001, ``W'd002);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd001, ``W'd003);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd001, ``W'd004);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd001, ``W'd005);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, ``W'd001, ``W'd014);


      // operands     mode     format            n             d_u_n    d_v_n     u_n      v_n        lut_u_n    lut_v_n
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b01, `W'd037, `W'd036, `W'd017, `W'd020);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b10, `W'd019, `W'd051, `W'd079, `W'd024);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b11, `W'd035, `W'd016, `W'd085, `W'd062);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b00, `W'd079, `W'd018, `W'd002, `W'd069);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b00,   2'b11, `W'd002, `W'd016, `W'd046, `W'd012);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd005, `W'd009, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd001, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd003, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd005, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd007, `W'd000, `W'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W'd007, `W'd009, `W'd000, `W'd000);

      //arst        = 1'b1;
      //run_clk(1);
      //run_clk(1);
      //arst        = 1'b0;
      //run_clk(1);

      // Test E mode for dw complex args
      //repeat(2**(2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);
      //repeat(2**(2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);
      //repeat(2**(2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd002,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);
      //repeat(2**(2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd003,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);
      //repeat(2**(2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd004,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);
      //repeat(2**(2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd005,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);
      //repeat(2**(2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd006,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);
      //repeat(2**(2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd007,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);

      //repeat(2**(`LOG2N+2+2+2*``W))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, cnt[4*``W+4+`LOG2N-1:4*``W+4],   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);




      // Test L mode for dw complex args
      //repeat(2**(2+2+2*``W))
         // operands     mode     format            n             d_u_n                d_v_n             u_n      v_n
         //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   cnt[4*``W+3:4*``W+2],  cnt[4*``W+1:4*``W], cnt[4*``W-1:3*``W+0], cnt[3*``W-1:2*``W+0], cnt[2*``W-1:``W], cnt[``W-1:0]);

      // operands     mode     format            n             d_u_n    d_v_n    u_n       v_n       lut_u_n   lut_v_n
      cnt_load    = {`MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b00,   2'b00, `W'h0037, `W'h0036, `W'h0017, `W'h0020};
      cnt_step    = {   1'b0,         2'b00   , `LOG2N'd000,   2'b00,   2'b00, `W'h0011, `W'h0731, `W'h0000, `W'h0000};

      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;
      load        = 1'b1;
      run_clk(1);
      load        = 1'b0;

      repeat(2**1) begin
         repeat(2**`W)
            load_operands(cnt);
         repeat(2**`W)
            load_operands(cnt);
         repeat(2**`W)
            load_operands(cnt);
         repeat(2**`W)
            load_operands(cnt);
      end

   end

// *****************************************************************************

endtask

