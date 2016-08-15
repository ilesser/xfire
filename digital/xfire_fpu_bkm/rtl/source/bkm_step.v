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
//    - 2016-08-15 - ilesser - Changed outputs to wires.
//    - 2016-08-11 - ilesser - Changed architecture: used local params WD and WC.
//    - 2016-07-23 - ilesser - Changed architecture: created bkm_control_step and bkm_data_step.
//    - 2016-07-18 - ilesser - Added CSD barrel shifter.
//    - 2016-07-18 - ilesser - Renamed csd_* to *_csd.
//    - 2016-07-18 - ilesser - Removed regs by wires. Signal definition clean up.
//    - 2016-04-23 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_step   (
   clk, arst, srst, enable,
   mode, format,
   n, d_x_n, d_y_n,
   X_n, Y_n, lut_X, lut_Y,
   u_n, v_n, lut_u, lut_v,
   X_np1, Y_np1,
   u_np1, v_np1
);
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter   W        = 64;
   parameter   LOG2W    = 6;
   parameter   LOG2N    = 6;
   localparam  WC       = W/4;
   localparam  WD       = W;
   localparam  LOG2WC   = LOG2W-2;
   localparam  LOG2WD   = LOG2W;
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input wire                 clk;
   input wire                 arst;
   input wire                 srst;
   input wire                 enable;
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input  wire                mode;
   input  wire [1:0]          format;
   input  wire [LOG2N-1:0]    n;
   input  wire [1:0]          d_x_n;        // d_n is encoded in ones complement
   input  wire [1:0]          d_y_n;        // d_n is encoded in ones complement
   input  wire [2*WD-1:0]     X_n;
   input  wire [2*WD-1:0]     Y_n;
   input  wire [2*WD-1:0]     lut_X;
   input  wire [2*WD-1:0]     lut_Y;
   input  wire [WC-1:0]       u_n;
   input  wire [WC-1:0]       v_n;
   input  wire [WC-1:0]       lut_u;
   input  wire [WC-1:0]       lut_v;
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire [2*WD-1:0]     X_np1;
   output wire [2*WD-1:0]     Y_np1;
   output wire [WC-1:0]       u_np1;
   output wire [WC-1:0]       v_np1;

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
// v_n    ---->+            SIZE = W/4          +---->   v_np1
// lut_u  ---->+                                |
// lut_v  ---->+                                |
//             |                                |
//             +--------------------------------+
//
//
//             +--------------------------------+
//             |                                |
// n      ---->+                                |
// d_x_n  ---->+                                |
// d_y_n  ---->+                                |
//             |           DATA STEP            |
// X_n    ---->+                                +---->   X_np1
// Y_n    ---->+           SIZE = W             +---->   Y_np1
// lut_X  ---->+                                |
// lut_Y  ---->+                                |
//             |                                |
//             +--------------------------------+


   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // For the control path
   wire  [1:0]          d_u_n;
   wire  [1:0]          d_v_n;
   // -----------------------------------------------------

   assign d_u_n = d_x_n;
   assign d_v_n = d_y_n;

   // -----------------------------------------------------
   // Control step
   // -----------------------------------------------------
   // TODO: imlpement a cap value for the division by 2^n for BUG7
   bkm_control_step #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (WC),
      .LOG2W               (LOG2WC),
      .LOG2N               (LOG2N-(LOG2WD-LOG2WC))
   ) bkm_control_step (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .mode                (mode),
      .format              (format),
      .n                   (n[LOG2N-(LOG2WD-LOG2WC)-1:0]),
      .d_u_n               (d_u_n),
      .d_v_n               (d_v_n),
      .u_n                 (u_n),
      .v_n                 (v_n),
      .lut_u_n             (lut_u),
      .lut_v_n             (lut_v),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .u_np1               (u_np1),
      .v_np1               (v_np1)
    );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Data step
   // -----------------------------------------------------
   bkm_data_step #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (WD),
      .LOG2W               (LOG2WD),
      .LOG2N               (LOG2N),
      .ARCH                ("CSD")
   ) bkm_data_step (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .mode                (mode),
      .format              (format),
      .n                   (n),
      .d_x_n               (d_x_n),
      .d_y_n               (d_y_n),
      .X_n                 (X_n),
      .Y_n                 (Y_n),
      .lut_X               (lut_X),
      .lut_Y               (lut_Y),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_np1               (X_np1),
      .Y_np1               (Y_np1)
    );
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


