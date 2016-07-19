// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Barrel shifter in CSD
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// barrel_shifter_csd.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - None
//
//  Data inputs:
//    - dir       : Direction of the shift: 1 for left      0 for right    (logic, 1 bit).
//    - op        : Operation of the shift: 1 for rotation  0 for shifting (logic, 1 bit).
//    - shift_t   : Type of the shift:      1 for aritmetic 0 for logic    (logic, 1 bit).
//    - sel       : Shift selector (unsigned, LOG2W bits).
//    - in        : Input to shift (CSD, 2*W bits).
//
//  Data outputs:
//    - out       : Shifted result (CSD, 2*W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//    - LOG2W     : Logarithm of base 2 of the word width (natural, default: 6).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-19 - ilesser - Changed decision logic.
//    - 2016-07-18 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module barrel_shifter_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64,
    parameter LOG2W  = 6
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input   wire              dir,
    input   wire              op,
    input   wire              shift_t,
    input   wire  [LOG2W-1:0] sel,
    input   wire  [2*W-1:0]   in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  wire  [2*W-1:0]   out
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
// TODO: try adding 1 to the lsb before shifting, that might save us the logic
//       used to decide

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire              in_odd;
   wire  [1:0]       c, s, comp;
   wire  [1:0]       in_lsb, shifted_lsb;
   wire  [2*W-1:0]   shifted, shifted_comp;
   // -----------------------------------------------------


   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Regular barrel shifter
   // -----------------------------------------------------
   barrel_shifter #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (2*W),
      .LOG2W               (LOG2W+1)
   ) barrel_shifter (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (dir),
      .op                  (op),
      .shift_t             (shift_t),
      .sel                 ({sel,1'b0}), // select with 2*sel
      .in                  (in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (shifted)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // 1 CSD bit substracter
   // -----------------------------------------------------

   add_subb_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (1)
   ) add_subb_csd (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              (`ADD),
      .subb_b              (`ADD),
      .a                   (shifted_lsb),
      .b                   (comp),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (c),
      .s                   (s)
   );
   // -----------------------------------------------------

   // Compensate rotation by adding/subbstracting one LSB

   // LSB of barrel shifter input and output
   assign in_lsb        = in[1:0];
   assign shifted_lsb   = shifted[1:0];
   assign shifted_comp  = {shifted[2*W-1:2], s};
   assign in_odd        = in_lsb == `CSD_p1 || in_lsb == `CSD_m1;

   assign comp = in_lsb;
   //assign comp = in_lsb == `CSD_p1  ?  `CSD_m1  :
                 //in_lsb == `CSD_m1  ?  `CSD_p1  :
                                       //`CSD_0_0 ;

   assign out  = sel    == {LOG2W{1'b0}}  ?  shifted        :
                 in_lsb == `CSD_m1        ?  shifted_comp   :
                                             shifted        ;

   //assign out = shifted;


// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   //XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

