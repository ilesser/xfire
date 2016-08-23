// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// LUT decoder for BKM algorithm.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// lut_decoder.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - None
//
//  Data inputs:
//    - mode      : Operation mode (logic, 1 bit).
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for 64 bit, 1 for 32 bit
//                                                 |---> Complex:    0 for complex args, 1 for real args
//    - d_x       : Real part of decision signal (one's complement, 2 bits).
//    - d_y       : Imag part of decision signal (one's complement, 2 bits).
//    - n         : Number of the step. (unsigned, LOG2N bits).
//
//  Data outputs:
//    - lut_X     : Real part of data channel lut (CSD, WD bits).
//    - lut_Y     : Imag part of data channel lut (CSD, WD bits).
//    - lut_u     : Real part of control channel lut (two's complement, WC bits).
//    - lut_v     : Imag part of control channel lut (two's complement, WC bits).
//
//  Parameters:
//    - WD        : Word width of the data channel (natural, default: 64).
//    - WC        : Word width of the control channel (natural, default: 16).
//    - LOG2N     : Logarithm of base 2 of the step size (natural, default: 6).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-22 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module lut_decoder #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter WD     = 64,
   parameter WC     = 64,
   parameter LOG2N  = 6
) (
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input    wire              mode,
   input    wire  [1:0]       format,
   input    wire  [1:0]       d_x,
   input    wire  [1:0]       d_y,
   input    wire  [LOG2N-1:0] n,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output   wire  [2*WD-1:0]  lut_X,
   output   wire  [2*WD-1:0]  lut_Y,
   output   wire  [WC-1:0]    lut_u,
   output   wire  [WC-1:0]    lut_v
);
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

// TODO: escribir las luts como ya negadas para evitar tener q negar en los sumadores???
   // E mode:
   // -------
   //
   // lut   = 2 * ( ln(1+d_n*2^-n) * 2^n )
   // lut_u = ln[ 1 + d_x 2^(-n+1) + (d_x^2 + d_y^2) * 2^-2n]  * 2^n
   // lut_v = d_y * atan[ 2^-n / (1+d_x 2^-n) ]                * 2^(n+1)

   // L mode:
   // -------
   //
   // lut   = ln(1+d_n*2^-n)
   // lut_X = 1/2 * ln[ 1 + d_x 2^(-n+1) + (d_x^2 + d_y^2) * 2^-2n]
   // lut_Y = d_y * atan[ 2^-n / (1+d_x 2^-n) ]


   // Comparison

   // lut_u = ln[ 1 + d_x 2^(-n+1) + (d_x^2 + d_y^2) * 2^-2n]  * 2^n    |  WC bits
   // lut_X = ln[ 1 + d_x 2^(-n+1) + (d_x^2 + d_y^2) * 2^-2n]  * 2^-1   |  WD bits

   // ln(x) in monotonically incresing so ln(f(x)) reaches its extreme points at
   // the extremes of f(x)

   // let f_d(n) = 1 + d_x 2^(-n+1) + (d_x^2 + d_y^2) * 2^-2n  then f_d(n) <= ln(5)    for all d and n.
   // Excluding the case d = 0 ^ n = 0                         then f_d(n) >= ln(0.25) for all d and n.
   //
   //    -0.6020 = ln(0.25) <= f_d(n) <= ln(5) = 0.6989
   // Then I can simply save the bits relative to 1.XXXXXXXXX




   // TODO  for  the imaginary part the d_y that sets the sign could be splitted in two:
   //       in the lut_decoder I select between 0 or atan (2^-n/(1+d_x*2^-n)) and
   //       then in the adder I select the sign based on the sign of d_y
   // lut_v = d_y * atan[ 2^-n / (1+d_x 2^-n) ] * 2^(n+1)               |  WC bits
   // lut_Y = d_y * atan[ 2^-n / (1+d_x 2^-n) ]                         |  WD bits

   // lut_Y <= 1  for all n, d_n
   // lut_v <= 1  for all n, d_n
   // Then I can simply save the bits relative to 1.XXXXXXXXX

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire [3:0]        d_n;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Constants definition
   // -----------------------------------------------------
   // Real part
   wire [2*WD-1:0]   X  [3:0] [1:(2**LOG2N)];
   wire [WC-1:0]     u  [3:0] [1:(2**LOG2N)];

   // Imaginary part
   wire [2*WD-1:0]   Y  [3:0] [1:(2**LOG2N)];
   wire [WC-1:0]     v  [3:0] [1:(2**LOG2N)];
   `include "lut_constants.vh"
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   //assign lut_X = {WD{`CSD_0_0}};
   //assign lut_Y = {WD{`CSD_0_1}};
   //assign lut_u = {WC{1'b1}};
   //assign lut_v = {WC{1'b0}};

   assign d_n = {d_x, d_y};

   // TODO: implement format
   // TODO: implement dependecies on d_y for the real part
   // TODO: implement dependecies on d_y for the imag part
   // TODO: another option is just to save the values in binary and
   //       then convert them to CSD here for the data channel.
   //       for the control channel I can use a div_by_2_n block here
   always@(*) begin
      lut_X = mode == `MODE_E   ?  {WD{`CSD_0_0}}  : X[d_n][n];
      lut_Y = mode == `MODE_E   ?  {WD{`CSD_0_0}}  : Y[d_n][n];
      lut_u = mode == `MODE_E   ?   u[d_n][n]      : {WC{1'b0}};
      lut_v = mode == `MODE_E   ?   v[d_n][n]      : {WC{1'b0}};

      //lut_v =  mode == `MODE_L      ?  {WC{1'b0}}     :
               //d_y[`D_DATA] == 1'b0 ?  {WC{1'b0}}     :
                                       //v[d_n][n]      ;  // Here d_y = +-1
   end

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

