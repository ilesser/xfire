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
   parameter WC      = 21
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
   input  real             tb_X_in,
   input  real             tb_Y_in,
   input  real             tb_u_in,
   input  real             tb_v_in,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire [2*WD-1:0]  X_in_csd,
   output wire [2*WD-1:0]  Y_in_csd,
   output wire [WC-1:0]    u_in_csd,
   output wire [WC-1:0]    v_in_csd
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   bkm_data_step_driver #(
      .W          (WD)
   ) bkm_data_driver (
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
      .tb_X_n     (tb_X_n),
      .tb_Y_n     (tb_Y_n),
      .tb_lut_X   (tb_lut_X),
      .tb_lut_Y   (tb_lut_Y),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_n_csd    (X_n_csd),
      .Y_n_csd    (Y_n_csd),
      .lut_X_csd  (lut_X_csd),
      .lut_Y_csd  (lut_Y_csd)
   );

// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule


