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
// Basic test for barrel shifter.
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
//    - 2016-04-25 - ilesser - Original version.
//
// -----------------------------------------------------------------------------
`define DIR_RIGHT 1'b0
`define DIR_LEFT  1'b1

`define OP_SHIFT  1'b0
`define OP_ROT    1'b1

`define SHIFT_T_LOGIC   1'b0
`define SHIFT_T_ARITH   1'b1

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

      $monitor("Time = %8t dir = %b op = %b shift_t = %b sel = %d in = %d\n\t\texpected = %d\n\t\tobtained = %d",$time, tb_dir, tb_op, tb_shift_t, tb_sel, tb_in, tb_out, wire_out);
      $dumpfile("../waves/tb_barrel_shifter_basic_test.vcd");
      $dumpvars();


      //                      dir         op          shift_t      sel   in  out
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_T_ARITH,   0,   0, 0   );


   end

// *****************************************************************************

endtask

// *****************************************************************************
// Interface
// *****************************************************************************
task load_barrel_shifter;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input                dir;
   input                op;
   input                shift_t;
   input [LOG2W-1:0]    sel;
   input [W-1:0]        in;
   input [W-1:0]        out;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      tb_dir      = dir;
      tb_op       = op;
      tb_shift_t  = shift_t;
      tb_sel      = sel;
      tb_in       = in;
      tb_out      = out;

      if ( wire_out != tb_out ) begin
         `ERR_MSG2(Expected result: %b\n\t\t  Obtained result: %b\t, tb_out, wire_out);
         $display("");
      end

      //$display("X = %h  Y = %h   F = %b", X, Y, F);
      //$display("x = %h  y = %h   f = %b", bkm_x, bkm_y, bkm_flags);
      //$display("err_x = %b err_y = %b  err_f = %b", err_x, err_y, err_f );

   end

// *****************************************************************************

endtask

