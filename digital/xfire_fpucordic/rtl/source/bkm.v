// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// BKM
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - clk       : Posedge active clock input (logic, 1 bit).
//    - arst      : Active high asynchronous reset (logic, 1 bit).
//    - enable    : Active high synchronous enable (logic, 1 bit).
//    - srst      : Active high synchronous reset (logic, 1 bit).
//
//  Data inputs:
//    - start     : Active high start strobe signal (logic, 1 bit).
//    - mode      : Operation mode (logic, 1 bit).
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for 64 bit, 1 for 32 bit
//                                                 |---> Complex:    0 for complex args, 1 for real args
//    - E_r_in    : Real      part of Exponential input (two's complement, W bits).
//    - E_i_in    : Imaginary part of Exponential input (two's complement, W bits).
//    - L_r_in    : Real      part of Logarithmic input (two's complement, W bits).
//    - L_i_in    : Imaginary part of Logarithmic input (two's complement, W bits).
//
//  Data outputs:
//    - E_r_out   : Real      part of Exponential input (two's complement, W bits).
//    - E_i_out   : Imaginary part of Exponential input (two's complement, W bits).
//    - L_r_out   : Real      part of Logarithmic input (two's complement, W bits).
//    - L_i_out   : Imaginary part of Logarithmic input (two's complement, W bits).
//    - flags     : Result flags (logic, 4 bits).
//    - done      : Active high done strobe signal (logic, 1 bit).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//    - LOG2W     : Logarithm of base 2 of the word width (natural, default: 6).
//    - N         : Number of steps in the cordic algorithm (natural, default: 64).
//    - LOG2N     : Logarithm of base 2 of the number of steps in the cordic
//                  algorithm (natural, default 6).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-04 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm #(
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
    input reg  [W-1:0]        E_r_in,
    input reg  [W-1:0]        E_i_in,
    input reg  [W-1:0]        L_r_in,
    input reg  [W-1:0]        L_i_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    input reg  [W-1:0]        E_r_out,
    input reg  [W-1:0]        E_i_out,
    input reg  [W-1:0]        L_r_out,
    input reg  [W-1:0]        L_i_out,
    output wire[FLO_FSIZE-1:0]flags,
    output wire               done
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

