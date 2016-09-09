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
// Monitor for lut_decoder block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// lut_decoder_monitor.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-01 - ilesser - Fixed lut_Z fractional calculation.
//    - 2016-08-31 - ilesser - Used real values for luts.
//    - 2016-08-28 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module lut_decoder_monitor #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter WD      = 73,
   parameter WC      = 21,
   parameter WI      = 11

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
   input  wire [2*WD-1:0]  lut_X_n_csd,
   input  wire [2*WD-1:0]  lut_Y_n_csd,
   input  wire [WC-1:0]    lut_u_n_bin,
   input  wire [WC-1:0]    lut_v_n_bin,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output real             res_lut_X_n,
   output real             res_lut_Y_n,
   output real             res_lut_u_n,
   output real             res_lut_v_n
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire  [WD-1:0] lut_X_n_bin,   lut_Y_n_bin;
   real           lut_X_int,     lut_Y_int;
   real           lut_X_frac,    lut_Y_frac;
   real           lut_u_int,     lut_v_int;
   real           lut_u_frac,    lut_v_frac;
   // -----------------------------------------------------

   //assign lut_X_int  =  $signed(lut_X_n_bin[WD-1   :WD-WI]);
   //assign lut_Y_int  =  $signed(lut_Y_n_bin[WD-1   :WD-WI]);
   //assign lut_u_int  =  $signed(lut_u_n_bin[WC-1   :WC-WI]);
   //assign lut_v_int  =  $signed(lut_v_n_bin[WC-1   :WC-WI]);
   //assign lut_X_frac =  $itor(  lut_X_n_bin[WD-WI-1:    0]) / 2.0**(WD-WI);
   //assign lut_Y_frac =  $itor(  lut_Y_n_bin[WD-WI-1:    0]) / 2.0**(WD-WI);
   //assign lut_u_frac =  $itor(  lut_u_n_bin[WC-WI-1:    0]) / 2.0**(WC-WI);
   //assign lut_v_frac =  $itor(  lut_v_n_bin[WC-WI-1:    0]) / 2.0**(WC-WI);

   //assign res_lut_X_n =  lut_X_int + lut_X_frac;
   //assign res_lut_Y_n =  lut_Y_int + lut_Y_frac;
   //assign res_lut_u_n =  lut_u_int + lut_u_frac;
   //assign res_lut_v_n =  lut_v_int + lut_v_frac;

   assign res_lut_X_n =     data2real( lut_X_n_bin );
   assign res_lut_Y_n =     data2real( lut_Y_n_bin );
   assign res_lut_u_n =  control2real( lut_u_n_bin );
   assign res_lut_v_n =  control2real( lut_v_n_bin );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (WD)
   ) csd2bin_X (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (lut_X_n_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (lut_X_n_bin)
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
      .x                   (lut_Y_n_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (lut_Y_n_bin)
   );
// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule



