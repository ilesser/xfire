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
//    - 2016-04-25 - ilesser   - Initial version
//
// -----------------------------------------------------------------------------

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
    output  reg   [W-1:0]     out
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg   s;
   reg   in0 [0:W-1][0:LOG2W-1];
   reg   in1 [0:W-1][0:LOG2W-1];
   reg   m   [0:W-1][0:LOG2W];

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // Select the bit that gets shifted in from the left
   assign s = shift_t ? in[W-1] : 1'b0;

   genvar i,j;
   generate
      for (i=0; i < W; i=i+1) begin

         // If the direction is 'to left' then I can simply reverse before and after
         // and run a 'to right' shift

         // Pre data reversal
         assign m[i][LOG2W] = dir ? in[W-1-i] : in[i];

         for (j=0; j < LOG2W; j=j+1) begin

            always @(*) begin

               m[i][j] = sel[j] ? in1[i][j] : in0[i][j];

               in0[i][j] = m[i][j+1];

               in1[i][j] = (i <= (W-1)-2**j) ? m[i+2**j][j+1] : op ? m[i-(W-1)+2**j-1][j+1] : s;

            end // always

         end // for j

         // Post data reversal
         assign out[i] = dir ? m[W-1-i][0] : m[i][0];

      end // for i

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
