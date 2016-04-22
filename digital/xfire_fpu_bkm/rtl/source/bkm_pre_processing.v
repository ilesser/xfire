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
// bkm_pre_processing.v
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

//  Data inputs:
//    - start     : Active high start strobe signal (logic, 1 bit).
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for 64 bit, 1 for 32 bit
//                                                 |---> Complex:    0 for complex args, 1 for real args
//    - op        : Operation code (logic, XXX bits).
//    - x1        : Real      part of z1 input (two's complement, W bits).
//    - y1        : Imaginary part of z1 input (two's complement, W bits).
//    - x2        : Real      part of z2 input (two's complement, W bits).
//    - y2        : Imaginary part of z2 input (two's complement, W bits).
//    - x3        : Real      part of z2 input (two's complement, W bits).
//    - y3        : Imaginary part of z2 input (two's complement, W bits).
//
//  Data outputs:
//    - E_r       : Real      part of E output (two's complement, W bits).
//    - E_i       : Imaginary part of E output (two's complement, W bits).
//    - L_r       : Real      part of E output (two's complement, W bits).
//    - L_i       : Imaginary part of E output (two's complement, W bits).
//    - done      : Active high done strobe signal (logic, 1 bit).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-10 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_fixed_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_pre_processing #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
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
    input   reg   [W-1:0]        x1,
    input   reg   [W-1:0]        y1,
    input   reg   [W-1:0]        x2,
    input   reg   [W-1:0]        y2,
    input   reg   [W-1:0]        x3,
    input   reg   [W-1:0]        y3,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [W-1:0]        E_r,
    output  reg   [W-1:0]        E_i,
    output  reg   [W-1:0]        L_r,
    output  reg   [W-1:0]        L_i,
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
         dummy = {W,{1'b1}};
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

