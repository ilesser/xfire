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
//    - 2016-08-15 - ilesser - Updated to use WD and WC.
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
      cnt_load    = {`MODE_L, `FORMAT_CMPLX_DW, `LOG2N'd002,   2'b00,   2'b00, `WC'h0000, `WC'h0000, `WC'h0000, `WC'h0000};
      cnt_step    = {`M_SIZE'd0,      2'b00   , `LOG2N'd000,   2'b00,   2'b00, `WC'h0000, `WC'h0001, `WC'h0000, `WC'h0000};
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;
      load        = 1'b1;
      run_clk(1);
      load        = 1'b0;

      repeat(2**(`M_SIZE+`F_SIZE+`D_SIZE+`D_SIZE+`LOG2N))
         repeat(2**`WC)
            repeat(2**`WC)
               repeat(2**`WC)
                  repeat(2**`WC)
                     load_operands(cnt);

   end

// *****************************************************************************

endtask


