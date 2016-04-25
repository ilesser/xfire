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
//    - type      : Type of the shift:      1 for aritmetic 0 for logic    (logic, 1 bit).
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
    input   wire              type,
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
   reg            s;
   reg   [W-1:0]  in0[LOG2W-1:0];
   reg   [W-1:0]  in1[LOG2W-1:0];
   reg   [W-1:0]  m  [LOG2W:0];

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // Select the bit that gets shifted in from the left
   assign s = type ? in[W-1] : 1'b0;

   genvar i;
   generate
      for (i=0; i < W; i=i+1) begin

         // If the direction is 'to left' then I can simply reverse before and after
         // and run a 'to right' shift

         // Pre data reversal
         m[i][LOG2W] = dir ? in(W-1-i) : in(i);

         for (j=0; j < LOG2W; j=j+1) begin

            always @(*) begin

               m[i][j] = sel[j] ? in1[i][j] : in0[i][j];

               in0[i][j] = m[i][j+1];

               in_1[i][j] = (i <= (W-1)-2**j) ? m[i+2**j][j+1] : op ? m[i-(W-1)+2**j-1][j+1] : s;

               //if ( i <= W-1-2**j ) begin
               //   in_1[i][j] = m[i+2**j][j+1];
               //end

               //if ( i > W-1-2**j ) begin
               //   in_1[i][j] = oper_i ? m[i-(W-1)+2**j-1][j+1] : s;
               //end

            end

         end

         // Post data reversal
         out[i][LOG2W] = dir ? m(W-1-i) : m(i);

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

