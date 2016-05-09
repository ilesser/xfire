// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Cannonic Signed Digit (CSD) complex multiplication by d.
// Possible values for d: {0, +-1, +-j, 1+-j, -1+-j}
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// multiply_by_d_csd.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Data inputs:
//    - d_x       : Real part of summand a (CSD, 2*W bits).
//    - d_y       : Imaginary part of summand a (CSD, 2*W bits).
//    - x_in      : Real part of summand b (CSD, 2*W bits).
//    - y_out     : Imaginary part of summand b (CSD, 2*W bits).
//
//  Data outputs:
//    - x_out     : Result s_x = (-1)^subb_a * a_x + (-1)^subb_b * b_x (CSD, 2*W bits).
//    - y_out     : Result s_y = (-1)^subb_a * a_y + (-1)^subb_b * b_y (CSD, 2*W bits).
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
module multiply_by_d_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input   wire  [1:0]       d_x,
    input   wire  [1:0]       d_y,
    input   wire  [2*W-1:0]   x_in,
    input   wire  [2*W-1:0]   y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [2*W-1:0]   x_out,
    output  reg   [2*W-1:0]   y_out
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
// This architecture uses the advantage bb blocks to implement the complex adder.
// z = x + j y
// d = dx + j dy
// z * d = z_dx_dy = (x dx - y dy) + j (x dy + y dx)   if dx != 0 ^ dy != 0
// z * d = z_dx    = (x + j y) dx                      if dx != 0 ^ dy == 0
// z * d = z_dy    = (-y + j x) dy                     if dx == 0 ^ dy != 0
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg   [2*W-1:0]      x_dx_dy;
   reg   [2*W-1:0]      y_dx_dy;
   reg   [2*W-1:0]      x_dx;
   reg   [2*W-1:0]      y_dx;
   reg   [2*W-1:0]      x_dy;
   reg   [2*W-1:0]      y_dy;
   wire  [1:0]          c_x;
   wire  [1:0]          c_y;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // If dx != 0 ^ dy == 0 then
   // z * d = z_dx = (x + j y) dx
   // -----------------------------------------------------
   csd_add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd_add_subb_x (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              ( d_x[1]),  // TODO: extract sign
      .subb_b              (~d_y[1]),  // TODO: extract sign
      .a                   (x_in),
      .b                   (y_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (c_x),
      .s                   (x_dx_dy)
   );

   csd_add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd_add_subb_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              (d_y[1]),  // TODO: extract sign
      .subb_b              (d_x[1]),  // TODO: extract sign
      .a                   (x_in),
      .b                   (y_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (c_y),
      .s                   (y_dx_dy)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // If dx != 0 ^ dy == 0 then
   // z * d = z_dx = (x + j y) dx
   // -----------------------------------------------------
   genvar i;
   generate
      for (i=0; i < 2*W; i=i+1) begin
         always @(*) begin
            // Flipping all the bits when substracting
            // Invert a and b depending on subb_a and subb_b
            x_dx[i] = x_in[i] ^ d_x;
            y_dx[i] = y_in[i] ^ d_x;
         end
      end
   endgenerate
   // -----------------------------------------------------

   // -----------------------------------------------------
   // If dx == 0 ^ dy != 0 then
   // z * d = z_dy = (-y + j x) dy
   // -----------------------------------------------------
   generate
      for (i=0; i < 2*W; i=i+1) begin
         always @(*) begin
            // Flipping all the bits when substracting
            // Invert a and b depending on subb_a and subb_b
            x_dy[i] = y_in[i] ^ ~d_y;
            y_dy[i] = x_in[i] ^  d_y;
         end
      end
   endgenerate
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Select the correct multiplication
   // z * d = z_dx_dy = (x dx - y dy) + j (x dy + y dx)   if dx != 0 ^ dy != 0
   // z * d = z_dx    = (x + j y) dx                      if dx != 0 ^ dy == 0
   // z * d = z_dy    = (-y + j x) dy                     if dx == 0 ^ dy != 0
   // -----------------------------------------------------
   always @(*) begin
      casex({d_x,d_y})
         4'b00XX: begin
                     x_out = x_dy;
                     y_out = y_dy;
                  end
         4'bXX00: begin
                     x_out = x_dx;
                     y_out = y_dx;
                  end
         default: begin
                     x_out = x_dx_dy;
                     y_out = y_dx_dy;
                  end
      endcase
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


