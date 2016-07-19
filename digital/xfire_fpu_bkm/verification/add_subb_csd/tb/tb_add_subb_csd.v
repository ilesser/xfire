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
// Testbench for add_subb_csd block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_add_subb_csd.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-18 - ilesser - Renamed to add_subb_csd.
//    - 2016-07-18 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define W 4
`define CNT_SIZE (2*`W)+2

`include "/home/ilesser/simlib/simlib_defs.vh"
// *****************************************************************************
// Interface
// *****************************************************************************
module tb_add_subb_csd ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   localparam              W = `W;
   localparam              CNT_SIZE = `CNT_SIZE;
   wire                    clk;
   reg                     rst, ena;
   reg                     tb_subb_x;
   reg                     tb_subb_y;
   reg   [W-1:0]           tb_x_bin;
   reg   [W-1:0]           tb_y_bin;
   reg   [W-1:0]           tb_z_bin;
   reg                     tb_c_bin;
   reg   [`CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire                    c_bin;
   wire  [W-1:0]           z_bin;
   wire  [2*W-1:0]         x_csd;
   wire  [2*W-1:0]         y_csd;
   wire  [1:0]             c_csd;
   wire  [2*W-1:0]         z_csd;
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
          cnt <= {CNT_SIZE{1'b0}};
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
      .x                   (tb_x_bin),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (x_csd)
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
      .x                   (tb_y_bin),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (y_csd)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1)
   ) csd2bin_z (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   ({c_csd, z_csd}),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   ({c_bin, z_bin})
   );

   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t tb_subb_x = %b tb_subb_y = %b tb_x_bin = %6d tb_y_bin = %6d tb_z_bin = %b %6d z_bin = %b %6d\n",$time, tb_subb_x, tb_subb_y, tb_x_bin, tb_y_bin, tb_c_bin, tb_z_bin, c_bin, z_bin);
      $dumpfile("../waves/tb_csd_add_subb.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_z_bin != z_bin) begin
            $display("\t\t\t\t\t\t    %b", tb_x_bin);
            $display("\t\t\t\t\t\t  + %b", tb_y_bin);
            $display("\t\t\t\t\t\t --------");
            $display("[%0d] ERROR: Different sum!\tExpected result: %b %b\n\t\t\t\tObtained result: %b %b\t\t. Instance: %m",$time, tb_c_bin, tb_z_bin, c_bin, z_bin);
            add_error();
            finish_sim();
         end
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_c_bin != c_bin) begin
            $display("\t\t\t\t\t\t    %b", tb_x_bin);
            $display("\t\t\t\t\t\t  + %b", tb_y_bin);
            $display("\t\t\t\t\t\t --------");
            $display("[%0d] WARNING: Different carry! Expected result: %b %b\n\t\t\t\t Obtained result: %b %b\t\t. Instance: %m",$time, tb_c_bin, tb_z_bin, c_bin, z_bin);
            add_warning();
         end
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   add_subb_csd #(
      .W(W)
   ) duv (
      .subb_a  (tb_subb_x),
      .subb_b  (tb_subb_y),
      .a       (x_csd),
      .b       (y_csd),
      .c       (c_csd),
      .s       (z_csd)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

