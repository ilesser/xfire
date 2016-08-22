// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Performs the nth control step of the BKM algorithm.
//
// E-mode
// ------
// w = 2^1 * L
// w_{n+1} = 2 w_n - 2^(n+1) * ln(1 + d_n * 2^-n)
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
// w = 2^1 * (E-1)
// w_{n+1} = 2 * [ w_n + d_n + d_n * w_n * 2^-n ]
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
// bkm_control_step.v
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
//    - u_in      : Real      part of the control input (two's complement, W bits).
//    - v_in      : Imaginary part of the control input (two's complement, W bits).
//
//  Data outputs:
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
//    TODO: implement power savings based on format. Currently it works always
//          in double word complex format.
//    - 2016-08-22 - ilesser - Changed default parameters.
//    - 2016-08-15 - ilesser - Replaced barrel shifters by div_by_2_n block.
//    - 2016-08-03 - ilesser - BUG3: Increased wordsize for internal signals 
//    - 2016-08-02 - ilesser - Changed the definition of W.
//    - 2016-07-27 - ilesser - BUG1: Fixed.
//    - 2016-07-22 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_control_step #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 16,
    parameter LOG2W  = 4,
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
    input wire    [1:0]       format,
    input wire    [LOG2N-1:0] n,
    input wire    [1:0]       d_u_n,        // d_n is encoded in ones complement
    input wire    [1:0]       d_v_n,        // d_n is encoded in ones complement
    input wire    [W-1:0]     u_n,
    input wire    [W-1:0]     v_n,
    input wire    [W-1:0]     lut_u_n,
    input wire    [W-1:0]     lut_v_n,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output wire   [W-1:0]     u_np1,
    output wire   [W-1:0]     v_np1
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
//
//
//
//             +--------------------------------+
//             |                                |
// n      ---->+                                |
// d_u_n  ---->+                                |
// d_v_n  ---->+                                |
//             |           CONTROL STEP         |
// u_n    ---->+                                +---->   u_np1
// v_n    ---->+                                +---->   v_np1
// lut_u_n---->+                                |
// lut_v_n---->+                                |
//             |                                |
//             +--------------------------------+
//
//

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire  [W:0]       u_n_plus_d_u_n;
   wire  [W:0]       v_n_plus_d_v_n;
   wire  [W:0]       u_n_times_d_n;
   wire  [W:0]       v_n_times_d_n;
   wire  [W:0]       u_n_times_d_n_div_2_n;
   wire  [W:0]       v_n_times_d_n_div_2_n;
   wire              sign_a_u;
   wire              sign_a_v;
   wire              sign_b_u;
   wire              sign_b_v;
   wire  [W:0]       a_u;
   wire  [W:0]       a_v;
   wire  [W:0]       b_u;
   wire  [W:0]       b_v;
   wire              c_u;
   wire              c_v;
   wire  [W+1:0]     s_u;
   wire  [W+1:0]     s_v;
   // -----------------------------------------------------

// *****************************************************************************
// CONTROL PATH
// *****************************************************************************

   // TODO: think of a better implementation for this
   //       a better way could be to add a carry in input to the add_subb used below
   assign   u_n_plus_d_u_n =  d_u_n[`D_SIGN]    ?  {u_n[W-1], u_n} - d_u_n[`D_DATA] :  {u_n[W-1], u_n} + d_u_n[`D_DATA] ;
   assign   v_n_plus_d_v_n =  d_v_n[`D_SIGN]    ?  {v_n[W-1], v_n} - d_v_n[`D_DATA] :  {v_n[W-1], v_n} + d_v_n[`D_DATA] ;
   //assign   u_n_plus_d_u_n =  d_u_n[`D_SIGN]    ?  u_n - d_u_n[`D_DATA] :  u_n + d_u_n[`D_DATA] ;
   //assign   v_n_plus_d_v_n =  d_v_n[`D_SIGN]    ?  v_n - d_v_n[`D_DATA] :  v_n + d_v_n[`D_DATA] ;
   //assign   u_n_plus_d_u_n =  d_u_n != 2'b10    ?  u_n + d_u_n :  u_n   ;
   //assign   v_n_plus_d_v_n =  d_v_n != 2'b10    ?  v_n + d_v_n :  v_n   ;

   // -----------------------------------------------------
   // Multiply by d_n
   // -----------------------------------------------------
   multiply_by_d #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1)
   ) multiply_by_d (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .d_x                 (d_u_n),
      .d_y                 (d_v_n),
      .x_in                ({u_n[W-1], u_n}),
      .y_in                ({v_n[W-1], v_n}),
      //.x_in                (u_n),
      //.y_in                (v_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x_out               (u_n_times_d_n),
      .y_out               (v_n_times_d_n)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Divide by 2^n
   // -----------------------------------------------------
   div_by_2_n #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1),
      .LOG2W               (LOG2W+1),
      .LOG2N               (LOG2N)
   ) div_by_2_n_u (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .n                   (n),
      .in                  (u_n_times_d_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (u_n_times_d_n_div_2_n)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Divide by 2^n
   // -----------------------------------------------------
   div_by_2_n #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1),
      .LOG2W               (LOG2W+1),
      .LOG2N               (LOG2N)
   ) div_by_2_n_v (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .n                   (n),
      .in                  (v_n_times_d_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (v_n_times_d_n_div_2_n)
   );
   // -----------------------------------------------------

   //       +--------------------------------------------------------------------------+
   //       | Mux the inputs of the two's complement complex adder                     |
   //       +--------------+--------------------+-----------+--------------------------+
   //       | Adder inputs |  mode              |  MODE_E   |  MODE_L                  |
   //       +--------------+--------------------+-----------+--------------------------+
   assign   sign_a_u       =  mode == `MODE_E   ?  `ADD     :  `ADD                    ;
   assign   sign_a_v       =  mode == `MODE_E   ?  `ADD     :  `ADD                    ;
   assign   sign_b_u       =  mode == `MODE_E   ?  `SUBB    :  `ADD                    ;
   assign   sign_b_v       =  mode == `MODE_E   ?  `SUBB    :  `ADD                    ;
   assign   a_u            =  mode == `MODE_E   ?   u_n     :   u_n_plus_d_u_n         ;
   assign   a_v            =  mode == `MODE_E   ?   v_n     :   v_n_plus_d_v_n         ;
   assign   b_u            =  mode == `MODE_E   ?   lut_u_n :   u_n_times_d_n_div_2_n  ;
   assign   b_v            =  mode == `MODE_E   ?   lut_v_n :   v_n_times_d_n_div_2_n  ;
   //       +--------------+--------------------+-----------+--------------------------+

   // -----------------------------------------------------
   // Complex adder for w_n
   // -----------------------------------------------------
   complex_add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1+1)     //TODO: I am adding 2 numbers of (W+1)

      // TODO: tengo q agregarle 3 bits de guarda?

   ) complex_add_sub (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a_x            (sign_a_u),
      .subb_a_y            (sign_a_v),
      .subb_b_x            (sign_b_u),
      .subb_b_y            (sign_b_v),
      .a_x                 ({a_u[W], a_u}),
      .a_y                 ({a_v[W], a_v}),
      .b_x                 ({b_u[W], b_u}),
      .b_y                 ({b_v[W], b_v}),
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


