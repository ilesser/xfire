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
// Driver for bkm_steps block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_steps_driver.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-07 - ilesser - Fixed u_frac and v_frac assignments.
//    - 2016-09-05 - ilesser - Changed io ports to real type.
//    - 2016-09-04 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_steps_driver #(
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
   input  wire             float_or_fix,
   input  wire             tb_mode,
   input  wire [1:0]       tb_format,
   input  real             tb_X_in,
   input  real             tb_Y_in,
   input  real             tb_u_in,
   input  real             tb_v_in,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire [2*WD-1:0]  X_in_csd,
   output wire [2*WD-1:0]  Y_in_csd,
   output wire [WC-1:0]    u_in_bin,
   output wire [WC-1:0]    v_in_bin
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire  [WD-1:0]   X_in_bin,   Y_in_bin;
   // -----------------------------------------------------

   // TODO: Initially all the inputs will come from the tb_Z/w_in in real format
   //assign X_in_bin = float_or_fix == 1'b1 ?  X_in_float2bin :  X_in_cnt ;
   //assign Y_in_bin = float_or_fix == 1'b1 ?  Y_in_float2bin :  Y_in_cnt ;
   //assign u_in_bin = float_or_fix == 1'b1 ?  u_in_float2bin :  u_in_cnt ;
   //assign v_in_bin = float_or_fix == 1'b1 ?  v_in_float2bin :  v_in_cnt ;

   assign X_in_bin     = real2data   ( tb_X_in    );
   assign Y_in_bin     = real2data   ( tb_Y_in    );
   assign u_in_bin     = real2control( tb_u_in    );
   assign v_in_bin     = real2control( tb_v_in    );

   bin2csd #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
      .W                   (WD)
   ) bin2csd_X (
   // ----------------------------------
   // Data inputs
   // ----------------------------------
      .x                   (X_in_bin),
   // ----------------------------------
   // Data outputs
   // ----------------------------------
      .y                   (X_in_csd)
   );

   bin2csd #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
      .W                   (WD)
   ) bin2csd_Y (
   // ----------------------------------
   // Data inputs
   // ----------------------------------
      .x                   (Y_in_bin),
   // ----------------------------------
   // Data outputs
   // ----------------------------------
      .y                   (Y_in_csd)
   );

// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule


