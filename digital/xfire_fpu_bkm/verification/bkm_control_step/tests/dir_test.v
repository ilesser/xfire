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


      // operands     mode     format            n             d_u_n    d_v_n     u_n         v_n         lut_u_n     lut_v_n
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b01,  `W'd00037,  `W'd00036,  `W'd00017,  `W'd00020);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b10,  `W'd00019,  `W'd00051,  `W'd00079,  `W'd00024);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b11,  `W'd00035,  `W'd00016,  `W'd00085,  `W'd00062);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b00,  `W'd00079,  `W'd00018,  `W'd00002,  `W'd00069);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b00,   2'b11,  `W'd00002,  `W'd00016,  `W'd00046,  `W'd00012);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b11,   2'b00, -`W'd32768,  `W'd00016,  `W'd00416,  `W'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b00, -`W'd32768,  `W'd00016,  `W'd00416,  `W'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b00, -`W'd32768,  `W'd00016,  `W'd00416,  `W'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd003,   2'b11,   2'b00, -`W'd32768,  `W'd00016,  `W'd00416,  `W'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd008,   2'b11,   2'b00, -`W'd32768,  `W'd00016,  `W'd00416,  `W'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd012,   2'b11,   2'b00, -`W'd32768,  `W'd00016,  `W'd00416,  `W'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd015,   2'b11,   2'b00, -`W'd32768,  `W'd00016,  `W'd00416,  `W'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `W'd00005,  `W'd00009,  `W'd00000,  `W'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `W'd00007,  `W'd00001,  `W'd00000,  `W'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `W'd00007,  `W'd00003,  `W'd00000,  `W'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `W'd00007,  `W'd00005,  `W'd00000,  `W'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `W'd00007,  `W'd00007,  `W'd00000,  `W'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `W'd00007,  `W'd00009,  `W'd00000,  `W'd00000);

      // To reproduce BUG11
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b01, -`W'd32768, -`W'd32768,  `W'd01070,  `W'd00310);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b11, -`W'd32768, -`W'd32768,  `W'd01070,  `W'd00310);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b01, -`W'd32768, -`W'd32768,  `W'd01070,  `W'd00310);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b11, -`W'd32768, -`W'd32768,  `W'd01070,  `W'd00310);

      // operands     mode     format            n             d_u_n    d_v_n    u_n       v_n       lut_u_n   lut_v_n
      cnt_load    = {`MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b00,   2'b00, `W'h0000, `W'h0000, `W'h0000, `W'h0000};
      cnt_step    = {   1'b0,         2'b00   , `LOG2N'd000,   2'b00,   2'b00, `W'h0000, `W'h0011, `W'h0000, `W'h0000};

      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;
      load        = 1'b1;
      run_clk(1);
      load        = 1'b0;

      repeat(2**4) begin
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

