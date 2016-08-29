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
// Sequential test for complex_add_subb block.
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
//    - 2016-07-06 - ilesser - Initial version.
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

      repeat(2**(`CNT_SIZE))
         load_operands(cnt);

   end

// *****************************************************************************

endtask

// *****************************************************************************
// Interface
// *****************************************************************************
task load_operands;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   input [`CNT_SIZE-1:0]   cnt;
   // -----------------------------------------------------

   begin

      tb_subb_a   = cnt[`CNT_SIZE-1];
      tb_subb_b   = cnt[`CNT_SIZE-2];
      tb_a_x      = cnt[4*`W-1:3*`W];
      tb_a_y      = cnt[3*`W-1:2*`W];
      tb_b_x      = cnt[2*`W-1:1*`W];
      tb_b_y      = cnt[1*`W-1:0*`W];

      case ({tb_subb_a, tb_subb_b})
         2'b00 :  begin
                     {tb_c_x, tb_s_x} =  tb_a_x + tb_b_x;
                     {tb_c_y, tb_s_y} =  tb_a_y + tb_b_y;
                  end
         2'b01 :  begin
                     {tb_c_x, tb_s_x} =  tb_a_x - tb_b_x;
                     {tb_c_y, tb_s_y} =  tb_a_y - tb_b_y;
                  end
         2'b10 :  begin
                     {tb_c_x, tb_s_x} = -tb_a_x + tb_b_x;
                     {tb_c_y, tb_s_y} = -tb_a_y + tb_b_y;
                  end
         2'b11 :  begin
                     {tb_c_x, tb_s_x} = -tb_a_x - tb_b_x;
                     {tb_c_y, tb_s_y} = -tb_a_y - tb_b_y;
                  end
      endcase

      run_clk(1);

   end

// *****************************************************************************

endtask



