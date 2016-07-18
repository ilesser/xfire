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
// Z_{n+1} = Z_n - ln(1 + d_n * 2^-n)
// w_{n+1} = 2 * [ w_n + d_n + d_n * w_n * 2^-n ]
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
//    - 2016-07-18 - ilesser - Removed regs by wires. Signal definition clean up.
//    - 2016-04-23 - ilesser - Initial version.
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
    input wire                mode,
    input wire [1:0]          format,
    input wire [LOG2N-1:0]    n,
    input wire [1:0]          d_x_n,        // d_n is encoded in ones complement
    input wire [1:0]          d_y_n,        // d_n is encoded in ones complement
    input wire [2*W-1:0]      X_n,
    input wire [2*W-1:0]      Y_n,
    input wire [2*W-1:0]      lut_X,
    input wire [2*W-1:0]      lut_Y,
    input wire [W-1:0]        u_n,
    input wire [W-1:0]        v_n,
    input wire [W-1:0]        lut_u,
    input wire [W-1:0]        lut_v,
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
   wire                 sign_a_x;
   wire                 sign_a_y;
   wire                 sign_b_x;
   wire                 sign_b_y;
   wire  [2*W-1:0]      a_x;
   wire  [2*W-1:0]      a_y;
   wire  [2*W-1:0]      b_x;
   wire  [2*W-1:0]      b_y;
   wire  [2*W-1:0]      X_n_shifted;
   wire  [2*W-1:0]      Y_n_shifted;
   wire  [2*W-1:0]      X_n_shifted_times_d_n;
   wire  [2*W-1:0]      Y_n_shifted_times_d_n;
   wire  [1:0]          c_x;
   wire  [1:0]          c_y;
   wire  [2*W-1:0]      s_x;
   wire  [2*W-1:0]      s_y;

   // For the control path
   wire  [1:0]          d_u_n;
   wire  [1:0]          d_v_n;
   wire                 sign_a_u;
   wire                 sign_a_v;
   wire                 sign_b_u;
   wire                 sign_b_v;
   wire  [W-1:0]        a_u;
   wire  [W-1:0]        a_v;
   wire  [W-1:0]        b_u;
   wire  [W-1:0]        b_v;
   wire  [W-1:0]        u_n_plus_d_u_n;
   wire  [W-1:0]        v_n_plus_d_v_n;
   wire  [W-1:0]        u_n_times_d_u_n;
   wire  [W-1:0]        v_n_times_d_v_n;
   wire                 c_u;
   wire                 c_v;
   wire  [W-1:0]        s_u;
   wire  [W-1:0]        s_v;
   wire  [W-1:0]        b_u_shifted;
   wire  [W-1:0]        b_v_shifted;

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
      .dir                 (`DIR_RIGHT),
      .op                  (`OP_SHIFT),
      .shift_t             (`SHIFT_ARITH),
      .sel                 ({n,1'b0}), // select with 2*n
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
      .dir                 (`DIR_RIGHT),
      .op                  (`OP_SHIFT),
      .shift_t             (`SHIFT_ARITH),
      .sel                 ({n,1'b0}), // select with 2*n
      .in                  (Y_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (Y_n_shifted)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Multiply by d_n
   // -----------------------------------------------------
   multiply_by_d_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                  (W)
   ) multiply_by_d_csd (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .d_x                 (d_x_n),
      .d_y                 (d_y_n),
      .x_in                (X_n_shifted),
      .y_in                (Y_n_shifted),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x_out               (X_n_shifted_times_d_n),
      .y_out               (Y_n_shifted_times_d_n)
    );
   // -----------------------------------------------------

   //       +--------------------------------------------------------------------------+
   //       | Mux the inputs of the CSD complex adder                                  |
   //       +--------------+--------------------+--------------------------+-----------+
   //       | Adder inputs |  mode              |  MODE_E                  |  MODE_L   |
   //       +--------------+--------------------+--------------------------+-----------+
   assign   sign_a_x       =  mode == `MODE_E   ?  `ADD                    :  `ADD     ;
   assign   sign_a_y       =  mode == `MODE_E   ?  `ADD                    :  `ADD     ;
   //assign sign_b_x       =  mode == `MODE_E   ?  d_x_n[`D_SIGN]          :  `SUBB    ;
   //assign sign_b_y       =  mode == `MODE_E   ?  d_y_n[`D_SIGN]          :  `SUBB    ;
   assign   sign_b_x       =  mode == `MODE_E   ?  `ADD                    :  `SUBB    ;
   assign   sign_b_y       =  mode == `MODE_E   ?  `ADD                    :  `SUBB    ;
   assign   a_x            =  mode == `MODE_E   ?   X_n                    :   X_n     ;
   assign   a_y            =  mode == `MODE_E   ?   Y_n                    :   Y_n     ;
   assign   b_x            =  mode == `MODE_E   ?   X_n_shifted_times_d_n  :   lut_X   ;
   assign   b_y            =  mode == `MODE_E   ?   Y_n_shifted_times_d_n  :   lut_Y   ;
   //       +--------------+--------------------+--------------------------+-----------+

   // -----------------------------------------------------
   // CSD adder
   // -----------------------------------------------------
   complex_csd_add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) complex_csd_add_subb (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a_x            (sign_a_x),
      .subb_a_y            (sign_a_y),
      .subb_b_x            (sign_b_x),
      .subb_b_y            (sign_b_y),
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
   assign X_np1 = s_x;
   assign Y_np1 = s_y;
   //TODO: use carry signals for some type of check?
   // -----------------------------------------------------

// *****************************************************************************

// *****************************************************************************
// CONTROL PATH
// *****************************************************************************

   // -----------------------------------------------------
   // Calculate decisions for u and v
   // -----------------------------------------------------
   assign d_u_n = d_x_n;
   assign d_v_n = d_y_n;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Multiply by d_n
   // -----------------------------------------------------
   multiply_by_d #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) multiply_by_d (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .d_x                 (d_u_n),
      .d_y                 (d_v_n),
      .x_in                (u_n),
      .y_in                (v_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x_out               (u_n_times_d_u_n),
      .y_out               (v_n_times_d_v_n)
   );
   // -----------------------------------------------------

   // TODO: think of a better implementation for this
   assign   u_n_plus_d_u_n =  d_u_n[`D_SIGN]    ?  u_n - d_u_n[`D_DATA] :  u_n + d_u_n[`D_DATA] ;
   assign   v_n_plus_d_v_n =  d_v_n[`D_SIGN]    ?  v_n - d_v_n[`D_DATA] :  v_n + d_v_n[`D_DATA] ;
   //assign   u_n_plus_d_u_n =  d_u_n != 2'b10    ?  u_n + d_u_n :  u_n   ;
   //assign   v_n_plus_d_v_n =  d_v_n != 2'b10    ?  v_n + d_v_n :  v_n   ;

   //       +--------------------------------------------------------------------+
   //       | Mux the inputs of the two's complement complex adder               |
   //       +--------------+--------------------+-----------+--------------------+
   //       | Adder inputs |  mode              |  MODE_E   |  MODE_L            |
   //       +--------------+--------------------+-----------+--------------------+
   assign   sign_a_u       =  mode == `MODE_E   ?  `ADD     :  `ADD              ;
   assign   sign_a_v       =  mode == `MODE_E   ?  `ADD     :  `ADD              ;
   //assign sign_b_u       =  mode == `MODE_E   ?  `SUBB    :  d_u_n[`D_SIGN]    ;
   //assign sign_b_v       =  mode == `MODE_E   ?  `SUBB    :  d_v_n[`D_SIGN]    ;
   assign   sign_b_u       =  mode == `MODE_E   ?  `SUBB    :  `ADD              ;
   assign   sign_b_v       =  mode == `MODE_E   ?  `SUBB    :  `ADD              ;
   assign   a_u            =  mode == `MODE_E   ?   u_n     :   u_n_plus_d_u_n   ;
   assign   a_v            =  mode == `MODE_E   ?   v_n     :   v_n_plus_d_v_n   ;
   assign   b_u            =  mode == `MODE_E   ?   lut_u   :   u_n_times_d_u_n  ;
   assign   b_v            =  mode == `MODE_E   ?   lut_v   :   v_n_times_d_v_n  ;
   //       +--------------+--------------------+-----------+--------------------+

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
      .dir                 (`DIR_RIGHT),
      .op                  (`OP_SHIFT),
      .shift_t             (`SHIFT_ARITH),
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
      .dir                 (`DIR_RIGHT),
      .op                  (`OP_SHIFT),
      .shift_t             (`SHIFT_ARITH),
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
   complex_add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) complex_add_sub (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a_x            (sign_a_u),
      .subb_a_y            (sign_a_v),
      .subb_b_x            (sign_b_u),
      .subb_b_y            (sign_b_v),
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
   // Multiply by 2 outputs
   assign u_np1 = s_u << 1;
   assign v_np1 = s_v << 1;
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


