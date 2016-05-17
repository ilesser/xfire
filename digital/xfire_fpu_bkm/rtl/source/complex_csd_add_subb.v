// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Cannonic Signed Digit (CSD) complex adder/substractor using borrow save representation.
//
//
// Borrow save:
//
//    y  = { y , y }      s stands for sign and d for data
//     BS     s   d
//
//    y  =  y - y
//     csd   d   s
//
// BS Digit |  CSD Value
// ---------|------------
// 00       |  0
// 01       | +1
// 10       | -1
// 11       |  0
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// complex_csd_add_subb.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Data inputs:
//    - subb_a_x  : Add(0)/sub(1) real part of a (logic, 1 bit).
//    - subb_a_y  : Add(0)/sub(1) imag part of a (logic, 1 bit).
//    - subb_b_x  : Add(0)/sub(1) real part of b (logic, 1 bit).
//    - subb_b_y  : Add(0)/sub(1) imag part of b (logic, 1 bit).
//    - a_x       : Real part of summand a (CSD, 2*W bits).
//    - a_y       : Imaginary part of summand a (CSD, 2*W bits).
//    - b_x       : Real part of summand b (CSD, 2*W bits).
//    - b_y       : Imaginary part of summand b (CSD, 2*W bits).
//
//  Data outputs:
//    - c_x       : Real part of the carry of the result   (CSD, 2 bits).
//    - c_y       : Imaginary part of the carry of the result   (CSD, 2 bits).
//    - s_x       : Result s_x = (-1)^subb_a * a_x + (-1)^subb_b * b_x (CSD, 2*W bits).
//    - s_y       : Result s_y = (-1)^subb_a * a_y + (-1)^subb_b * b_y (CSD, 2*W bits).
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
module complex_csd_add_subb #(
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
    input   wire  [2*W-1:0]   a_x,
    input   wire  [2*W-1:0]   a_y,
    input   wire  [2*W-1:0]   b_x,
    input   wire  [2*W-1:0]   b_y,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  wire  [1:0]       c_x,
    output  wire  [1:0]       c_y,
    output  wire  [2*W-1:0]   s_x,
    output  wire  [2*W-1:0]   s_y
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
// This architecture uses two csd_add_subb blocks to implement the complex adder.
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
   csd_add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd_add_subb_x (
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
   csd_add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) csd_add_subb_y (
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

