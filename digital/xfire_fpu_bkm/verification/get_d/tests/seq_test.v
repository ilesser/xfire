// -----------------------------------------------------------------------------
//  Copyright (c) 2016 Microelectronics Lab. FIUBA.
//  All Rights Reserved.
//
//  The information contained in this file is confidential and proprietary.
//  Any reproduction, use or disclosure, in whole or in part, of this
//  program, including any attempt to obtain a human-readable version of this
//  program, without the express, prior written consent of Microelectronics Lab.
//  FIUBA is strictly prohibited.
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Sequential test for get_d_n block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// seq_test.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-06-15 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
task seq_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   real        u,v;
   real        u_i,v_i;    // integer part
   real        u_d,v_d;    // decimal part
   // -----------------------------------------------------

   begin

      ena         = 1'b0;
      rst         = 1'b0;
      run_clk(1);
      rst         = 1'b1;
      run_clk(1);
      rst         = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      //repeat(2**(2*`W+1))
      repeat(2**8)
      begin

         tb_mode     = cnt[2*`W];
         tb_u[`W-1]  = ~cnt[2*`W-1];
         tb_u[`W-2:0]= cnt[2*`W-2:`W];
         tb_v[`W-1]  = cnt[`W-1];
         tb_v[`W-2:0]= ~cnt[`W-2:0];

         u_i   = $itor($signed(tb_u[W-1:4]));
         v_i   = $itor($signed(tb_v[W-1:4]));
         u_d   = $itor((tb_u[3:0]))/16;
         v_d   = $itor((tb_v[3:0]))/16;
         u     = u_i + u_d;
         v     = v_i + v_d;

         $display("u = %f + %f = %f", u_i, u_d, u);
         $display("v = %f + %f = %f", v_i, v_d, v);

         if ( tb_mode == `MODE_E ) begin

            // if                u   <= -10/16   then  d_x = -1
            // if   - 8/16 <=    u   <=   4/16   then  d_x =  0
            // if     6/16 <=    u               then  d_x = +1
            if ( u <= -0.625 )
               tb_d_x = 2'b11;
            else if ( u >= 0.375)
               tb_d_x = 2'b01;
            else
               tb_d_x = 2'b00;

            // if                v   <= -13/16   then  d_y = -1
            // if   -12/16 <=    v   <=  12/16   then  d_y =  0
            // if    13/16 <=    v               then  d_y = +1
            if ( v <= -0.8125 )
               tb_d_y = 2'b11;
            else if ( v >= 0.8125 )
               tb_d_y = 2'b01;
            else
               tb_d_y = 2'b00;

         end
         else if ( tb_mode == `MODE_L ) begin

            // if                u   <= -8/16    then  d_x = -1
            // if    -8/16 <     u   <   8/16    then  d_x =  0
            // if     8/16 <=    u               then  d_x = +1
            if ( u <= -0.50 )
               tb_d_x = 2'b11;
            else if ( u >= 0.50 )
               tb_d_x = 2'b01;
            else
               tb_d_x = 2'b00;

            // if                v   <= -8/16    then  d_y = -1
            // if    -8/16 <     v   <   8/16    then  d_y =  0
            // if     8/16 <=    v               then  d_y = +1
            if ( v <= -0.50 )
               tb_d_y = 2'b11;
            else if ( v >= 0.50 )
               tb_d_y = 2'b01;
            else
               tb_d_y = 2'b00;

         end

         run_clk(1);

      end

   end

// *****************************************************************************

endtask

