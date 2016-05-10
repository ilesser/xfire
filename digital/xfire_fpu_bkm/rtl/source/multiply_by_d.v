// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Two's complement complex multiplication by d.
// Possible values for d: {0, +-1, +-j, 1+-j, -1+-j}
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// multiply_by_d.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Data inputs:
//    - d_x       : Real part of d (one's complement, 2 bits).
//    - d_y       : Imag part of d (ones's complement, 2 bits).
//    - x_in      : Real part of z (two's complement, W bits).
//    - y_in      : Imag part of z (two's complement, W bits).
//
//  Data outputs:
//    - x_out     : Result x_out = x * dx - y * dy (two's complement, W bits).
//    - y_out     : Result y_out = x * dy + y * dx (two's complement, W bits).
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
module multiply_by_d #(
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
    input   wire  [W-1:0]     x_in,
    input   wire  [W-1:0]     y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [W-1:0]     x_out,
    output  reg   [W-1:0]     y_out
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
   reg   [W-1:0]        x_dx_dy;
   reg   [W-1:0]        y_dx_dy;
   reg   [W-1:0]        x_dx;
   reg   [W-1:0]        y_dx;
   reg   [W-1:0]        x_dy;
   reg   [W-1:0]        y_dy;
   wire                 c_x;
   wire                 c_y;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // If dx != 0 ^ dy == 0 then
   // z * d = z_dx_dy = (x dx - y dy) + j (x dy + y dx)
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



