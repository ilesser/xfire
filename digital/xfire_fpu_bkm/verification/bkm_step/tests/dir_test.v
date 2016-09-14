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
//    - 2016-09-13 - ilesser - Implemented real number model.
//    - 2016-08-15 - ilesser - Put control path values in range.
//    - 2016-08-11 - ilesser - Updated for WD and WC.
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
      load        = 1'b0;
      cnt_load    = {`CNT_SIZE{1'b0}};
      cnt_step    = {{`CNT_SIZE-1{1'b0}},1'b1};
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      // operands     mode     format            n           d_x_n  d_y_n  X_n      Y_n      u_n      v_n      lut_X_n  lut_Y_n  lut_u_n  lut_v_n
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd002, 2'b11, 2'b01, 1.000,   0.000,   1.000,   0.000,   0.500,   0.000,   1.000,   0.000);
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd002, 2'b11, 2'b01, 1.037,   1.036,   0.007,   0.006,   0.017,   0.020,   1.070,   1.050);

      // operands     mode     format            n           d_x_n  d_y_n      X_n                    Y_n         u_n         v_n            lut_X_n     lut_Y_n     lut_u_n     lut_v_n
      cnt_load =   { `MODE_E, `FORMAT_CMPLX_W , `LOG2N'd003, 2'b01, 2'b00,  72'hFFF800000000000000,  72'h00000,  22'hFFFE00,  22'h000000,  72'd00000,  72'd00000,  22'hFFFE00, 22'h000000};
      cnt_step =   {  1'b0  ,    2'b00        , `LOG2N'd000, 2'b00, 2'b00,  72'h000004000000000000,  72'h00000,  22'h000001,  22'h000000,  72'd00011,  72'd00000,  22'h000001, 22'h000000};
      //                                                                       -1 + 2^-9 * repeats             -2+2^-8*repeat 



      // operands     mode     format            n           d_x_n  d_y_n      X_n         Y_n         u_n         v_n         lut_X_n     lut_Y_n     lut_u_n     lut_v_n
      //cnt_load =   { `MODE_E, `FORMAT_CMPLX_W , `LOG2N'd003, 2'b10, 2'b11, `WD'd00008, `WD'd00004, `WC'd00002, `WC'd00001, `WD'd00008, `WD'd00004, `WC'd00002, `WC'd00001};
      //cnt_step =   {  1'b0  ,    2'b00        , `LOG2N'd000, 2'b00, 2'b00, `WD'd00000, `WD'd00000, `WC'd00000, `WC'd00000, `WD'd00001, `WD'd00001, `WC'd00001, `WC'd00001};

      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      load        = 1'b1;
      run_clk(1);
      load        = 1'b0;

      repeat(2**00) begin
         //repeat(2**`WD)
            //repeat(2**`WC)
               //repeat(2**`WC)
               repeat(2**10)
                  load_operands(cnt);
      end
   end

// *****************************************************************************

endtask

