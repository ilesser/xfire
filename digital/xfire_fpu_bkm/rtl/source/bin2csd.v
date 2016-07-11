// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Binary two's complement to Cannonic Signed Digit (CSD) representation.
// It follows this equation to calculate the CSD representation of x:
//
//    y   = CSD(x)
//    x   = [x_{W-1}   x_{W-2} ... x_1 x_0]
//    y   = [y_{W-1}   y_{W-2} ... y_1 y_0]
//    y_i = {y_i^s y_i^d}
//
//
//    h_{-1}  = 0
//    k_{-1}  = 0
//
//    h_{i+1} = h_i  &  x_{i+1};    for i even
//    k_{i+1} = k_i  |  x_{i+1};    for i even
//
//    h_{i+1} = h_i  |  x_{i+1};    for i odd
//    k_{i+1} = k_i  &  x_{i+1};    for i odd
//
//    y_i^d  = ~h_{i+1} &  k_i       for i odd
//    y_i^d  =  h_i     & ~k_{i+1}   for i even
//
//    y_i^s  = ~h_i     &  k_{i+1}   for i odd
//    y_i^s  =  h_{i+1} & ~k_i       for i odd
//
//    y_{W-1}^d  = ~h_{W-2} &  k_{W-1}   for W-1 odd
//    y_{W-1}^d  =  h_{W-1} & ~k_{W-2}   for W-1 even
//
//    y_{W-1}^s  = ~h_{W-1} &  k_{W-2}   for W-1 odd
//    y_{W-1}^s  =  h_{W-2} & ~k_{W-1}   for W-1 even
//    TODO: review if this equations are 100% accurate
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
// bin2csd.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - None
//
//  Data inputs:
//    - x         : X input variable (two's complement, W bits).
//
//  Data outputs:
//    - y         : Y output result (cannonic signed digit, 2*W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-11 - ilesser - Removed regs and used wires.
//    - 2016-03-17 - ilesser - Working version. Using a ripple carry architecture.
//    - 2016-03-15 - ilesser - Initial version
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
module bin2csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire [W-1:0]        x,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output wire[2*W-1:0]      y
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire  [W-1:0]  h;
   wire  [W-1:0]  k;
   wire  [W-1:0]  y_s;
   wire  [W-1:0]  y_d;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // i=0 first bit
   assign h[0] = x[0];
   assign k[0] = 1'b0;

   genvar i;
   generate
      for (i=0; i < W-1; i=i+1) begin

         // i is odd
         if ( i%2 ) begin

            assign h[i+1] =  h[i]   |  x[i+1];
            assign k[i+1] =  k[i]   &  x[i+1];
            assign y_s[i] = ~h[i]   &  k[i+1];
            assign y_d[i] = ~h[i+1] &  k[i];

         end
         else begin // i is even

            assign h[i+1] =  h[i]   &  x[i+1];
            assign k[i+1] =  k[i]   |  x[i+1];
            assign y_s[i] =  h[i+1] & ~k[i];
            assign y_d[i] =  h[i]   & ~k[i+1];

         end

         assign y[2*i+1:2*i] = {y_s[i], y_d[i]};

      end
   endgenerate

   // i=W-1 last bit
   if ( (W-1)%2 ) begin // W-1 is odd

      assign y_s[W-1] =  ~h[W-2] &  k[W-1];
      assign y_d[W-1] =  ~h[W-1] &  k[W-2];

   end
   else begin  // W-1 is even

      assign y_s[W-1] =   h[W-1] & ~k[W-2];
      assign y_d[W-1] =   h[W-2] & ~k[W-1];

   end

   assign y[2*(W-1)+1:2*(W-1)] = {y_s[W-1], y_d[W-1]};
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


