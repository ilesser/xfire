// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Cannonic Signed Digit (CSD) adder/substractor
//
// Digit |  Value interpreted
// ------|-------------------
// 00    |  0
// 01    | +1
// 10    | -1
// 11    |  0
//
//
// Taken from :
// Gustavo A. Ruiz, Mercedes Granda, "Efficient canonic signed digit recording".
// Microelectronics Journal 42 ( September 2011) 1090-1097, Elsevier.
// https://www.researchgate.net/publication/220254523_Efficient_canonic_signed_digit_recoding
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// csd_add_subb.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Data inputs:
//    - subb_a    : Add/sub a (logic, 1 bit).
//    - subb_b    : Add/sub b (logic, 1 bit).
//    - a         : Summand a (CSD, 2*W bits).
//    - b         : Summand b (CSD, 2*W bits).
//
//  Data outputs:
//    - c         : Result c=a+b (CSD, 2*W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-10 - ilesser - Changed representation to CSD (see paper in desc).
//    - 2016-04-08 - ilesser - Converted to adder/subbstracter.
//    - 2016-04-08 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
module rbr_add_subb #(
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
    input   wire  [2*W-1:0]   a,
    input   wire  [2*W-1:0]   b,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [2*W-1:0]   s
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg   [W-1:0]     p; // partial sum
   reg   [2*W-1:0]   c; // carry
   reg   [2*W-1:0]   a_neg;
   reg   [2*W-1:0]   b_neg;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------
   always @(*) begin
      if (subb_a == 1'b1) begin
         a_neg = ~a;
      end
      else begin
         a_neg = a;
      end
      if (subb_b == 1'b1) begin
         b_neg = ~b;
      end
      else begin
         b_neg = b;
      end
   end

   // Initial values
   assign c[1]  = 1'b1;  // if add: c = 10   if subb: c = 01 ??? TODO
   assign c[0]  = 1'b0;  //          0                 0

   genvar i;
   generate
      for (i=0; i < W-1; i=i+1) begin
         always @(*) begin

            {c[2*(i+1)+1], p[i]}       = a_neg[2*i+1] + a_neg[2*i]   + b_neg[2*i+1];

            {c[2*(i+1)  ], s[2*i+1]}   = p[i]         + b_neg[2*i]   + c[2*i+1];

            s[2*i] = c[2*i];

         end
      end
   endgenerate

   // -----------------------------------------------------
   // Digit-by-digit diagram
   // -----------------------------------------------------
   // If want to invert a or b sign just negate each digit
   // ai    bi    ci  | pi |  ci+1  si  | representation    carry    sum
   //-----------------|----|------------|-------------------------------
   // 00    00    00  | 0  |  00    00  |  0 +  0 +  0       0        0
   // 00    00    01  | 0  |  00    01  |  0 +  0 +  1       0        1
   // 00    00    10  | 0  |  00    10  |  0 +  0 + -1       0       -1
   // 00    00    11  | 0  |  00    11  |  0 +  0 +  0       0        0
   // 00    01    00  | 0  |  00    10  |  0 +  1 +  0       0        1
   // 00    01    01  | 0  |  00    11  |  0 +  1 +  1       1        0    <-- error en el dato del carry 
   // 00    01    10  | 0  |  01    00  |  0 +  1 + -1       0        0
   // 00    01    11  | 0  |  01    01  |  0 +  1 +  0       0        1
   // 00    10    00  | 1  |  00    10  |  0 + -1 +  0       0       -1
   // 00    10    01  | 1  |  00    01  |  0 + -1 +  1       0        0    <--- error en el dato de la suma xq el carry in se propaga directamente
   // 00    10    10  | 1  |  01    10  |  0 + -1 + -1      -1        0    <-- error en el signo  y dato del carry
   // 00    10    11  | 1  |  01    11  |  0 + -1 +  0       0       -1
   // 00    11    00  | 0  |  00    10  |  0 +  0 +  0       0        0
   // 00    11    01  | 0  |  00    11  |  0 +  0 +  1       0        1
   // 00    11    10  | 0  |  01    00  |  0 +  0 + -1       0       -1
   // 00    11    11  | 0  |  01    01  |  0 +  0 +  0       0        0
   // 01    00    00  | 1  |  0C    S0  |  1 +  0 +  0       0        1
   // 01    00    01  | 1  |  0C    S1  |  1 +  0 +  1       1        0
   // 01    00    10  | 1  |  0C    S0  |  1 +  0 + -1       0        0
   // 01    00    11  | 1  |  0C    S1  |  1 +  0 +  0       0        1
   // 01    01    00  | 1  |  0C    S0  |  1 +  1 +  0       1        0
   // 01    01    01  | 1  |  0C    S1  |  1 +  1 +  1       1        1
   // 01    01    10  | 1  |  0C    S0  |  1 +  1 + -1       0        1
   // 01    01    11  | 1  |  0C    S1  |  1 +  1 +  0       1        0
   // 01    10    00  | 0  |  1C    S0  |  1 + -1 +  0       0        0
   // 01    10    01  | 0  |  1C    S1  |  1 + -1 +  1       0        1
   // 01    10    10  | 0  |  1C    S0  |  1 + -1 + -1       0       -1
   // 01    10    11  | 0  |  1C    S1  |  1 + -1 +  0       0        0
   // 01    11    00  | 0  |  1C    S0  |  1 +  0 +  0       0        1
   // 01    11    01  | 0  |  1C    S1  |  1 +  0 +  1       1        0
   // 01    11    10  | 0  |  1C    S0  |  1 +  0 + -1       0        0
   // 01    11    11  | 0  |  1C    S1  |  1 +  0 +  0       0        1

   // 01    01    01    0     10    01
   // 01    01    10    0     11    10




   // ESTE GRAFICO QUE HICE ACA ES UN CARRY SAVE ADDER 4-TO-2 ADDER
   // si agarro esto e invierto a_i^s, b_i^s, c_i^s y c^{i+1}_s lo
   // convierto en un BORROW SAVE ADDER 4-TO-2 ADDER
   //
   // Despues eso puedo usarlo con un wallace tree para poder hacer las sumas
   // y finalmente convertilo a una notacion no redundante
   //
   //                   a           b
   //                    i           i
   //                   | |         | |
   //                   | |         | |
   //                 +-----+       | |
   //                 |     |       | |
   //           +-----| FA  |-------+ |
   //           |     |     |         |
   //           |     +-----+         |
   //           |        |            |
   //           |      p | +----------+
   //           |       i| |
   //           |      +-----+
   //           |      |     |
   //   c    ---+   +--| FA  |-----------c
   //    i+1 -------+  |     |       +--- i
   //                  +-----+       |
   //                     |          |
   //                     |+---------+
   //                     ||
   //                     ||
   //                     s
   //                      i
   //
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

