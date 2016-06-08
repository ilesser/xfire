// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Cannonic Signed Digit (CSD) adder/substractor using borrow save representation.
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
//    - subb_a    : Add(0)/sub(1) a (logic, 1 bit).
//    - subb_b    : Add(0)/sub(1) b (logic, 1 bit).
//    - a         : Summand a (CSD, 2*W bits).
//    - b         : Summand b (CSD, 2*W bits).
//
//  Data outputs:
//    - c         : Carry of the result   (CSD, 2 bits).
//    - s         : Result s = (-1)^subb_a * a + (-1)^subb_b * b (CSD, 2*W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-10 - ilesser - Changed representation to BS (see paper in desc).
//    - 2016-04-08 - ilesser - Converted to adder/subbstracter.
//    - 2016-04-08 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
module csd_add_subb #(
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
    output  reg   [1:0]       c,
    output  reg   [2*W-1:0]   s
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
//         subb      a    subb   b
//             a      i       b   i
//           |       | |    |    | |
//           |       | |    |    | |
//           |     +-----+  |  +-----+
//           |     |     |  |  |     |
//           +-----| XOR |  +--| XOR |
//                 |     |     |     |
//                 +-----+     +-----+
//                   | |         | |
//            a_inv  | |   b_inv | |
//                 i | |        i| |
//                   | |         | |
//                   O |         | |
//                 +-----+       | |
//                 |     |       | |
//           +----O| FA  |O------+ |
//           |     |     |         |
//           |     +-----+         |
//           |        |            |
//           |      p | +----------+
//           |       i| |
//           |      +-----+
//           |      |     |
//   c    ---+   +--| FA  |O----------c
//    i+1 -------+  |     |       +--- i
//                  +-----+       |
//                     O          |
//                     |+---------+
//                     ||
//                     ||
//                     s
//                      i
//
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg   [2*W-1:0]   a_inv;// inverted version of a
   reg   [2*W-1:0]   b_inv;// inverted version of b
   reg   [W-1:0]     a_s;  // a sign bit
   reg   [W-1:0]     a_d;  // a data bit
   reg   [W-1:0]     b_s;  // b sign bit
   reg   [W-1:0]     b_d;  // b data bit
   reg   [W:0]       c_s;  // carry sign bit
   reg   [W:0]       c_d;  // carry data bit
   reg   [W-1:0]     s_s;  // sum sign bit
   reg   [W-1:0]     s_d;  // sum data bit
   reg   [W-1:0]     p;    // partial sum
   //reg   [2*W-1:0]   c;    // carry
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // Initial values
   // CSD 0 = {0,0} o {1,1} in BS but sign digit has to be inverted
   // so the initial carry can be {1,0} or {0,1}
   always @(*) begin
      case({a_inv[1:0],b_inv[1:0]})
         4'b0010: {c_s[0],c_d[0]} = 2'b10;
         4'b1000: {c_s[0],c_d[0]} = 2'b10;
         4'b1011: {c_s[0],c_d[0]} = 2'b10;
         4'b1110: {c_s[0],c_d[0]} = 2'b10;
         default: {c_s[0],c_d[0]} = 2'b01;
      endcase
   end

   genvar i;
   generate
      for (i=0; i < W; i=i+1) begin
         always @(*) begin

            // Flipping all the bits corresponds to the additive inverse of a number in BS
            // Invert a and b depending on subb_a and subb_b
            a_inv[2*i+1:2*i] = a[2*i+1:2*i] ^ {2{subb_a}};
            b_inv[2*i+1:2*i] = b[2*i+1:2*i] ^ {2{subb_b}};

            // Split the CSD numbers into its BS representation
            // _s stands for sign bit and _d for data bit
            // See initial description for more information
            {a_s[i], a_d[i]} = a_inv[2*i+1:2*i];
            {b_s[i], b_d[i]} = b_inv[2*i+1:2*i];

            // The carry sign bit inverters cancell each other
            // So I only have to invert the sign bit of a, b ans s
            {c_s[i+1],   p[i]} = ~a_s[i] + a_d[i] + ~b_s[i];
            {c_d[i+1], s_s[i]} =             p[i] +  b_d[i] +  c_s[i];
                       s_d[i]  =                               c_d[i];

            s[2*i+1:2*i] = {~s_s[i], s_d[i]};

         end
      end
   endgenerate


   // I do have to invert the last carry
   always @(*) begin
      c[1:0] = {~c_s[W], c_d[W]};
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Digit-by-digit diagram
   // -----------------------------------------------------
   // If want to invert a or b sign just negate each digit
   // ai    bi    ci  | pi |  ci+1  si  | representation    carry    sum
   //-----------------|----|------------|-------------------------------
   // 00    00    00  | 0  |  00    10  |  0 +  0 +  0       0        0
   // 00    00    01  | 0  |  00    11  |  0 +  0 +  1       0        1
   // 00    00    10  | 0  |  01    00  |  0 +  0 + -1       0       -1
   // 00    00    11  | 0  |  01    01  |  0 +  0 +  0       0        0
   // 00    01    00  | 0  |  00    10  |  0 +  1 +  0       0        1
   // 00    01    01  | 0  |  00    11  |  0 +  1 +  1       1        0    <-- error en el dato del carry 
   // 00    01    10  | 0  |  01    00  |  0 +  1 + -1       0        0
   // 00    01    11  | 0  |  01    01  |  0 +  1 +  0       0        1
   // 00    10    00  | 1  |  10    10  |  0 + -1 +  0       0       -1
   // 00    10    01  | 1  |  10    01  |  0 + -1 +  1       0        0    <--- error en el dato de la suma xq el carry in se propaga directamente
   // 00    10    10  | 1  |  11    10  |  0 + -1 + -1      -1        0    <-- error en el signo  y dato del carry
   // 00    10    11  | 1  |  11    11  |  0 + -1 +  0       0       -1
   // 00    11    00  | 0  |  10    10  |  0 +  0 +  0       0        0
   // 00    11    01  | 0  |  10    11  |  0 +  0 +  1       0        1
   // 00    11    10  | 0  |  11    00  |  0 +  0 + -1       0       -1
   // 00    11    11  | 0  |  11    01  |  0 +  0 +  0       0        0
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

