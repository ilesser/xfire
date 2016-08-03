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
// Sequential test for bkm_control_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// seq_test.v
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
task seq_test;
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
      //cnt_load    = `CNT_SIZE'h0000_0000_0000_0000;
      //cnt_step    = `CNT_SIZE'h0000_0001_0000_0000;
      //cnt_load    = 'h00000000;
      //cnt_step    = 'h00000000;
      //cnt_load    = 76'h1700_0000_0010_2000_0000;
      //cnt_step    = 76'h0000_0000_0001_1000_0000;
      // operands     mode     format            n             d_u_n    d_v_n    u_n      v_n      lut_u_n  lut_v_n
      cnt_load    = {`MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b00,   2'b00, `W'd037, `W'd036, `W'd017, `W'd020};
      cnt_step    = {   1'b0,         2'b00   , `LOG2N'd000,   2'b00,   2'b00, `W'd000, `W'd009, `W'd000, `W'd000};
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;
      load        = 1'b1;
      run_clk(1);
      load        = 1'b0;

      //repeat(2**16)
      repeat(2**(`CNT_SIZE/4))
         load_operands(cnt);
      repeat(2**(`CNT_SIZE/4))
         load_operands(cnt);
      repeat(2**(`CNT_SIZE/4))
         load_operands(cnt);
      repeat(2**(`CNT_SIZE/4))
         load_operands(cnt);

   end

// *****************************************************************************

endtask


