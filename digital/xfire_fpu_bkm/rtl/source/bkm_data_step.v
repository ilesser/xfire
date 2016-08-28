// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Performs the nth data step of the BKM algorithm.
//
// E-mode
// ------
// Z = E
// Z_{n+1} = Z_n * (1 + d_n * 2^-n)
//
//                          -n
// Z     =  Z  * (1 + d  * 2   )
//  n+1      n         n
//
//
// L-mode
// ------
// Z = L
// Z_{n+1} = Z_n - ln(1 + d_n * 2^-n)
//
//                           -n
// Z     = Z  - ln(1 + d  * 2   )
//  n+1     n           n
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_data_step.v
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
//    TODO: implement power savings based on format. Currently it works always
//          in double word complex format.
//    - 2016-08-28 - ilesser - Updated default parameters.
//    - 2016-08-15 - ilesser - Changed outputs to wires.
//    - 2016-08-10 - ilesser - Duplicated BUG3 fix.
//    - 2016-07-22 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_data_step #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 72,
    parameter LOG2W  = 7,
    parameter LOG2N  = 6,
    parameter ARCH   = "CSD"
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
    input wire    [1:0]       d_x_n,        // d_n is encoded in ones complement
    input wire    [1:0]       d_y_n,        // d_n is encoded in ones complement
    input wire    [2*W-1:0]   X_n,
    input wire    [2*W-1:0]   Y_n,
    input wire    [2*W-1:0]   lut_X,
    input wire    [2*W-1:0]   lut_Y,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output wire   [2*W-1:0]   X_np1,
    output wire   [2*W-1:0]   Y_np1
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
//
//             +--------------------------------+
//             |                                |
// n      ---->+                                |
// d_x_n  ---->+                                |
// d_y_n  ---->+                                |
//             |           DATA STEP            |
// X_n    ---->+                                +---->   X_np1
// Y_n    ---->+                                +---->   Y_np1
// lut_X  ---->+                                |
// lut_Y  ---->+                                |
//             |                                |
//             +--------------------------------+


   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire                 sign_a_x;
   wire                 sign_a_y;
   wire                 sign_b_x;
   wire                 sign_b_y;
   wire  [2*W+1:0]      a_x;
   wire  [2*W+1:0]      a_y;
   wire  [2*W+1:0]      b_x;
   wire  [2*W+1:0]      b_y;
   wire  [2*W+1:0]      X_n_times_d_n;
   wire  [2*W+1:0]      Y_n_times_d_n;
   wire  [2*W+1:0]      X_n_times_d_n_div_2_n;
   wire  [2*W+1:0]      Y_n_times_d_n_div_2_n;
   wire  [1:0]          c_x;
   wire  [1:0]          c_y;
   wire  [2*W+1:0]      s_x;
   wire  [2*W+1:0]      s_y;
   // -----------------------------------------------------

// *****************************************************************************
// DATA PATH
// *****************************************************************************

   // -----------------------------------------------------
   // Multiply by d_n
   // -----------------------------------------------------
   multiply_by_d_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                  (W+1)
   ) multiply_by_d_csd (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .d_x                 (d_x_n),
      .d_y                 (d_y_n),
      .x_in                ({`CSD_0_0, X_n}),
      .y_in                ({`CSD_0_0, Y_n}),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x_out               (X_n_times_d_n),
      .y_out               (Y_n_times_d_n)
    );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Barrel shifter for X
   // -----------------------------------------------------
   barrel_shifter_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1),
      .LOG2W               (LOG2W)
   ) barrel_shifter_csd_x(
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (`DIR_RIGHT),
      .sel                 ({{(LOG2W-LOG2N){1'b0}},n}),
      .in                  (X_n_times_d_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (X_n_times_d_n_div_2_n)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Barrel shifter for Y
   // -----------------------------------------------------
   barrel_shifter_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1),
      .LOG2W               (LOG2W)
   ) barrel_shifter_csd_y(
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (`DIR_RIGHT),
      .sel                 ({{(LOG2W-LOG2N){1'b0}},n}),
      .in                  (Y_n_times_d_n),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (Y_n_times_d_n_div_2_n)
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
   assign   b_x            =  mode == `MODE_E   ?   X_n_times_d_n_div_2_n  :   lut_X   ;
   assign   b_y            =  mode == `MODE_E   ?   Y_n_times_d_n_div_2_n  :   lut_Y   ;
   //       +--------------+--------------------+--------------------------+-----------+

   // -----------------------------------------------------
   // CSD adder
   // -----------------------------------------------------
   complex_add_subb_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W+1)
   ) complex_add_subb_csd (
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
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   //XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule


