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
//    - 2016-09-14 - ilesser - Updated to use real number model.
//    - 2016-08-22 - ilesser - Added guard bits.
//    - 2016-08-11 - ilesser - Updated for WD and WC.
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
   reg   [1:0]        rand_d_x_n;
   reg   [1:0]        rand_d_y_n;
   real               rand_X_n;
   real               rand_Y_n;
   real               rand_u_n;
   real               rand_v_n;
   real               rand_lut_X_n;
   real               rand_lut_Y_n;
   real               rand_lut_u_n;
   real               rand_lut_v_n;
   reg   [30:0]       cnt1, cnt2;
   // -----------------------------------------------------

   begin

      ena         = 1'b0;
      arst        = 1'b0;
      srst        = 1'b0;
      load        = 1'b0;
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

      repeat(2**14) begin

         rand_mode      = constrained_rand_int(0, 1);
         rand_format    = constrained_rand_int(0, 3);
         rand_n         = constrained_rand_int(0, 2**`LOG2N);
         rand_d_x_n     = constrained_rand_int(0, 3);
         rand_d_y_n     = constrained_rand_int(0, 3);


         // Limit the input range to [-2; 2]
         //rand_X_n       = constrained_rand_real( -2.0,  2.0);
         //rand_Y_n       = constrained_rand_real( -2.0,  2.0);
         //rand_lut_X_n   = constrained_rand_real( -2.0,  2.0);
         //rand_lut_Y_n   = constrained_rand_real( -2.0,  2.0);
         //rand_u_n       = constrained_rand_real( -2.0,  2.0);
         //rand_v_n       = constrained_rand_real( -2.0,  2.0);
         //rand_lut_u_n   = constrained_rand_real( -2.0,  2.0);
         //rand_lut_v_n   = constrained_rand_real( -2.0,  2.0);

         // Limit the input range so that it uses only WI integer bits
         rand_X_n       = constrained_rand_real(-1*(2.0**(`WI-1)), 2.0**(`WI-1)-1.0);
         rand_Y_n       = constrained_rand_real(-1*(2.0**(`WI-1)), 2.0**(`WI-1)-1.0);
         rand_lut_X_n   = constrained_rand_real(-1*(2.0**(`WI-1)), 2.0**(`WI-1)-1.0);
         rand_lut_Y_n   = constrained_rand_real(-1*(2.0**(`WI-1)), 2.0**(`WI-1)-1.0);
         // Limit the input range so that it uses only WI integer bits
         rand_u_n       = constrained_rand_real(-1*(2.0**(`WI-1)), 2.0**(`WI-1)-1.0);
         rand_v_n       = constrained_rand_real(-1*(2.0**(`WI-1)), 2.0**(`WI-1)-1.0);
         rand_lut_u_n   = constrained_rand_real(-1*(2.0**(`WI-1)), 2.0**(`WI-1)-1.0);
         rand_lut_v_n   = constrained_rand_real(-1*(2.0**(`WI-1)), 2.0**(`WI-1)-1.0);

         rand_mode      = `MODE_E;
         rand_format    = `FORMAT_CMPLX_DW;
         //rand_n         = 4;
         //rand_n         = constrained_rand_int(4,15);
         //rand_d_x_n     = 2'b00;
         //rand_d_y_n     = 2'b00;
         //rand_X_n       = constrained_rand_int(-300, 300);
         //rand_Y_n       = constrained_rand_int(-300, 300);
         //rand_lut_X_n   = constrained_rand_int(-300, 300);
         //rand_lut_Y_n   = constrained_rand_int(-300, 300);
         //rand_u_n       = constrained_rand_int(-300, 300);
         //rand_v_n       = constrained_rand_int(-300, 300);
         //rand_lut_u_n   = constrained_rand_int(-300, 300);
         //rand_lut_v_n   = constrained_rand_int(-300, 300);

         load_directed  (
                           rand_mode,
                           rand_format,
                           rand_n,
                           rand_d_x_n,    rand_d_y_n,
                           rand_X_n,      rand_Y_n,
                           rand_u_n,      rand_v_n,
                           rand_lut_X_n,  rand_lut_Y_n,
                           rand_lut_u_n,  rand_lut_v_n
                        );

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


// Summary
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  date  |  mode  |  format   |  n  |  d_x   |  d_y   |  X_n   |  Y_n   |  res_X |  res_Y |  res_u |  res_v |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   E    |  CMPLX_DW |  0  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   E    |  CMPLX_DW |  1  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   E    |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |  rand  |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  FAIL  |  FAIL  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   L    |  CMPLX_DW |  0  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   L    |  CMPLX_DW |  1  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   L    |  CMPLX_DW |  2  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   L    |  CMPLX_DW |  3  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  FAIL  |  FAIL  | 5 veces en u y 3 en v
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   L    |  CMPLX_DW |  4  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  FAIL  |  FAIL  | -8 <= delta_u/v <= 0
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/11 |   L    |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  FAIL  |  FAIL  | -8 <= delta_u/v <= 0
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
// |  08/12 |  rand  |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  FAIL  |  FAIL  | Found the problem behind BUG7 and found BUG11 ( 4 errors on 2^16 runs).
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+--------+--------+
