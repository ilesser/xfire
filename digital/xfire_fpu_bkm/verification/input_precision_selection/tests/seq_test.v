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
// Sequential test for input_precision_selection block.
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

`include "bkm_defs.vh"

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

      tb_format   = cnt[`CNT_SIZE-1:`CNT_SIZE-2];
      tb_e_x_i    = cnt[4*`W-1:3*`W];
      tb_e_y_i    = cnt[3*`W-1:2*`W];
      tb_l_x_i    = cnt[2*`W-1:1*`W];
      tb_l_y_i    = cnt[1*`W-1:0*`W];

      case (tb_format)
         `FORMAT_REAL_32:
                        begin
                           tb_e_x_o = { {`W/2{tb_e_x_i[`W/2-1]}}, tb_e_x_i[`W/2-1:0]};
                           tb_e_y_o = {`W{1'b0}};
                           tb_l_x_o = { {`W/2{tb_l_x_i[`W/2-1]}}, tb_l_x_i[`W/2-1:0]};
                           tb_l_y_o = {`W{1'b0}};
                        end
         `FORMAT_REAL_64:
                        begin
                           tb_e_x_o = tb_e_x_i;
                           tb_e_y_o = {`W{1'b0}};
                           tb_l_x_o = tb_l_x_i;
                           tb_l_y_o = {`W{1'b0}};
                        end
         `FORMAT_CMPLX_32:
                        begin
                           tb_e_x_o = { {`W/2{tb_e_x_i[`W/2-1]}}, tb_e_x_i[`W/2-1:0]};
                           tb_e_y_o = { {`W/2{tb_e_y_i[`W/2-1]}}, tb_e_y_i[`W/2-1:0]};
                           tb_l_x_o = { {`W/2{tb_l_x_i[`W/2-1]}}, tb_l_x_i[`W/2-1:0]};
                           tb_l_y_o = { {`W/2{tb_l_y_i[`W/2-1]}}, tb_l_y_i[`W/2-1:0]};
                        end
         `FORMAT_CMPLX_64:
                        begin
                           tb_e_x_o = tb_e_x_i;
                           tb_e_y_o = tb_e_y_i;
                           tb_l_x_o = tb_l_x_i;
                           tb_l_y_o = tb_l_y_i;
                        end
         default:
                        begin
                           tb_e_x_o = {`W{1'b0}};
                           tb_e_y_o = {`W{1'b0}};
                           tb_l_x_o = {`W{1'b0}};
                           tb_l_y_o = {`W{1'b0}};
                        end
      endcase

      run_clk(1);

   end

// *****************************************************************************

endtask



