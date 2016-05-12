// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Converts E/Y inputs into Z/w output.
// In this representation Z = X + j Y represents the data path and w = u + j v
// the control path.
//
//
// E-mode
// ------
// Z = E
// w = 2^1 * L
//
// L-mode
// ------
// Z = L
// w = 2^1 * (E-1)
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
//    TODO change Z to CSD???
//    - X_out     : Real      part of the data output (two's complement, W bits).
//    - Y_out     : Imaginary part of the data output (two's complement, W bits).
//    - u_out     : Real      part of the control output (two's complement, W bits).
//    - v_out     : Imaginary part of the control output (two's complement, W bits).
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
//    - 2016-05-01 - ilesser - Renamed pre step, changed control path to w = u+jv
//    - 2016-04-23 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_pre_step #(
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
    output reg [W-1:0]        u_out,
    output reg [W-1:0]        v_out,
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
         X_out   <= {W{1'b0}};
         Y_out   <= {W{1'b0}};
         u_out   <= {W{1'b0}};
         v_out   <= {W{1'b0}};
      end
      else if (srst) begin
         done    <= 1'b0;
         X_out   <= {W{1'b0}};
         Y_out   <= {W{1'b0}};
         u_out   <= {W{1'b0}};
         v_out   <= {W{1'b0}};
      end
      else if (enable) begin
         done    <= start;
         case(mode)
            `MODE_E:
               begin
                  X_out   <= E_x_in;
                  Y_out   <= E_y_in;
                  u_out   <= L_x_in*2;
                  v_out   <= L_y_in*2;
               end
            `MODE_L:
               begin
                  X_out   <= L_x_in;
                  Y_out   <= L_y_in;
                  // TODO esta resta de aca se podria hacer muy facil en CSD
                  u_out   <= (E_x_in-{{W-1{1'b0}},1'b1})*2;
                  v_out   <= E_y_in*2;
               end
            default:
               begin
                  X_out   <= {W{1'b0}};
                  Y_out   <= {W{1'b0}};
                  u_out   <= {W{1'b0}};
                  v_out   <= {W{1'b0}};
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

