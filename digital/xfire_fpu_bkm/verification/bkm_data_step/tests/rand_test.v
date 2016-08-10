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
// Random test for bkm_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// rand_test.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-03 - ilesser - Copied from bkm_control_step rand test.
//    - 2016-07-06 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task rand_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   reg                rand_mode;
   reg   [1:0]        rand_format;
   reg   [`LOG2N-1:0] rand_n;
   reg   [1:0]        rand_d_x_n,   rand_d_y_n;
   reg   [`W-1:0]     rand_X_n,     rand_Y_n;
   reg   [`W-1:0]     rand_lut_X_n, rand_lut_Y_n;
   reg   [30:0]       cnt1, cnt2;
   // -----------------------------------------------------

   begin

      ena         = 1'b0;
      arst        = 1'b0;
      srst        = 1'b0;
      cnt_load    = {`CNT_SIZE{1'b0}};
      cnt_step    = {`CNT_SIZE{1'b0}};
      run_clk(1);
      arst        = 1'b1;
      srst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      srst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      repeat(2**12) begin

         rand_mode      = constrained_rand_int(0, 2**`M_SIZE-1);
         rand_format    = constrained_rand_int(0, 2**`F_SIZE-1);
         rand_n         = constrained_rand_int(0, 2**`LOG2N-1);
         rand_d_x_n     = constrained_rand_int(0, 2**`D_SIZE-1);
         rand_d_y_n     = constrained_rand_int(0, 2**`D_SIZE-1);
         rand_X_n       = constrained_rand_int(0, 2**(`W)-1);
         rand_Y_n       = constrained_rand_int(0, 2**(`W)-1);
         rand_lut_X_n   = constrained_rand_int(0, 2**(`W)-1);
         rand_lut_Y_n   = constrained_rand_int(0, 2**(`W)-1);

         //rand_mode      = `MODE_E;
         rand_format    = `FORMAT_CMPLX_DW;
         //rand_n         = 2;
         //rand_n         = constrained_rand_int(0, (2**1)-1);
         //rand_d_x_n     = 2'b01;
         //rand_d_y_n     = 2'b00;
         //rand_X_n       = constrained_rand_int(0, 100);
         //rand_Y_n       = constrained_rand_int(0, 100);
         //rand_lut_X_n   = constrained_rand_int(0, 100);
         //rand_lut_Y_n   = constrained_rand_int(0, 100);

         load_directed( rand_mode, rand_format,  rand_n, rand_d_x_n,   rand_d_y_n,   rand_X_n,  rand_Y_n,  rand_lut_X_n,  rand_lut_Y_n);

      end

      //repeat(2**(`CNT_SIZE))
      //repeat(2**14) begin
      //   cnt1 = constrained_rand_int(0, 2**31);
      //   cnt2 = constrained_rand_int(0, 2**31);
      //   load_operands({cnt1, cnt1^cnt2});
      //end

   end

// *****************************************************************************

endtask


// Summary L mode: PASS (10/08)
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  date  |  mode  |  format   |  n  |  d_x   |  d_y   |  X_n   |  Y_n   |  lut_X |  lut_Y |  res_X |  res_Y |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/10 |   L    |  CMPLX_DW |  0  |  rand  |  rand  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/10 |   L    |  CMPLX_DW |  1  |  rand  |  rand  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/10 |   L    |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  | after fixing BUG3
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+

// Summary E mode: PASS (10/8)
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  date  |  mode  |  format   |  n  |  d_x   |  d_y   |  X_n   |  Y_n   |  lut_X |  lut_Y |  res_X |  res_Y |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/10 |   E    |  CMPLX_DW |  0  |  rand  |  rand  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/10 |   E    |  CMPLX_DW |  1  |  rand  |  rand  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/10 |   E    |  CMPLX_DW |  2  |  rand  |  rand  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/10 |   E    |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  | after fixing BUG3
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/10 |  rand  |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  | run for 2**20 iterations
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
