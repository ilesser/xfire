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
// Monitor for bkm_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_step_monitor.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-14 - ilesser - Updated to use real number model.
//    - 2016-08-11 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_step_monitor #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter WD      = 72,
   parameter WC      = 22
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
   input  wire [WC-1:0]    u_np1_bin,
   input  wire [WC-1:0]    v_np1_bin,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output real             res_X_np1,
   output real             res_Y_np1,
   output real             res_u_np1,
   output real             res_v_np1
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire  [WD-1:0]    X_np1_bin,     Y_np1_bin;
   // -----------------------------------------------------

   assign res_X_np1   =  data2real   (  X_np1_bin   );
   assign res_Y_np1   =  data2real   (  Y_np1_bin   );
   assign res_u_np1   =  control2real(  u_np1_bin   );
   assign res_v_np1   =  control2real(  v_np1_bin   );

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
      .res_X_np1  (X_np1_bin),
      .res_Y_np1  (Y_np1_bin)
   );
// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule



