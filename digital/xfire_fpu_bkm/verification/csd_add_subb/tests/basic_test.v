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

      $monitor("Time = %8t tb_a = %b tb_b = %b tb_s = %b wire_s = %b\n",$time, tb_a, tb_b, tb_s, wire_s);
      $dumpfile("../waves/tb_csd_add_subb_basic_test.vcd");
      $dumpvars();

      // test csd2bs
      $display("convierto %d a BS: %b",-2, csd2bs(-2));
      $display("convierto %d a BS: %b",-1, csd2bs(-1));
      $display("convierto %d a BS: %b", 0, csd2bs( 0));
      $display("convierto %d a BS: %b", 1, csd2bs( 1));
      $display("convierto %d a BS: %b", 2, csd2bs( 2));

      // operands       subb_a subb_b        a           b           c           s
      load_operands_test(1'b0, 1'b0, csd2bs( 0), csd2bs( 0), csd2bs( 0), csd2bs( 0));
      load_operands_test(1'b0, 1'b0, csd2bs( 0), csd2bs( 1), csd2bs( 0), csd2bs( 1));
      load_operands_test(1'b0, 1'b0, csd2bs( 0), csd2bs(-1), csd2bs( 0), csd2bs(-1));
      load_operands_test(1'b0, 1'b0, csd2bs( 0), csd2bs( 0), csd2bs( 0), csd2bs( 0));
      load_operands_test(1'b0, 1'b0, csd2bs( 1), csd2bs( 0), csd2bs( 0), csd2bs( 1));
      load_operands_test(1'b0, 1'b0, csd2bs( 1), csd2bs( 1), csd2bs( 1), csd2bs( 0));
      load_operands_test(1'b0, 1'b0, csd2bs( 1), csd2bs(-1), csd2bs( 0), csd2bs( 0));
      load_operands_test(1'b0, 1'b0, csd2bs( 1), csd2bs( 0), csd2bs( 0), csd2bs( 1));
      load_operands_test(1'b0, 1'b0, csd2bs(-1), csd2bs( 0), csd2bs( 0), csd2bs(-1));
      load_operands_test(1'b0, 1'b0, csd2bs(-1), csd2bs( 1), csd2bs( 0), csd2bs( 0));
      load_operands_test(1'b0, 1'b0, csd2bs(-1), csd2bs(-1), csd2bs(-1), csd2bs( 0));
      load_operands_test(1'b0, 1'b0, csd2bs(-1), csd2bs( 0), csd2bs( 0), csd2bs(-1));
      load_operands_test(1'b0, 1'b0, csd2bs( 0), csd2bs( 0), csd2bs( 0), csd2bs( 0));
      load_operands_test(1'b0, 1'b0, csd2bs( 0), csd2bs( 1), csd2bs( 0), csd2bs( 1));
      load_operands_test(1'b0, 1'b0, csd2bs( 0), csd2bs(-1), csd2bs( 0), csd2bs(-1));
      load_operands_test(1'b0, 1'b0, csd2bs( 0), csd2bs( 0), csd2bs( 0), csd2bs( 0));
      // operands       subb_a subb_b  a      b      c      s
      load_operands_test(1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 2'b00);
      load_operands_test(1'b0, 1'b0, 2'b00, 2'b01, 2'b00, 2'b01);
      load_operands_test(1'b0, 1'b0, 2'b00, 2'b10, 2'b00, 2'b10);
      load_operands_test(1'b0, 1'b0, 2'b00, 2'b11, 2'b00, 2'b11);
      load_operands_test(1'b0, 1'b0, 2'b01, 2'b00, 2'b00, 2'b01);
      load_operands_test(1'b0, 1'b0, 2'b01, 2'b01, 2'b01, 2'b00);
      load_operands_test(1'b0, 1'b0, 2'b01, 2'b10, 2'b00, 2'b00);
      load_operands_test(1'b0, 1'b0, 2'b01, 2'b11, 2'b00, 2'b01);
      load_operands_test(1'b0, 1'b0, 2'b10, 2'b00, 2'b00, 2'b10);
      load_operands_test(1'b0, 1'b0, 2'b10, 2'b01, 2'b00, 2'b00);
      load_operands_test(1'b0, 1'b0, 2'b10, 2'b10, 2'b10, 2'b00);
      load_operands_test(1'b0, 1'b0, 2'b10, 2'b11, 2'b00, 2'b10);
      load_operands_test(1'b0, 1'b0, 2'b11, 2'b00, 2'b00, 2'b00);
      load_operands_test(1'b0, 1'b0, 2'b11, 2'b01, 2'b00, 2'b01);
      load_operands_test(1'b0, 1'b0, 2'b11, 2'b10, 2'b00, 2'b10);
      load_operands_test(1'b0, 1'b0, 2'b11, 2'b11, 2'b00, 2'b11);

      //load_operands_test(1'b0, 1'b1, 2'b00, 2'b00, 2'b00, 2'b00);
      //load_operands_test(1'b0, 1'b1, 2'b00, 2'b01, 2'b00, 2'b10);
      //load_operands_test(1'b0, 1'b1, 2'b00, 2'b10, 2'b00, 2'b01);
      //load_operands_test(1'b0, 1'b1, 2'b00, 2'b11, 2'b00, 2'b11);
      //load_operands_test(1'b0, 1'b1, 2'b01, 2'b00, 2'b00, 2'b01);
      //load_operands_test(1'b0, 1'b1, 2'b01, 2'b01, 2'b00, 2'b00);
      //load_operands_test(1'b0, 1'b1, 2'b01, 2'b10, 2'b00, 2'b00);
      //load_operands_test(1'b0, 1'b1, 2'b01, 2'b11, 2'b00, 2'b01);
      //load_operands_test(1'b0, 1'b1, 2'b10, 2'b00, 2'b00, 2'b10);
      //load_operands_test(1'b0, 1'b1, 2'b10, 2'b01, 2'b00, 2'b00);
      //load_operands_test(1'b0, 1'b1, 2'b10, 2'b10, 2'b10, 2'b00);
      //load_operands_test(1'b0, 1'b1, 2'b10, 2'b11, 2'b00, 2'b10);
      //load_operands_test(1'b0, 1'b1, 2'b11, 2'b00, 2'b00, 2'b00);
      //load_operands_test(1'b0, 1'b1, 2'b11, 2'b01, 2'b00, 2'b01);
      //load_operands_test(1'b0, 1'b1, 2'b11, 2'b10, 2'b00, 2'b10);
      //load_operands_test(1'b0, 1'b1, 2'b11, 2'b11, 2'b00, 2'b11);

      //load_operands_test(1'b1, 1'b0, 2'b00, 2'b00, 2'b00, 2'b00);
      //load_operands_test(1'b1, 1'b0, 2'b00, 2'b01, 2'b00, 2'b01);
      //load_operands_test(1'b1, 1'b0, 2'b00, 2'b10, 2'b00, 2'b10);
      //load_operands_test(1'b1, 1'b0, 2'b00, 2'b11, 2'b00, 2'b11);
      //load_operands_test(1'b1, 1'b0, 2'b01, 2'b00, 2'b00, 2'b01);
      //load_operands_test(1'b1, 1'b0, 2'b01, 2'b01, 2'b01, 2'b00);
      //load_operands_test(1'b1, 1'b0, 2'b01, 2'b10, 2'b00, 2'b00);
      //load_operands_test(1'b1, 1'b0, 2'b01, 2'b11, 2'b00, 2'b01);
      //load_operands_test(1'b1, 1'b0, 2'b10, 2'b00, 2'b00, 2'b10);
      //load_operands_test(1'b1, 1'b0, 2'b10, 2'b01, 2'b00, 2'b00);
      //load_operands_test(1'b1, 1'b0, 2'b10, 2'b10, 2'b10, 2'b00);
      //load_operands_test(1'b1, 1'b0, 2'b10, 2'b11, 2'b00, 2'b10);
      //load_operands_test(1'b1, 1'b0, 2'b11, 2'b00, 2'b00, 2'b00);
      //load_operands_test(1'b1, 1'b0, 2'b11, 2'b01, 2'b00, 2'b01);
      //load_operands_test(1'b1, 1'b0, 2'b11, 2'b10, 2'b00, 2'b10);
      //load_operands_test(1'b1, 1'b0, 2'b11, 2'b11, 2'b00, 2'b11);
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

      if (c == 2'b11) begin
         c = 2'b00;
      end

      if (s == 2'b11) begin
         s = 2'b00;
      end

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

      if (wire_s == 2'b11) begin
         s_res = 2'b00;
      end
      else begin
         s_res = wire_s;
      end

      //if (s_res != s) begin
      if (c_res != c || s_res != s) begin
         `ERR_MSG4(\tExpected result: %b %b\n\t\tObtained result: %b %b\t\t, c, s, c_res, s_res);
         $display("");
      end

      //if (tb_s == 2'b00 || tb_s == 2'b11) begin
      //   if (wire_s != tb_s && wire_s != ~tb_s) begin
      //      `ERR_MSG2(\tExpected result: %b\n\t\tObtained result: %b\t\t, tb_s, wire_s);
      //      $display("");
      //   end
      //end
      //else begin
      //   if (wire_s != tb_s) begin
      //      `ERR_MSG2(\tExpected result: %b\n\t\tObtained result: %b\t\t, tb_s, wire_s);
      //      $display("");
      //   end
      //end

   end

// *****************************************************************************

endtask


// *****************************************************************************
// Interface
// *****************************************************************************
function [3:0] csd2bs;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   input    [3:0]   x;
   // -----------------------------------------------------

   begin

      if (x == 4'b1110) begin
         //c = 2'b10;
         //y = 2'b00;
         csd2bs = 4'b1000;
      end
      else if (x == 4'b1111) begin
         //c = 2'b00;
         //y = 2'b10;
         csd2bs = 4'b0010;
      end
      else if (x == 4'b0000) begin
         //c = 2'b00;
         //y = 2'b00;
         csd2bs = 4'b0000;
      end
      else if (x == 4'b0001) begin
         //c = 2'b00;
         //y = 2'b01;
         csd2bs = 4'b0001;
      end
      else if (x == 4'b0010) begin
         //c = 2'b01;
         //y = 2'b00;
         csd2bs = 4'b0100;
      end
      else begin
         csd2bs = 4'b1111;
         `ERR_MSG1(\tInvalid conversion to BS: %s\t\t, x);
      end

   end
// *****************************************************************************

endfunction

