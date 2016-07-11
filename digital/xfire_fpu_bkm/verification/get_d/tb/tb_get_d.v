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
// Testbench for get_d block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_get_d.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-10 - ilesser - Changed architecture and updated limits.
//    - 2016-05-17 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define W 8
`define CNT_SIZE `W+1

`include "bkm_defs.vh"
`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_get_d ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   localparam                    W = `W;
   localparam                    CNT_SIZE = `CNT_SIZE;
   wire                          clk;
   reg                           rst, ena;
   reg                           err_x, err_y;
   reg            [CNT_SIZE-1:0] cnt;
   reg                           tb_mode;
   reg   signed   [W-1:0]        tb_u;
   reg   signed   [W-1:0]        tb_v;
   reg   signed   [1:0]          tb_d_x;
   reg   signed   [1:0]          tb_d_y;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbench wiring
   // -----------------------------------------------------
   wire  signed   [1:0]          res_d_x;
   wire  signed   [1:0]          res_d_y;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Transactors
   // -----------------------------------------------------
   simlib_clk_osc #(
      // ----------------------------------------------
      // Parameters
      // ----------------------------------------------
      .CLK_PERIOD_NS    (`SIM_CLK_PERIOD_NS)
   ) clk_osc (
      // ----------------------------------------------
      // Ports in
      // ----------------------------------------------
      .stop             (1'b0),
      // ----------------------------------------------
      // Ports out
      // ----------------------------------------------
      .clk_out          (clk)
   );

   always @(posedge clk)
       if (rst) begin
          cnt <= `CNT_SIZE'd0;
       end else if (ena) begin
          cnt <= cnt + 1;
       end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t tb_u = %d tb_v = %d tb_d_x = %d tb_d_y = %d res_d_x = %d res_d_y = %d\n",$time, tb_u, tb_v, tb_d_x, tb_d_y, res_d_x, res_d_y);
      $dumpfile("../waves/tb_get_d_n.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_d_x != res_d_x) begin
            $display("[%0d] ERROR: Different d_x! Expected result: %d \n\t\t\t\t Obtained result: %d\t\t. Instance: %m",$time, tb_d_x, res_d_x);
            add_error();
            err_x = 1'b1;
            //finish_sim();
         end
         else
            err_x = 1'b0;
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_d_y != res_d_y) begin
            $display("[%0d] ERROR: Different d_y! Expected result: %d \n\t\t\t\t Obtained result: %d\t\t. Instance: %m",$time, tb_d_y, res_d_y);
            add_error();
            err_y = 1'b1;
            //finish_sim();
         end
         else
            err_y = 1'b0;
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   get_d #(
      .W(W)
   ) duv (
      .mode    (tb_mode),
      .u       (tb_u),
      .v       (tb_v),
      .d_x     (res_d_x),
      .d_y     (res_d_y)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

