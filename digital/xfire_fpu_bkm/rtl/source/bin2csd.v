// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Binary to Cannonic Signed Digit (CSD) representation.
// It follows this equation to calculate the CSD representation of x:
//
//    y = CSD(x)
//    x = x_{W-1} x_{W-2} ... x_1 x_0
//    y = y_{2*W-1} y_{2*W-2} ... y_1 y_0
//
//    B_0 = 0
//    B_i = B_i +   x_{i+1} + x_i
//    y_i = B_i - 2*x_{i+1} + x_i
//
// B_i behaves as the carry out of a full adder so it follows the rules of
// binary addition, i.e. B_{i+1} is 1 if there are 2 or 3 ones among
// B_i, x_{i+1} and x_i.
//
// y_i is taken from 3 full adders.
//
//          0        B_i
//       +  0        x_i
//       -  x_{i+1}  0
//         --------------
//       cy y1_i     y0_i     -->   y_i = {y1_i, y0_i}
//
//
//
// Taken from :
// Geetanjali  Wasson, "IEEE-754 compliant Algorithms for Fast Multiplication
//                      of Double Precision Floating Point Numbers".
// International   Journal   of   Research   in   Computer   Science,
// 1   (1):   pp.   1-7 , September   2011.   doi:10.7815/ijorcs.11.2011.001
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bin2csd.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - None
//
//  Data inputs:
//    - x         : X input variable (two's complement, W bits).
//
//  Data outputs:
//    - y         : Y output result (cannonic signed digit, 2*W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-03-15 - ilesser   - Initial version
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
module bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire [W-1:0]        x,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg [2*W-1:0]      y
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // Variables for B_i generation
   reg   [W:0]          B;
   reg   [W-1:0]        sB;

   // Variables for y_i generation
   reg   [W-1:0]   cxB [0:1];
   reg   [W-1:0]   sxB;
   reg   [W-1:0]   cyB [0:2];
   reg   [W-1:0]   syB [0:1];

   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------
   initial
      B[0]  = 1'b0;

   genvar i;
   generate
      for (i=0; i < W; i=i+1) begin

         always @(*) begin

            // Generation of B_i
            // B_{i+1} is the carry of x_{i+1} + x_i + B_i
            {B[i+1],    sB[i]}      = x[i+1]  + x[i]      + B[i];

            // Generation of y_i
            // y_i = B_i + x_i - 2 x_{i+1}

            // Initialize carries to 0 to add and 1 to substract
            cxB[0][i] = 1'b0;
            cyB[0][i] = 1'b1;

            // First add x_i and B_i
            {cxB[1][i], sxB[i]}     = x[i]    + B[i]      + cxB[0][i];

            // To the result substract 2 x_{i+1}
            {cyB[1][i], syB[0][i]}  = 1'b1    + sxB[i]    + cyB[0][i];
            {cyB[2][i], syB[1][i]}  = ~x[i+1] + cxB[1][i] + cyB[1][i];

            y[2*i+1:2*i] = {syB[1][i], syB[0][i]};
         end

      end
   endgenerate

   // -----------------------------------------------------

// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

