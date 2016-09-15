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
//    - 2016-09-14 - ilesser - Used binary to real functions.
//    - 2016-09-07 - ilesser - Implemented monitor for bkm_steps.
//    - 2016-09-05 - ilesser - Changed io ports to real type.
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
   parameter WD      = 72,
   parameter WC      = 21,
   parameter WI      = 11,
   parameter WFD     = 59,
   parameter WFC     =  7
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
   input  wire [2*WD-1:0]  X_out_csd,
   input  wire [2*WD-1:0]  Y_out_csd,
   input  wire [WC-1:0]    u_out_bin,
   input  wire [WC-1:0]    v_out_bin,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output real             res_X_out,
   output real             res_Y_out,
   output real             res_u_out,
   output real             res_v_out
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire  [WD-1:0]   X_out_bin,  Y_out_bin;
   // -----------------------------------------------------

   assign res_X_out   =  data2real   (  X_out_bin   );
   assign res_Y_out   =  data2real   (  Y_out_bin   );
   assign res_u_out   =  control2real(  u_out_bin   );
   assign res_v_out   =  control2real(  v_out_bin   );

   csd2bin #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
      .W                   (WD)
   ) csd2bin_X (
   // ----------------------------------
   // Data inputs
   // ----------------------------------
      .x                   (X_out_csd),
   // ----------------------------------
   // Data outputs
   // ----------------------------------
      .y                   (X_out_bin)
   );

   csd2bin #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
      .W                   (WD)
   ) csd2bin_Y (
   // ----------------------------------
   // Data inputs
   // ----------------------------------
      .x                   (Y_out_csd),
   // ----------------------------------
   // Data outputs
   // ----------------------------------
      .y                   (Y_out_bin)
   );


// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule



