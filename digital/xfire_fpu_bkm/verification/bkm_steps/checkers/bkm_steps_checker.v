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
   input wire               tb_done,
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

   //initial begin
      //$monitor("Time = %8t",                                               $time,
               //"\ttb_mode=%b",                                             tb_mode,
               //"\ttb_format=%b",                                           tb_format,
               //"\ttb_n=%b",                                                tb_n,
               //"\ttb_d_x_n=%b\ttb_d_y_n=%b\n",                             tb_d_x_n, tb_d_y_n,
               //"\ttb_X_n=%6d\ttb_Y_n=%6d\t tb_X_np1=%6d\t tb_Y_np1=%6d\n", tb_X_n, tb_Y_n, tb_X_np1, tb_Y_np1,
               //"\t\t\t\t\tres_X_np1=%6d\tres_Y_np1=%6d\n",                                res_X_np1,res_Y_np1,
               //"\ttb_u_n=%6d\ttb_v_n=%6d\t tb_u_np1=%6d\t tb_v_np1=%6d\n", tb_u_n, tb_v_n, tb_u_np1, tb_v_np1,
               //"\t\t\t\t\tres_u_np1=%6d\tres_v_np1=%6d\n",                                res_u_np1,res_v_np1,
            //);
   //end

   assign war_X = 1'b0;
   assign war_Y = 1'b0;
   assign war_u = 1'b0;
   assign war_v = 1'b0;
   assign err_X = 1'b0;
   assign err_Y = 1'b0;
   assign err_u = 1'b0;
   assign err_v = 1'b0;
   assign delta_X = 0.0;
   assign delta_Y = 0.0;
   assign delta_u = 0.0;
   assign delta_v = 0.0;
   assign max_delta_X = 0.0;
   assign min_delta_X = 0.0;
   assign max_delta_Y = 0.0;
   assign min_delta_Y = 0.0;
   assign max_delta_u = 0.0;
   assign min_delta_u = 0.0;
   assign max_delta_v = 0.0;
   assign min_delta_v = 0.0;

   //always @(posedge clk or posedge arst) begin
      //if (arst==1'b1) begin
         //max_delta_X <= 0.0;
         //min_delta_X <= 0.0;
         //max_delta_Y <= 0.0;
         //min_delta_Y <= 0.0;
         //max_delta_u <= 0.0;
         //min_delta_u <= 0.0;
         //max_delta_v <= 0.0;
         //min_delta_v <= 0.0;
      //end
      //else begin
         //if (srst==1'b1) begin
            //max_delta_X <= 0.0;
            //min_delta_X <= 0.0;
            //max_delta_Y <= 0.0;
            //min_delta_Y <= 0.0;
            //max_delta_u <= 0.0;
            //min_delta_u <= 0.0;
            //max_delta_v <= 0.0;
            //min_delta_v <= 0.0;
         //end
         //else if (enable==1'b1) begin
            //if ( $signed(delta_X) > $signed(max_delta_X) )
               //max_delta_X <= delta_X;
            //else
               //max_delta_X <= max_delta_X;

            //if ( $signed(delta_X) < $signed(min_delta_X) )
               //min_delta_X <= delta_X;
            //else
               //min_delta_X <= min_delta_X;

            //if ( $signed(delta_Y) < $signed(min_delta_Y) )
               //max_delta_Y <= delta_Y;
            //else
               //max_delta_Y <= max_delta_Y;

            //if ( $signed(delta_Y) < $signed(min_delta_Y) )
               //min_delta_Y <= delta_Y;
            //else
               //min_delta_Y <= min_delta_Y;

            //if ( $signed(delta_u) < $signed(min_delta_u) )
               //max_delta_u <= delta_u;
            //else
               //max_delta_u <= max_delta_u;

            //if ( $signed(delta_u) < $signed(min_delta_u) )
               //min_delta_u <= delta_u;
            //else
               //min_delta_u <= min_delta_u;

            //if ( $signed(delta_v) < $signed(min_delta_v) )
               //max_delta_v <= delta_v;
            //else
               //max_delta_v <= max_delta_v;

            //if ( $signed(delta_v) < $signed(min_delta_v) )
               //min_delta_v <= delta_v;
            //else
               //min_delta_v <= min_delta_v;

         //end
      //end
   //end

   // -----------------------------------------------------

// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

