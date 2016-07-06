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
// Sequential test for multiply_by_d_csd block.
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
//    - 2016-07-05 - ilesser - Initial version.
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

      //repeat(80)
      repeat(2**(`CNT_SIZE))
         load_operands(cnt);

   end

// *****************************************************************************

endtask

// *****************************************************************************
// Interface
// *****************************************************************************
task load_operands;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input [`CNT_SIZE-1:0]   cnt;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   real        xi, yi;
   real        xo, yo;
   real        dx, dy;
   // -----------------------------------------------------

   begin

      tb_d_x      = cnt[2*`W+3:2*`W+2];
      tb_d_y      = cnt[2*`W+1:2*`W];
      tb_x_in     = cnt[2*`W-1:`W];
      tb_y_in     = cnt[`W-1:0];

      xi = $itor($signed(tb_x_in));
      yi = $itor($signed(tb_y_in));
      //dx = $itor($signed(tb_d_x));
      //dy = $itor($signed(tb_d_y));

      case(tb_d_x)
         2'b00:   dx = +0.0;
         2'b01:   dx = +1.0;
         2'b10:   dx = -0.0;
         2'b11:   dx = -1.0;
      endcase

      case(tb_d_y)
         2'b00:   dy = +0.0;
         2'b01:   dy = +1.0;
         2'b10:   dy = -0.0;
         2'b11:   dy = -1.0;
      endcase

      $display("dx = %f", dx);
      $display("dy = %f", dy);
      $display("xi = %f", xi);
      $display("yi = %f", yi);

      xo = xi*dx - yi*dy;
      yo = xi*dy + yi*dx;

      $display("xo = %f", xo);
      $display("yo = %f", yo);
      $display("zo = (dx*xi - dy*yi) + j (dy*xi + dx*yi)");
      $display("zo = (%.2f*%.2f - %.2f*%.2f) + j (%.2f*%.2f + %.2f*%.2f)", dx, xi, dy, yi, dy, xi, dx, yi);
      $display("zo = (      %.2f     ) + j (      %.2f     )", xo, yo);

      //tb_x_out = $realtobits(xo);
      //tb_y_out = $realtobits(yo);
      tb_x_out = (xo);
      tb_y_out = (yo);

      run_clk(1);

   end

// *****************************************************************************

endtask

