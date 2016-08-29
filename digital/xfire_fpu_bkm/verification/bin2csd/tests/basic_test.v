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
// Basic test for bin2csd
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
//    - 2016-04-10 - ilesser - Original version.
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

      $monitor ("Time = %8t tb_x = %b \twire_y = %b \n\t\t\t\tres    = %b\n\n",$time, tb_x, wire_y, res);
      load_operands(`W'b00000, `W2'b0000000000);  // res = 0
      load_operands(`W'b00001, `W2'b0000000001);  // res = 1
      load_operands(`W'b00010, `W2'b0000000100);  // res = 2
      load_operands(`W'b00100, `W2'b0000010000);  // res = 4
      load_operands(`W'b01000, `W2'b0001000000);  // res = 8
      load_operands(`W'b10000, `W2'b1000000000);  // res =-16
      load_operands(`W'b00110, `W2'b0001001000);  // res = 6 = 8-2
      load_operands(`W'b00111, `W2'b0001000010);  // res = 7 = 8-1
      load_operands(`W'b10111, `W2'b0010000010);  // res =-9 =-8-1
      load_operands(`W'b11111, `W2'b0000000010);  // res = 1
      load_operands(`W'b00011, `W2'b0000010010);  // res = 3 =-4+1
      load_operands(`W'b01011, `W2'b0100100010);  // res = 11 = 16-4-1
      load_operands(`W'b00111, convert_to_csd(`W'b00111));  // res = 1

   end

// *****************************************************************************

endtask

