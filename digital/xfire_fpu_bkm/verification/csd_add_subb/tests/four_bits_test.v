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
// Four bit test for csd_add_subb block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// 4bits_test.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-16 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
task four_bits_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      $monitor("Time = %8t \n\ttb_a   = %b \n\ttb_b   = %b \n\ttb_s   = %b \n\twire_s = %b\n",$time, tb_a, tb_b, tb_s, wire_s);
      $dumpfile("../waves/tb_csd_add_subb_four_bits_test.vcd");
      $dumpvars();

      // First test
      // 7 + 3 = 10
      // 7 = 4'b0111 => 4'b100| in CSD
      // 7 = 8'b01000010

      // 3 = 4'b0011 => 4'b010| in CSD
      // 3 = 8'b00010010

      // 10= 4'b1010 => 4'b1010 in CSD == 5'b10||0 = 16-4-2=10 TODO!!!! THIS IS NOT CSD because it has two nonzero digits
      // 10= 8'b01000100

      // operands       subb_a subb_b  a            b            c      s
      load_operands_test(1'b0, 1'b0, 8'b01000010, 8'b00010010, 2'b01, 8'b11101011);


      // First test
      // 7 - 3 = 4
      // 7 = 4'b0111 => 4'b100| in CSD
      // 7 = 8'b01000010

      // 3 = 4'b0011 => 4'b010| in CSD
      // 3 = 8'b00010010

      // 4 = 4'b0100 => 4'b0100 in CSD
      // 10= 8'b01000100

      // operands       subb_a subb_b  a            b            c      s
      load_operands_test(1'b0, 1'b1, 8'b01000010, 8'b00010010, 2'b00, 8'b00011111);


      // NOTE: Apparently when it does perform calculations on the ith bit and
      // the result is 0 it usually encodes it a 11 rathen than 00
   end

// *****************************************************************************

endtask

// *****************************************************************************
// Interface
// *****************************************************************************
task load_operands_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   input             subb_a;
   input             subb_b;
   input [2*W-1:0]   a;
   input [2*W-1:0]   b;
   input [1:0]       c;
   input [2*W-1:0]   s;

   reg   [1:0]       c_res;
   reg   [2*W-1:0]   s_res;
   // -----------------------------------------------------

   begin

      tb_subb_a   = subb_a;
      tb_subb_b   = subb_b;
      tb_a        = a;
      tb_b        = b;
      tb_s        = s;
      #1

      if (wire_c == 2'b11) begin
         c_res = 2'b00;
      end
      else begin
         c_res = wire_c;
      end

      s_res = wire_s;

      //if (s_res != s) begin
      if (c_res != c || s_res != s) begin
         `ERR_MSG4(\tExpected result: %b %b\n\t\tObtained result: %b %b\t\t, c, s, c_res, s_res);
         $display("");
      end

   end

// *****************************************************************************

endtask
