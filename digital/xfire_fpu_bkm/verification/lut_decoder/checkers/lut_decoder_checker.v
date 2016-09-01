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
// Checker for lut_decoder block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// lut_decoder_checker.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-31 - ilesser - Used real values for luts.
//    - 2016-08-28 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module lut_decoder_checker #(
   // ----------------------------------
   // Parameters
   // ----------------------------------
   parameter WC      = 16,
   parameter WD      = 64,
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
   input wire              tb_mode,
   input wire  [1:0]       tb_format,
   input wire  [LOG2N-1:0] tb_n,
   input wire  [1:0]       tb_d_x_n,
   input wire  [1:0]       tb_d_y_n,
   input real              tb_lut_u_n,
   input real              tb_lut_v_n,
   input real              res_lut_u_n,
   input real              res_lut_v_n,
   input real              tb_lut_X_n,
   input real              tb_lut_Y_n,
   input real              res_lut_X_n,
   input real              res_lut_Y_n,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output reg                war_u,
   output reg                war_v,
   output reg                err_u,
   output reg                err_v,
   output real               delta_u,
   output real               delta_v,
   output real               min_delta_u,
   output real               min_delta_v,
   output real               max_delta_u,
   output real               max_delta_v,
   output reg                war_X,
   output reg                war_Y,
   output reg                err_X,
   output reg                err_Y,
   output real               delta_X,
   output real               delta_Y,
   output real               min_delta_X,
   output real               min_delta_Y,
   output real               max_delta_X,
   output real               max_delta_Y
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   real     n;
   real     pow_2_mn;
   wire     neq_X,         neq_Y;
   wire     neq_u,         neq_v;
   // -----------------------------------------------------

   //initial begin
      //$monitor("Time = %8t",                             $time,
               //"\ttb_mode=%b",                           tb_mode,
               //"\ttb_format=%b",                         tb_format,
               //"\ttb_n=%b",                              tb_n,
               //"\ttb_d_x_n=%b\ttb_d_y_n=%b\n",           tb_d_x_n,      tb_d_y_n,
               //"\ttb_lut_X_n =%6d\ttb_lut_Y_n =%6d\n",   tb_lut_X_n,    tb_lut_Y_n,
               //"\ttb_lut_u_n =%6d\ttb_lut_v_n =%6d\n",   tb_lut_u_n,    tb_lut_v_n,
               //"\tres_lut_X_n=%6d\tres_lut_Y_n=%6d\n",   res_lut_X_n,   res_lut_Y_n,
               //"\tres_lut_u_n=%6d\tres_lut_v_n=%6d\n",   res_lut_u_n,   res_lut_v_n,
            //);
   //end

   assign n = $itor(tb_n+1);
   assign pow_2_mn = 2**(-n);
   assign neq_X      = tb_lut_X_n != res_lut_X_n;
   assign neq_Y      = tb_lut_Y_n != res_lut_Y_n;
   assign delta_X    = tb_lut_X_n -  res_lut_X_n;
   assign delta_Y    = tb_lut_Y_n -  res_lut_Y_n;

   assign neq_u      = tb_lut_u_n != res_lut_u_n;
   assign neq_v      = tb_lut_v_n != res_lut_v_n;
   assign delta_u    = tb_lut_u_n -  res_lut_u_n;
   assign delta_v    = tb_lut_v_n -  res_lut_v_n;

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_X       <= 1'b0;
         war_X       <= 1'b0;
      end
      else begin
         if (enable == 1'b1) begin
            if (neq_X == 1'b1) begin
               // this report an error if |delta| > 2**(-n) or a warning otherwise
               // the idea is the get a warning if the delta is only 1 LSB
               if (abs((delta_X)) > 2**(-n)) begin
                  $display("[%0d] ERROR: in u.\tExpected result: %f\n\t\t\tObtained result: %f\t\t. Instance: %m",$time, tb_lut_X_n, res_lut_X_n);
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
               if (abs((delta_Y)) > 2**(-n)) begin
                  $display("[%0d] ERROR: in v.\tExpected result: %f\n\t\t\tObtained result: %f\t\t. Instance: %m",$time, tb_lut_Y_n, res_lut_Y_n);
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

   always @(posedge clk) begin
      if (srst == 1'b1) begin
         err_u       <= 1'b0;
         war_u       <= 1'b0;
      end
      else begin
         if (enable == 1'b1) begin
            if (neq_u == 1'b1) begin
               // this report an error if |delta| > 2**(-n) or a warning otherwise
               // the idea is the get a warning if the delta is only 1 LSB
               if (abs((delta_u)) > 2**(-n)) begin
                  $display("[%0d] ERROR: in u.\tExpected result: %f\n\t\t\tObtained result: %f\t\t. Instance: %m",$time, tb_lut_u_n, res_lut_u_n);
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
               if (abs((delta_v)) > 2**(-n)) begin
                  $display("[%0d] ERROR: in v.\tExpected result: %f\n\t\t\tObtained result: %f\t\t. Instance: %m",$time, tb_lut_v_n, res_lut_v_n);
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

   always @(posedge clk or posedge arst) begin
      if (arst==1'b1) begin
         max_delta_X <= 0.0;
         min_delta_X <= 0.0;
         max_delta_Y <= 0.0;
         min_delta_Y <= 0.0;
         max_delta_u <= 0.0;
         min_delta_u <= 0.0;
         max_delta_v <= 0.0;
         min_delta_v <= 0.0;
      end
      else begin
         if (srst==1'b1) begin
            max_delta_X <= 0.0;
            min_delta_X <= 0.0;
            max_delta_Y <= 0.0;
            min_delta_Y <= 0.0;
            max_delta_u <= 0.0;
            min_delta_u <= 0.0;
            max_delta_v <= 0.0;
            min_delta_v <= 0.0;
         end
         else if (enable==1'b1) begin
            if ( (delta_X) > (max_delta_X) )
               max_delta_X <= delta_X;
            else
               max_delta_X <= max_delta_X;

            if ( (delta_X) < (min_delta_X) )
               min_delta_X <= delta_X;
            else
               min_delta_X <= min_delta_X;

            if ( (delta_Y) < (min_delta_Y) )
               max_delta_Y <= delta_Y;
            else
               max_delta_Y <= max_delta_Y;

            if ( (delta_Y) < (min_delta_Y) )
               min_delta_Y <= delta_Y;
            else
               min_delta_Y <= min_delta_Y;

            if ( (delta_u) < (min_delta_u) )
               max_delta_u <= delta_u;
            else
               max_delta_u <= max_delta_u;

            if ( (delta_u) < (min_delta_u) )
               min_delta_u <= delta_u;
            else
               min_delta_u <= min_delta_u;

            if ( (delta_v) < (min_delta_v) )
               max_delta_v <= delta_v;
            else
               max_delta_v <= max_delta_v;

            if ( (delta_v) < (min_delta_v) )
               min_delta_v <= delta_v;
            else
               min_delta_v <= min_delta_v;

         end
      end
   end
   // -----------------------------------------------------

// *****************************************************************************

`ifdef RTL_DEBUG

//

`else

//XXXXX FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

