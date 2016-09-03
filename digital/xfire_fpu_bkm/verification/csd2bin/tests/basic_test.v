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
// Basic test for csd2bin block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// basic_test.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-03 - ilesser - Changed architecture to automatically generate results.
//    - 2016-04-18 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------


// *****************************************************************************
// Interface
// *****************************************************************************
task basic_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      ena = 1'b1;
      rst = 1'b0;
      run_clk(1);
      load_operands(`WCSD'b0000000000);  // res = 0
      load_operands(`WCSD'b0000000001);  // res = 1
      load_operands(`WCSD'b0000000100);  // res = 2
      load_operands(`WCSD'b0000010010);  // res = 3 = 4 - 1
      load_operands(`WCSD'b0000010000);  // res = 4
      load_operands(`WCSD'b0000010001);  // res = 5
      load_operands(`WCSD'b0001001000);  // res = 6 = 8 - 2
      load_operands(`WCSD'b0001000010);  // res = 7 = 8 - 1
      load_operands(`WCSD'b0001000000);  // res = 8
      load_operands(`WCSD'b0000000010);  // res =-1
      load_operands(`WCSD'b0000001000);  // res =-2
      load_operands(`WCSD'b0000100000);  // res =-4
      load_operands(`WCSD'b0010000000);  // res =-8
      load_operands(`WCSD'b1000000000);  // res =-16
      load_operands(`WCSD'b0010000010);  // res =-9 =-8-1
      load_operands(`WCSD'b0000010010);  // res = 3 =-4+1
      load_operands(`WCSD'b0100100010);  // res = 11 = 16-4-1

   end

// *****************************************************************************

endtask

