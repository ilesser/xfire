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
// bkm_steps.v
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
//    - 2016-04-23 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_steps #(
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
    input wire                clk,
    input wire                arst,
    input wire                srst,
    input wire                enable,
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire                start,
    input wire                mode,
    input wire [1:0]          format,
    input wire [W-1:0]        X_in,
    input wire [W-1:0]        Y_in,
    input wire [W-1:0]        x_in,
    input wire [W-1:0]        y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg [W-1:0]        X_out,
    output reg [W-1:0]        Y_out,
    output reg [`FSIZE-1:0]   flags,
    output reg                done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   always @(posedge clk or posedge arst) begin
      if (arst) begin
         X_out <= {W{1'b0}};
         Y_out <= {W{1'b0}};
         flags <= {`FSIZE{1'b0}};
         done  <= 1'b0;
      end
      else if (srst) begin
         X_out <= {W{1'b0}};
         Y_out <= {W{1'b0}};
         flags <= {`FSIZE{1'b0}};
         done  <= 1'b0;
      end
      else if (enable) begin
         X_out <= X_in;
         Y_out <= Y_in;
         flags <= {`FSIZE{1'b0}};
         done  <= start;
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

