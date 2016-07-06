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
// Load operands task for bin2csd block.
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
//    - 2016-06-12 - ilesser - Initial version.
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
   input [`CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   begin

      tb_subb_x   = cnt[`CNT_SIZE-1];
      tb_subb_y   = cnt[`CNT_SIZE-2];
      tb_x_bin    = cnt[2*`W-1:`W];
      tb_y_bin    = cnt[`W-1:0];

      case ({tb_subb_x, tb_subb_x})
         2'b00 : {tb_c_bin, tb_z_bin} =  tb_x_bin + tb_y_bin;
         2'b01 : {tb_c_bin, tb_z_bin} =  tb_x_bin - tb_y_bin;
         2'b10 : {tb_c_bin, tb_z_bin} = -tb_x_bin + tb_y_bin;
         2'b11 : {tb_c_bin, tb_z_bin} = -tb_x_bin - tb_y_bin;
      endcase

      run_clk(1);

   end

// *****************************************************************************

endtask

