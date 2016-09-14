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
// Driver for bkm_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_step_driver.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-13 - ilesser - Implemented real number model.
//    - 2016-08-11 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_step_driver #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter CNT     = 389,
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
   input  real             tb_X_n,
   input  real             tb_Y_n,
   input  real             tb_u_n,
   input  real             tb_v_n,
   input  real             tb_lut_X_n,
   input  real             tb_lut_Y_n,
   input  real             tb_lut_u_n,
   input  real             tb_lut_v_n,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire [2*WD-1:0]  X_n_csd,
   output wire [2*WD-1:0]  Y_n_csd,
   output wire [WC-1:0]    u_n_bin,
   output wire [WC-1:0]    v_n_bin,
   output wire [2*WD-1:0]  lut_X_n_csd,
   output wire [2*WD-1:0]  lut_Y_n_csd,
   output wire [WC-1:0]    lut_u_n_bin,
   output wire [WC-1:0]    lut_v_n_bin
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire  [WD-1:0]    X_n_bin,       Y_n_bin;
   wire  [WD-1:0]    lut_X_n_bin,   lut_Y_n_bin;
   // -----------------------------------------------------

   assign X_n_bin     = real2data   ( tb_X_n    );
   assign Y_n_bin     = real2data   ( tb_Y_n    );
   assign u_n_bin     = real2control( tb_u_n    );
   assign v_n_bin     = real2control( tb_v_n    );
   assign lut_X_n_bin = real2data   ( tb_lut_X_n);
   assign lut_Y_n_bin = real2data   ( tb_lut_Y_n);
   assign lut_u_n_bin = real2control( tb_lut_u_n);
   assign lut_v_n_bin = real2control( tb_lut_v_n);

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
      .tb_X_n     (X_n_bin),
      .tb_Y_n     (Y_n_bin),
      .tb_lut_X   (lut_X_n_bin),
      .tb_lut_Y   (lut_Y_n_bin),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_n_csd    (X_n_csd),
      .Y_n_csd    (Y_n_csd),
      .lut_X_csd  (lut_X_n_csd),
      .lut_Y_csd  (lut_Y_n_csd)
   );

// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule


