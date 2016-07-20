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
// Barrel shifter CSD testbench.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_barrel_shifter_csd.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-19 - ilesser - Deleted op and shift_t inputs.
//    - 2016-07-18 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define W 8
`define LOG2W 3
`define CNT_SIZE 1+`LOG2W+`W

`include "/home/ilesser/simlib/simlib_defs.vh"
// *****************************************************************************
// Interface
// *****************************************************************************
module tb_barrel_shifter_csd ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   wire                       clk;
   reg                        rst, ena;
   reg                        err,war;
   reg   [`CNT_SIZE-1:0]      cnt;
   reg                        tb_dir;
   reg                        tb_op;
   reg                        tb_shift_t;
   reg   [`LOG2W-1:0]         tb_sel;
   reg   signed   [`W-1:0]    tb_in;
   reg   signed   [`W-1:0]    tb_out;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire           [2*`W-1:0]  in_csd, out_csd;
   wire  signed   [`W-1:0]    res_out;
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
      .W                   (`W)
   ) bin2csd (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (in_csd)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (`W)
   ) csd2bin (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (out_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (res_out)
   );

   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t tb_dir = %b tb_op_x = %b tb_shift_t = %b tb_sel = %d tb_in = %d tb_out = %d res_out = %d\n",$time, tb_dir, tb_op, tb_shift_t, tb_sel, tb_in, tb_out, res_out);
      $dumpfile("../waves/tb_barrel_shifter.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_out !== res_out) begin
            $display("\t\t\t\t\t\t    %b", tb_in );
            $display("\t\t\t\t\t\t    %b", tb_sel);
            $display("\t\t\t\t\t\t -------------");
            $display("[%0d] ERROR: Different result!\tExpected result: %b\n\t\t\t\tObtained result: %b\t\t. Instance: %m",$time, tb_out, res_out);
            add_error();
            err = 1'b1;
            //finish_sim();
         end
         else
            err = 1'b0;
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   barrel_shifter_csd #(
      .W             (`W),
      .LOG2W         (`LOG2W)
   ) duv (
      .dir           (tb_dir),
      //.op            (tb_op),
      //.shift_t       (tb_shift_t),
      .sel           (tb_sel),
      .in            (in_csd),
      .out           (out_csd)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

