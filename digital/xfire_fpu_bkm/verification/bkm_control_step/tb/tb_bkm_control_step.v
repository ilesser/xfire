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
//    - 2016-08-15 - ilesser - Updated to use WD and WC.
//    - 2016-08-11 - ilesser - Added driver and monitor to make tb nicer.
//    - 2016-08-02 - ilesser - Changed the definition of W.
//    - 2016-08-02 - ilesser - Added parallel load to the counter.
//    - 2016-07-25 - ilesser - Added checker.
//    - 2016-07-23 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define N      16
`define W      16
`define WD     16 //`W
`define WC      4 //`W/4
`define LOG2N   4
`define LOG2W   4
`define LOG2WD `LOG2W
`define LOG2WC `LOG2W-2
`define M_SIZE  1
`define F_SIZE  2
`define D_SIZE  2
`define CNT_SIZE `M_SIZE+`F_SIZE+`D_SIZE+`D_SIZE+`LOG2N+4*(`WC)

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
   wire                    clk;
   reg                     arst, srst, ena, load;
   reg                     tb_mode;
   reg   [1:0]             tb_format;
   reg   [`LOG2N-1:0]      tb_n;
   reg   [1:0]             tb_d_u_n;
   reg   [1:0]             tb_d_v_n;
   reg   [`WC-1:0]         tb_u_n,     tb_v_n;
   reg   [`WC-1:0]         tb_lut_u_n, tb_lut_v_n;
   reg   [`WC-1:0]         tb_u_np1,   tb_v_np1;
   reg   [`CNT_SIZE-1:0]   cnt, cnt_load, cnt_step;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire  [`WC-1:0]         res_u_np1,  res_v_np1;

   // Checker wiring
   wire                    err_u,   err_v;
   wire                    war_u,   war_v;
   wire  [`WC-1:0]         delta_u, delta_v;
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
      end
      else if (ena) begin
         if (load)
            cnt <= cnt_load;
         else
          cnt <= cnt + cnt_step;
       end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   // Uncomment these lines to add waveforms to iverilog simulation
   initial begin
      $dumpfile("../waves/tb_bkm_control_step.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   bkm_control_step_checker #(
      .W          (`WC)
   ) duv_checker (
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
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   bkm_control_step #(
      .W          (`WC),
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
      .u_n        (tb_u_n),
      .v_n        (tb_v_n),
      .lut_u_n    (tb_lut_u_n),
      .lut_v_n    (tb_lut_v_n),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .u_np1      (res_u_np1),
      .v_np1      (res_v_np1)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

