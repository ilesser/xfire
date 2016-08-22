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
// Testbench for bkm_steps block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// tb_bkm_steps.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-08-15 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`define SIM_CLK_PERIOD_NS 10
`timescale 1ns/1ps
`define N      32
`define LOG2N   5
`define W      32
`define LOG2W   5
`define GD      1
`define GC      2
`define WD     `W+`GD      //32+1 //`W
`define WC     `W/4+`GC   //8+2 //`W/4
`define LOG2WD `LOG2W
`define LOG2WC `LOG2W-2
`define M_SIZE  1
`define F_SIZE  2
`define D_SIZE  2
`define CNT_SIZE `M_SIZE+`F_SIZE+2*(`WC)+2*(`WD)

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module tb_bkm_steps ();
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Testbench controlled variables and signals
   // -----------------------------------------------------
   wire                    clk;
   reg                     arst, srst, ena, load;
   reg                     tb_start;
   reg                     tb_mode;
   reg   [1:0]             tb_format;
   reg   [`WD-1:0]         tb_X_in,       tb_Y_in;
   reg   [`WD-1:0]         tb_X_out,      tb_Y_out;
   reg   [`WC-1:0]         tb_u_in,       tb_v_in;
   reg   [`WC-1:0]         tb_u_out,      tb_v_out;
   reg   [`CNT_SIZE-1:0]   cnt, cnt_load, cnt_step;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Testbecnch wiring
   // -----------------------------------------------------
   wire                    err_X,         err_Y;
   wire                    war_X,         war_Y;
   wire                    err_u,         err_v;
   wire                    war_u,         war_v;
   wire  [`WD-1:0]         delta_X,       delta_Y;
   wire  [`WC-1:0]         delta_u,       delta_v;
   wire  [`WD-1:0]         res_X_out,     res_Y_out;
   wire  [`WC-1:0]         res_u_out,     res_v_out;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Transactors
   // -----------------------------------------------------
   simlib_clk_osc #(
      // ----------------------------------------------
      // Parameters
      // ----------------------------------------------
      .CLK_PERIOD_NS    (`SIM_CLK_PERIOD_NS)
   ) clk_osc (
      // ----------------------------------------------
      // Ports in
      // ----------------------------------------------
      .stop             (1'b0),
      // ----------------------------------------------
      // Ports out
      // ----------------------------------------------
      .clk_out          (clk)
   );

   always @(posedge clk)
      if (arst==1'b1) begin
         cnt <= {`CNT_SIZE{1'b0}};
      end else if (ena) begin
         if (load)
            cnt <= cnt_load;
         else
            cnt <= cnt + cnt_step;
      end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Monitors
   // -----------------------------------------------------
   //bkm_steps_monitor #(
      //.WD         (`WD)
   //) duv_monitor (
      //// ----------------------------------
      //// Clock, reset & enable inputs
      //// ----------------------------------
      //.clk        (clk),
      //.arst       (arst),
      //.srst       (srst),
      //.enable     (ena),
      //// ----------------------------------
      //// Data inputs
      //// ----------------------------------
      //.X_np1_csd  (X_np1_csd),
      //.Y_np1_csd  (Y_np1_csd),
      //// ----------------------------------
      //// Data outputs
      //// ----------------------------------
      //.res_X_np1  (res_X_np1),
      //.res_Y_np1  (res_Y_np1)
   //);

   // Uncomment these lines to add waveforms to iverilog simulation
   //initial begin
      //$dumpfile("../waves/tb_bkm_step.vcd");
      //$dumpvars();
   //end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Checkers
   // -----------------------------------------------------
   //bkm_step_checker #(
      //.WC         (`WC),
      //.WD         (`WD),
      //.LOG2N      (`LOG2N)
   //) duv_checker (
      //// ----------------------------------
      //// Clock, reset & enable inputs
      //// ----------------------------------
      //.clk        (clk),
      //.arst       (arst),
      //.srst       (srst),
      //.enable     (ena),
      //// ----------------------------------
      //// Data inputs
      //// ----------------------------------
      //.tb_mode    (tb_mode),
      //.tb_format  (tb_format),
      //.tb_n       (tb_n),
      //.tb_d_x_n   (tb_d_x_n),
      //.tb_d_y_n   (tb_d_y_n),
      //.tb_u_n     (tb_u_n),
      //.tb_v_n     (tb_v_n),
      //.tb_u_np1   (tb_u_np1),
      //.tb_v_np1   (tb_v_np1),
      //.res_u_np1  (res_u_np1),
      //.res_v_np1  (res_v_np1),
      //.tb_X_n     (tb_X_n),
      //.tb_Y_n     (tb_Y_n),
      //.tb_X_np1   (tb_X_np1),
      //.tb_Y_np1   (tb_Y_np1),
      //.res_X_np1  (res_X_np1),
      //.res_Y_np1  (res_Y_np1),
      //// ----------------------------------
      //// Data outputs
      //// ----------------------------------
      //.war_u      (war_u),
      //.war_v      (war_v),
      //.err_u      (err_u),
      //.err_v      (err_v),
      //.delta_u    (delta_u),
      //.delta_v    (delta_v),
      //.war_X      (war_X),
      //.war_Y      (war_Y),
      //.err_X      (err_X),
      //.err_Y      (err_Y),
      //.delta_X    (delta_X),
      //.delta_Y    (delta_Y)
   //);
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Device under verifiacion
   // -----------------------------------------------------
   bkm_steps #(
      .W          (`W),
      .LOG2W      (`LOG2W),
      .N          (`N),
      .LOG2N      (`LOG2N)
   ) duv (
      // ----------------------------------
      // Clock, reset & enable inputs
      // ----------------------------------
      .clk        (clk),
      .arst       (arst),
      .srst       (srst),
      .enable     (ena),
      // ----------------------------------
      // Data inputs
      // ----------------------------------
      .start      (tb_start),
      .mode       (tb_mode),
      .format     (tb_format),
      .X_in       (tb_X_in),
      .Y_in       (tb_Y_in),
      .u_in       (tb_u_in),
      .v_in       (tb_v_in),
      // ----------------------------------
      // Data outputs
      // ----------------------------------
      .X_out      (res_X_out),
      .Y_out      (res_Y_out),
      .u_out      (res_u_out),
      .v_out      (res_v_out),
      .flags      (res_flags),
      .done       (res_done)
   );
   // -----------------------------------------------------

// *****************************************************************************

endmodule

