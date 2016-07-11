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
// Testbench for multiply_by_d_csd block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_multiply_by_d_csd.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-05-17 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define W 4
`define CNT_SIZE 2*`W+4

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_multiply_by_d_csd ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   localparam                 W = `W;
   localparam                 CNT_SIZE = `CNT_SIZE;
   wire                       clk;
   reg                        rst, ena;
   reg       [CNT_SIZE-1:0]   cnt;
   reg                        err_x,      err_y;
   reg            [1:0]       tb_d_x,     tb_d_y;
   reg   signed   [W-1:0]     tb_x_in,    tb_y_in;
   reg   signed   [W-1:0]     tb_x_out,   tb_y_out;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire  signed   [W-1:0]     res_x,      res_y;
   wire  signed   [2*W-1:0]   x_in_csd,   y_in_csd;
   wire  signed   [2*W-1:0]   x_out_csd,  y_out_csd;
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

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_x (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_x_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (x_in_csd)
   );

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_y_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (y_in_csd)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_x (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (x_out_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (res_x)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (y_out_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (res_y)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t tb_d_x = %b tb_d_y = %b tb_x_in = %d tb_y_in = %d tb_x_out = %d tb_y_out = %d res_x = %d res_y = %d\n",$time, tb_d_x, tb_d_y, tb_x_in, tb_y_in, tb_x_out, tb_y_out, res_x, res_y);
      $dumpfile("../waves/tb_multiply_by_d_csd.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_x_out != res_x) begin
            $display("[%0d] ERROR: In X. Expected result: %b\n\t\t\t Obtained result: %b\t\t. Instance: %m",$time, tb_x_out, res_x);
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
         if (tb_y_out != res_y) begin
            $display("[%0d] ERROR: In Y. Expected result: %b\n\t\t\t Obtained result: %b\t\t. Instance: %m",$time, tb_y_out, res_y);
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
   multiply_by_d_csd #(
      // ----------------------------------
      // Parameters
      // ----------------------------------
      .W       (`W)
   ) duv (
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .d_x        (tb_d_x),
      .d_y        (tb_d_y),
      .x_in       (x_in_csd),
      .y_in       (y_in_csd),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .x_out      (x_out_csd),
      .y_out      (y_out_csd)
  );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

