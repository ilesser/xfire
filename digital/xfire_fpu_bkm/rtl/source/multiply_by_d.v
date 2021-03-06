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
//    - d_y       : Imag part of d (one's complement, 2 bits).
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
//    - 2016-08-02 - ilesser - Added defines.
//    - 2016-05-02 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

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
//Complex multiplication normally involves four multiplications and two additions.
//(a+bi)(c+di)=(ac-bd)+(bc+ad)j.
// By 1805 Gauss had discovered a way of reducing the number of multiplications to three
// The product (a + bi) · (c + di) can be calculated in the following way.
//k1 = c · (a + b)
//k2 = a · (d − c)
//k3 = b · (c + d)
//Real part = k1 − k3
//Imaginary part = k1 + k2.

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire                 d_x_sign;
   wire                 d_x_data;
   wire                 d_y_sign;
   wire                 d_y_data;
   wire                 cx_dx_dy;
   wire                 cy_dx_dy;
   wire  [W-1:0]        x_dx_dy;
   wire  [W-1:0]        y_dx_dy;
   reg   [W:0]          cx_dx;
   reg   [W:0]          cy_dx;
   reg   [W-1:0]        x_dx_xor;
   reg   [W-1:0]        y_dx_xor;
   reg   [W-1:0]        x_dx;
   reg   [W-1:0]        y_dx;
   reg   [W:0]          cx_dy;
   reg   [W:0]          cy_dy;
   reg   [W-1:0]        x_dy_xor;
   reg   [W-1:0]        y_dy_xor;
   reg   [W-1:0]        x_dy;
   reg   [W-1:0]        y_dy;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Obtain d signs and data
   // -----------------------------------------------------
   assign d_x_sign = d_x[`D_SIGN];
   assign d_x_data = d_x[`D_DATA];
   assign d_y_sign = d_y[`D_SIGN];
   assign d_y_data = d_y[`D_DATA];
   // -----------------------------------------------------

   // -----------------------------------------------------
   // If dx != 0 ^ dy != 0 then
   // z * d = z_dx_dy = (x dx - y dy) + j (x dy + y dx)
   // -----------------------------------------------------
   add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) add_subb_x (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              ( d_x_sign),
      .subb_b              (~d_y_sign),
      .a                   (x_in),
      .b                   (y_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (cx_dx_dy),
      .s                   (x_dx_dy)
   );

   add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) add_subb_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              (d_y_sign),
      .subb_b              (d_x_sign),
      .a                   (x_in),
      .b                   (y_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (cy_dx_dy),
      .s                   (y_dx_dy)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // If dx != 0 ^ dy == 0 then
   // z * d = z_dx = (x + j y) dx
   // -----------------------------------------------------
   always @(*) begin
      cx_dx[0] = d_x_sign;
      cy_dx[0] = d_x_sign;
   end

   genvar i;
   generate
      for (i=0; i < W; i=i+1) begin
         always @(*) begin
            // Ripple carry adder to invert and add 1
            // Invert a and b depending on subb_a and subb_b
            x_dx_xor[i] = x_in[i] ^ d_x_sign;
            y_dx_xor[i] = y_in[i] ^ d_x_sign;

            {cx_dx[i+1], x_dx[i]} = x_dx_xor[i] + cx_dx[i];
            {cy_dx[i+1], y_dx[i]} = y_dx_xor[i] + cy_dx[i];
         end
      end
   endgenerate
   // -----------------------------------------------------

   // -----------------------------------------------------
   // If dx == 0 ^ dy != 0 then
   // z * d = z_dy = (-y + j x) dy
   // -----------------------------------------------------
   always @(*) begin
      cx_dy[0] =~d_y_sign; //1
      cy_dy[0] = d_y_sign; //0
   end

   generate
      for (i=0; i < W; i=i+1) begin
         always @(*) begin
            // Ripple carry adder to invert and add 1
            // Invert x_dy and y_dy depending on the sign of dy
            x_dy_xor[i] = y_in[i] ^ ~d_y_sign;  // ^ 1 == inv
            y_dy_xor[i] = x_in[i] ^  d_y_sign;  // ^ 0 == buff

            {cx_dy[i+1], x_dy[i]} = x_dy_xor[i] + cx_dy[i];
            {cy_dy[i+1], y_dy[i]} = y_dy_xor[i] + cy_dy[i];
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
      case({d_x,d_y})
         // d is 0
         4'b0000, // dx = +0, dy = +0
         4'b0010, // dx = +0, dy = -0
         4'b1000, // dx = -0, dy = +0
         4'b1010: // dx = -0, dy = -0
                  begin
                     x_out = {W{1'b0}};
                     y_out = {W{1'b0}};
                  end
         // d has only imaginary part
         4'b0001, // dx = +0, dy = +1
         4'b0011, // dx = +0, dy = -1
         4'b1001, // dx = -0, dy = +1
         4'b1011: // dx = -0, dy = -1
                  begin
                     x_out = x_dy;
                     y_out = y_dy;
                  end
         // d has only real part
         4'b0100, // dx = +1, dy = +0
         4'b0110, // dx = +1, dy = -0
         4'b1100, // dx = -1, dy = +0
         4'b1110: // dx = -1, dy = -0
                  begin
                     x_out = x_dx;
                     y_out = y_dx;
                  end
         // d has real and imaginary parts
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



