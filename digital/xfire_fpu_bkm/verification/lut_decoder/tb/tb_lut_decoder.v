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
// Testbench for lut_decoder block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_lut_decoder.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-31 - ilesser - Used real values for luts.
//    - 2016-08-25 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define W      64
`define LOG2W   6
`define WI     11

`define UGD     2
`define LGD    `LOG2W
`define WDI    (`UGD + `WI)
`define WDF    (`W-`WI+`LGD)
`define WD     (`WDI + `WDF)
`define LOG2WD  7

`define UGC     3
`define LGC     4
`define WCI    (`UGC + `WI)
`define WCF    (  4  + `LGD)
`define WC     (`WCI + `WCF)
`define LOG2WC  5

`define LOG2N   6
`define M_SIZE  1
`define F_SIZE  2
`define D_SIZE  2
`define CNT_SIZE `M_SIZE+`F_SIZE+2*`D_SIZE+`LOG2N

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_lut_decoder ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   reg                     arst, srst, ena, load;
   reg                     tb_mode;
   reg   [1:0]             tb_format;
   reg   [`LOG2N-1:0]      tb_n;
   reg   [1:0]             tb_d_x_n,      tb_d_y_n;
   reg   [`CNT_SIZE-1:0]   cnt, cnt_load, cnt_step;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire                    clk;
   wire                    err_X,         err_Y;
   wire                    war_X,         war_Y;
   wire                    err_u,         err_v;
   wire                    war_u,         war_v;
   wire  [2*`WD-1:0]       lut_X_n_csd,   lut_Y_n_csd;
   wire  [`WC-1:0]         lut_u_n_bin,   lut_v_n_bin;
   real                    delta_X,       delta_Y;
   real                    delta_u,       delta_v;
   real                    max_delta_X,   max_delta_Y;
   real                    max_delta_u,   max_delta_v;
   real                    min_delta_X,   min_delta_Y;
   real                    min_delta_u,   min_delta_v;
   real                    res_lut_X_n,   res_lut_Y_n;
   real                    res_lut_u_n,   res_lut_v_n;
   real                    tb_lut_X_n,    tb_lut_Y_n;
   real                    tb_lut_u_n,    tb_lut_v_n;
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
   // Monitors
   // -----------------------------------------------------
   lut_decoder_monitor #(
      .WD         (`WD),
      .WC         (`WC),
      .WI         (`WI)
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
      .lut_X_n_csd(lut_X_n_csd),
      .lut_Y_n_csd(lut_Y_n_csd),
      .lut_u_n_bin(lut_u_n_bin),
      .lut_v_n_bin(lut_v_n_bin),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .res_lut_X_n(res_lut_X_n),
      .res_lut_Y_n(res_lut_Y_n),
      .res_lut_u_n(res_lut_u_n),
      .res_lut_v_n(res_lut_v_n)
   );

   // Dump waveforms for iverilog simulation
   `ifdef IVERILOG
      initial begin
         $dumpfile("../waves/tb_lut_decoder.vcd");
         $dumpvars();
      end
   `endif
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   lut_decoder_checker #(
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
      .tb_lut_u_n (tb_lut_u_n),
      .tb_lut_v_n (tb_lut_v_n),
      .res_lut_u_n(res_lut_u_n),
      .res_lut_v_n(res_lut_v_n),
      .tb_lut_X_n (tb_lut_X_n),
      .tb_lut_Y_n (tb_lut_Y_n),
      .res_lut_X_n(res_lut_X_n),
      .res_lut_Y_n(res_lut_Y_n),
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
   lut_decoder #(
      .WD         (`WD),
      .WC         (`WC),
      .LOG2N      (`LOG2N)
   ) duv (
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .mode       (tb_mode),
      .format     (tb_format),
      .n          (tb_n),
      .d_x_n      (tb_d_x_n),
      .d_y_n      (tb_d_y_n),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .lut_X      (lut_X_n_csd),
      .lut_Y      (lut_Y_n_csd),
      .lut_u      (lut_u_n_bin),
      .lut_v      (lut_v_n_bin)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

