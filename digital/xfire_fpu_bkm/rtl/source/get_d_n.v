// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Get the decision value (d) for the current step (n).
// Possible values for d: {0, +-1, +-j, 1+-j, -1+-j}
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// get_d_n.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Data inputs:
//    - mode      : Operation mode (logic, 1 bit).
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for 64 bit, 1 for 32 bit
//                                                 |---> Complex:    0 for complex args, 1 for real args
//    - u_n       : Real part of w (two's complement, W bits).
//    - v_n       : Imag part of w (two's complement, W bits).
//
//  Data outputs:
//    - d_x       : Real part of d (one's complement, 2 bits).
//    - d_y       : Imag part of d (one's complement, 2 bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-05-10 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module get_d_n #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire                mode,
    input wire [W-1:0]        u_n,
    input wire [W-1:0]        v_n,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [1:0]       d_x,
    output  reg   [1:0]       d_y
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
// E-mode
// ------
// if                u_n   <=  -5/8    then  d_x = -1
// if    -4/8  <=    u_n   <=   2/8    then  d_x =  0
// if     3/8  <=    u_n               then  d_x = +1
// if                v_n   <= -13/16   then  d_y = -1
// if   -12/16 <=    v_n   <=  12/16   then  d_y =  0
// if    13/16 <=    v_n               then  d_y = +1
//
// L-mode
// ------
// if                u_n   <= -1/2     then  d_x = -1
// if    -1/2  <     u_n   <   1/2     then  d_x =  0
// if     1/2  <=    u_n               then  d_x = +1
// if                v_n   <= -1/2     then  d_y = -1
// if    -1/2  <     v_n   <   1/2     then  d_y =  0
// if     1/2  <=    v_n               then  d_y = +1
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Mux the value of d_n
   // -----------------------------------------------------
   always @(*) begin
      case(mode)
         `MODE_E:
                  begin
                     if (u_n <= -5/8) begin
                        d_x = 2'b11;
                     end
                     else if (u_n >= -4/8 && u_n <= 2/8) begin
                        d_x = 2'b00;
                     end
                     else if (u_n >=  3/8) begin
                        d_x = 2'b01;
                     end

                     if (v_n <= -13/16) begin
                        d_y = 2'b11;
                     end
                     else if (v_n >= -12/16 && v_n <= 12/16) begin
                        d_y = 2'b00;
                     end
                     else if (v_n >=  13/16) begin
                        d_y = 2'b01;
                     end
                  end
         `MODE_L:
                  begin
                     if (u_n <= -1/2) begin
                        d_x = 2'b11;
                     end
                     else if (u_n > -1/2 && u_n < 1/2) begin
                        d_x = 2'b00;
                     end
                     else if (u_n >=  1/2) begin
                        d_x = 2'b01;
                     end

                     if (v_n <= -1/2) begin
                        d_y = 2'b11;
                     end
                     else if (v_n > -1/2 && v_n <= 1/2) begin
                        d_y = 2'b00;
                     end
                     else if (v_n >=  1/2) begin
                        d_y = 2'b01;
                     end
                  end
         default:
                  begin
                     d_x = 2'b00;
                     d_y = 2'b00;
                  end
      endcase
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


