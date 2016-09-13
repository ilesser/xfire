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
// Directed test for lut_decoder block.
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
//    - 2016-09-01 - ilesser - Initial version.
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

      // operands     mode     format            n           d_y_n  d_x_n
      cnt_load =   { `MODE_E, `FORMAT_CMPLX_W , `LOG2N'd000, 2'b00, 2'b00 };
      cnt_step =   {  1'b0  ,    2'b00        , `LOG2N'd001, 2'b00, 2'b00 };

      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      ena         = 1'b1;

      repeat(2**`M_SIZE) begin
         repeat(2**(2*`D_SIZE)) begin
            // Load the counter
            arst = 1'b1;
            run_clk(1);
            arst = 1'b0;
            load = 1'b1;
            run_clk(1);
            load = 1'b0;

            // Increase just the n variable
            repeat(2**(`LOG2N)) begin
               load_operands(cnt);
            end

            // Increase just the d_n variable
            cnt_load = cnt_load + 1;
         end
         // Change the mode
         cnt_load = cnt_load + {1'b1, {`CNT_SIZE-1{1'b0}}};
      end

   end

// *****************************************************************************

endtask

