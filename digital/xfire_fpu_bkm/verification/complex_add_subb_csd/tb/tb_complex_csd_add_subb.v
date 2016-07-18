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
// Testbench for complex_csd_add_subb block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_complex_csd_add_subb.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-06 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define W 4
`define CNT_SIZE (4*`W)+2

`include "/home/ilesser/simlib/simlib_defs.vh"
// *****************************************************************************
// Interface
// *****************************************************************************
module tb_complex_csd_add_subb ();
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
   reg                     err_x, err_y;
   reg                     war_x, war_y;
   reg                     tb_subb_a;
   reg                     tb_subb_b;
   reg   [W-1:0]           tb_a_x;
   reg   [W-1:0]           tb_a_y;
   reg   [W-1:0]           tb_b_x;
   reg   [W-1:0]           tb_b_y;
   reg                     tb_c_x;
   reg                     tb_c_y;
   reg   [W-1:0]           tb_s_x;
   reg   [W-1:0]           tb_s_y;
   reg   [`CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire                    res_c_x;
   wire                    res_c_y;
   wire  [W-1:0]           res_s_x;
   wire  [W-1:0]           res_s_y;
   wire  [2*W-1:0]         a_x_csd;
   wire  [2*W-1:0]         a_y_csd;
   wire  [2*W-1:0]         b_x_csd;
   wire  [2*W-1:0]         b_y_csd;
   wire  [1:0]             c_x_csd;
   wire  [1:0]             c_y_csd;
   wire  [2*W-1:0]         s_x_csd;
   wire  [2*W-1:0]         s_y_csd;
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
   ) bin2csd_a_x (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_a_x),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (a_x_csd)
   );

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_a_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_a_y),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (a_y_csd)
   );

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_b_x (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_b_x),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (b_x_csd)
   );

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_b_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_b_y),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (b_y_csd)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1)
   ) csd2bin_c_x (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   ({c_x_csd,s_x_csd}),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   ({res_c_x,res_s_x})
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_c_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   ({c_y_csd,s_y_csd}),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   ({res_c_y, res_s_y})
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t tb_subb_a = %b tb_subb_b=%b tb_a_x = %d tb_a_y = %d tb_b_x = %d tb_b_y = %d tb_s_x = %b %d tb_s_y %b %d res_s_x = %b %d res_s_y = %b %d\n",$time, tb_subb_a, tb_subb_b, tb_a_x, tb_a_y, tb_b_x, tb_b_y, tb_c_x, tb_s_x, tb_c_y, tb_s_y, res_c_x, res_s_x, res_c_y, res_s_y);
      $dumpfile("../waves/tb_complex_csd_add_subb.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_s_x != res_s_x) begin
            $display("\t\t\t\t\t\t    %b", tb_a_x);
            $display("\t\t\t\t\t\t  + %b", tb_b_x);
            $display("\t\t\t\t\t\t --------");
            $display("[%0d] ERROR: Different sum in X!\tExpected result: %b %b\n\t\t\t\tObtained result: %b %b\t\t. Instance: %m",$time, tb_c_x, tb_s_x, res_c_x, res_s_x);
            add_error();
            //finish_sim();
            err_x = 1'b1;
         end
         else
            err_x = 1'b0;
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_c_x!= res_c_x) begin
            $display("\t\t\t\t\t\t    %b", tb_a_x);
            $display("\t\t\t\t\t\t  + %b", tb_b_x);
            $display("\t\t\t\t\t\t --------");
            $display("[%0d] WARNING: Different carry in X! Expected result: %b %b\n\t\t\t\t Obtained result: %b %b\t\t. Instance: %m",$time, tb_c_x, tb_s_x, res_c_x, res_s_x);
            add_warning();
            war_x = 1'b1;
         end
         else
            war_x = 1'b0;
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_s_y != res_s_y) begin
            $display("\t\t\t\t\t\t    %b", tb_a_y);
            $display("\t\t\t\t\t\t  + %b", tb_b_y);
            $display("\t\t\t\t\t\t --------");
            $display("[%0d] ERROR: Different sum in Y!\tExpected result: %b %b\n\t\t\t\tObtained result: %b %b\t\t. Instance: %m",$time, tb_c_y, tb_s_y, res_c_y, res_s_y);
            add_error();
            //finish_sim();
            err_y = 1'b1;
         end
         else
            err_y = 1'b0;
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_c_y!= res_c_y) begin
            $display("\t\t\t\t\t\t    %b", tb_a_y);
            $display("\t\t\t\t\t\t  + %b", tb_b_y);
            $display("\t\t\t\t\t\t --------");
            $display("[%0d] WARNING: Different carry in X! Expected result: %b %b\n\t\t\t\t Obtained result: %b %b\t\t. Instance: %m",$time, tb_c_y, tb_s_y, res_c_y, res_s_y);
            add_warning();
            war_y = 1'b1;
         end
         else
            war_y = 1'b0;
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   complex_csd_add_subb #(
      .W(W)
   ) duv (
      .subb_a_x   (tb_subb_a),
      .subb_a_y   (tb_subb_a),
      .subb_b_x   (tb_subb_b),
      .subb_b_y   (tb_subb_b),
      .a_x        (a_x_csd),
      .a_y        (a_y_csd),
      .b_x        (b_x_csd),
      .b_y        (b_y_csd),
      .c_x        (c_x_csd),
      .c_y        (c_y_csd),
      .s_x        (s_x_csd),
      .s_y        (s_y_csd)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule
