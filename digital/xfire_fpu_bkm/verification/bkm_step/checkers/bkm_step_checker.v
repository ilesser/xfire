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
// Checker for bkm_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_step_checker.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-11 - ilesser - Added min and max of delta signals.
//    - 2016-08-11 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_step_checker #(
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
   input wire  [WC-1:0]     tb_u_n,
   input wire  [WC-1:0]     tb_v_n,
   input wire  [WC-1:0]     tb_u_np1,
   input wire  [WC-1:0]     tb_v_np1,
   input wire  [WC-1:0]     res_u_np1,
   input wire  [WC-1:0]     res_v_np1,
   input wire  [WD-1:0]     tb_X_n,
   input wire  [WD-1:0]     tb_Y_n,
   input wire  [WD-1:0]     tb_X_np1,
   input wire  [WD-1:0]     tb_Y_np1,
   input wire  [WD-1:0]     res_X_np1,
   input wire  [WD-1:0]     res_Y_np1,
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
   wire  [1:0]             tb_d_u_n,      tb_d_v_n;
   reg   signed [WD-1:0]   max_delta_X,   max_delta_Y;
   reg   signed [WD-1:0]   min_delta_X,   min_delta_Y;
   reg   signed [WC-1:0]   max_delta_u,   max_delta_v;
   reg   signed [WC-1:0]   min_delta_u,   min_delta_v;
   // -----------------------------------------------------

   initial begin
      $monitor("Time = %8t",                                               $time,
               "\ttb_mode=%b",                                             tb_mode,
               "\ttb_format=%b",                                           tb_format,
               "\ttb_n=%b",                                                tb_n,
               "\ttb_d_x_n=%b\ttb_d_y_n=%b\n",                             tb_d_x_n, tb_d_y_n,
               "\ttb_X_n=%6d\ttb_Y_n=%6d\t tb_X_np1=%6d\t tb_Y_np1=%6d\n", tb_X_n, tb_Y_n, tb_X_np1, tb_Y_np1,
               "\t\t\t\t\tres_X_np1=%6d\tres_Y_np1=%6d\n",                                res_X_np1,res_Y_np1,
               "\ttb_u_n=%6d\ttb_v_n=%6d\t tb_u_np1=%6d\t tb_v_np1=%6d\n", tb_u_n, tb_v_n, tb_u_np1, tb_v_np1,
               "\t\t\t\t\tres_u_np1=%6d\tres_v_np1=%6d\n",                                res_u_np1,res_v_np1,
            );
   end

   assign tb_d_u_n = tb_d_x_n;
   assign tb_d_v_n = tb_d_y_n;

   always @(posedge clk or posedge arst) begin
      if (arst==1'b1) begin
         max_delta_X <= {WD{1'b0}};
         min_delta_X <= {WD{1'b0}};
         max_delta_Y <= {WD{1'b0}};
         min_delta_Y <= {WD{1'b0}};
         max_delta_u <= {WC{1'b0}};
         min_delta_u <= {WC{1'b0}};
         max_delta_v <= {WC{1'b0}};
         min_delta_v <= {WC{1'b0}};
      end
      else begin
         if (srst==1'b1) begin
            max_delta_X <= {WD{1'b0}};
            min_delta_X <= {WD{1'b0}};
            max_delta_Y <= {WD{1'b0}};
            min_delta_Y <= {WD{1'b0}};
            max_delta_u <= {WC{1'b0}};
            min_delta_u <= {WC{1'b0}};
            max_delta_v <= {WC{1'b0}};
            min_delta_v <= {WC{1'b0}};
         end
         else if (enable==1'b1) begin
            if ( $signed(delta_X) > $signed(max_delta_X) )
               max_delta_X <= delta_X;
            else
               max_delta_X <= max_delta_X;

            if ( $signed(delta_X) < $signed(min_delta_X) )
               min_delta_X <= delta_X;
            else
               min_delta_X <= min_delta_X;

            if ( $signed(delta_Y) < $signed(min_delta_Y) )
               max_delta_Y <= delta_Y;
            else
               max_delta_Y <= max_delta_Y;

            if ( $signed(delta_Y) < $signed(min_delta_Y) )
               min_delta_Y <= delta_Y;
            else
               min_delta_Y <= min_delta_Y;

            if ( $signed(delta_u) < $signed(min_delta_u) )
               max_delta_u <= delta_u;
            else
               max_delta_u <= max_delta_u;

            if ( $signed(delta_u) < $signed(min_delta_u) )
               min_delta_u <= delta_u;
            else
               min_delta_u <= min_delta_u;

            if ( $signed(delta_v) < $signed(min_delta_v) )
               max_delta_v <= delta_v;
            else
               max_delta_v <= max_delta_v;

            if ( $signed(delta_v) < $signed(min_delta_v) )
               min_delta_v <= delta_v;
            else
               min_delta_v <= min_delta_v;

         end
      end
   end

   bkm_control_step_checker #(
      .W          (WC)
   ) bkm_control_checker (
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
      .tb_mode    (tb_mode),
      .tb_format  (tb_format),
      .tb_n       (tb_n),
      .tb_d_u_n   (tb_d_u_n),
      .tb_d_v_n   (tb_d_v_n),
      .tb_u_n     (tb_u_n),
      .tb_v_n     (tb_v_n),
      .tb_u_np1   (tb_u_np1),
      .tb_v_np1   (tb_v_np1),
      .res_u_np1  (res_u_np1),
      .res_v_np1  (res_v_np1),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .war_u      (war_u),
      .war_v      (war_v),
      .err_u      (err_u),
      .err_v      (err_v),
      .delta_u    (delta_u),
      .delta_v    (delta_v)
   );

   bkm_data_step_checker #(
      .W          (WD)
   ) bkm_data_checker (
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
      .tb_mode    (tb_mode),
      .tb_format  (tb_format),
      .tb_n       (tb_n),
      .tb_d_x_n   (tb_d_x_n),
      .tb_d_y_n   (tb_d_y_n),
      .tb_X_n     (tb_X_n),
      .tb_Y_n     (tb_Y_n),
      .tb_X_np1   (tb_X_np1),
      .tb_Y_np1   (tb_Y_np1),
      .res_X_np1  (res_X_np1),
      .res_Y_np1  (res_Y_np1),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .war_X      (war_X),
      .war_Y      (war_Y),
      .err_X      (err_X),
      .err_Y      (err_Y),
      .delta_X    (delta_X),
      .delta_Y    (delta_Y)
   );
   // -----------------------------------------------------

// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

