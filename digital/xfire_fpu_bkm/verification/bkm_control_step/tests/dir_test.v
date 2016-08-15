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
//    - 2016-08-15 - ilesser - Updated to use WD and WC.
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
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b01,  `WC'd00037,  `WC'd00036,  `WC'd00017,  `WC'd00020);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b10,  `WC'd00019,  `WC'd00051,  `WC'd00079,  `WC'd00024);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b11,  `WC'd00035,  `WC'd00016,  `WC'd00085,  `WC'd00062);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b00,  `WC'd00079,  `WC'd00018,  `WC'd00002,  `WC'd00069);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b00,   2'b11,  `WC'd00002,  `WC'd00016,  `WC'd00046,  `WC'd00012);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b11,   2'b00, -`WC'd32768,  `WC'd00016,  `WC'd00416,  `WC'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b00, -`WC'd32768,  `WC'd00016,  `WC'd00416,  `WC'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b11,   2'b00, -`WC'd32768,  `WC'd00016,  `WC'd00416,  `WC'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd003,   2'b11,   2'b00, -`WC'd32768,  `WC'd00016,  `WC'd00416,  `WC'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd008,   2'b11,   2'b00, -`WC'd32768,  `WC'd00016,  `WC'd00416,  `WC'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd012,   2'b11,   2'b00, -`WC'd32768,  `WC'd00016,  `WC'd00416,  `WC'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd015,   2'b11,   2'b00, -`WC'd32768,  `WC'd00016,  `WC'd00416,  `WC'd00312);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `WC'd00005,  `WC'd00009,  `WC'd00000,  `WC'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `WC'd00007,  `WC'd00001,  `WC'd00000,  `WC'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `WC'd00007,  `WC'd00003,  `WC'd00000,  `WC'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `WC'd00007,  `WC'd00005,  `WC'd00000,  `WC'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `WC'd00007,  `WC'd00007,  `WC'd00000,  `WC'd00000);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00,  `WC'd00007,  `WC'd00009,  `WC'd00000,  `WC'd00000);

      // To reproduce BUG11
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b01, -`WC'd32768, -`WC'd32768,  `WC'd01070,  `WC'd00310);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b11, -`WC'd32768, -`WC'd32768,  `WC'd01070,  `WC'd00310);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b01, -`WC'd32768, -`WC'd32768,  `WC'd01070,  `WC'd00310);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b11,   2'b11, -`WC'd32768, -`WC'd32768,  `WC'd01070,  `WC'd00310);

      // operands     mode     format            n             d_u_n    d_v_n    u_n       v_n       lut_u_n   lut_v_n
      cnt_load    = {`MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b00,   2'b00, `WC'h0000, `WC'h0000, `WC'h0000, `WC'h0000};
      cnt_step    = {   1'b0,         2'b00   , `LOG2N'd000,   2'b00,   2'b00, `WC'h0000, `WC'h0011, `WC'h0000, `WC'h0000};

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
         repeat(2**`WC)
            load_operands(cnt);
         repeat(2**`WC)
            load_operands(cnt);
         repeat(2**`WC)
            load_operands(cnt);
         repeat(2**`WC)
            load_operands(cnt);
      end

   end

// *****************************************************************************

endtask

