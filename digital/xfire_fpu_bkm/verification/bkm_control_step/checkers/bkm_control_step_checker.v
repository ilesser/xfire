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
// Checker for bkm_control_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_control_step_checker.v
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
module bkm_control_step_checker #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter W       = 64
   ) (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input wire              clk,
   input wire              arst,
   input wire              srst,
   input wire              enable,
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input wire  [W/4-1:0]   tb_u_np1,
   input wire  [W/4-1:0]   tb_v_np1,
   input wire  [W/4-1:0]   res_u_np1,
   input wire  [W/4-1:0]   res_v_np1,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output reg              war_u,
   output reg              war_v,
   output reg              err_u,
   output reg              err_v,
   output reg   [W/4-1:0]  delta_u,
   output reg   [W/4-1:0]  delta_v
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   assign war_u = 1'b0;
   assign war_v = 1'b0;

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_u    <= 1'b0;
         delta_u  <= {W/4{1'b0}};
      end
      else begin
         if (enable == 1'b1) begin
            if (tb_u_np1 !== res_u_np1) begin
               $display("[%0d] ERROR: in u.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_u_np1, res_u_np1);
               add_error();
               //finish_sim();
               err_u    <= 1'b1;
               delta_u  <= tb_u_np1 - res_u_np1;
            end
            else begin
               add_note();
               err_u    <= 1'b0;
               delta_u  <= {W/4{1'b0}};
            end
         end
      end
   end

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_v    <= 1'b0;
         delta_v  <= {W/4{1'b0}};
      end
      else begin
         if (enable == 1'b1) begin
            if (tb_v_np1 !== res_v_np1) begin
               $display("[%0d] ERROR: in v.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_v_np1, res_v_np1);
               add_error();
               //finish_sim();
               err_v    <= 1'b1;
               delta_v  <= tb_v_np1 - res_v_np1;
            end
            else begin
               add_note();
               err_v    <= 1'b0;
               delta_v  <= {W/4{1'b0}};
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

