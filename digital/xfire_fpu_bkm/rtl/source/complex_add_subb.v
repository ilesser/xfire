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
    input   wire              subb_a_x,
    input   wire              subb_a_y,
    input   wire              subb_b_x,
    input   wire              subb_b_y,
    input   wire  [W-1:0]     a_x,
    input   wire  [W-1:0]     a_y,
    input   wire  [W-1:0]     b_x,
    input   wire  [W-1:0]     b_y,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  wire              c_x,
    output  wire              c_y,
    output  wire  [W-1:0]     s_x,
    output  wire  [W-1:0]     s_y
  );
// *****************************************************************************

`include "bkm_defs.vh"

// *****************************************************************************
// Architecture
// *****************************************************************************
// This architecture uses two ripple carry adders to implement the complex adder.
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // X Adder/subb
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
      .subb_a              (subb_a_x),
      .subb_b              (subb_b_x),
      .a                   (a_x),
      .b                   (b_x),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (c_x),
      .s                   (s_x)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Y Adder/subb
   // -----------------------------------------------------
   add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) add_subb_y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              (subb_a_y),
      .subb_b              (subb_b_y),
      .a                   (a_y),
      .b                   (b_y),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (c_y),
      .s                   (s_y)
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


