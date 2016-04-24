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
// bkm_range_extension.v
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
//    - a         :
//    - b         :
//    - k1        :
//    - k2        :
//    - k3        :
//    - X_in      : Real      part of the result (two's complement, W bits).
//    - Y_in      : Imaginary part of the result (two's complement, W bits).
//
//  Data outputs:
//    - X_out     : Real      part of the result (extended to full range) (two's complement, W bits).
//    - X_out     : Imaginary part of the result (extended to full range) (two's complement, W bits).
//    - done      : Active high done strobe signal (logic, 1 bit).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-23 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_range_extension #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
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
    input wire [W-1:0]        a,
    input wire [W-1:0]        b,
    input wire [W-1:0]        k1,
    input wire [W-1:0]        k2,
    input wire [W-1:0]        k3,
    input wire [W-1:0]        X_in,
    input wire [W-1:0]        Y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg [W-1:0]        X_out,
    output reg [W-1:0]        Y_out,
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
         done     = 1'b0;
         X_out    = {W{1'b0}};
         Y_out    = {W{1'b0}};
      end
      else if (srst) begin
         done     = 1'b0;
         X_out    = {W{1'b0}};
         Y_out    = {W{1'b0}};
      end
      else if (enable) begin
         done     = start;
         X_out    = X_in;
         Y_out    = Y_in;
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

