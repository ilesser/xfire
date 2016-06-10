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
// Sequential test for add_subb block.
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
//    - 2016-06-09 - ilesser - Initial version.
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

      $dumpfile("../waves/tb_add_subb_seq_test.vcd");
      $dumpvars();

      tb_subb_a   = cnt[2*`W+1];
      tb_subb_b   = cnt[2*`W];
      tb_a        = cnt[2*`W-1:`W];
      tb_b        = cnt[`W-1:0];

      always @(*) begin
         case ({tb_subb_a, tb_subb_b})
            2'b00 : {tb_c, tb_s} =  tb_a + tb_b;
            2'b01 : {tb_c, tb_s} =  tb_a - tb_b;
            2'b10 : {tb_c, tb_s} = -tb_a + tb_b;
            2'b11 : {tb_c, tb_s} = -tb_a - tb_b;
         endcase
      end
   end

// *****************************************************************************

endtask