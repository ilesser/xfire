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
//    - 2016-07-06 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

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
   reg   [30:0]   cnt1, cnt2;
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

      //repeat(2**(`CNT_SIZE))
      repeat(2**14) begin
         cnt1 = constrained_rand_int(0, 2**31);
         cnt2 = constrained_rand_int(0, 2**31);
         load_operands({cnt1, cnt1^cnt2});
      end

   end

// *****************************************************************************

endtask


