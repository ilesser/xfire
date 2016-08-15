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

      // operands     mode     format            n           d_x_n  d_y_n      X_n         Y_n         u_n         v_n         lut_X_n     lut_Y_n     lut_u_n     lut_v_n
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `LOG2N'd002, 2'b11, 2'b01, `WD'd00037, `WD'd00036, `WC'd00007, `WC'd00006, `WD'd00017, `WD'd00020, `WC'd00007, `WC'd00005);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002, 2'b11, 2'b01, `WD'd00033, `WD'd00039, `WC'd00001, `WC'd00008, `WD'd00007, `WD'd00020, `WC'd00007, `WC'd00003);

      // operands     mode     format            n           d_x_n  d_y_n      X_n         Y_n         u_n         v_n         lut_X_n     lut_Y_n     lut_u_n     lut_v_n
      cnt_load =   { `MODE_E, `FORMAT_CMPLX_W , `LOG2N'd003, 2'b10, 2'b11, `WD'd00008, `WD'd00004, `WC'd00002, `WC'd00001, `WD'd00008, `WD'd00004, `WC'd00002, `WC'd00001};
      cnt_step =   {  1'b0  ,    2'b00        , `LOG2N'd000, 2'b00, 2'b00, `WD'd00000, `WD'd00000, `WC'd00000, `WC'd00000, `WD'd00001, `WD'd00001, `WC'd00001, `WC'd00001};
      //cnt_step =   {  1'b0  ,    2'b00        , `LOG2N'd000, 2'b00, 2'b00, `WD'h00000, `WD'h00000, `WC'h00000, `WC'h00000, `WD'h00000, `WD'h00000, `WC'h00000, `WC'h00001};

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
               repeat(2**`WC)
                  load_operands(cnt);
      end
   end

// *****************************************************************************

endtask

