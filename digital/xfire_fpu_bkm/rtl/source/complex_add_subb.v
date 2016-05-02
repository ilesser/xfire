// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Two's complement complex adder/substractor.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// complex_add_subb.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Data inputs:
//    - subb_a    : Add(0)/sub(1) a (logic, 1 bit).
//    - subb_b    : Add(0)/sub(1) b (logic, 1 bit).
//    - a_x       : Real part of summand a (two's complement, 2*W bits).
//    - a_y       : Imaginary part of summand a (two's complement, 2*W bits).
//    - b_x       : Real part of summand b (two's complement, 2*W bits).
//    - b_y       : Imaginary part of summand b (two's complement, 2*W bits).
//
//  Data outputs:
//    - c_x       : Real part of the carry of the result   (two's complement, 2 bits).
//    - c_y       : Imaginary part of the carry of the result   (two's complement, 2 bits).
//    - s_x       : Result s_x = (-1)^subb_a * a_x + (-1)^subb_b * b_x (two's complement, 2*W bits).
//    - s_y       : Result s_y = (-1)^subb_a * a_y + (-1)^subb_b * b_y (two's complement, 2*W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-05-02 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
module complex_add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    //input   wire              subb_a,
    input   wire              subb_b,
    input   wire  [W-1:0]     a_x,
    input   wire  [W-1:0]     a_y,
    input   wire  [W-1:0]     b_x,
    input   wire  [W-1:0]     b_y,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg               c_x,
    output  reg               c_y,
    output  reg   [W-1:0]     s_x,
    output  reg   [W-1:0]     s_y
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
// This architecture uses two ripple carry adders to implement the complex adder.
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   //reg   [W-1:0]     a_x_inv;// inverted version of a_x
   //reg   [W-1:0]     a_y_inv;// inverted version of a_y
   reg   [W-1:0]     b_x_inv;// inverted version of b_x
   reg   [W-1:0]     b_y_inv;// inverted version of b_y
   reg   [W-1:0]     cxx;  // x carry vector
   reg   [W-1:0]     cyy;  // y carry vector
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // Initial values
   assign cxx[0] = subb_b;
   assign cyy[0] = subb_b;

   genvar i;
   generate
      for (i=0; i < W; i=i+1) begin
         always @(*) begin

            // Flipping all the bits when substracting
            // Invert a and b depending on subb_a and subb_b
            //a_x_inv[i] = a_x[i] ^ subb_a;
            //a_y_inv[i] = a_y[i] ^ subb_a;
            b_x_inv[i] = b_x[i] ^ subb_b;
            b_y_inv[i] = b_y[i] ^ subb_b;

            // Ripple carry adder
            // TODO add logic to invert a ?? Is it necessary??
            //{c_x[i+1], s_x[i]} = a_x_inv[i] + b_x_inv[i] + c_x[i];
            //{c_y[i+1], s_y[i]} = a_y_inv[i] + b_y_inv[i] + c_y[i];
            {cxx[i+1], s_x[i]} = a_x[i] + b_x_inv[i] + cxx[i];
            {cyy[i+1], s_y[i]} = a_y[i] + b_y_inv[i] + cyy[i];

         end
      end
   endgenerate

   // Carry output
   assign c_x = cxx[W];
   assign c_y = cyy[W];

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


