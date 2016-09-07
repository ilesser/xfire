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
//    - 2016-09-04 - ilesser - Added parameters for the integer part.
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
   real        u_f,v_f;    // fractional part
   real        d_x_r, d_y_r;
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

      repeat(2**(`CNT_SIZE))
      begin

         // The u and v channels are independat of each other
         // hence I can assign them at the same time
         tb_mode        =  cnt[`WC];
         tb_u[`WC-1]    = ~cnt[`WC-1];
         tb_u[`WC-2:0]  =  cnt[`WC-2:0];
         tb_v[`WC-1]    = ~cnt[`WC-1];
         tb_v[`WC-2:0]  =  cnt[`WC-2:0];

         u_i   = $itor($signed(tb_u[`WC-1:`WF]));
         v_i   = $itor($signed(tb_v[`WC-1:`WF]));
         u_f   = $itor((tb_u[`WF-1:`WF-4]))/2.0**4;
         v_f   = $itor((tb_v[`WF-1:`WF-4]))/2.0**4;
         u     = u_i + u_f;
         v     = v_i + v_f;

         // Get the d_n value
         get_d_n (
            // ----------------------------------
            // Data inputs
            // ----------------------------------
            tb_mode,
            u,       v,
            // ----------------------------------
            // Data outputs
            // ----------------------------------
            d_x_r,   d_y_r,
            tb_d_x,  tb_d_y
         );

         run_clk(1);

      end

   end

// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   $display("u = %f + %f = %f", u_i, u_f, u);
   $display("v = %f + %f = %f", v_i, v_f, v);


`endif
// *****************************************************************************

endtask

