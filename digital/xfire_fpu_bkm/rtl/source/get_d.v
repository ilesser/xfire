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
// get_d.v
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
//    - u         : Real part of w (two's complement, W bits).
//    - v         : Imag part of w (two's complement, W bits).
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
//    - 2016-06-15 - ilesser - Renamed get_d and implemented dxy muxing.
//    - 2016-05-10 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module get_d #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire                mode,
    input wire [W-1:0]        u,
    input wire [W-1:0]        v,
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
// if                u   <= -10/16   then  d_x = -1
// if   - 8/16 <=    u   <=   4/16   then  d_x =  0
// if     6/16 <=    u               then  d_x = +1
// if                v   <= -13/16   then  d_y = -1
// if   -12/16 <=    v   <=  12/16   then  d_y =  0
// if    13/16 <=    v               then  d_y = +1
//
// L-mode
// ------
// if                u   <= -8/16    then  d_x = -1
// if    -8/16 <     u   <   8/16    then  d_x =  0
// if     8/16 <=    u               then  d_x = +1
// if                v   <= -8/16    then  d_y = -1
// if    -8/16 <     v   <   8/16    then  d_y =  0
// if     8/16 <=    v               then  d_y = +1
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg   [W-5:0]     u_i;     // Integer part of u
   reg   [W-5:0]     v_i;     // Integer part of v
   reg   [3:0]       u_d;     // Decimal part of u
   reg   [3:0]       v_d;     // Decimal part of v
   reg               u_negative;
   reg               u_less_than_m1;
   reg               u_higher_than_p1;
   reg               v_negative;
   reg               v_less_than_m1;
   reg               v_higher_than_p1;
   reg		     u_range_m1_0;
   reg		     u_range_0_p1;
   reg		     v_range_m1_0;
   reg		     v_range_0_p1;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Get the decimal part of u and v
   // -----------------------------------------------------
   always @(*) begin
      u_i               =  u[W-1:4];	// integer part	
      u_d               =  u[3:0];	// decimal part	
      u_negative        =  u[W-1];
      u_range_m1_0      =  &u_i;	// All ones	//u_i == {W-4{1'b1}}; 
      u_range_0_p1      =  ~|u_i;	// All zeros 	//u_i >= (W-4)'d1;     //u_i[0] & !u_negative;
   end

   always @(*) begin
      v_i               =  v[W-1:4];
      v_d               =  v[3:0];
      v_negative        =  v[W-1];
      v_range_m1_0      =  &v_i;	// All ones	//u_i == {W-4{1'b1}}; 
      v_range_0_p1      =  ~|v_i;	// All zeros 	//u_i >= (W-4)'d1;     //u_i[0] & !u_negative;
   end
   // -----------------------------------------------------
   // Mux the value of d_n
   // -----------------------------------------------------
   always @(*) begin
      case(mode)
         `MODE_E:
                  begin

                     // Limits for u
                     // -5/8 = -10/16 = -16/16 + 6/16
                     //               = {{(W-4){1'b1}}, 4'0110 }
                     //  3/8 =   6/16 =      0 + 6/16
                     //               = {{(W-4){1'b0}}, 4'0110 }
                     case({u_negative, u_range_m1_0, u_range_0_p1, u_d <= 4'd6})
                        4'b1000:   d_x =2'b11;  //            u <  -1		=> d_x = -1
                        4'b1001:   d_x =2'b11;  //            u <  -1		=> d_x = -1
                        4'b1100:   d_x =2'b11;  //  -1     <= u <= -10/16	=> d_x = -1
                        4'b1101:   d_x =2'b00;  //  -10/16 <  u <   0		=> d_x =  0
                        4'b0011:   d_x =2'b00;  //   0     <= u <=  4/16	=> d_x =  0
                        4'b0010:   d_x =2'b01;  //   4/16  <  u <   1   	=> d_x =  1
                        4'b0000:   d_x =2'b01;  //   1     <= u 		=> d_x =  1
                        4'b0001:   d_x =2'b01;  //   1     <= u 		=> d_x =  1
			default:   d_x =2'b00;	// default 			=> d_x =  0
                     endcase

                     // Limits for v
                     // -13/16 = -16/16 +  3/16
                     //        = {{(W-4){1'b1}}, 4'0011 }
                     //  13/16 =      0 + 13/16
                     //        = {{(W-4){1'b0}}, 4'1101 }
                     //case({v_negative, v_range_m1_0, v_range_0_p1, v_d <= 4'd3})
                     //   4'b1000:   d_y =2'b11;  //            v <  -1		=> d_y = -1
                     //   4'b1001:   d_y =2'b11;  //            v <  -1		=> d_y = -1
                     //   4'b1100:   d_y =2'b11;  //  -1     <= v <= -13/16	=> d_y = -1
                     //   4'b1101:   d_y =2'b00;  //  -10/16 <  v <   0		=> d_y =  0
                     //   4'b0011:   d_y =2'b00;  //   0     <= v <=  12/16	=> d_y =  0
                     //   4'b0010:   d_y =2'b01;  //   4/16  <  v <   1   	=> d_y =  1
                     //   4'b0000:   d_y =2'b01;  //   1     <= v 		=> d_y =  1
                     //   4'b0001:   d_y =2'b01;  //   1     <= v 		=> d_y =  1
		     //   default:   d_y =2'b00;	// default 			=> d_y =  0
                     //endcase
		     if ( v_negative == 1'b1 ) begin
		        if ( v_range_m1_0 == 1'b1 ) begin
			   if ( v_d <= 4'd3 ) begin
			      d_y = 2'b11;
			   else
			      d_y = 2'b00;
			   end
		        end
			else
			   d_y = 2'b11;
		        end
		     end
		     else
		        if ( v_range_0_p1 == 1'b1 ) begin
			   if ( v_d <= 4'd12 ) begin
			      d_y = 2'b00;
			   end
			      d_y = 2'b00;
			   end
		        end
			else
			   d_y = 2'b01;
		        end
		     end





                     //if ( u_negative && u_less_than_m1 )
                        //d_x = 2'b11;
                     //else if ( u_negative && !u_less_than_m1 ) begin
                        //if (u_d <= 4'd6)
                           //d_x = 2'b11;
                        //else
                           //d_x = 2'b00;
                     //end
                     //else if ( !u_negative && !u_higher_than_p1 ) begin
                        //if (u_d >= 4'd6)
                           //d_x = 2'b01;
                        //else
                           //d_x = 2'b00;
                     //end
                     //else
                        //d_x = 2'b00;

                     // If u is negative and the decimal part is lower or equal than 6/16
                     // then d_x is -1
                     //if (u[W-1] == 1'b1 && flag == 1'b1)//u_d <= 4'd6)
                        //d_x = 2'b11;

                     // If u is positive and the decimal part is higher or equal than 6/16
                     // then d_x is 1
                     //else if (u[W-1] == 1'b0 && flag == 1'b0)//u_d >= 4'd6)
                       //d_x = 2'b01;

                     // Else d_x is 0
                     //else
                       //d_x = 2'b00;

                     // If v is negative and the decimal part is lower or equal than 3/16
                     // then d_y is -1
                     //if (v[W-1] == 1'b1 && v_d <= 4'd3)
                     //   d_y = 2'b11;

                     // If u is positive and the decimal part is higher or equal than 13/16
                     // then d_y is 1
                     //else if (v[W-1] == 1'b0 && v_d >= 4'd13)
                     //   d_y = 2'b01;

                     // Else d_y is 0
                     //else
                     //   d_y = 2'b00;

                  end
         `MODE_L:
                  begin
                     // Limits for u
                     // -1/2 = - 8/16 = -16/16 + 8/16
                     //               = {{(W-4){1'b1}}, 4'1000 }
                     //  1/2 =   8/16 =      0 + 8/16
                     //               = {{(W-4){1'b0}}, 4'1000 }

                     // If u is negative and the decimal part is lower or equal than 7/16
                     // then d_x is -1
                     if (u[W-1] == 1'b1 && u_d <= 4'd7)
                        d_x = 2'b11;

                     // If u is positive and the decimal part is higher or equal than 8/16
                     // then d_x is 1
                     else if (u[W-1] == 1'b0 && u_d >= 4'd8)
                        d_x = 2'b01;

                     // Else d_x is 0
                     else
                        d_x = 2'b00;

                     // Limits for v
                     // -1/2 = - 8/16 = -16/16 + 8/16
                     //               = {{(W-4){1'b1}}, 4'1000 }
                     //  1/2 =   8/16 =      0 + 8/16
                     //               = {{(W-4){1'b0}}, 4'1000 }

                     // If v is negative and the decimal part is lower or equal than 7/16
                     // then d_y is -1
                     if (v[W-1] == 1'b1 && v_d <= 4'd7)
                        d_y = 2'b11;

                     // If v is positive and the decimal part is higher or equal than 8/16
                     // then d_y is 1
                     else if (v[W-1] == 1'b0 && v_d >= 4'd8)
                        d_y = 2'b01;

                     // Else d_y is 0
                     else
                        d_y = 2'b00;

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



