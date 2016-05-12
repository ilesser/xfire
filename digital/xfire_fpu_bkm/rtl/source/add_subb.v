// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Two's complement ripple carry adder/substractor.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// add_subb.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Data inputs:
//    - subb_a    : Add(0)/sub(1) a (logic, 1 bit).
//    - subb_b    : Add(0)/sub(1) b (logic, 1 bit).
//    - a         : Summand a (two's complement, W bits).
//    - b         : Summand b (two's complement, W bits).
//
//  Data outputs:
//    - c         : Carry of the result   (logic, 1 bit).
//    - s         : Result s = (-1)^subb_a * a + (-1)^subb_b * b (two's complement, W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-05-12 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
module add_subb #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input   wire              subb_a,
    input   wire              subb_b,
    input   wire  [W-1:0]     a,
    input   wire  [W-1:0]     b,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg               c,
    output  reg   [W-1:0]     s
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
// This architecture is implemented using two full adders in a similar way as a
// 4-to-2-CS-adder but with the bits representing the sign bit inverted
// *****************************************************************************
// ESTE GRAFICO QUE HICE ACA ES UN CARRY SAVE ADDER 4-TO-2 ADDER
// si agarro esto e invierto a_i^s, b_i^s, c_i^s y c^{i+1}_s lo
// convierto en un BORROW SAVE ADDER 4-TO-2 ADDER
//
// Despues eso puedo usarlo con un wallace tree para poder hacer las sumas
// y finalmente convertilo a una notacion no redundante
//
//         subb           subb
//             a      a       b   b
//           |        |i    |     |i
//           |        |     |     |
//           |     +-----+  |  +-----+
//           |     |     |  |  |     |
//           +-----| XOR |  +--| XOR |
//                 |     |     |     |
//                 +-----+     +-----+
//                    |           |
//            a_inv   |    b_inv  |      +------+
//                 i  |         i |      |      |
//                    |           |      | +----|---+
//                    | +---------+      | |    |   |
//                    | |              +-----+  |   |
//                    | |              |     |  |   |
//    cp -------------|-|--------------| HA  |  |   +--- cp
//      i+1           | |              |     |  |          i
//                    | |              +-----+  |
//                    | |                 |     |
//                  +-----+     p         |     |
//                  |     |      i        |     |
//   c    ----------| FA  |---------------+     +------- c
//    i+1           |     |                               i
//                  +-----+
//                     |
//                     |
//                     |
//                     |
//                     s
//                      i
//
// *****************************************************************************


   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg   [W-1:0]  a_inv;// inverted version of a
   reg   [W-1:0]  b_inv;// inverted version of b
   reg   [W:0]    cc;   // carry
   reg   [W:0]    cp;   // partial carry
   reg   [W-1:0]  p;    // partial sum
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

// TODO: change architecture to remove this always block to
//       use bitwise XOR inversion plus some half adders for
//       the carries.

//   always @(*) begin
//      if (subb_a == 1'b1) begin
//         a_inv = ~a+1;
//      end
//      else begin
//         a_inv = a;
//      end
//      if (subb_b == 1'b1) begin
//         b_inv = ~b+1;
//      end
//      else begin
//         b_inv = b;
//      end
//   end

   // Initial values
   always @(*) begin
      cc[0]  = subb_a;
      cp[0] = subb_b;
   end

   genvar i;
   generate
      for (i=0; i < W; i=i+1) begin
         always @(*) begin

            a_inv[i]       =  a[i] ^ subb_a;
            b_inv[i]       =  b[i] ^ subb_b;

            {cp[i+1],p[i]} =  cc[i] + cp[i];
            {cc[i+1],s[i]} =  a_inv[i] + b_inv[i] + p[i];

         end
      end
   endgenerate


   // Report carry if any of c or cp is 1
   always @(*) begin
      c = cc[W] | cp[W];
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


