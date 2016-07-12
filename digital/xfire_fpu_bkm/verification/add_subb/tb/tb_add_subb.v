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
// Testbench for add_subb block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_add_subb.v
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

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_add_subb ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   localparam              W = `W;
   localparam              CNT_SIZE = 2 * `W + 2;
   wire                    clk;
   reg                     rst, ena;
   reg                     tb_subb_a;
   reg                     tb_subb_b;
   reg   signed   [W-1:0]  tb_a;
   reg   signed   [W-1:0]  tb_b;
   reg                     tb_c;
   reg   signed   [W-1:0]  tb_s;
   reg            [CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbench wiring
   // -----------------------------------------------------
   wire                    c_res;
   wire  signed   [W-1:0]  s_res;
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
      $monitor("Time = %8t subb_a = %b subb_b = %b tb_a = %6d tb_b = %6d tb_s = %b %6d s_res = %b %6d\n",$time, tb_subb_a, tb_subb_b, tb_a, tb_b, tb_c, tb_s, c_res, s_res);
      $dumpfile("../waves/tb_add_subb.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_s !== s_res) begin
            $display("[%0d] ERROR: Different sum! Expected result: %b %b\n\t\t\t\t Obtained result: %b %b\t\t. Instance: %m",$time, tb_c, tb_s, c_res, s_res);
            add_error();
            finish_sim();
         end
      end
   end

   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_c !== c_res) begin
            $display("\t\t\t\t\t\t    %b", tb_a);
            $display("\t\t\t\t\t\t  + %b", tb_b);
            $display("\t\t\t\t\t\t --------");
            $display("[%0d] WARNING: Different carry! Expected result: %b %b\n\t\t\t\t Obtained result: %b %b\t\t. Instance: %m",$time, tb_c, tb_s, c_res, s_res);
            add_warning();
         end
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   add_subb #(
      .W(W)
   ) duv (
      .subb_a  (tb_subb_a),
      .subb_b  (tb_subb_b),
      .a       (tb_a),
      .b       (tb_b),
      .c       (c_res),
      .s       (s_res)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

