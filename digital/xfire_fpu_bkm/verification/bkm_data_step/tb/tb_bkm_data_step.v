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
// Testbench for bkm_data_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_bkm_data_step.v
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
module tb_bkm_data_step ();
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
   reg                     err_X, err_Y;
   reg                     war_X, war_Y;
   reg                     err_u, err_v;
   reg                     war_u, war_v;
   reg                     tb_mode;
   reg   [1:0]             tb_format;
   reg   [`LOG2N-1:0]      tb_n;
   reg   [1:0]             tb_d_x_n;
   reg   [1:0]             tb_d_y_n;
   reg   [W-1:0]           tb_X_n,     tb_Y_n;
   reg   [W-1:0]           tb_lut_X,   tb_lut_Y;
   reg   [W-1:0]           tb_X_np1,   tb_Y_np1;
   reg   [W-1:0]           delta_X,    delta_Y;
   reg   [`CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire  [2*W-1:0]         X_n_csd,    Y_n_csd;
   wire  [2*W-1:0]         X_np1_csd,  Y_np1_csd;
   wire  [2*W-1:0]         lut_X_csd,  lut_Y_csd;
   wire  [W-1:0]           res_X_np1,  res_Y_np1;
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

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_X (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_X_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (X_n_csd)
   );

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_Y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_Y_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (Y_n_csd)
   );

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_lut_X (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_lut_X),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (lut_X_csd)
   );

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_lut_Y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_lut_Y),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (lut_Y_csd)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_X (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (X_np1_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (res_X_np1)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_Y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (Y_np1_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (res_Y_np1)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t",                                               $time,
               "\ttb_mode=%b",                                             tb_mode,
               "\ttb_format=%b",                                           tb_format,
               "\ttb_n=%b",                                                tb_n,
               "\ttb_d_x_n=%b\ttb_d_y_n=%b\n",                             tb_d_x_n, tb_d_y_n,
               "\ttb_X_n=%6d\ttb_Y_n=%6d\t tb_X_np1=%6d\t tb_Y_np1=%6d\n", tb_X_n, tb_Y_n, tb_X_np1, tb_Y_np1,
               "\t\t\t\t\tres_X_np1=%6d\tres_Y_np1=%6d\n",                                res_X_np1,res_Y_np1,
            );

      //$dumpfile("../waves/tb_bkm_data_step.vcd");
      //$dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------

   bkm_data_step_checker #(
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
      .tb_X_np1   (tb_X_np1),
      .tb_Y_np1   (tb_Y_np1),
      .res_X_np1  (res_X_np1),
      .res_Y_np1  (res_Y_np1),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .err_X      (err_X),
      .err_Y      (err_Y),
      .delta_X    (delta_X),
      .delta_Y    (delta_Y)
   );
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_X    <= 1'b0;
         delta_X  <= {W{1'b0}};
      end
      else begin
         if (ena == 1'b1) begin
            if (tb_X_np1 !== res_X_np1) begin
               $display("[%0d] ERROR: in X.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_X_np1, res_X_np1);
               add_error();
               //finish_sim();
               err_X    <= 1'b1;
               delta_X  <= tb_X_np1 - res_X_np1;
            end
            else begin
               add_note();
               err_X    <= 1'b0;
            end
         end
      end
   end

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_Y    <= 1'b0;
         delta_Y  <= {W{1'b0}};
      end
      else begin
         if (ena == 1'b1) begin
            if (tb_Y_np1 !== res_Y_np1) begin
               $display("[%0d] ERROR: in Y.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_Y_np1, res_Y_np1);
               add_error();
               //finish_sim();
               err_Y    <= 1'b1;
               delta_Y  <= tb_Y_np1 - res_Y_np1;
            end
            else begin
               add_note();
               err_Y    <= 1'b0;
            end
         end
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   bkm_data_step #(
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
      .d_x_n      (tb_d_x_n),
      .d_y_n      (tb_d_y_n),
      .X_n        (X_n_csd),
      .Y_n        (Y_n_csd),
      .lut_X      (lut_X_csd),
      .lut_Y      (lut_Y_csd),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_np1      (X_np1_csd),
      .Y_np1      (Y_np1_csd)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

