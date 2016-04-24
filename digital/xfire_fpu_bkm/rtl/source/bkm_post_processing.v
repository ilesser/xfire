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
// bkm_post_processing.v
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
//    - E_x       : Real      part of E input (two's complement, W bits).
//    - E_y       : Imaginary part of E input (two's complement, W bits).
//    - L_x       : Real      part of E input (two's complement, W bits).
//    - L_y       : Imaginary part of E input (two's complement, W bits).
//
//  Data outputs:
//    - x         : Real      part of z output (two's complement, W bits).
//    - y         : Imaginary part of z output (two's complement, W bits).
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
module bkm_post_processing #(
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
    input   wire  [W-1:0]        x_in,
    input   wire  [W-1:0]        y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [W-1:0]        x_out,
    output  reg   [W-1:0]        y_out,
    output  reg   [`FSIZE-1:0]   flags,
    output  reg                  done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   assign flags = {`FSIZE{1'b0}};

   always @(posedge clk or posedge arst) begin
      if (arst) begin
         done  <= 1'b0;
         x_out <= {W{1'b0}};
         y_out <= {W{1'b0}};
      end
      else if (srst) begin
         done  <= 1'b0;
         x_out <= {W{1'b0}};
         y_out <= {W{1'b0}};
      end
      else if (enable) begin
         done  <= start;
         x_out <= x_in;
         y_out <= y_in;
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

