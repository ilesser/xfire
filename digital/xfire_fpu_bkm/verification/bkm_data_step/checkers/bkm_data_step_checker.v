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
   parameter W       = 64
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
   output reg   [W-1:0]      delta_X,
   output reg   [W-1:0]      delta_Y
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   assign war_X = 1'b0;
   assign war_Y = 1'b0;

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_X    <= 1'b0;
         delta_X  <= {W{1'b0}};
      end
      else begin
         if (enable == 1'b1) begin
            if (tb_X_np1 !== res_X_np1) begin
               $display("[%0d] ERROR: in X.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_X_np1, res_X_np1);
               add_error();
               //finish_sim();
               err_X    <= 1'b1;
               delta_X  <= tb_X_np1 - res_X_np1;
            end
            else begin
               add_note();
               err_X    <= 1'b0;
            end
         end
      end
   end

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_Y    <= 1'b0;
         delta_Y  <= {W{1'b0}};
      end
      else begin
         if (enable == 1'b1) begin
            if (tb_Y_np1 !== res_Y_np1) begin
               $display("[%0d] ERROR: in Y.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_Y_np1, res_Y_np1);
               add_error();
               //finish_sim();
               err_Y    <= 1'b1;
               delta_Y  <= tb_Y_np1 - res_Y_np1;
            end
            else begin
               add_note();
               err_Y    <= 1'b0;
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

