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
// Testbench for bkm_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_bkm_step.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-13 - ilesser - Implemented real number model.
//    - 2016-09-05 - ilesser - Added parenthesis to parameters.
//    - 2016-08-22 - ilesser - Added guard bits.
//    - 2016-08-22 - ilesser - Added min/max deltas to tb.
//    - 2016-08-15 - ilesser - Updated indentation.
//    - 2016-08-15 - ilesser - Changed some regs to wires.
//    - 2016-07-06 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define N      64
`define LOG2N   6
`define W      64
`define LOG2W   6
`define WI     11

`define UGD     2
`define LGD    `LOG2W
`define WDI    (`UGD   + `WI )
`define WDF    (`W-`WI + `LGD)
`define WD     (`WDI   + `WDF)
`define LOG2WD  7

`define UGC     3
`define LGC     4
`define WCI    (`UGC   + `WI )
`define WCF    (  4    + `LGC)
`define WC     (`WCI   + `WCF)
`define LOG2WC  5

`define M_SIZE  1
`define F_SIZE  2
`define D_SIZE  2
`define CNT_SIZE (`M_SIZE+`F_SIZE+`D_SIZE+`D_SIZE+`LOG2N+4*(`WC)+4*(`WD))

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_bkm_step ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   wire                    clk;
   reg                     arst, srst, ena, load;
   wire                    err_X,         err_Y;
   wire                    war_X,         war_Y;
   wire                    err_u,         err_v;
   wire                    war_u,         war_v;
   reg                     tb_mode;
   reg   [1:0]             tb_format;
   reg   [`LOG2N-1:0]      tb_n;
   reg   [1:0]             tb_d_x_n,      tb_d_y_n;
   real                    tb_X_n,        tb_Y_n;
   real                    tb_lut_X_n,    tb_lut_Y_n;
   real                    tb_X_np1,      tb_Y_np1;
   real                    tb_u_n,        tb_v_n;
   real                    tb_lut_u_n,    tb_lut_v_n;
   real                    tb_u_np1,      tb_v_np1;
   reg   [`CNT_SIZE-1:0]   cnt, cnt_load, cnt_step;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire  [2*`WD-1:0]       X_n_csd,       Y_n_csd;
   wire  [2*`WD-1:0]       X_np1_csd,     Y_np1_csd;
   wire  [2*`WD-1:0]       lut_X_n_csd,   lut_Y_n_csd;
   real                    res_X_np1,     res_Y_np1;
   real                    delta_X,       delta_Y;
   real                    min_delta_X,   min_delta_Y;
   real                    max_delta_X,   max_delta_Y;

   wire  [`WC-1:0]         u_n_bin,       v_n_bin;
   wire  [`WC-1:0]         u_np1_bin,     v_np1_bin;
   wire  [`WC-1:0]         lut_u_n_bin,   lut_v_n_bin;
   real                    res_u_np1,     res_v_np1;
   real                    delta_u,       delta_v;
   real                    min_delta_u,   min_delta_v;
   real                    max_delta_u,   max_delta_v;
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
   bkm_step_driver #(
      .CNT        (`CNT_SIZE),
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
      .tb_X_n     (tb_X_n),
      .tb_Y_n     (tb_Y_n),
      .tb_u_n     (tb_u_n),
      .tb_v_n     (tb_v_n),
      .tb_lut_X_n (tb_lut_X_n),
      .tb_lut_Y_n (tb_lut_Y_n),
      .tb_lut_u_n (tb_lut_u_n),
      .tb_lut_v_n (tb_lut_v_n),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_n_csd    (X_n_csd),
      .Y_n_csd    (Y_n_csd),
      .u_n_bin    (u_n_bin),
      .v_n_bin    (v_n_bin),
      .lut_X_n_csd(lut_X_n_csd),
      .lut_Y_n_csd(lut_Y_n_csd),
      .lut_u_n_bin(lut_u_n_bin),
      .lut_v_n_bin(lut_v_n_bin)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   bkm_step_monitor #(
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
      .X_np1_csd  (X_np1_csd),
      .Y_np1_csd  (Y_np1_csd),
      .u_np1_bin  (u_np1_bin),
      .v_np1_bin  (v_np1_bin),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .res_X_np1  (res_X_np1),
      .res_Y_np1  (res_Y_np1),
      .res_u_np1  (res_u_np1),
      .res_v_np1  (res_v_np1)
   );

   // Dump waveforms from testbench if using iverilog
   `ifdef IVERILOG
      initial begin
         $dumpfile("../waves/tb_bkm_steps.vcd");
         $dumpvars();
      end
   `endif
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   bkm_step_checker #(
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
      .tb_mode    (tb_mode),
      .tb_format  (tb_format),
      .tb_n       (tb_n),
      .tb_d_x_n   (tb_d_x_n),
      .tb_d_y_n   (tb_d_y_n),
      .tb_u_n     (tb_u_n),
      .tb_v_n     (tb_v_n),
      .tb_u_np1   (tb_u_np1),
      .tb_v_np1   (tb_v_np1),
      .res_u_np1  (res_u_np1),
      .res_v_np1  (res_v_np1),
      .tb_X_n     (tb_X_n),
      .tb_Y_n     (tb_Y_n),
      .tb_X_np1   (tb_X_np1),
      .tb_Y_np1   (tb_Y_np1),
      .res_X_np1  (res_X_np1),
      .res_Y_np1  (res_Y_np1),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .war_u         (war_u),
      .war_v         (war_v),
      .err_u         (err_u),
      .err_v         (err_v),
      .delta_u       (delta_u),
      .delta_v       (delta_v),
      .min_delta_u   (min_delta_u),
      .min_delta_v   (min_delta_v),
      .max_delta_u   (max_delta_u),
      .max_delta_v   (max_delta_v),
      .war_X         (war_X),
      .war_Y         (war_Y),
      .err_X         (err_X),
      .err_Y         (err_Y),
      .delta_X       (delta_X),
      .delta_Y       (delta_Y),
      .min_delta_X   (min_delta_X),
      .min_delta_Y   (min_delta_Y),
      .max_delta_X   (max_delta_X),
      .max_delta_Y   (max_delta_Y)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   bkm_step #(
      .WC         (`WC),
      .WD         (`WD),
      .LOG2WC     (`LOG2WC),
      .LOG2WD     (`LOG2WD),
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
      .d_x_n      (tb_d_x_n),
      .d_y_n      (tb_d_y_n),
      .X_n        (X_n_csd),
      .Y_n        (Y_n_csd),
      .lut_X      (lut_X_n_csd),
      .lut_Y      (lut_Y_n_csd),
      .u_n        (u_n_bin),
      .v_n        (v_n_bin),
      .lut_u      (lut_u_n_bin),
      .lut_v      (lut_v_n_bin),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_np1      (X_np1_csd),
      .Y_np1      (Y_np1_csd),
      .u_np1      (u_np1_bin),
      .v_np1      (v_np1_bin)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

