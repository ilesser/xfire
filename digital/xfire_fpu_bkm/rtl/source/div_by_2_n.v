// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Divides by 2^n in two's complement logic.
//
// out = in / 2^n
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// div_by_2_n.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - None
//
//  Data inputs:
//    - n         : Exponent of the divider (unsigned, LOG2N bits).
//    - in        : Input to divide (two's complement, W bits).
//
//  Data outputs:
//    - out       : Result (two's complement, W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//    - LOG2W     : Logarithm of base 2 of the lenght of in (natural, default: 6).
//    - LOG2N     : Logarithm of base 2 of the length of n  (natural, default: 6).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-15 - ilesser - Initial version
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module div_by_2_n #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64,
    parameter LOG2W  = 6,
    parameter LOG2N  = 6
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input   wire  [LOG2N-1:0] n,
    input   wire  [W-1:0]     in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  wire  [W-1:0]     out
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire              underflow;
   wire [LOG2W-1:0]  n_bs;
   wire [W-1:0]      shifted;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Barrel shifter
   // -----------------------------------------------------
   barrel_shifter #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W)
   ) barrel_shifter (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (`DIR_RIGHT),
      .op                  (`OP_SHIFT),
      .shift_t             (`SHIFT_ARITH),
      .sel                 (n_bs),
      .in                  (in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (shifted)
   );
   // -----------------------------------------------------


   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   generate
      if( LOG2N > LOG2W ) begin
      // If n has more bits than LOG2W then whenever one of the
      // LSBs above LOG2W is 1 the result of the division underflows
      // and is 0.
         assign underflow = & n[LOG2N-1:LOG2W];
         assign n_bs = n[LOG2W-1:0];
      end
      else begin
      // If n has less bits than LOG2W then it can't underflow
      // and I have to add 0s to pad.
         assign underflow = 1'b0;
         assign n_bs = { {LOG2W-LOG2N{1'b0}}, n};
      end
   endgenerate

   assign out = underflow == 1'b1 ? {W{1'b0}} : shifted;
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

