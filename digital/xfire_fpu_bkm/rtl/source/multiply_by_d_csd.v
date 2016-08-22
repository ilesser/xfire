// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Cannonic Signed Digit (CSD) complex multiplication by d.
// Possible values for d: {0, +-1, +-j, 1+-j, -1+-j}
//
// z_in  = x_in + j y_in
// d     = d_x  + j d_y
// z_out = z_in * d
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
//    - d_x       : Real part of d (one's complement, 2 bits).
//    - d_y       : Imag part of d (one's complement, 2 bits).
//    - x_in      : Real part of z (CSD, 2*W bits).
//    - y_in      : Imag part of z (CSD, 2*W bits).
//
//  Data outputs:
//    - x_out     : Result x_out = x * dx - y * dy (CSD, 2*W bits).
//    - y_out     : Result y_out = x * dy + y * dx (CSD, 2*W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-18 - ilesser - Renamed csd_* to *_csd.
//    - 2016-07-10 - ilesser - Added defines for d_x/d_y sign and data.
//    - 2016-05-02 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

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
   wire  [1:0]          c_x;
   wire  [1:0]          c_y;
   wire  [2*W-1:0]      x_dx_dy;
   wire  [2*W-1:0]      y_dx_dy;
   reg   [2*W-1:0]      x_dx;
   reg   [2*W-1:0]      y_dx;
   reg   [2*W-1:0]      x_dy;
   reg   [2*W-1:0]      y_dy;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // If dx != 0 ^ dy == 0 then
   // z * d = z_dx_dy = (x dx - y dy) + j (x dy + y dx)
   // -----------------------------------------------------
   add_subb_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) add_subb_csd_x (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              ( d_x[`D_SIGN]),
      .subb_b              (~d_y[`D_SIGN]),
      .a                   (x_in),
      .b                   (y_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (c_x),
      .s                   (x_dx_dy)
   );

   add_subb_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) add_subb_csd_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              (d_y[`D_SIGN]),
      .subb_b              (d_x[`D_SIGN]),
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
            // Flipping all the bits is equivalent to negation
            // Invert x and y depending on the sign of d_x
            x_dx[i] = x_in[i] ^ d_x[`D_SIGN];
            y_dx[i] = y_in[i] ^ d_x[`D_SIGN];
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
            // Flipping all the bits is equivalent to negation
            // Invert x and y depending on the sign of d_y
            x_dy[i] = y_in[i] ^ ~d_y[`D_SIGN];
            y_dy[i] = x_in[i] ^  d_y[`D_SIGN];
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
      casex({d_x[`D_DATA],d_y[`D_DATA]})
         // If d_x == 0 ^ d_y != 0
         2'b01: begin
                     x_out = x_dy;
                     y_out = y_dy;
                  end
         // If d_x != 0 ^ d_y == 0
         2'b10: begin
                     x_out = x_dx;
                     y_out = y_dx;
                  end
         // If d_x != 0 ^ d_y != 0
         2'b11: begin
                     x_out = x_dx_dy;
                     y_out = y_dx_dy;
                  end

         default: begin
                     x_out = {W{1'b0}};
                     y_out = {W{1'b0}};
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


