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
// Basic test for csd_add_subb block.
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
//    - 2016-04-16 - ilesser - Original version.
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

      $monitor("Time = %8t tb_a = %b tb_b = %b wire_s = %b tb_res = %b\n",$time, tb_a, tb_b, wire_s, tb_s);
      $dumpfile("tb_csd_add_subb_basic_test.vcd");
      $dumpvars();

      // operands       subb_a subb_b  a      b      s
      load_operands_test(1'b0, 1'b0, 2'b00, 2'b00, 2'b00);
      load_operands_test(1'b0, 1'b0, 2'b00, 2'b01, 2'b01);
      load_operands_test(1'b0, 1'b0, 2'b00, 2'b10, 2'b10);
      load_operands_test(1'b0, 1'b0, 2'b00, 2'b11, 2'b11);
      //load_operands_test(1'b0, 1'b0, 2'b01, 2'b00, 2'b00);
      //load_operands_test(1'b0, 1'b0, 2'b01, 2'b01, 2'b01);
      //load_operands_test(1'b0, 1'b0, 2'b01, 2'b10, 2'b10);
      //load_operands_test(1'b0, 1'b0, 2'b01, 2'b11, 2'b11);
      //load_operands_test(1'b0, 1'b0, 2'b10, 2'b00, 2'b00);
      //load_operands_test(1'b0, 1'b0, 2'b10, 2'b01, 2'b01);
      //load_operands_test(1'b0, 1'b0, 2'b10, 2'b10, 2'b10);
      //load_operands_test(1'b0, 1'b0, 2'b10, 2'b11, 2'b11);

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
   input            subb_a;
   input            subb_b;
   input [2*W-1:0]  a;
   input [2*W-1:0]  b;
   input [2*W-1:0]  s;
   // -----------------------------------------------------

   begin

      tb_subb_a   = subb_a;
      tb_subb_b   = subb_b;
      tb_a        = a;
      tb_b        = b;
      tb_s        = s;
      #1

      if (wire_s != tb_s) begin
         `ERR_MSG2(\tExpected result: %b\n\t\tObtained result: %b\n, tb_s, wire_s);
      end

   end

// *****************************************************************************

endtask
