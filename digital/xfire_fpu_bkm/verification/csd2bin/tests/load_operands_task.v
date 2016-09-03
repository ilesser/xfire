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
// Load operands task for csd2bin block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// load_operands_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-03 - ilesser - Changed architecture to automatically generate results.
//    - 2016-06-13 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------


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
   input [2*`W-1:0]   x_csd;
   // -----------------------------------------------------

   begin

      tb_x_csd = x_csd;


      tb_x_bin = convert_to_bin(x_csd);

      run_clk(1);

   end

// *****************************************************************************

endtask

