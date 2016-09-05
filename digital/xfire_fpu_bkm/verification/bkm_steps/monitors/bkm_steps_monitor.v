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
// Monitor for bkm_steps block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_steps_monitor.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-03 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_steps_monitor #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter WD      = 64
   ) (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input wire              clk,
   input wire              arst,
   input wire              srst,
   input wire              enable,
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input  wire [2*WD-1:0]  X_np1_csd,
   input  wire [2*WD-1:0]  Y_np1_csd,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire [WD-1:0]    res_X_np1,
   output wire [WD-1:0]    res_Y_np1
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   bkm_data_step_monitor #(
      .W          (WD)
   ) bkm_data_monitor (
      // ----------------------------------
      // Clock, reset & enable inputs
      // ----------------------------------
      .clk        (clk),
      .arst       (arst),
      .srst       (srst),
      .enable     (enable),
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .X_np1_csd  (X_np1_csd),
      .Y_np1_csd  (Y_np1_csd),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .res_X_np1  (res_X_np1),
      .res_Y_np1  (res_Y_np1)
   );
// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule



