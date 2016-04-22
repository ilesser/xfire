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
// output_precision_selection.v
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
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for 64 bit, 1 for 32 bit
//                                                 |---> Complex:    0 for complex args, 1 for real args
//    - X_in    : Real      part of the result input (two's complement, W bits).
//    - Y_in    : Imaginary part of the result input (two's complement, W bits).
//
//  Data outputs:
//    - X_out   : Real      part of the result output (two's complement, W bits).
//    - Y_out   : Imaginary part of the result output (two's complement, W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-20 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module output_precision_selection #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire  [W-1:0]       X_in,
    input wire  [W-1:0]       Y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg  [W-1:0]       X_out,
    output reg  [W-1:0]       Y_out
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   always @(*) begin
      case (format)
         `FORMAT_REAL_32:
                        begin
                           X_out = {{W/2{X_in[W/2-1]}},X_in};
                           Y_out = {W{1'b0}};
                        end
         `FORMAT_REAL_64:
                        begin
                           X_out = X_in;
                           Y_out = {W{1'b0}};
                        end
         `FORMAT_CMPLX_32:
                        begin
                           X_out = {{W/2{X_in[W/2-1]}},X_in};
                           Y_out = {{W/2{Y_in[W/2-1]}},Y_in};
                        end
         `FORMAT_CMPLX_64:
                        begin
                           X_out = X_in;
                           Y_out = Y_in;
                        end
         default:
                        begin
                           X_out = {W{1'b0}};
                           Y_out = {W{1'b0}};
                        end
      endcase
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

