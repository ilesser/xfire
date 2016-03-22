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
// Testbench for the bin2csd module.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_bin2csd.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-03-02 - ilesser  - First version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_bin2csd ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   localparam        W=4;
   reg   [W-1:0]     tb_x;
   reg   [2*W-1:0]   res;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire  [2*W-1:0]   wire_y;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) duv (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (tb_x),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (wire_y)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // TB Control
   // -----------------------------------------------------
   initial begin
      $monitor ("Time = %8t tb_x = %b \twire_y = %b B = %b\n\t\t\t\tres    = %b\n\n",$time, tb_x, wire_y, duv.B, res);
      $dumpfile("tb_bin2csd.vcd");
      $dumpvars(:,   tb_bin2csd);
      //$dumpvars(0,   tb_bin2csd);
      //$dumpvars(1,   duv.cxB,
      //               duv.cyB,
      //               duv.sxB,
      //               duv.syB);
      #1    tb_x = 4'b0000;   res = 8'b00000000;
      #1    tb_x = 4'b0001;   res = 8'b00000001;
      #1    tb_x = 4'b0010;   res = 8'b00000100;
      #1    tb_x = 4'b0100;   res = 8'b00010000;
      #1    tb_x = 4'b1000;   res = 8'b01000000;
      #1    tb_x = 4'b0110;   res = 8'b01001100;
      #1    tb_x = 4'b0111;   res = 8'b01000011;
      #10   $finish;     //finish after 20 time units
   end

// *****************************************************************************

endmodule
