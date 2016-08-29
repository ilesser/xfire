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
// Checker for lut_decoder block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// lut_decoder_checker.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-28 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module lut_decoder_checker #(
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
   input wire               tb_mode,
   input wire  [1:0]        tb_format,
   input wire  [LOG2N-1:0]  tb_n,
   input wire  [1:0]        tb_d_x_n,
   input wire  [1:0]        tb_d_y_n,
   input wire  [WC-1:0]     tb_lut_u_n,
   input wire  [WC-1:0]     tb_lut_v_n,
   input wire  [WC-1:0]     res_lut_u_n,
   input wire  [WC-1:0]     res_lut_v_n,
   input wire  [WD-1:0]     tb_lut_X_n,
   input wire  [WD-1:0]     tb_lut_Y_n,
   input wire  [WD-1:0]     res_lut_X_n,
   input wire  [WD-1:0]     res_lut_Y_n,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire               war_u,
   output wire               war_v,
   output wire               err_u,
   output wire               err_v,
   output wire  [WC-1:0]     delta_u,
   output wire  [WC-1:0]     delta_v,
   output wire               war_X,
   output wire               war_Y,
   output wire               err_X,
   output wire               err_Y,
   output wire  [WD-1:0]     delta_X,
   output wire  [WD-1:0]     delta_Y
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
      $monitor("Time = %8t",                                               $time,
               "\ttb_mode=%b",                                             tb_mode,
               "\ttb_format=%b",                                           tb_format,
               "\ttb_n=%b",                                                tb_n,
               "\ttb_d_x_n=%b\ttb_d_y_n=%b\n",                             tb_d_x_n,      tb_d_y_n,
               "\ttb_lut_X_n=%6d\ttb_lut_Y_n=%6d\n",                       tb_lut_X_n,    tb_lut_Y_n,
               "\ttb_lut_u_n=%6d\ttb_lut_v_n=%6d\n",                       tb_lut_u_n,    tb_lut_v_n,
               "\t\t\t\t\tres_X_np1=%6d\tres_Y_np1=%6d\n",                 res_lut_X_n,   res_lut_Y_n,
               "\t\t\t\t\tres_u_np1=%6d\tres_v_np1=%6d\n",                 res_lut_u_n,   res_lut_v_n,
            );
   end

   // -----------------------------------------------------

// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

