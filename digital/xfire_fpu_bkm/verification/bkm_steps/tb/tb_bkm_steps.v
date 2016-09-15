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
// Testbench for bkm_steps block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_bkm_steps.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-14 - ilesser - Instanciated checker and updated parameters.
//    - 2016-09-07 - ilesser - Implemented rolled architcture.
//    - 2016-09-05 - ilesser - WIP: testing bkm_steps_task.
//    - 2016-08-15 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define N      64
`define LOG2N   7
`define W      64
`define LOG2W   6
`define WI     11

`define UGD     2
`define LGD    `LOG2W
`define WDI    (`UGD   + `WI )
`define WDF    (`W-`WI + `LGD)
`define WD     (`WDI   + `WDF)
`define LOG2WD  1+`LOG2W

`define UGC     3
`define LGC     4
`define WCI    (`UGC   + `WI )
`define WCF    (  4    + `LGC)
`define WC     (`WCI   + `WCF)
`define LOG2WC  5

`define M_SIZE  1
`define F_SIZE  2
`define D_SIZE  2
`define CNT_SIZE `M_SIZE+`F_SIZE+2*(`WC)+2*(`WD)

`include "/home/ilesser/simlib/simlib_defs.vh"
`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_bkm_steps ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   reg                     arst, srst, ena, load;
   reg                     float_or_fix;
   reg                     tb_start;
   reg                     tb_mode;
   reg   [1:0]             tb_format;
   real                    tb_X_in,       tb_Y_in;
   real                    tb_u_in,       tb_v_in;
   reg   [`FSIZE-1:0]      tb_flags;
   reg   [`CNT_SIZE-1:0]   cnt, cnt_load, cnt_step;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbench wiring
   // -----------------------------------------------------
   wire                    clk;
   wire                    res_done;
   wire                    err_X,         err_Y;
   wire                    war_X,         war_Y;
   wire                    err_u,         err_v;
   wire                    war_u,         war_v;
   real                    tb_X_out,      tb_Y_out;
   real                    res_X_out,     res_Y_out;
   real                    tb_u_out,      tb_v_out;
   real                    res_u_out,     res_v_out;
   real                    delta_X,       delta_Y;
   real                    delta_u,       delta_v;
   real                    min_delta_X,   min_delta_Y;
   real                    max_delta_X,   max_delta_Y;
   real                    min_delta_u,   min_delta_v;
   real                    max_delta_u,   max_delta_v;
   wire  [2*`WD-1:0]       X_in_csd,      Y_in_csd;
   wire  [2*`WD-1:0]       X_out_csd,     Y_out_csd;
   wire  [`WC-1:0]         u_in_bin,      v_in_bin;
   wire  [`WC-1:0]         u_out_bin,     v_out_bin;
   wire  [`FSIZE-1:0]      res_flags;
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
         if (load)
            cnt <= cnt_load;
         else
            cnt <= cnt + cnt_step;
      end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Drivers
   // -----------------------------------------------------
   bkm_steps_driver #(
      .WD         (`WD),
      .WC         (`WC)
   ) duv_driver (
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
      .float_or_fix  (float_or_fix),
      .tb_mode    (tb_mode),
      .tb_format  (tb_format),
      .tb_X_in    (tb_X_in),
      .tb_Y_in    (tb_Y_in),
      .tb_u_in    (tb_u_in),
      .tb_v_in    (tb_v_in),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_in_csd   (X_in_csd),
      .Y_in_csd   (Y_in_csd),
      .u_in_bin   (u_in_bin),
      .v_in_bin   (v_in_bin)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   bkm_steps_monitor #(
      .WD         (`WD),
      .WC         (`WC)
   ) duv_monitor (
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
      .X_out_csd  (X_out_csd),
      .Y_out_csd  (Y_out_csd),
      .u_out_bin  (u_out_bin),
      .v_out_bin  (v_out_bin),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .res_X_out  (res_X_out),
      .res_Y_out  (res_Y_out),
      .res_u_out  (res_u_out),
      .res_v_out  (res_v_out)
   );

   // Dump waveforms from testbench if using iverilog
   `ifdef IVERILOG
      initial begin
         $dumpfile("../waves/tb_bkm_steps.vcd");
         $dumpvars();
      end
   `endif
/tests/dir_test.v
--- a/digital/xfire_fpu_bkm/verification/bkm_steps/tests/dir_test.v     Wed Sep 14 21:54:27 2016 -0300
+++ b/digital/xfire_fpu_bkm/verification/bkm_steps/tests/dir_test.v     Wed Sep 14 21:54:31 2016 -0300
@@ -46,7 +46,7 @@
    // -----------------------------------------------------
    real  X_r, X_res, X_f;
    reg   [`WI-1:0]   X_int;
-   reg   [`WFD-1:0]  X_frac;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   bkm_steps_checker #(
      .WC         (`WC),
      .WD         (`WD),
      .LOG2N      (`LOG2N)
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
      .tb_start   (tb_start),
      .tb_mode    (tb_mode),
      .tb_format  (tb_format),
      .tb_u_out   (tb_u_out),
      .tb_v_out   (tb_v_out),
      .res_u_out  (res_u_out),
      .res_v_out  (res_v_out),
      .tb_X_out   (tb_X_out),
      .tb_Y_out   (tb_Y_out),
      .res_X_out  (res_X_out),
      .res_Y_out  (res_Y_out),
      .res_done   (res_done),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .war_u      (war_u),
      .war_v      (war_v),
      .err_u      (err_u),
      .err_v      (err_v),
      .delta_u    (delta_u),
      .delta_v    (delta_v),
      .max_delta_u(max_delta_u),
      .min_delta_u(min_delta_u),
      .max_delta_v(max_delta_v),
      .min_delta_v(min_delta_v),
      .war_X      (war_X),
      .war_Y      (war_Y),
      .err_X      (err_X),
      .err_Y      (err_Y),
      .delta_X    (delta_X),
      .delta_Y    (delta_Y),
      .max_delta_X(max_delta_X),
      .min_delta_X(min_delta_X),
      .max_delta_Y(max_delta_Y),
      .min_delta_Y(min_delta_Y)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   bkm_steps #(
      .N          (`N),
      .LOG2N      (`LOG2N),
      .WD         (`WD),
      .LOG2WD     (`LOG2WD),
      .WC         (`WC),
      .LOG2WC     (`LOG2WC)
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
      .start      (tb_start),
      .mode       (tb_mode),
      .format     (tb_format),
      .X_in       (X_in_csd),
      .Y_in       (Y_in_csd),
      .u_in       (u_in_bin),
      .v_in       (v_in_bin),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_out      (X_out_csd),
      .Y_out      (Y_out_csd),
      .u_out      (u_out_bin),
      .v_out      (v_out_bin),
      .flags      (res_flags),
      .done       (res_done)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

