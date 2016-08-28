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
// Sequential test for lut_decoder block.
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
//    - 2016-08-28 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

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
      cnt_load    = {`CNT_SIZE{1'b0}};
      cnt_step    = {{`CNT_SIZE-1{1'b0}},1'b1};
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      //repeat(2**(`CNT_SIZE))
      repeat(2**(2))
         load_operands(cnt);

   end

// *****************************************************************************

endtask


