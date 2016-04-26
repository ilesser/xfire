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
      $dumpfile("../waves/tb_bin2csd_basic_test.vcd");
      $dumpvars();
      load_operands(5'b00000, 10'b0000000000);  // res = 0
      load_operands(5'b00001, 10'b0000000001);  // res = 1
      load_operands(5'b00010, 10'b0000000100);  // res = 2
      load_operands(5'b00100, 10'b0000010000);  // res = 4
      load_operands(5'b01000, 10'b0001000000);  // res = 8
      load_operands(5'b10000, 10'b1000000000);  // res =-16
      load_operands(5'b00110, 10'b0001001000);  // res = 6 = 8-2
      load_operands(5'b00111, 10'b0001000010);  // res = 7 = 8-1
      load_operands(5'b10111, 10'b0010000010);  // res =-9 =-8-1
      load_operands(5'b11111, 10'b0000000010);  // res = 1
      load_operands(5'b00011, 10'b0000010010);  // res = 3 =-4+1
      load_operands(5'b01011, 10'b0100100010);  // res = 11 = 16-4-1

   end

// *****************************************************************************

endtask

// *****************************************************************************
// Interface
// *****************************************************************************
task load_operands;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   input [W-1:0]     x;
   input [2*W-1:0]   y;
   // -----------------------------------------------------

   begin

      tb_x  = x;
      res   = y;
      #1

      if (wire_y != y) begin
         `ERR_MSG2(\tExpected result: %b\n\t\tObtained result: %b\t\t, y, wire_y);
         $display("");
      end

   end

// *****************************************************************************

endtask
