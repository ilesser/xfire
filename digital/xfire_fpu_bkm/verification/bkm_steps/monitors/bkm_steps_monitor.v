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
   wire  [WI-1:0]   X_int,      Y_int;
   wire  [WFD-1:0]  X_frac,     Y_frac;
   wire  [WI-1:0]   u_int,      v_int;
   wire  [WFC-1:0]  u_frac,     v_frac;
   // -----------------------------------------------------

   assign   X_int    = $itor( $signed( X_out_bin[WD-1:WD-WI] ) );
   assign   Y_int    = $itor( $signed( Y_out_bin[WD-1:WD-WI] ) );
   assign   u_int    = $itor( $signed( u_out_bin[WC-1:WC-WI] ) );
   assign   v_int    = $itor( $signed( v_out_bin[WC-1:WC-WI] ) );

   assign   X_frac   = $itor(          X_out_bin[WD-WI-1:0]    );
   assign   Y_frac   = $itor(          Y_out_bin[WD-WI-1:0]    );
   assign   u_frac   = $itor(          u_out_bin[WC-WI-1:0]    );
   assign   v_frac   = $itor(          v_out_bin[WC-WI-1:0]    );

   always @(*) begin
      res_X_out = X_int + X_frac / 2.0**(WD-WI);
      res_Y_out = Y_int + Y_frac / 2.0**(WD-WI);
      res_u_out = u_int + u_frac / 2.0**(WC-WI);
      res_v_out = v_int + v_frac / 2.0**(WC-WI);
   end

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



