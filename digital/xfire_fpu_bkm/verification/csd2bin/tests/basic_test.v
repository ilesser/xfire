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
//    - 2016-04-18 - ilesser - Original version.
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
      load_operands(`W2'b0000000000, `W'b00000);  // res = 0
      load_operands(`W2'b0000000001, `W'b00001);  // res = 1
      load_operands(`W2'b0000000100, `W'b00010);  // res = 2
      load_operands(`W2'b0000010010, `W'b00011);  // res = 3 = 4 - 1
      load_operands(`W2'b0000010000, `W'b00100);  // res = 4
      load_operands(`W2'b0000010001, `W'b00101);  // res = 5
      load_operands(`W2'b0001001000, `W'b00110);  // res = 6 = 8 - 2
      load_operands(`W2'b0001000010, `W'b00111);  // res = 7 = 8 - 1
      load_operands(`W2'b0001000000, `W'b01000);  // res = 8
      load_operands(`W2'b0000000010, `W'b11111);  // res =-1
      load_operands(`W2'b0000001000, `W'b11110);  // res =-2
      load_operands(`W2'b0000100000, `W'b11100);  // res =-4
      load_operands(`W2'b0010000000, `W'b11000);  // res =-8
      load_operands(`W2'b1000000000, `W'b10000);  // res =-16
      load_operands(`W2'b0010000010, `W'b10111);  // res =-9 =-8-1
      load_operands(`W2'b0000010010, `W'b00011);  // res = 3 =-4+1
      load_operands(`W2'b0100100010, `W'b01011);  // res = 11 = 16-4-1

   end

// *****************************************************************************

endtask

