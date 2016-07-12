// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Barrel shifter
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// barrel_shifter.v
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
//    - in        : Input to shift (two's complement, W bits).
//
//  Data outputs:
//    - out       : Shifted result (two's complement, W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//    - LOG2W     : Logarithm of base 2 of the word width (natural, default: 6).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-11 - ilesser - Removed regs and used wires.
//    - 2016-06-13 - ilesser - Cosmetic changes
//    - 2016-04-25 - ilesser - Initial version
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module barrel_shifter #(
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
   // Every value in the muxs matrix represents a 1 bit 2 to 1 mux
   // with in0 and in1 its inputs

   //        in0[i][j]   in1[i][j]
   //            |       |
   //       +----:-------:----+
   //        \   0       1   /------ sel[i]
   //         +------:------+
   //                |
   //             muxs[i][j]
   wire  s;
   //    cols: j        rows: i
   wire  [W-1:0]  in0   [0:LOG2W-1];
   wire  [W-1:0]  in1   [0:LOG2W-1];
   wire  [W-1:0]  muxs  [0:LOG2W];


   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // Select the bit that gets shifted in from the left
   // If shifting left put 1'b0.
   // If shifting right and arithmetic put in[W-1] if logic put 1'b0
   assign s = dir == `DIR_LEFT ? 1'b0 : shift_t == `SHIFT_ARITH ? in[W-1] : 1'b0;

   genvar i,j;
   generate
      for (j=0; j < W; j=j+1) begin
         // Here is what I have to do for each value of i and j
         //  i              j
         //LOG2W    [W-1 W ... 1 0]   connect in[W-1:0] or in[0:W-] to muxs[LOG2W][j]        (pre data reversal)
         //LOG2W-1  [W-1 W ... 1 0]   connect in0[i][j] or in1[i][j] to muxs[i][j]
         //.                .
         //.                .
         //.                .
         //1        [W-1 W ... 1 0]   connect in0[i][j] or in1[i][j] to muxs[i][j]
         //0        [W-1 W ... 1 0]   connect in0[i][j] or in1[i][j] to muxs[i][j]
         //                           connect muxs[0][W-1:0] or muxs[0][0:W-1] to out[W-1:0] (post data reversal)

         // If the direction is 'to left' then I can simply reverse before and after
         // and run a 'to right' shift
         // Pre data reversal
         assign muxs[LOG2W][j] = dir == `DIR_LEFT ? in[W-1-j] : in[j];

         for (i=0; i < LOG2W; i=i+1) begin

            // Select in0 input from the output from the jth mux of the previous row
            assign in0[i][j] = muxs[i+1][j];

            // Select in1
            if (j <= (W-1)-2**i)
               // take the input from the (j+2^i)th mux of the previous row
               assign in1[i][j]  = muxs[i+1][j+(2**i)];
            else // if i > W-1-2^j
               // if it is a rotation then take the input from the [(i+2^j) mod W]th mux of the previous row
               assign in1[i][j]  = (op == `OP_ROT) ? muxs[i+1][j-(W-1)+(2**i)-1]
               // if it is a shift then take the input from the sign
                                                      : s;

            // Connect mux in0 and in1 with sel[i]
            assign muxs[i][j]  = sel[i] ? in1[i][j] : in0[i][j];

         end // for i

         // Post data reversal
         assign out[j] = dir == `DIR_LEFT ? muxs[0][W-1-j] : muxs[0][j];

      end // for j

   endgenerate
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

