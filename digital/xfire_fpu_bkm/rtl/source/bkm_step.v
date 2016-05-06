// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Performs the nth step of the BKM algorithm.
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
// bkm_step.v
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
//    - 2016-04-23 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_step #(
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
    input wire [LOG2W-1:0]    n,
    input wire [2*W-1:0]      X_n,
    input wire [2*W-1:0]      Y_n,
    input wire [W-1:0]        u_n,
    input wire [W-1:0]        v_n,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg [2*W-1:0]      X_np1,
    output reg [2*W-1:0]      Y_np1,
    output reg [W-1:0]        u_np1,
    output reg [W-1:0]        v_np1
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // For the data path
   wire  [1:0]          d_n;        // d_n is encoded in ones complement
   wire                 d_n_data_x;
   wire                 d_n_data_y;
   wire                 d_n_sign_x;
   wire                 d_n_sign_y;
   wire                 sign_a_x;
   wire                 sign_a_y;
   wire                 sign_b_x;
   wire                 sign_b_y;
   wire  [2*W-1:0]      a_x;
   wire  [2*W-1:0]      a_y;
   wire  [2*W-1:0]      b_x;
   wire  [2*W-1:0]      b_y;
   wire  [2*W-1:0]      lut_x;
   wire  [2*W-1:0]      lut_y;
   wire  [2*W-1:0]      X_n_shifted_times_d_n;
   wire  [2*W-1:0]      Y_n_shifted_times_d_n;
   reg   [`FSIZE-1:0]   flags_int;

   // For the control path
   wire                 d_n_data_u;
   wire                 d_n_data_v;
   wire                 d_n_sign_u;
   wire                 d_n_sign_v;
   wire                 sign_a_u;
   wire                 sign_a_v;
   wire                 sign_b_u;
   wire                 sign_b_v;
   wire  [2*W-1:0]      a_u;
   wire  [2*W-1:0]      a_v;
   wire  [2*W-1:0]      b_u;
   wire  [2*W-1:0]      b_v;
   wire  [2*W-1:0]      lut_u;
   wire  [2*W-1:0]      lut_v;
   wire  [2*W-1:0]      u_n_times_d_n;
   wire  [2*W-1:0]      v_n_times_d_n;

   // -----------------------------------------------------

// *****************************************************************************
// DATA PATH
// *****************************************************************************

   // -----------------------------------------------------
   // Barrel shifter for X
   // -----------------------------------------------------
   barrel_shifter #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (2*W),
      .LOG2W               (LOG2W+1)
   ) barrel_shifter_x(
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (DIR_RIGHT),
      .op                  (OP_SHIFT),
      .shift_t             (SHIFT_ARITHMETIC),
      .sel                 (n),
      .in                  (X_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (X_n_shifted)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Barrel shifter for Y
   // -----------------------------------------------------
   barrel_shifter #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (2*W),
      .LOG2W               (LOG2W+1)
   ) barrel_shifter_y(
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (DIR_RIGHT),
      .op                  (OP_SHIFT),
      .shift_t             (SHIFT_ARITHMETIC),
      .sel                 (n),
      .in                  (Y_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (Y_n_shifted)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Calculate signs and data from d_n
   // -----------------------------------------------------

   //            real   imag
   //              |      |
   //            .---.  .---.
   //            |   |  |   |
   //    d_n = [ Xs  Xd Ys  Yd ]
   assign d_n_data_x = d_n[0];
   assign d_n_sign_x = d_n[1];
   assign d_n_data_y = d_n[2];
   assign d_n_sign_y = d_n[3];
   assign d_n_data_u = d_n[0];
   assign d_n_sign_u = d_n[1];
   assign d_n_data_v = d_n[2];
   assign d_n_sign_v = d_n[3];
   // -----------------------------------------------------

 //  // -----------------------------------------------------
 //  // Multiply by d_n
 //  // -----------------------------------------------------
 //  //multipĺy_by_d_csd #(
 //  // // ----------------------------------
 //  // // Parameters
 //   // ----------------------------------
 //     .W                  (W)
 //  ) multipĺy_by_d_n_csd (
 //   // ----------------------------------
 //   // Data inputs
 //   // ----------------------------------
 //     .d_x                 (d_n_data_x),
 //     .d_y                 (d_n_data_y),
 //     .X_in                (X_n_shifted),
 //     .Y_in                (Y_n_shifted),
 //   // ----------------------------------
 //   // Data outputs
 //   // ----------------------------------
 //   .X_out               (X_n_shifted_times_d_n),
 //   .Y_out               (Y_n_shifted_times_d_n)
 //);
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Mux the inputs of the CSD complex adder
   // -----------------------------------------------------
   always @(*) begin
      case(mode)
         `MODE_E:
                  begin
                     sign_a_x = 1'b0;  // add
                     sign_a_y = 1'b0;  // add
                     sign_b_x = d_n_sign_x;
                     sign_b_y = d_n_sign_y;
                     a_x      = X_n;
                     a_y      = Y_n;
                     b_x      = X_n_shifted_times_d_n;
                     b_y      = Y_n_shifted_times_d_n;
                  end
         `MODE_L:
                  begin
                     sign_a_x = 1'b0;  // add
                     sign_a_y = 1'b0;  // add
                     sign_b_x = 1'b1;  // substract
                     sign_b_y = 1'b1;  // substract
                     a_x      = X_n;
                     a_y      = Y_n;
                     b_x      = lut_x;
                     b_y      = lut_y;
                  end
         default:
                  begin
                     sign_a_x = 1'b0;
                     sign_a_y = 1'b0;
                     sign_b_x = 1'b0;
                     sign_b_y = 1'b0;
                     a_x      = X_n;
                     a_y      = Y_n;
                     b_x      = {W{1'b0}};
                     b_y      = {W{1'b0}};
                  end
      endcase
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // CSD adder
   // -----------------------------------------------------
   complex_csd_add_sub #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) complex_(
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .sign_a_x            (sign_a_x),
      .sign_a_y            (sign_a_y),
      .sign_b_x            (sign_b_x),
      .sign_b_y            (sign_b_y),
      .a_x                 (a_x),
      .a_y                 (a_y),
      .b_x                 (b_x),
      .b_y                 (b_y),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c_x                 (c_x),
      .c_y                 (c_y),
      .s_x                 (s_x),
      .s_y                 (s_y)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Output assignment for Z_n+1
   // -----------------------------------------------------
   assign   X_np1    = s_x;
   assign   Y_np1    = s_y;
   // -----------------------------------------------------

// *****************************************************************************

// *****************************************************************************
// CONTROL PATH
// *****************************************************************************

   // -----------------------------------------------------
   // Multiply by d_n
   // -----------------------------------------------------
//   multipĺy_by_d #(
//    // ----------------------------------
//    // Parameters
//    // ----------------------------------
//      .W                   (W)
//   ) multipĺy_by_d_n  (
//    // ----------------------------------
//    // Data inputs
//    // ----------------------------------
//      .d_x                 (d_n_data_u), // calculate
//      .d_y                 (d_n_data_v), // calculate
//      .X_in                (u_n),
//      .Y_in                (v_n),
//    // ----------------------------------
//    // Data outputs
//    // ----------------------------------
//      .X_out               (u_n_times_d_n),
//      .Y_out               (v_n_times_d_n)
//   );
//   // -----------------------------------------------------

   // -----------------------------------------------------
   // Mux the inputs of the two's complement complex adder
   // -----------------------------------------------------
   always @(*) begin
      case(mode)
         `MODE_E:
                  begin
                     sign_a_u = 1'b0;  // add
                     sign_a_v = 1'b0;  // add
                     sign_b_u = 1'b1;  // substract
                     sign_b_v = 1'b1;  // substract
                     a_u      = u_n;
                     a_v      = v_n;
                     b_u      = lut_u;
                     b_v      = lut_v;
                  end
         `MODE_L:
                  begin
                     sign_a_u = 1'b0;  // add
                     sign_a_v = 1'b0;  // add
                     sign_b_u = d_n_sign_u;  // calculate
                     sign_b_v = d_n_sign_v;  // calculate
                     a_u      = u_n + d_n_data_u; // calculate
                     a_v      = v_n + d_n_data_v; // calculate
                     b_u      = u_n_times_d_n;
                     b_v      = v_n_times_d_n;
                  end
         default:
                  begin
                     sign_a_u = 1'b0;
                     sign_a_v = 1'b0;
                     sign_b_u = 1'b0;
                     sign_b_v = 1'b0;
                     a_u      = {W{1'b0}};
                     a_v      = {W{1'b0}};
                     b_u      = {W{1'b0}};
                     b_v      = {W{1'b0}};
                  end
      endcase
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Barrel shifter for u
   // -----------------------------------------------------
   barrel_shifter #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W)
   ) barrel_shifter_u (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (DIR_RIGHT),
      .op                  (OP_SHIFT),
      .shift_t             (SHIFT_ARITHMETIC),
      .sel                 (n),
      .in                  (b_u),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (b_u_shifted)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Barrel shifter for v
   // -----------------------------------------------------
   barrel_shifter #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W)
   ) barrel_shifter_v (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (DIR_RIGHT),
      .op                  (OP_SHIFT),
      .shift_t             (SHIFT_ARITHMETIC),
      .sel                 (n),
      .in                  (b_v),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (b_v_shifted)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Complex adder for w_n
   // -----------------------------------------------------
   complex_add_sub #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) complex_add_sub (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .sign_a_x            (sign_a_u),
      .sign_a_y            (sign_a_v),
      .sign_b_x            (sign_b_u),
      .sign_b_y            (sign_b_v),
      .a_x                 (a_u),
      .a_y                 (a_v),
      .b_x                 (b_u_shifted),
      .b_y                 (b_v_shifted),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c_x                 (c_u),
      .c_y                 (c_v),
      .s_x                 (s_u),
      .s_y                 (s_v)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Output assignment for w_n+1
   // -----------------------------------------------------
   assign   u_np1    = s_u << 1;
   assign   v_np1    = s_v << 1;
   // -----------------------------------------------------

// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   //XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule


