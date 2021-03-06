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
// Monitor for bkm_data_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_data_step_monitor.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-15 - ilesser - Fixed parameters.
//    - 2016-08-11 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_data_step_monitor #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter W       = 64
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
   input  wire [2*W-1:0]   X_np1_csd,
   input  wire [2*W-1:0]   Y_np1_csd,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire [W-1:0]     res_X_np1,
   output wire [W-1:0]     res_Y_np1
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_X (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (X_np1_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (res_X_np1)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_Y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (Y_np1_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (res_Y_np1)
   );
// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule



