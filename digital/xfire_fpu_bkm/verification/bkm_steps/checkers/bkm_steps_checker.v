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
// Checker for bkm_steps block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_steps_checker.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-05 - ilesser - Changed io ports to real type.
//    - 2016-09-03 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_steps_checker #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter WC      = 16,
   parameter WD      = 64,
   parameter LOG2N   = 6
   ) (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input wire               clk,
   input wire               arst,
   input wire               srst,
   input wire               enable,
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input wire               tb_start,
   input wire               tb_mode,
   input wire  [1:0]        tb_format,
   input real               tb_u_out,
   input real               tb_v_out,
   input real               res_u_out,
   input real               res_v_out,
   input real               tb_X_out,
   input real               tb_Y_out,
   input real               res_X_out,
   input real               res_Y_out,
   input wire               res_done,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire               war_u,
   output wire               war_v,
   output wire               err_u,
   output wire               err_v,
   output real               delta_u,
   output real               delta_v,
   output real               max_delta_u,
   output real               max_delta_v,
   output real               min_delta_u,
   output real               min_delta_v,
   output wire               war_X,
   output wire               war_Y,
   output wire               err_X,
   output wire               err_Y,
   output real               delta_X,
   output real               delta_Y,
   output real               max_delta_X,
   output real               max_delta_Y,
   output real               min_delta_X,
   output real               min_delta_Y
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   initial begin
      $monitor("Time = %8t\n",                                               $time,
               //"\ttb_mode=%b",                                             tb_mode,
               //"\ttb_format=%b",                                           tb_format,
               "\t tb_X_out=%06.16f\t tb_Y_out=%06.16f\n",  tb_X_out, tb_Y_out,
               "\tres_X_out=%06.16f\tres_Y_out=%06.16f\n", res_X_out,res_Y_out,
               "\tdelta_X  =%06.16f\tdelta_Y  =%06.16f\n", delta_X,  delta_Y,
               "\t tb_u_out=%06.16f\t tb_v_out=%06.16f\n",  tb_u_out, tb_v_out,
               "\tres_u_out=%06.16f\tres_v_out=%06.16f\n", res_u_out,res_v_out,
            );
   end

   // -----------------------------------------------------
   // Min max values
   // -----------------------------------------------------
   min_max min_max_X (
      // ----------------------------------
      // Clock, reset & enable inputs
      // ----------------------------------
      .clk           (clk),
      .arst          (arst),
      .srst          (srst),
      .enable        (enable),
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .start         (tb_start),
      .done          (res_done),
      .tb            (tb_X_out),
      .res           (res_X_out),
      .max_abs_delta (2.0**-12),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .war           (war_X),
      .err           (err_X),
      .delta         (delta_X),
      .min_delta     (min_delta_X),
      .max_delta     (max_delta_X)
   );
   // -----------------------------------------------------


   // -----------------------------------------------------

// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

