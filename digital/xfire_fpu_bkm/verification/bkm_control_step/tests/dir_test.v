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
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      // operands     mode     format            n             d_u_n    d_v_n     u_n      v_n
      //load_directed( `MODE_E, `FORMAT_REAL_W  , `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);
      //load_directed( `MODE_E, `FORMAT_REAL_DW , `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_W , `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);
      //load_directed( `MODE_L, `FORMAT_REAL_W  , `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);
      //load_directed( `MODE_L, `FORMAT_REAL_DW , `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_W , `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);

      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd001);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd002);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd003);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd004);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd005);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd014);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd000, `W/4'd015);

      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd001, `W/4'd000);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd001, `W/4'd001);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd001, `W/4'd002);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd001, `W/4'd003);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd001, `W/4'd004);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd001, `W/4'd005);
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   2'b00,   2'b00, `W/4'd001, `W/4'd014);


      // operands     mode     format            n             d_u_n    d_v_n     u_n      v_n
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd004, `W/4'd006);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd005, `W/4'd001);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd005, `W/4'd003);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd005, `W/4'd005);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd005, `W/4'd007);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd005, `W/4'd009);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd007, `W/4'd001);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd007, `W/4'd003);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd007, `W/4'd005);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd007, `W/4'd007);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   2'b01,   2'b00, `W/4'd007, `W/4'd009);

      //arst        = 1'b1;
      //run_clk(1);
      //run_clk(1);
      //arst        = 1'b0;
      //run_clk(1);

      // Test E mode for dw complex args
      //repeat(2**(2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd000,   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);
      //repeat(2**(2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd001,   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);
      //repeat(2**(2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd002,   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);
      //repeat(2**(2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd003,   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);
      //repeat(2**(2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd004,   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);
      //repeat(2**(2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd005,   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);
      //repeat(2**(2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd006,   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);
      //repeat(2**(2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd007,   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);

      //repeat(2**(`LOG2N+2+2+2*`W/4))
         //load_directed( `MODE_E, `FORMAT_CMPLX_DW, cnt[2*`W/4+4+`LOG2N-1:2*`W/4+4],   cnt[2*`W/4+3:2*`W/4+2],   cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);




      // Test L mode for dw complex args
      //repeat(2**(2+2+2*`W/4))
         // operands     mode     format            n             d_u_n                d_v_n             u_n      v_n
         //load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd001,   cnt[2*`W/4+3:2*`W/4+2],  cnt[2*`W/4+1:2*`W/4], cnt[2*`W/4-1:`W/4], cnt[`W/4-1:0]);
   end

// *****************************************************************************

endtask

