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
//    - 2016-09-14 - ilesser - Changed get_d parameters.
//    - 2016-09-14 - ilesser - Updated default parameter WC = 20.
//    - 2016-09-07 - ilesser - Updated default parameter WC = 20.
//    - 2016-09-07 - ilesser - Implemented rolled architcture.
//    - 2016-09-05 - ilesser - Removed CSD conversion from this block.
//    - 2016-08-28 - ilesser - Updated default parameters.
//    - 2016-08-22 - ilesser - Uncommented lut_decoder.
//    - 2016-07-11 - ilesser - Build an unrolled version.
//    - 2016-04-23 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_steps  (
   clk, arst, srst, enable,
   start, mode, format,
   X_in, Y_in,
   u_in, v_in,
   X_out, Y_out,
   u_out, v_out,
   flags, done
);
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter   N        = 64;
   parameter   LOG2N    = 6;
   parameter   WD       = 72;
   parameter   WC       = 22;
   parameter   LOG2WD   = 7;
   parameter   LOG2WC   = 5;
   parameter   UGD      = 2;
   parameter   LGD      = 6;
   parameter   UGC      = 3;
   parameter   LGC      = 4;
   parameter   WI       = 11;
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input wire                    clk;
   input wire                    arst;
   input wire                    srst;
   input wire                    enable;
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input    wire                 start;
   input    wire                 mode;
   input    wire  [1:0]          format;
   input    wire  [2*WD-1:0]     X_in;
   input    wire  [2*WD-1:0]     Y_in;
   input    wire  [WC-1:0]       u_in;
   input    wire  [WC-1:0]       v_in;
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output   wire  [2*WD-1:0]     X_out;
   output   wire  [2*WD-1:0]     Y_out;
   output   wire  [WC-1:0]       u_out;
   output   wire  [WC-1:0]       v_out;
   output   wire  [`FSIZE-1:0]   flags;
   output   wire                 done;

// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Registers
   // -----------------------------------------------------
   reg   [LOG2N-1:0] n;
   reg   [2*WD-1:0]  X_n_reg;
   reg   [2*WD-1:0]  Y_n_reg;
   reg   [WC-1:0]    u_n_reg;
   reg   [WC-1:0]    v_n_reg;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Internal wiring
   // -----------------------------------------------------
   wire  [1:0]       d_x_n;
   wire  [1:0]       d_y_n;
   wire  [2*WD-1:0]  lut_X_n;
   wire  [2*WD-1:0]  lut_Y_n;
   wire  [WC-1:0]    lut_u_n;
   wire  [WC-1:0]    lut_v_n;
   wire  [2*WD-1:0]  X_n, X_np1;
   wire  [2*WD-1:0]  Y_n, Y_np1;
   wire  [WC-1:0]    u_n, u_np1;
   wire  [WC-1:0]    v_n, v_np1;
   // -----------------------------------------------------


   // -------------------------------------
   // N counter
   // -------------------------------------
   always @(posedge clk or posedge arst) begin
      if (arst) begin
         n <= {{LOG2N-1{1'b0}}, 1'b1};
      end
      else if (srst|start) begin
         n <= {{LOG2N-1{1'b0}}, 1'b1};
      end
      else if (enable&~done) begin
         n <= n + 1;
      end
   end

   // TODO: Should I stop when n=64 or n=65?
   assign done  = n[LOG2N-1];
   // -------------------------------------


   // -------------------------------------
   // Assign starting values of the algorithm
   // -------------------------------------
   // TODO: implement input latching when start==1 ??
   //       if the input comes from the previous block registered then I don't need it
   assign   X_n   = start == 1'b1 ?    X_in  :  X_n_reg;
   assign   Y_n   = start == 1'b1 ?    Y_in  :  Y_n_reg;
   assign   u_n   = start == 1'b1 ?    u_in  :  u_n_reg;
   assign   v_n   = start == 1'b1 ?    v_in  :  v_n_reg;

   // ----------------------------------
   // Get d_n
   // ----------------------------------
   get_d #(
      .WC         (WC),
      .WCI        (UGC + WI),
      .WCF        (4 + LGC)
   ) get_d_n (
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .mode       (mode),
      .u          (u_n),
      .v          (v_n),
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .d_x        (d_x_n),
      .d_y        (d_y_n)
   );

   // ----------------------------------
   // LUT decoder
   // ----------------------------------
   lut_decoder #(
      .WD         (WD),
      .WC         (WC),
      .LOG2N      (LOG2N)
   ) lut_decoder_n (
      // ----------------------------------
      // Data inputs
      // ----------------------------------

      .mode       (mode),
      .format     (format),
      .n          (n),
      .d_x_n      (d_x_n),
      .d_y_n      (d_y_n),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .lut_X      (lut_X_n),
      .lut_Y      (lut_Y_n),
      .lut_u      (lut_u_n),
      .lut_v      (lut_v_n)
   );

   // ----------------------------------
   // Step n
   // ----------------------------------
   bkm_step #(
      .WD         (WD),
      .WC         (WC),
      .LOG2WD     (LOG2WD),
      .LOG2WC     (LOG2WC),
      .LOG2N      (LOG2N)
   ) bkm_step_n (
      // ----------------------------------
      // Clock, reset & enable inputs
      // ----------------------------------
      .clk        (clk),
      .arst       (arst),
      .srst       (srst),
      .enable     (enable),
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .mode       (mode),
      .format     (format),
      .n                (n),
      .d_x_n      (  d_x_n),     .d_y_n      (  d_y_n),
      .X_n        (    X_n),     .Y_n        (    Y_n),
      .lut_X      (lut_X_n),     .lut_Y      (lut_Y_n),
      .u_n        (    u_n),     .v_n        (    v_n),
      .lut_u      (lut_u_n),     .lut_v      (lut_v_n),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_np1      (    X_np1),   .Y_np1      (    Y_np1),
      .u_np1      (    u_np1),   .v_np1      (    v_np1)
   );

   // -------------------------------------
   // Feedback
   // -------------------------------------
   always @(posedge clk or posedge arst) begin
      if (arst) begin
         X_n_reg <= {WD{`CSD_0_0}};
         Y_n_reg <= {WD{`CSD_0_0}};
         u_n_reg <= {WC{1'b0}};
         v_n_reg <= {WC{1'b0}};
      end
      else if (srst) begin
         X_n_reg <= {WD{`CSD_0_0}};
         Y_n_reg <= {WD{`CSD_0_0}};
         u_n_reg <= {WC{1'b0}};
         v_n_reg <= {WC{1'b0}};
      end
      else if (enable) begin
         if (done == 1'b1) begin
            X_n_reg <= X_n_reg;
            Y_n_reg <= Y_n_reg;
            u_n_reg <= u_n_reg;
            v_n_reg <= v_n_reg;
         end
         else begin
            #1 X_n_reg <= X_np1;
            #1 Y_n_reg <= Y_np1;
            #1 u_n_reg <= u_np1;
            #1 v_n_reg <= v_np1;
         end
      end
   end


   // -------------------------------------
   // Assign outputs
   // -------------------------------------
   assign X_out = X_n_reg;
   assign Y_out = Y_n_reg;
   assign u_out = u_n_reg;
   assign v_out = v_n_reg;
   // TODO: implement output latching when done==1
   //       if the output comes from the previous block registered then I don't need it
   //assign X_out = done == 1'b1   ?  X_n_reg  :  {WD{`CSD_0_0}};
   //assign Y_out = done == 1'b1   ?  Y_n_reg  :  {WD{`CSD_0_0}};
   //assign u_out = done == 1'b1   ?  u_n_reg  :  {WC{1'b0}};
   //assign v_out = done == 1'b1   ?  v_n_reg  :  {WC{1'b0}};

   // TODO: implement flags
   assign flags = {`FSIZE{1'b0}};
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

