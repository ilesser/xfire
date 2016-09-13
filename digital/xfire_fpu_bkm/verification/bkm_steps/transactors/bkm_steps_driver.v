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
   reg               double_word;
   reg               complex;
   wire  [WI-1:0]   X_int,      Y_int;
   wire  [WFD-1:0]  X_frac,     Y_frac;
   wire  [WD-1:0]   X_in_bin,   Y_in_bin;
   wire  [WI-1:0]   u_int,      v_int;
   wire  [WFC-1:0]  u_frac,     v_frac;
   // -----------------------------------------------------

   // TODO: Initially all the inputs will come from the tb_Z/w_in in real format
   //assign X_in_bin = float_or_fix == 1'b1 ?  X_in_float2bin :  X_in_cnt ;
   //assign Y_in_bin = float_or_fix == 1'b1 ?  Y_in_float2bin :  Y_in_cnt ;
   //assign u_in_bin = float_or_fix == 1'b1 ?  u_in_float2bin :  u_in_cnt ;
   //assign v_in_bin = float_or_fix == 1'b1 ?  v_in_float2bin :  v_in_cnt ;

   assign X_int    = $rtoi( tb_X_in );
   assign Y_int    = $rtoi( tb_Y_in );
   assign u_int    = $rtoi( tb_u_in );
   assign v_int    = $rtoi( tb_v_in );
   assign X_frac   = $rtoi( (tb_X_in - X_int) * 2.0**(WFD) );
   assign Y_frac   = $rtoi( (tb_Y_in - Y_int) * 2.0**(WFD) );
   assign u_frac   = $rtoi( (tb_u_in - u_int) * 2.0**(WFC) );
   assign v_frac   = $rtoi( (tb_v_in - v_int) * 2.0**(WFC) );
   assign X_in_bin = {X_int, X_frac};
   assign Y_in_bin = {Y_int, Y_frac};
   assign u_in_bin = {u_int, u_frac};
   assign v_in_bin = {v_int, v_frac};

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


