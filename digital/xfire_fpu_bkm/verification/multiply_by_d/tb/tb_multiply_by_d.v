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
// Testbench for multiply_by_d block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_multiply_by_d.v
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
`define W 16
`define CNT_SIZE 2*`W+4

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_multiply_by_d ();
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
   reg            [1:0]    tb_d_x;
   reg            [1:0]    tb_d_y;
   reg   signed   [W-1:0]  tb_x_in;
   reg   signed   [W-1:0]  tb_y_in;
   reg   signed   [W-1:0]  tb_x_out;
   reg   signed   [W-1:0]  tb_y_out;

   reg            [CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire  signed   [W-1:0]  res_x;
   wire  signed   [W-1:0]  res_y;
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
      $monitor("Time = %8t tb_d_x = %b tb_d_y = %b tb_x_in = %d tb_y_in = %d tb_x_out = %d tb_y_out = %d res_x = %d res_y = %d\n",$time, tb_d_x, tb_d_y, tb_x_in, tb_y_in, tb_x_out, tb_y_out, res_x, res_y);
      //$dumpfile("../waves/tb_multiply_by_d.vcd");
      //$dumpvars();
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
   multiply_by_d #(
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
      .x_in       (tb_x_in),
      .y_in       (tb_y_in),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .x_out      (res_x),
      .y_out      (res_y)
  );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

