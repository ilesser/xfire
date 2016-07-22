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
// Random test for bkm_control_step block.
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
//    - 2016-07-23 - ilesser - Initial version.
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
   reg   [1:0]        rand_d_u_n;
   reg   [1:0]        rand_d_v_n;
   reg   [`W/4-1:0]   rand_u_n;
   reg   [`W/4-1:0]   rand_v_n;
   reg   [30:0]       cnt1, cnt2;
   // -----------------------------------------------------

   begin

      ena         = 1'b0;
      arst        = 1'b0;
      srst        = 1'b0;
      run_clk(1);
      arst        = 1'b1;
      srst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      srst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      repeat(2**7) begin

         rand_mode   = constrained_rand_int(0, 1);
         rand_format = constrained_rand_int(0, 3);
         rand_n      = constrained_rand_int(0, 2**`LOG2N);
         rand_d_u_n  = constrained_rand_int(0, 3);
         rand_d_v_n  = constrained_rand_int(0, 3);
         rand_u_n    = constrained_rand_int(0, 2**(`W/4));
         rand_v_n    = constrained_rand_int(0, 2**(`W/4));

         rand_mode   = `MODE_L;
         rand_format = `FORMAT_CMPLX_DW;
         rand_n      = 1;
         rand_d_u_n  = 2'b00;
         rand_d_v_n  = 2'b01;
         rand_u_n    = constrained_rand_int(0, 100);
         rand_v_n    = constrained_rand_int(0, 100);

         load_directed( rand_mode, rand_format,  rand_n, rand_d_u_n,   rand_d_v_n,   rand_u_n,  rand_v_n);

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
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  date  |  mode  |  format   |  n  |  d_x   |  d_y   |  X_n   |  Y_n   |  res_u |  res_v |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/23 |   E    |  CMPLX_DW |  0  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/23 |   E    |  CMPLX_DW |  1  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/23 |   E    |  CMPLX_DW |  2  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/23 |   E    |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |  con 2^16 repeticiones
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/18 |   L    |  CMPLX_DW |  0  |  rand  |  rand  |  rand  |  rand  |  FAIL  |  FAIL  |  u and v fail when d_x = d_y = 2'b11-- > FIXED: there was a problem with the w_n + d_n part
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/23 |   L    |  CMPLX_DW |  0  |  rand  |  rand  |  rand  |  rand  |  PASS  |  PASS  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/23 |   L    |  CMPLX_DW |  1  |  rand  |  rand  |  rand  |  rand  |  FAIL  |  FAIL  | aca parece fallar xq el modelo no trunca al dividir por dos, siempre el delta del error es 1
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/xx |   L    |  CMPLX_DW |  2  |  rand  |  rand  |  rand  |  rand  |  FAIL  |  FAIL  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/xx |   L    |  CMPLX_DW | rnd |  rand  |  rand  |  rand  |  rand  |  FAIL  |  FAIL  |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+
// |  07/00 |        |           |     |        |        |        |        |        |        |
// +--------+--------+-----------+-----+--------+--------+--------+--------+--------+--------+