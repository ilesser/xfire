// -----------------------------------------------------------------------------
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
// xfire_fpucordic.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - clk      : Posedge active clock input (logic, 1 bit).
//    - arst     : High active asynchronous reset (logic, 1 bit).
//    - enable   : Synchronous enable (logic, 1 bit).
//    - srst     : High active synchronous reset (logic, 1 bit).
//
//  Data inputs:
//    - XXXXX    : XXXXXXXXXX (XXXXX, XXXX bits).
//
//  Data outputs:
//    - XXXXX    : XXXXXXXXXX (XXXXX, XXXX bits).
//
//  Parameters:
//    - XXXXX    : XXXXXXXXXX (XXXXX, default: XXXXX).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-03-02 - pdk_admin - Original version.
//
// -----------------------------------------------------------------------------

`include "XXXXXXXX.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module xfire_fpucordic #(
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
    input wire  [XXXXX-1:0]  XXXXXXX,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg  [XXXXX-1:0]  XXXXXXX,
    output wire [XXXXX-1:0]  XXXXXXX
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

   always @(posedge clk or posedge arst) begin
      if (arst) begin
         XXXXX
      end
      else if (srst) begin
         XXXXX
      end
      else if (enable) begin
         XXXXX
      end
   end

// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

