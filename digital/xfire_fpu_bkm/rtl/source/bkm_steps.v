// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Performs all the steps of the BKM algorithm.
//
// E-mode
// ------
// Z = E
// w = 2^1 * L
// Z_{n+1} = Z_n * (1 + d_n * 2^-n)
// w_{n+1} = 2 w_n - 2^(n+1) * ln(1 + d_n * 2^-n)
//
//                          -n
// Z     =  Z  * (1 + d  * 2   )
//  n+1      n         n
//
//               _                              _
//              |        n                  -n   |
// w     =  2 * |  w  - 2   *  ln(1 + d  * 2   ) |
//  n+1         |_  n                  n        _|
//
//
//
//
// L-mode
// ------
// Z = L
// w = 2^1 * (E-1)
//
//                           -n
// Z     = Z  - ln(1 + d  * 2   )
//  n+1     n           n
//
//              _                           _
//             |                 -n          |
// w     = 2 * |  w  * (1 + d  * 2   ) + d   |
//  n+1        |_  n         n            n _|
//
//
//              _                      _
//             |                    -n  |
// w     = 2 * |  w  + d  + d * w * 2   |
//  n+1        |_  n    n    n   n     _|
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
//    - X_in      : Real      part of the data input (two's complement, W bits).
//    - Y_in      : Imaginary part of the data input (two's complement, W bits).
//    - u_in      : Real      part of the control input (two's complement, W bits).
//    - v_in      : Imaginary part of the control input (two's complement, W bits).
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
//    - 2016-07-11 - ilesser - Build an unrolled version.
//    - 2016-04-23 - ilesser - Initial version.
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
    input wire                   clk,
    input wire                   arst,
    input wire                   srst,
    input wire                   enable,
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire                   start,
    input wire                   mode,
    input wire    [1:0]          format,
    input wire    [W-1:0]        X_in,
    input wire    [W-1:0]        Y_in,
    input wire    [W-1:0]        u_in,
    input wire    [W-1:0]        v_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output wire   [W-1:0]        X_out,
    output wire   [W-1:0]        Y_out,
    output wire   [`FSIZE-1:0]   flags,
    output wire                  done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg   [LOG2N:0]   n_cnt;
   wire  [1:0]       d_x   [0:N-1];
   wire  [1:0]       d_y   [0:N-1];
   wire  [2*W-1:0]   lut_X [0:N-1];
   wire  [2*W-1:0]   lut_Y [0:N-1];
   wire  [W-1:0]     lut_u [0:N-1];
   wire  [W-1:0]     lut_v [0:N-1];
   wire  [2*W-1:0]   X     [0:N];
   wire  [2*W-1:0]   Y     [0:N];
   wire  [W-1:0]     u     [0:N];
   wire  [W-1:0]     v     [0:N];
   // -----------------------------------------------------


   // TODO: implement JK flop for the ena = f(start, done)
   always @(posedge clk or posedge arst) begin
      if (arst) begin
         n_cnt <= {LOG2N{1'b0}};
      end
      else if (srst|start) begin
         n_cnt <= {LOG2N{1'b0}};
      end
      else if (enable) begin
         n_cnt <= n_cnt + 1;
      end
   end
   assign flags = {`FSIZE{1'b0}};
   assign done  = n_cnt[LOG2N];

 // -------------------------------------
 // Convert inputs to CSD
 // -------------------------------------
 // TODO: implement input latching when start==1
   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_X (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (X_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (X[0])
   );

   bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bin2csd_Y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (Y_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (Y[0])
   );
 // -------------------------------------


   assign u[0] = u_in;
   assign v[0] = v_in;

   genvar n;
   generate
      for (n=0; n < N; n=n+1) begin

         // ----------------------------------
         // Get d_n
         // ----------------------------------
         //assign d_x[n] = 2'b00;
         //assign d_y[n] = 2'b00;
         get_d #(
            .W          (W)
         ) get_d_n (
            // ----------------------------------
            // Data inputs
            // ----------------------------------
            .mode       (mode),
            .u          (u[n]),
            .v          (v[n]),
            // ----------------------------------
            // Data inputs
            // ----------------------------------
            .d_x        (d_x[n]),
            .d_y        (d_y[n])
         );

         // ----------------------------------
         // LUT decoder
         // ----------------------------------
         assign lut_X[n] = {2*W{1'b0}};
         assign lut_Y[n] = {2*W{1'b0}};
         assign lut_u[n] = {W{1'b0}};
         assign lut_v[n] = {W{1'b0}};
         //lut_decoder #(
            //.W          (W),
            //.LOG2W      (LOG2W)
         //) lut_decoder_n (
            //// ----------------------------------
            //// Clock, reset & enable inputs
            //// ----------------------------------
            //.clk        (clk),
            //.arst       (arst),
            //.srst       (srst),
            //.enable     (enable),
            //// ----------------------------------
            //// Data inputs
            //// ----------------------------------
            //.mode       (mode),
            //.format     (format),
            //.n          (n),
            //.d_x_n      (d_x[n]),
            //.d_y_n      (d_y[n]),
            //// ----------------------------------
            //// Data outputs
            //// ----------------------------------
            //.lut_X      (lut_X[n]),
            //.lut_Y      (lut_X[n]),
            //.lut_u      (lut_u[n]),
            //.lut_v      (lut_v[n])
         //);

         // ----------------------------------
         // Step n
         // ----------------------------------
         assign X[n] = {2*W{1'b0}};
         assign Y[n] = {2*W{1'b0}};
         assign u[n] = {W{1'b0}};
         assign v[n] = {W{1'b0}};
         // TODO: when I  uncomment the bkm_step instantiation iverilogs fails to simulate
         //bkm_step #(
            //.W          (W),
            //.LOG2W      (LOG2W)
         //) bkm_step_n (
            //// ----------------------------------
            //// Clock, reset & enable inputs
            //// ----------------------------------
            //.clk        (clk),
            //.arst       (arst),
            //.srst       (srst),
            //.enable     (enable),
            //// ----------------------------------
            //// Data inputs
            //// ----------------------------------
            //.mode       (mode),
            //.format     (format),
            //.n          (n),
            //.d_x_n      (d_x[n]),
            //.d_y_n      (d_y[n]),
            //.X_n        (X[n]),
            //.Y_n        (Y[n]),
            //.lut_X      (lut_X[n]),
            //.lut_Y      (lut_Y[n]),
            //.u_n        (u[n]),
            //.v_n        (v[n]),
            //.lut_u      (lut_u[n]),
            //.lut_v      (lut_v[n]),
            //// ----------------------------------
            //// Data outputs
            //// ----------------------------------
            //.X_np1      (X[n+1]),
            //.Y_np1      (Y[n+1]),
            //.u_np1      (u[n+1]),
            //.v_np1      (v[n+1])
         //);

      end // for n

   endgenerate

 // -------------------------------------
 // Convert outputs to binary
 // -------------------------------------
 // TODO: implement output latching when done==1
   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_X (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (X[N]),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (X_out)
   );

   csd2bin #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd2bin_Y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x                   (Y[N]),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .y                   (Y_out)
   );
 // -------------------------------------

// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   //XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

