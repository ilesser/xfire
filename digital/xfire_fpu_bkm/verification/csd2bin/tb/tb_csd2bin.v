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
// Testbench for the csd2bin module.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_csd2bin.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-03 - ilesser - Changed architecture to automatically generate results.
//    - 2016-06-13 - ilesser - Added sequential test.
//    - 2016-04-18 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps

`define W         15
`define WCSD      2*`W
`define CNT_SIZE  `WCSD

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_csd2bin ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   reg                     rst, ena;
   reg   [2*`W-1:0]        tb_x_csd;
   reg   [`W-1:0]          tb_x_bin;
   reg   [`CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire                    clk;
   wire  [`W-1:0]          res_x_bin;
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
          cnt <= {`CNT_SIZE{1'b0}} ;
       end else if (ena) begin
          cnt <= cnt + 1;
       end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   initial begin
      $monitor("Time = %8t tb_x_bin = %b\ttb_x_bin =\t%b\n\t\t\t\t\tres_x_bin =\t\t%b\n\n",$time, tb_x_csd, tb_x_bin, res_x_bin);
      $dumpfile("../waves/tb_csd2bin.vcd");
      $dumpvars();
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   always @(posedge clk) begin
      if (ena == 1'b1) begin
         if (tb_x_bin !== res_x_bin) begin
            $display("[%0d] ERROR: Different conversion!\tExpected result:\t%b\n\t\t\t\t\tObtained result:\t%b. Instance: %m",$time, tb_x_bin, res_x_bin);
            add_error();
            //$finish();
         end
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (`W)
   ) duv (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_x_csd),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (res_x_bin)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

