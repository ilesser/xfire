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
//    - 2016-06-13 - ilesser - Added clk to simulation.
//    - 2016-04-25 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

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

      //                      dir         op          shift_t      sel   in  out
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   0, 0   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   1, 1   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   2, 2   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   3, 3   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   4, 4   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   5, 5   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   6, 6   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   7, 7   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   8, 8   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   9, 9   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,  10,10   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   0, 0   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   1, 0   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   2, 1   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   3, 1   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   4, 2   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   5, 2   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   6, 3   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   7, 3   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   8, 4   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,   9, 4   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,  10, 5   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   0, 0   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   1, 0   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   2, 0   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   3, 0   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   4, 1   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   5, 1   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   6, 1   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   7, 1   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   8, 2   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,   9, 2   );
      load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   2,  10, 2   );
      //load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,   4, 4   );
      //load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   0,  -4,-4   );
      //load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1,  16, 8   );
      //load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   1, 524, 262 );
      //load_barrel_shifter( `DIR_RIGHT, `OP_SHIFT,  `SHIFT_ARITH,   3, 524, 65  );
      //load_barrel_shifter( `DIR_LEFT , `OP_SHIFT,  `SHIFT_ARITH,   3, 524, 4192);
      //load_barrel_shifter( `DIR_LEFT , `OP_SHIFT,  `SHIFT_ARITH,   0, 524, 524 );
      //load_barrel_shifter( `DIR_LEFT , `OP_SHIFT,  `SHIFT_ARITH,   1, 524, 1048);
      //load_barrel_shifter( `DIR_LEFT , `OP_SHIFT,  `SHIFT_ARITH,   6, 524, 3144);

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
   input [`LOG2W-1:0]   sel;
   input [`W-1:0]       in;
   input [`W-1:0]       out;
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

      run_clk(1);

   end

// *****************************************************************************

endtask

