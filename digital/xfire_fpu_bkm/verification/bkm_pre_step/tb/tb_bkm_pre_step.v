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
// tb_bkm_pre_step.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-05-17 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS XXXXX
`timescale 1ns/1ps
`include "XXXXXXXX.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_bkm_pre_step ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   reg  [XXXXX-1:0]  tb_XXXXX;
   reg  [XXXXX-1:0]  tb_XXXXX;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire [XXXXX-1:0]  wire_XXXXX;
   wire [XXXXX-1:0]  wire_XXXXX;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Transactors
   // -----------------------------------------------------
   <transactor_name> <transactor_name> (
      <port_mapping>
   );

   <transactor_name> <transactor_name> (
      <port_mapping>
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   <monitor_name> <monitor_name> (
      <port_mapping>
   );

   <monitor_name> <monitor_name> (
      <port_mapping>
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   <checker_name> <checker_name> (
      <port_mapping>
   );

   <checker_name> <checker_name> (
      <port_mapping>
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   <block_name> duv (
      <port_mapping>
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

