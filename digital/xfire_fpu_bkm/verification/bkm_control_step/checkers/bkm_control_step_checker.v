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
//    - 2016-08-15 - ilesser - Added LOG2N parameter.
//    - 2016-08-15 - ilesser - Deleted unused regs.
//    - 2016-08-02 - ilesser - Changed the definition of W.
//    - 2016-08-02 - ilesser - BUG2 fixed: solved problem with deltas, err and war.
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
   parameter W       = 64,
   parameter LOG2N   = 6
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
   input wire               tb_mode,
   input wire  [1:0]        tb_format,
   input wire  [LOG2N-1:0]  tb_n,
   input wire  [1:0]        tb_d_u_n,
   input wire  [1:0]        tb_d_v_n,
   input wire  [W-1:0]      tb_u_n,
   input wire  [W-1:0]      tb_v_n,
   input wire  [W-1:0]      tb_u_np1,
   input wire  [W-1:0]      tb_v_np1,
   input wire  [W-1:0]      res_u_np1,
   input wire  [W-1:0]      res_v_np1,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output reg               war_u,
   output reg               war_v,
   output reg               err_u,
   output reg               err_v,
   output wire [W-1:0]      delta_u,
   output wire [W-1:0]      delta_v
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire     neq_u,         neq_v;
   // -----------------------------------------------------

   initial begin
      $monitor("Time = %8t",                                               $time,
               "\ttb_mode=%b",                                             tb_mode,
               "\ttb_format=%b",                                           tb_format,
               "\ttb_n=%b",                                                tb_n,
               "\ttb_d_u_n=%b\ttb_d_v_n=%b\n",                             tb_d_u_n, tb_d_v_n,
               "\ttb_u_n=%6d\ttb_v_n=%6d\t tb_u_np1=%6d\t tb_v_np1=%6d\n", tb_u_n, tb_v_n, tb_u_np1, tb_v_np1,
               "\t\t\t\t\tres_u_np1=%6d\tres_v_np1=%6d\n",                                res_u_np1,res_v_np1,
            );
   end

   assign neq_u      = tb_u_np1 !== res_u_np1;
   assign neq_v      = tb_v_np1 !== res_v_np1;
   assign delta_u    = tb_u_np1 - res_u_np1;
   assign delta_v    = tb_v_np1 - res_v_np1;

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_u       <= 1'b0;
         war_u       <= 1'b0;
      end
      else begin
         if (enable == 1'b1) begin
            if (neq_u == 1'b1) begin
               // this report an error if |delta| > 1 or a warning otherwise
               // the idea is the get a warning if the delta is only 1 LSB
               if (abs($signed(delta_u)) > 1) begin
                  $display("[%0d] ERROR: in u.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_u_np1, res_u_np1);
                  add_error();
                  err_u    <= 1'b1;
                  war_u    <= 1'b0;
                  //finish_sim();
               end
               else begin
                  add_warning();
                  err_u    <= 1'b0;
                  war_u    <= 1'b1;
               end
            end
            else begin
               add_note();
               err_u       <= 1'b0;
               war_u       <= 1'b0;
            end
         end
      end
   end

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_v    <= 1'b0;
         war_v    <= 1'b0;
      end
      else begin
         if (enable == 1'b1) begin
            if (neq_v == 1'b1) begin
               if (abs($signed(delta_v)) > 1) begin
                  $display("[%0d] ERROR: in v.\tExpected result: %d\n\t\t\tObtained result: %d\t\t. Instance: %m",$time, tb_v_np1, res_v_np1);
                  add_error();
                  err_v    <= 1'b1;
                  war_v    <= 1'b0;
                  //finish_sim();
               end
               else begin
                  add_warning();
                  err_v    <= 1'b0;
                  war_v    <= 1'b1;
               end
            end
            else begin
               add_note();
               err_v       <= 1'b0;
               war_v       <= 1'b0;
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

