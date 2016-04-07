// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Full adder
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// fadder.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - None
//
//  Data inputs:
//    - a         : Summand a (logic, 1 bit).
//    - b         : Summand a (logic, 1 bit).
//    - ci        : Carry in (logic, 1 bit).
//
//  Data outputs:
//    - s         : Sum result (logic, 1 bit).
//    - co        : Carry out (logic, 1 bit).
//
//  Parameters:
//    - None
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
module fadder(
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire                a, b, ci,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output wire               s, co
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // wires (from ands to or)
   wire w1, w2, w3;

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------
   // carry-out circuitry
   and( w1, a, b );
   and( w2, a, ci );
   and( w3, b, ci );
   or( co, w1, w2, w3 );

   // sum
   xor( s, a, b, ci );
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



