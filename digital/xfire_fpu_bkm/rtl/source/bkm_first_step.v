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
// bkm_first_step.v
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
//    - X_out     : Real      part of the result (two's complement, W bits).
//    - Y_out     : Imaginary part of the result (two's complement, W bits).
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
//    - 2016-04-23 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_first_step #(
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
    output reg [W-1:0]        X_out,
    output reg [W-1:0]        Y_out,
    output reg [W-1:0]        x_out,
    output reg [W-1:0]        y_out,
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

   assign x_out   = {W{1'b0}};
   assign y_out   = {W{1'b0}};

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
         case(mode)
            `MODE_E:
               begin
                  X_out    = E_x_in;
                  Y_out    = E_y_in;
               end
            `MODE_L:
               begin
                  X_out    = L_x_in;
                  Y_out    = L_y_in;
               end
            default:
               begin
                  X_out    = {W{1'b0}};
                  Y_out    = {W{1'b0}};
               end
         endcase
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

