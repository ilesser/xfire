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
// Checker for bkm_data_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_data_step_checker.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-15 - ilesser - Added LOG2N parameter.
//    - 2016-08-15 - ilesser - Deleted unused regs.
//    - 2016-08-03 - ilesser - Copied from bkm_control_step checker.
//    - 2016-07-22 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_data_step_checker #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter W       = 64,
   parameter LOG2N   = 6
   ) (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input wire               clk,
   input wire               arst,
   input wire               srst,
   input wire               enable,
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input wire               tb_mode,
   input wire  [1:0]        tb_format,
   input wire  [LOG2N-1:0]  tb_n,
   input wire  [1:0]        tb_d_x_n,
   input wire  [1:0]        tb_d_y_n,
   input wire  [W-1:0]      tb_X_n,
   input wire  [W-1:0]      tb_Y_n,
   input wire  [W-1:0]      tb_X_np1,
   input wire  [W-1:0]      tb_Y_np1,
   input wire  [W-1:0]      res_X_np1,
   input wire  [W-1:0]      res_Y_np1,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output reg                war_X,
   output reg                war_Y,
   output reg                err_X,
   output reg                err_Y,
   output wire  [W-1:0]      delta_X,
   output wire  [W-1:0]      delta_Y
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire     neq_X,         neq_Y;
   // -----------------------------------------------------

   initial begin
      $monitor("Time = %8t",                                               $time,
               "\ttb_mode=%b",                                             tb_mode,
               "\ttb_format=%b",                                           tb_format,
               "\ttb_n=%b",                                                tb_n,
               "\ttb_d_x_n=%b\ttb_d_y_n=%b\n",                             tb_d_x_n, tb_d_y_n,
               "\ttb_X_n=%6d\ttb_Y_n=%6d\t tb_X_np1=%6d\t tb_Y_np1=%6d\n", tb_X_n, tb_Y_n, tb_X_np1, tb_Y_np1,
               "\t\t\t\t\tres_X_np1=%6d\tres_Y_np1=%6d\n",                                res_X_np1,res_Y_np1,
            );
   end

   assign neq_X      = tb_X_np1 !== res_X_np1;
   assign neq_Y      = tb_Y_np1 !== res_Y_np1;
   assign delta_X    = tb_X_np1 - res_X_np1;
   assign delta_Y    = tb_Y_np1 - res_Y_np1;

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_X       <= 1'b0;
         war_X       <= 1'b0;
      end
      else begin
         if (enable == 1'b1) begin
            if (neq_X == 1'b1) begin
               // this report an error if |delta| > 1 or a warning otherwise
               // the idea is the get a warning if the delta is only 1 LSB
               if (abs($signed(delta_X)) > 1) begin
                  $display("[%0d] ERROR: in u.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_X_np1, res_X_np1);
                  add_error();
                  err_X    <= 1'b1;
                  war_X    <= 1'b0;
                  //finish_sim();
               end
               else begin
                  add_warning();
                  err_X    <= 1'b0;
                  war_X    <= 1'b1;
               end
            end
            else begin
               add_note();
               err_X       <= 1'b0;
               war_X       <= 1'b0;
            end
         end
      end
   end

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_Y    <= 1'b0;
         war_Y    <= 1'b0;
      end
      else begin
         if (enable == 1'b1) begin
            if (neq_Y == 1'b1) begin
               if (abs($signed(delta_Y)) > 1) begin
                  $display("[%0d] ERROR: in v.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_Y_np1, res_Y_np1);
                  add_error();
                  err_Y    <= 1'b1;
                  war_Y    <= 1'b0;
                  //finish_sim();
               end
               else begin
                  add_warning();
                  err_Y    <= 1'b0;
                  war_Y    <= 1'b1;
               end
            end
            else begin
               add_note();
               err_Y       <= 1'b0;
               war_Y       <= 1'b0;
            end
         end
      end
   end
// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

