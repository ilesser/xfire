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
// Testbench for bkm_control_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_bkm_control_step.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-23 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define W 8
`define N 8
`define LOG2W 3
`define LOG2N 3
`define CNT_SIZE 1+2+2+2+`LOG2W+2*`W

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_bkm_control_step ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   localparam              W = `W;
   wire                    clk;
   reg                     arst, srst, ena;
   reg                     tb_mode;
   reg   [1:0]             tb_format;
   reg   [`LOG2N-1:0]      tb_n;
   reg   [1:0]             tb_d_u_n;
   reg   [1:0]             tb_d_v_n;
   reg   [W-1:0]           tb_u_n,     tb_v_n;
   reg   [W-1:0]           tb_lut_u,   tb_lut_v;
   reg   [W-1:0]           tb_u_np1,   tb_v_np1;
   reg   [`CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire  [2*W-1:0]         u_n_csd,    v_n_csd;
   wire  [2*W-1:0]         u_np1_csd,  v_np1_csd;
   wire  [2*W-1:0]         lut_u_csd,  lut_v_csd;
   wire  [W-1:0]           res_u_np1,  res_v_np1;

   // Checker wiring
   wire                    err_u,   err_v;
   wire                    war_u,   war_v;
   wire  [W-1:0]           delta_u, delta_v;
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
       if (arst==1'b1) begin
          cnt <= {`CNT_SIZE{1'b0}};
       end else if (ena) begin
          cnt <= cnt + 1;
       end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t",                                               $time,
               "\ttb_mode=%b",                                             tb_mode,
               "\ttb_format=%b",                                           tb_format,
               "\ttb_n=%b",                                                tb_n,
               "\ttb_d_u_n=%b\ttb_d_v_n=%b\n",                             tb_d_u_n, tb_d_v_n,
               "\ttb_u_n=%6d\ttb_v_n=%6d\t tb_u_np1=%6d\t tb_v_np1=%6d\n", tb_u_n, tb_v_n, tb_u_np1, tb_v_np1,
               "\t\t\t\t\tres_u_np1=%6d\tres_v_np1=%6d\n",                                res_u_np1,res_v_np1,
            );

      //$dumpfile("../waves/tb_bkm_control_step.vcd");
      //$dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   bkm_control_step_checker #(
      .W          (`W),
      .LOG2W      (`LOG2W),
      .LOG2N      (`LOG2N)
   ) checker (
      // ----------------------------------
      // Clock, reset & enable inputs
      // ----------------------------------
      .clk        (clk),
      .arst       (arst),
      .srst       (srst),
      .enable     (ena),
      // ----------------------------------
      // Data inputs
      // ----------------------------------
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
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   bkm_control_step #(
      .W          (`W),
      .LOG2W      (`LOG2W),
      .LOG2N      (`LOG2N)
   ) duv (
      // ----------------------------------
      // Clock, reset & enable inputs
      // ----------------------------------
      .clk        (clk),
      .arst       (arst),
      .srst       (srst),
      .enable     (ena),
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .mode       (tb_mode),
      .format     (tb_format),
      .n          (tb_n),
      .d_u_n      (tb_d_u_n),
      .d_v_n      (tb_d_v_n),
      .u_n        (u_n_csd),
      .v_n        (v_n_csd),
      .lut_u      (lut_u_csd),
      .lut_v      (lut_v_csd),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .u_np1      (u_np1_csd),
      .v_np1      (v_np1_csd)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

