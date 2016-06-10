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

      // operands   subb_a subb_b      a        b     c       s
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd0, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd1, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd2, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd3, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd4, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd5, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd6, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd0,  `W'd7, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd0, -`W'd1, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,     `W'd0, -`W'd2, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,     `W'd0, -`W'd3, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,     `W'd0, -`W'd4, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,     `W'd0, -`W'd5, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,     `W'd0, -`W'd6, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,     `W'd0, -`W'd7, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,     `W'd0, -`W'd8, 1'b0, -`W'd8);

      load_operands(1'b0,  1'b0,     `W'd1,  `W'd0, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd1, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd2, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd3, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd4, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd5, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd6, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd1,  `W'd7, 1'b1,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd1, -`W'd1, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd1, -`W'd2, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,     `W'd1, -`W'd3, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,     `W'd1, -`W'd4, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,     `W'd1, -`W'd5, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,     `W'd1, -`W'd6, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,     `W'd1, -`W'd7, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,     `W'd1, -`W'd8, 1'b0, -`W'd7);

      load_operands(1'b0,  1'b0,     `W'd2,  `W'd0, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd1, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd2, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd3, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd4, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd5, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd6, 1'b0,  `W'd8);
      load_operands(1'b0,  1'b0,     `W'd2,  `W'd7, 1'b0,  `W'd9);
      load_operands(1'b0,  1'b0,     `W'd2, -`W'd1, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd2, -`W'd2, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd2, -`W'd3, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,     `W'd2, -`W'd4, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,     `W'd2, -`W'd5, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,     `W'd2, -`W'd6, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,     `W'd2, -`W'd7, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,     `W'd2, -`W'd8, 1'b0, -`W'd6);

      load_operands(1'b0,  1'b0,     `W'd3,  `W'd0, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd1, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd2, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd3, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd4, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd5, 1'b0,  `W'd8);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd6, 1'b0,  `W'd9);
      load_operands(1'b0,  1'b0,     `W'd3,  `W'd7, 1'b0,  `W'd10);
      load_operands(1'b0,  1'b0,     `W'd3, -`W'd1, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd3, -`W'd2, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd3, -`W'd3, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd3, -`W'd4, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,     `W'd3, -`W'd5, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,     `W'd3, -`W'd6, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,     `W'd3, -`W'd7, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,     `W'd3, -`W'd8, 1'b0, -`W'd5);

      load_operands(1'b0,  1'b0,     `W'd4,  `W'd0, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd1, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd2, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd3, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd4, 1'b0,  `W'd8);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd5, 1'b0,  `W'd9);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd6, 1'b0,  `W'd10);
      load_operands(1'b0,  1'b0,     `W'd4,  `W'd7, 1'b0,  `W'd11);
      load_operands(1'b0,  1'b0,     `W'd4, -`W'd1, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd4, -`W'd2, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd4, -`W'd3, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd4, -`W'd4, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd4, -`W'd5, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,     `W'd4, -`W'd6, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,     `W'd4, -`W'd7, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,     `W'd4, -`W'd8, 1'b0, -`W'd4);

      load_operands(1'b0,  1'b0,     `W'd5,  `W'd0, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd5,  `W'd1, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd5,  `W'd2, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd5,  `W'd3, 1'b0,  `W'd8);
      load_operands(1'b0,  1'b0,     `W'd5,  `W'd4, 1'b0,  `W'd9);
      load_operands(1'b0,  1'b0,     `W'd5,  `W'd5, 1'b0,  `W'd10);
      load_operands(1'b0,  1'b0,     `W'd5,  `W'd6, 1'b0,  `W'd11);
      load_operands(1'b0,  1'b0,     `W'd5,  `W'd7, 1'b0,  `W'd12);
      load_operands(1'b0,  1'b0,     `W'd5, -`W'd1, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd5, -`W'd2, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd5, -`W'd3, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd5, -`W'd4, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd5, -`W'd5, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd5, -`W'd6, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,     `W'd5, -`W'd7, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,     `W'd5, -`W'd8, 1'b0, -`W'd3);

      load_operands(1'b0,  1'b0,     `W'd6,  `W'd0, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd6,  `W'd1, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd6,  `W'd2, 1'b0,  `W'd8);
      load_operands(1'b0,  1'b0,     `W'd6,  `W'd3, 1'b0,  `W'd9);
      load_operands(1'b0,  1'b0,     `W'd6,  `W'd4, 1'b0,  `W'd10);
      load_operands(1'b0,  1'b0,     `W'd6,  `W'd5, 1'b0,  `W'd11);
      load_operands(1'b0,  1'b0,     `W'd6,  `W'd6, 1'b0,  `W'd12);
      load_operands(1'b0,  1'b0,     `W'd6,  `W'd7, 1'b0,  `W'd13);
      load_operands(1'b0,  1'b0,     `W'd6, -`W'd1, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd6, -`W'd2, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd6, -`W'd3, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd6, -`W'd4, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd6, -`W'd5, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd6, -`W'd6, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd6, -`W'd7, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,     `W'd6, -`W'd8, 1'b0, -`W'd2);

      load_operands(1'b0,  1'b0,     `W'd7,  `W'd0, 1'b0,  `W'd7);
      load_operands(1'b0,  1'b0,     `W'd7,  `W'd1, 1'b0,  `W'd8);
      load_operands(1'b0,  1'b0,     `W'd7,  `W'd2, 1'b0,  `W'd9);
      load_operands(1'b0,  1'b0,     `W'd7,  `W'd3, 1'b0,  `W'd10);
      load_operands(1'b0,  1'b0,     `W'd7,  `W'd4, 1'b0,  `W'd11);
      load_operands(1'b0,  1'b0,     `W'd7,  `W'd5, 1'b0,  `W'd12);
      load_operands(1'b0,  1'b0,     `W'd7,  `W'd6, 1'b0,  `W'd13);
      load_operands(1'b0,  1'b0,     `W'd7,  `W'd7, 1'b0,  `W'd14);
      load_operands(1'b0,  1'b0,     `W'd7, -`W'd1, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,     `W'd7, -`W'd2, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,     `W'd7, -`W'd3, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,     `W'd7, -`W'd4, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,     `W'd7, -`W'd5, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,     `W'd7, -`W'd6, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,     `W'd7, -`W'd7, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,     `W'd7, -`W'd8, 1'b0, -`W'd1);

      load_operands(1'b0,  1'b0,    -`W'd1,  `W'd0, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,    -`W'd1,  `W'd1, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,    -`W'd1,  `W'd2, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,    -`W'd1,  `W'd3, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,    -`W'd1,  `W'd4, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,    -`W'd1,  `W'd5, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,    -`W'd1,  `W'd6, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,    -`W'd1,  `W'd7, 1'b0,  `W'd6);
      load_operands(1'b0,  1'b0,    -`W'd1, -`W'd1, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,    -`W'd1, -`W'd2, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,    -`W'd1, -`W'd3, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,    -`W'd1, -`W'd4, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,    -`W'd1, -`W'd5, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,    -`W'd1, -`W'd6, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,    -`W'd1, -`W'd7, 1'b0, -`W'd8);
      load_operands(1'b0,  1'b0,    -`W'd1, -`W'd8, 1'b0, -`W'd9); //////////////

      load_operands(1'b0,  1'b0,    -`W'd2,  `W'd0, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,    -`W'd2,  `W'd1, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,    -`W'd2,  `W'd2, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,    -`W'd2,  `W'd3, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,    -`W'd2,  `W'd4, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,    -`W'd2,  `W'd5, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,    -`W'd2,  `W'd6, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,    -`W'd2,  `W'd7, 1'b0,  `W'd5);
      load_operands(1'b0,  1'b0,    -`W'd2, -`W'd1, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,    -`W'd2, -`W'd2, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,    -`W'd2, -`W'd3, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,    -`W'd2, -`W'd4, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,    -`W'd2, -`W'd5, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,    -`W'd2, -`W'd6, 1'b0, -`W'd8);
      load_operands(1'b0,  1'b0,    -`W'd2, -`W'd7, 1'b0, -`W'd9);
      load_operands(1'b0,  1'b0,    -`W'd2, -`W'd8, 1'b0, -`W'd10);

      load_operands(1'b0,  1'b0,    -`W'd3,  `W'd0, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,    -`W'd3,  `W'd1, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,    -`W'd3,  `W'd2, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,    -`W'd3,  `W'd3, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,    -`W'd3,  `W'd4, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,    -`W'd3,  `W'd5, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,    -`W'd3,  `W'd6, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,    -`W'd3,  `W'd7, 1'b0,  `W'd4);
      load_operands(1'b0,  1'b0,    -`W'd3, -`W'd1, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,    -`W'd3, -`W'd2, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,    -`W'd3, -`W'd3, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,    -`W'd3, -`W'd4, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,    -`W'd3, -`W'd5, 1'b0, -`W'd8);
      load_operands(1'b0,  1'b0,    -`W'd3, -`W'd6, 1'b0, -`W'd9);
      load_operands(1'b0,  1'b0,    -`W'd3, -`W'd7, 1'b0, -`W'd10);
      load_operands(1'b0,  1'b0,    -`W'd3, -`W'd8, 1'b0, -`W'd11);

      load_operands(1'b0,  1'b0,    -`W'd4,  `W'd0, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,    -`W'd4,  `W'd1, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,    -`W'd4,  `W'd2, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,    -`W'd4,  `W'd3, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,    -`W'd4,  `W'd4, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,    -`W'd4,  `W'd5, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,    -`W'd4,  `W'd6, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,    -`W'd4,  `W'd7, 1'b0,  `W'd3);
      load_operands(1'b0,  1'b0,    -`W'd4, -`W'd1, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,    -`W'd4, -`W'd2, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,    -`W'd4, -`W'd3, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,    -`W'd4, -`W'd4, 1'b0, -`W'd8);
      load_operands(1'b0,  1'b0,    -`W'd4, -`W'd5, 1'b0, -`W'd9);
      load_operands(1'b0,  1'b0,    -`W'd4, -`W'd6, 1'b0, -`W'd10);
      load_operands(1'b0,  1'b0,    -`W'd4, -`W'd7, 1'b0, -`W'd11);
      load_operands(1'b0,  1'b0,    -`W'd4, -`W'd8, 1'b0, -`W'd12);

      load_operands(1'b0,  1'b0,    -`W'd5,  `W'd0, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,    -`W'd5,  `W'd1, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,    -`W'd5,  `W'd2, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,    -`W'd5,  `W'd3, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,    -`W'd5,  `W'd4, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,    -`W'd5,  `W'd5, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,    -`W'd5,  `W'd6, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,    -`W'd5,  `W'd7, 1'b0,  `W'd2);
      load_operands(1'b0,  1'b0,    -`W'd5, -`W'd1, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,    -`W'd5, -`W'd2, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,    -`W'd5, -`W'd3, 1'b0, -`W'd8);
      load_operands(1'b0,  1'b0,    -`W'd5, -`W'd4, 1'b0, -`W'd9);
      load_operands(1'b0,  1'b0,    -`W'd5, -`W'd5, 1'b0, -`W'd10);
      load_operands(1'b0,  1'b0,    -`W'd5, -`W'd6, 1'b0, -`W'd11);
      load_operands(1'b0,  1'b0,    -`W'd5, -`W'd7, 1'b0, -`W'd12);
      load_operands(1'b0,  1'b0,    -`W'd5, -`W'd8, 1'b0, -`W'd13);

      load_operands(1'b0,  1'b0,    -`W'd6,  `W'd0, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,    -`W'd6,  `W'd1, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,    -`W'd6,  `W'd2, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,    -`W'd6,  `W'd3, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,    -`W'd6,  `W'd4, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,    -`W'd6,  `W'd5, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,    -`W'd6,  `W'd6, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,    -`W'd6,  `W'd7, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b0,    -`W'd6, -`W'd1, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,    -`W'd6, -`W'd2, 1'b0, -`W'd8);
      load_operands(1'b0,  1'b0,    -`W'd6, -`W'd3, 1'b0, -`W'd9);
      load_operands(1'b0,  1'b0,    -`W'd6, -`W'd4, 1'b0, -`W'd10);
      load_operands(1'b0,  1'b0,    -`W'd6, -`W'd5, 1'b0, -`W'd11);
      load_operands(1'b0,  1'b0,    -`W'd6, -`W'd6, 1'b0, -`W'd12);
      load_operands(1'b0,  1'b0,    -`W'd6, -`W'd7, 1'b0, -`W'd13);
      load_operands(1'b0,  1'b0,    -`W'd6, -`W'd8, 1'b0, -`W'd14);

      load_operands(1'b0,  1'b0,    -`W'd7,  `W'd0, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,    -`W'd7,  `W'd1, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,    -`W'd7,  `W'd2, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,    -`W'd7,  `W'd3, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,    -`W'd7,  `W'd4, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,    -`W'd7,  `W'd5, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,    -`W'd7,  `W'd6, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,    -`W'd7,  `W'd7, 1'b0,  `W'd0);
      load_operands(1'b0,  1'b0,    -`W'd7, -`W'd1, 1'b0, -`W'd8);
      load_operands(1'b0,  1'b0,    -`W'd7, -`W'd2, 1'b0, -`W'd9);
      load_operands(1'b0,  1'b0,    -`W'd7, -`W'd3, 1'b0, -`W'd10);
      load_operands(1'b0,  1'b0,    -`W'd7, -`W'd4, 1'b0, -`W'd11);
      load_operands(1'b0,  1'b0,    -`W'd7, -`W'd5, 1'b0, -`W'd12);
      load_operands(1'b0,  1'b0,    -`W'd7, -`W'd6, 1'b0, -`W'd13);
      load_operands(1'b0,  1'b0,    -`W'd7, -`W'd7, 1'b0, -`W'd14);
      load_operands(1'b0,  1'b0,    -`W'd7, -`W'd8, 1'b0, -`W'd15);

      load_operands(1'b0,  1'b0,    -`W'd8,  `W'd0, 1'b0, -`W'd8);
      load_operands(1'b0,  1'b0,    -`W'd8,  `W'd1, 1'b0, -`W'd7);
      load_operands(1'b0,  1'b0,    -`W'd8,  `W'd2, 1'b0, -`W'd6);
      load_operands(1'b0,  1'b0,    -`W'd8,  `W'd3, 1'b0, -`W'd5);
      load_operands(1'b0,  1'b0,    -`W'd8,  `W'd4, 1'b0, -`W'd4);
      load_operands(1'b0,  1'b0,    -`W'd8,  `W'd5, 1'b0, -`W'd3);
      load_operands(1'b0,  1'b0,    -`W'd8,  `W'd6, 1'b0, -`W'd2);
      load_operands(1'b0,  1'b0,    -`W'd8,  `W'd7, 1'b0, -`W'd1);
      load_operands(1'b0,  1'b0,    -`W'd8, -`W'd1, 1'b0, -`W'd9);
      load_operands(1'b0,  1'b0,    -`W'd8, -`W'd2, 1'b0, -`W'd10);
      load_operands(1'b0,  1'b0,    -`W'd8, -`W'd3, 1'b0, -`W'd11);
      load_operands(1'b0,  1'b0,    -`W'd8, -`W'd4, 1'b0, -`W'd12);
      load_operands(1'b0,  1'b0,    -`W'd8, -`W'd5, 1'b0, -`W'd13);
      load_operands(1'b0,  1'b0,    -`W'd8, -`W'd6, 1'b0, -`W'd14);
      load_operands(1'b0,  1'b0,    -`W'd8, -`W'd7, 1'b0, -`W'd15);
      load_operands(1'b0,  1'b0,    -`W'd8, -`W'd8, 1'b0, -`W'd16);

      load_operands(1'b0,  1'b1,     `W'd1,  `W'd0, 1'b0,  `W'd1);
      load_operands(1'b0,  1'b1,     `W'd1,  `W'd1, 1'b0,  `W'd0);
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

      load_operands(1'b1,  1'b1,     `W'd1,  `W'd0, 1'b0, -`W'd1);
      load_operands(1'b1,  1'b1,     `W'd1,  `W'd1, 1'b0, -`W'd2);
      load_operands(1'b1,  1'b1,     `W'd1,  `W'd2, 1'b0, -`W'd3);
      load_operands(1'b1,  1'b1,     `W'd1,  `W'd3, 1'b0, -`W'd4);
      load_operands(1'b1,  1'b1,     `W'd1,  `W'd4, 1'b0, -`W'd5);

      load_operands(1'b1,  1'b1,     `W'd2,  `W'd0, 1'b0, -`W'd2);
      load_operands(1'b1,  1'b1,     `W'd2,  `W'd1, 1'b0, -`W'd3);
      load_operands(1'b1,  1'b1,     `W'd2,  `W'd2, 1'b0, -`W'd4);
      load_operands(1'b1,  1'b1,     `W'd2,  `W'd3, 1'b0, -`W'd5);
      load_operands(1'b1,  1'b1,     `W'd2,  `W'd4, 1'b0, -`W'd6);

      load_operands(1'b1,  1'b1,     `W'd3,  `W'd0, 1'b0, -`W'd3);
      load_operands(1'b1,  1'b1,     `W'd3,  `W'd1, 1'b0, -`W'd4);
      load_operands(1'b1,  1'b1,     `W'd3,  `W'd2, 1'b0, -`W'd5);
      load_operands(1'b1,  1'b1,     `W'd3,  `W'd3, 1'b0, -`W'd6);
      load_operands(1'b1,  1'b1,     `W'd3,  `W'd4, 1'b0, -`W'd7);

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

      run_clk(1);

   end

// *****************************************************************************

endtask

