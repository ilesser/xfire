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
   localparam        W=5;
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

// *****************************************************************************

endmodule