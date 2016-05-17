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
// Basic test for add_subb block.
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
//    - 2016-05-17 - ilesser - Initial version.
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

      $monitor("Time = %8t tb_a = %d tb_b = %d tb_s = %b %d s_res = %b %d\n",$time, tb_a, tb_b, tb_c, tb_s, c_res, s_res);
      $dumpfile("../waves/tb_add_subb_basic_test.vcd");
      $dumpvars();

      // operands   subb_a subb_b      a        b     c       s
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd0, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd1, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd2, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd3, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd4, 1'b0,  `W'd4);

      load_operands(1'b0,  1'b0,     `W'd1,  `W'd0, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd1, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd2, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd3, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd4, 1'b0,  `W'd5);

      load_operands(1'b0,  1'b0,     `W'd2,  `W'd0, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd1, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd2, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd3, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd4, 1'b0,  `W'd6);

      load_operands(1'b0,  1'b0,     `W'd3,  `W'd0, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd1, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd2, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd3, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd4, 1'b0,  `W'd7);

      load_operands(1'b0,  1'b0,     `W'd4,  `W'd0, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd1, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd2, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd3, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd4, 1'b0,  `W'd8);

      load_operands(1'b0,  1'b1,     `W'd0,  `W'd0, 1'b0,  `W'd0);   // C is wrong
      load_operands(1'b0,  1'b1,     `W'd0,  `W'd1, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b1,     `W'd0,  `W'd2, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b1,     `W'd0,  `W'd3, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b1,     `W'd0,  `W'd4, 1'b0, -`W'd4);

      load_operands(1'b0,  1'b1,     `W'd1,  `W'd0, 1'b0,  `W'd1);   // en estos dos S esta bien y C esta mal
      load_operands(1'b0,  1'b1,     `W'd1,  `W'd1, 1'b0,  `W'd0);   //
      load_operands(1'b0,  1'b1,     `W'd1,  `W'd2, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b1,     `W'd1,  `W'd3, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b1,     `W'd1,  `W'd4, 1'b0, -`W'd3);

      load_operands(1'b0,  1'b1,     `W'd2,  `W'd0, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b1,     `W'd2,  `W'd1, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b1,     `W'd2,  `W'd2, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b1,     `W'd2,  `W'd3, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b1,     `W'd2,  `W'd4, 1'b0, -`W'd2);

      load_operands(1'b0,  1'b1,     `W'd3,  `W'd0, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b1,     `W'd3,  `W'd1, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b1,     `W'd3,  `W'd2, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b1,     `W'd3,  `W'd3, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b1,     `W'd3,  `W'd4, 1'b0, -`W'd1);

   end

// *****************************************************************************

endtask

// *****************************************************************************
// Task
// *****************************************************************************
task load_operands;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   input             subb_a;
   input             subb_b;
   input [W-1:0]     a;
   input [W-1:0]     b;
   input             c;
   input [W-1:0]     s;
   // -----------------------------------------------------

   begin

      tb_subb_a   = subb_a;
      tb_subb_b   = subb_b;
      tb_a        = a;
      tb_b        = b;
      tb_c        = c;
      tb_s        = s;
      #1

      if (tb_c != c_res || tb_s != s_res) begin
         `ERR_MSG4(\tExpected result: %b %b\n\t\tObtained result: %b %b\t\t, tb_c, tb_s, c_res, s_res);
         $display("");
      end

   end

// *****************************************************************************

endtask

