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
// input_precision_selection.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Data inputs:
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for 64 bit, 1 for 32 bit
//                                                 |---> Complex:    0 for complex args, 1 for real args
//    - E_x_in    : Real      part of Exponential input (two's complement, W bits).
//    - E_y_in    : Imaginary part of Exponential input (two's complement, W bits).
//    - L_x_in    : Real      part of Logarithmic input (two's complement, W bits).
//    - L_y_in    : Imaginary part of Logarithmic input (two's complement, W bits).
//
//  Data outputs:
//    - E_x_out   : Real      part of Exponential input (two's complement, W bits).
//    - E_y_out   : Imaginary part of Exponential input (two's complement, W bits).
//    - L_x_out   : Real      part of Logarithmic input (two's complement, W bits).
//    - L_y_out   : Imaginary part of Logarithmic input (two's complement, W bits).
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
module input_precision_selection #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input   wire  [1:0]       format,
    input   wire  [W-1:0]     E_x_in,
    input   wire  [W-1:0]     E_y_in,
    input   wire  [W-1:0]     L_x_in,
    input   wire  [W-1:0]     L_y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [W-1:0]     E_x_out,
    output  reg   [W-1:0]     E_y_out,
    output  reg   [W-1:0]     L_x_out,
    output  reg   [W-1:0]     L_y_out
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
                           E_x_out = {{W/2{E_x_in[W/2-1]}},E_x_in[W/2-1:0]};
                           E_y_out = {W{1'b0}};
                           L_x_out = {{W/2{L_x_in[W/2-1]}},L_x_in[W/2-1:0]};
                           L_y_out = {W{1'b0}};
                        end
         `FORMAT_REAL_64:
                        begin
                           E_x_out = E_x_in;
                           E_y_out = {W{1'b0}};
                           L_x_out = L_x_in;
                           L_y_out = {W{1'b0}};
                        end
         `FORMAT_CMPLX_32:
                        begin
                           E_x_out = {{W/2{E_x_in[W/2-1]}},E_x_in[W/2-1:0]};
                           E_y_out = {{W/2{E_y_in[W/2-1]}},E_y_in[W/2-1:0]};
                           L_x_out = {{W/2{L_x_in[W/2-1]}},L_x_in[W/2-1:0]};
                           L_y_out = {{W/2{L_y_in[W/2-1]}},L_y_in[W/2-1:0]};
                        end
         `FORMAT_CMPLX_64:
                        begin
                           E_x_out = E_x_in;
                           E_y_out = E_y_in;
                           L_x_out = L_x_in;
                           L_y_out = L_y_in;
                        end
         default:
                        begin
                           E_x_out = {W{1'b0}};
                           E_y_out = {W{1'b0}};
                           L_x_out = {W{1'b0}};
                           L_y_out = {W{1'b0}};
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

