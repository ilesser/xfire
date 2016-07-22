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
// bkm_step_checker.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-14 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "XXXXXXXX.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_step_checker #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter XXXXX   = XXXXX,
   parameter XXXXX   = XXXXX
   ) (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input wire               clk,
   input wire               arst,
   input wire               srst,
   input wire               enable,
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input wire  [XXXXX-1:0]  XXXXXXX,
   input wire  [XXXXX-1:0]  XXXXXXX
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire [XXXXX-1:0]  XXXXX;
   reg  [XXXXX-1:0]  XXXXX;
   // -----------------------------------------------------

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

