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
// XXXXX FILL IN HERE XXXXX
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_input_precision_selection.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-05-17 - ilesser - Original version.
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
module tb_input_precision_selection ();
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
   reg                     err_e_x, err_e_y;
   reg                     err_l_x, err_l_y;
   reg            [1:0]    tb_format;
   reg   signed   [W-1:0]  tb_e_x_i, tb_e_y_i;
   reg   signed   [W-1:0]  tb_l_x_i, tb_l_y_i;
   reg   signed   [W-1:0]  tb_e_x_o, tb_e_y_o;
   reg   signed   [W-1:0]  tb_l_x_o, tb_l_y_o;

   reg            [CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire  signed   [W-1:0]  res_e_x, res_e_y;
   wire  signed   [W-1:0]  res_l_x, res_l_y;
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
          cnt <= {CNT_SIZE{1'b0}} ;
          //cnt <= `CNT_SIZE'd0;
       end else if (ena) begin
          cnt <= cnt + 1;
       end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t tb_format = %b tb_e_x = %d tb_e_y = %d tb_l_x = %d tb_l_y = %d res_e_x = %d res_e_y = %d res_l_x = %d res_l_y = %d\n",$time, tb_format, tb_e_x_i, tb_e_y_i, tb_l_x_i, tb_l_y_i, res_e_x, res_e_y, res_l_x, res_l_y);
      $dumpfile("../waves/tb_input_precision_selection.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_e_x_o != res_e_x) begin
            $display("[%0d] ERROR: in E_x. Expected result: %b \n\t\t\t Obtained result:  %b\t\t. Instance: %m",$time, tb_e_x_o, res_e_x);
            add_error();
            //finish_sim();
            err_e_x = 1'b1;
         end
         else
            err_e_x = 1'b0;
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_e_y_o != res_e_y) begin
            $display("[%0d] ERROR: in E_y. Expected result: %b \n\t\t\t Obtained result:  %b\t\t. Instance: %m",$time, tb_e_y_o, res_e_y);
            add_error();
            //finish_sim();
            err_e_y = 1'b1;
         end
         else
            err_e_y = 1'b0;
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_l_x_o != res_l_x) begin
            $display("[%0d] ERROR: in L_x. Expected result: %b \n\t\t\t Obtained result:  %b\t\t. Instance: %m",$time, tb_l_x_o, res_l_x);
            add_error();
            //finish_sim();
            err_l_x = 1'b1;
         end
         else
            err_l_x = 1'b0;
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_l_y_o != res_l_y) begin
            $display("[%0d] ERROR: in L_y. Expected result: %b \n\t\t\t Obtained result:  %b\t\t. Instance: %m",$time, tb_l_y_o, res_l_y);
            add_error();
            //finish_sim();
            err_l_y = 1'b1;
         end
         else
            err_l_y = 1'b0;
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   input_precision_selection #(
      .W(W)
   ) duv (
      .format     (tb_format),
      .E_x_in     (tb_e_x_i),
      .E_y_in     (tb_e_y_i),
      .L_x_in     (tb_l_x_i),
      .L_y_in     (tb_l_y_i),
      .E_x_out    (res_e_x),
      .E_y_out    (res_e_y),
      .L_x_out    (res_l_x),
      .L_y_out    (res_l_y)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

