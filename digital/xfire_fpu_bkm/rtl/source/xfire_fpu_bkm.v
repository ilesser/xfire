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
// xfire_fpu_bkm.v
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
//    - 2016-04-10 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "xfire_fpu_bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module xfire_fpu_bkm #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64,
    parameter LOG2W  = 6,
    parameter N      = 64,
    parameter LOG2N  = 6
  ) (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
    input   wire                 clk,
    input   wire                 arst,
    input   wire                 srst,
    input   wire                 enable,
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input   wire                 start,
    input   wire  [1:0]          format,
    input   wire  [`OPSIZE-1:0]  op,
    input   wire  [W-1:0]        x1,
    input   wire  [W-1:0]        y1,
    input   wire  [W-1:0]        x2,
    input   wire  [W-1:0]        y2,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [W-1:0]        x3,
    output  reg   [W-1:0]        y3,
    output  wire  [`FSIZE-1:0]   flags,
    output  wire                 done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg  [W-1:0]  dummy;
   // -----------------------------------------------------

   always @(posedge clk or posedge arst) begin
      if (arst) begin
         dummy = {W{1'b0}};
      end
      else if (srst) begin
         dummy = {W{1'b0}};
      end
      else if (enable) begin
         dummy = x1;
      end
   end

// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   //XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

