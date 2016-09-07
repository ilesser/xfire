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
// Directed test for bkm_steps block.
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
//    - 2016-09-05 - ilesser - Added some initial test values.
//    - 2016-08-15 - ilesser - Initial version.
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
   real  X_r, X_res, X_f;
   reg   [`WI-1:0]   X_int;
   reg   [`WFD-1:0]  X_frac;
   reg   [`WD-1:0]   X;
   // -----------------------------------------------------

   begin

      ena         = 1'b0;
      arst        = 1'b0;
      srst        = 1'b0;
      load        = 1'b0;
      cnt_load    = {`CNT_SIZE{1'b0}};
      cnt_step    = {{`CNT_SIZE-1{1'b0}},1'b1};
      tb_mode     = `MODE_E;
      tb_format   = `FORMAT_CMPLX_DW;
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;
      tb_start    = 1'b0;
      run_clk(1);

      // operands     mode     format               X_in        Y_in        u_in        v_in
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,  1023.00000,  1023.00000,  1023.0000,  1023.0000);
      //load_directed( `MODE_L, `FORMAT_CMPLX_DW, -1023.00000, -1023.00000, -1023.0000, -1023.0000);

      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.0000,     0.0000);  // 1.0 * exp(0.0)   1.00000000000000
      load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.1000*2,   0.0000);  // 1.0 * exp(0.1)   1.10517091807565
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.2000*2,   0.0000);  // 1.0 * exp(0.2)   1.22140275816017
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.3000*2,   0.0000);  // 1.0 * exp(0.3)   1.34985880757600
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.4000*2,   0.0000);  // 1.0 * exp(0.4)   1.49182469764127
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.5000*2,   0.0000);  // 1.0 * exp(0.5)   1.64872127070013
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.6000*2,   0.0000);  // 1.0 * exp(0.6)   1.82211880039051
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.7000*2,   0.0000);  // 1.0 * exp(0.7)   2.01375270747048
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.8000*2,   0.0000);  // 1.0 * exp(0.8)   2.22554092849247
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     0.9000*2,   0.0000);  // 1.0 * exp(0.9)   2.45960311115695
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     0.00000,     1.0000*2,   0.0000);  // 1.0 * exp(1.0)   2.71828182845905

      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.0000,     0.0000*2);  // 1.0 * exp(0.0)   1.00000000000000
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.1000*2,   0.1000*2);  // 1.0 * exp(0.1)   1.10517091807565
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.2000*2,   0.1000*2);  // 1.0 * exp(0.2)   1.22140275816017
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.3000*2,   0.1000*2);  // 1.0 * exp(0.3)   1.34985880757600
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.4000*2,   0.1000*2);  // 1.0 * exp(0.4)   1.49182469764127
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.5000*2,   0.1000*2);  // 1.0 * exp(0.5)   1.64872127070013
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.6000*2,   0.1000*2);  // 1.0 * exp(0.6)   1.82211880039051
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.7000*2,   0.1000*2);  // 1.0 * exp(0.7)   2.01375270747048
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.8000*2,   0.1000*2);  // 1.0 * exp(0.8)   2.22554092849247
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     0.9000*2,   0.1000*2);  // 1.0 * exp(0.9)   2.45960311115695
      //load_directed( `MODE_E, `FORMAT_CMPLX_DW,     1.00000,     1.00000,     1.0000*2,   0.1000*2);  // 1.0 * exp(1.0)   2.71828182845905


      //run_clk(1);
      //arst        = 1'b1;
      //run_clk(1);
      //arst        = 1'b0;
      //run_clk(1);
      //load        = 1'b1;
      //run_clk(1);
      //load        = 1'b0;

      //repeat(2**00) begin
         //repeat(2**`WD)
            //repeat(2**`WC)
               //repeat(2**`WC)
                  //load_operands(cnt);
      //end
   end

// *****************************************************************************

endtask


