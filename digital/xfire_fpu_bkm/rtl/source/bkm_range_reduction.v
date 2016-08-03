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
// bkm_range_reduction.v
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
//    - E_x_in    : Real      part of Exponential input (two's complement, W bits).
//    - E_y_in    : Imaginary part of Exponential input (two's complement, W bits).
//    - L_x_in    : Real      part of Logarithmic input (two's complement, W bits).
//    - L_y_in    : Imaginary part of Logarithmic input (two's complement, W bits).
//
//  Data outputs:
//    - E_x_out   : Real      part of Exponential (inside convergence range) (two's complement, W bits).
//    - E_y_out   : Imaginary part of Exponential (inside convergence range) (two's complement, W bits).
//    - L_x_out   : Real      part of Logarithmic (inside convergence range) (two's complement, W bits).
//    - L_y_out   : Imaginary part of Logarithmic (inside convergence range) (two's complement, W bits).
//    - a         :
//    - b         :
//    - k1        :
//    - k2        :
//    - k3        :
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

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_range_reduction #(
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
    input wire [W-1:0]        E_x_in,
    input wire [W-1:0]        E_y_in,
    input wire [W-1:0]        L_x_in,
    input wire [W-1:0]        L_y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg  [W-1:0]       E_x_out,
    output reg  [W-1:0]       E_y_out,
    output reg  [W-1:0]       L_x_out,
    output reg  [W-1:0]       L_y_out,
    output reg  [W-1:0]       a,
    output reg  [W-1:0]       b,
    output reg  [W-1:0]       k1,
    output reg  [W-1:0]       k2,
    output reg  [W-1:0]       k3,
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
         done    <= 1'b0;
         E_x_out <= {W{1'b0}};
         E_y_out <= {W{1'b0}};
         L_x_out <= {W{1'b0}};
         L_y_out <= {W{1'b0}};
         a       <= {W{1'b0}};
         b       <= {W{1'b0}};
         k1      <= {W{1'b0}};
         k2      <= {W{1'b0}};
         k3      <= {W{1'b0}};
      end
      else if (srst) begin
         done    <= 1'b0;
         E_x_out <= {W{1'b0}};
         E_y_out <= {W{1'b0}};
         L_x_out <= {W{1'b0}};
         L_y_out <= {W{1'b0}};
         a       <= {W{1'b0}};
         b       <= {W{1'b0}};
         k1      <= {W{1'b0}};
         k2      <= {W{1'b0}};
         k3      <= {W{1'b0}};
      end
      else if (enable) begin
         done    <= start;
         E_x_out <= E_x_in;
         E_y_out <= E_y_in;
         L_x_out <= L_x_in;
         L_y_out <= L_y_in;
         a       <= {W{1'b0}};
         b       <= {W{1'b0}};
         k1      <= {W{1'b0}};
         k2      <= {W{1'b0}};
         k3      <= {W{1'b0}};
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

