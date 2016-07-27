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
// Load operands task for bkm_control_step block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// load_operands_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-23 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

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
   reg                     double_word;
   reg                     complex;
   real                    n;
   real                    du,      dv;
   real                    u_n,     v_n;
   real                    u_np1,   v_np1;
   real                    lut_u,   lut_v;
   // -----------------------------------------------------

   begin

      tb_mode     = cnt[`CNT_SIZE-1];
      tb_format   = cnt[`CNT_SIZE-2:`CNT_SIZE-3];
      tb_n        = cnt[4*`W/4+4+`LOG2N-1:4*`W/4+4];
      tb_d_u_n    = cnt[4*`W/4+3         :4*`W/4+2];
      tb_d_v_n    = cnt[4*`W/4+1         :4*`W/4+0];
      tb_u_n      = cnt[4*`W/4-1         :3*`W/4];
      tb_v_n      = cnt[3*`W/4-1         :2*`W/4];
      tb_lut_u_n  = cnt[2*`W/4-1         :1*`W/4];
      tb_lut_v_n  = cnt[1*`W/4-1         :0*`W/4];

      double_word = tb_format[0];
      complex     = tb_format[1];

      n  = $itor($signed(tb_n));

      du =  tb_d_u_n == 2'b01 ?  1  :
            tb_d_u_n == 2'b11 ? -1  :
                                 0  ;

      dv =  tb_d_v_n == 2'b01 ?  1  :
            tb_d_v_n == 2'b11 ? -1  :
                                 0  ;

      if (double_word==1'b1) begin
         u_n   = $itor($signed(tb_u_n));
         v_n   = $itor($signed(tb_v_n));
         lut_u = $itor($signed(tb_lut_u_n));
         lut_v = $itor($signed(tb_lut_v_n));
      end
      else begin
         u_n   = $itor($signed(tb_u_n[`W/4/2-1:0]));
         v_n   = $itor($signed(tb_v_n[`W/4/2-1:0]));
         lut_u = $itor($signed(tb_lut_u_n[`W/4/2-1:0]));
         lut_v = $itor($signed(tb_lut_v_n[`W/4/2-1:0]));
      end

      if (tb_mode==`MODE_E) begin
      // E-mode
      // ------
      // w = 2^1 * L
      // w_{n+1} = 2 w_n - 2^(n+1) * ln(1 + d_n * 2^-n)

         if (complex==1'b1) begin

            // Calculate u and v
            u_np1 = 2 * (u_n - lut_u);
            v_np1 = 2 * (v_n - lut_v);

         end
         else begin

            // Calculate u and v
            u_np1 = 2 * (u_n - lut_u);
            v_np1 = 0;

         end

      end
      //else if (tb_mode==`MODE_L) begin
      else begin
      // L-mode
      // ------
      // w = 2^1 * (E-1)
      // w_{n+1} = 2 * [ w_n + d_n + d_n * w_n * 2^-n ]

      // d_n * w_n = (du + j dv) * (u + j v) = (du*u-dv*v) + j (du*v+dv*u)

         if (complex==1'b1) begin

            // Calculate u and v
            u_np1 = 2*(u_n + du + $rtoi((du * u_n - dv * v_n) * 2**(-n)));
            v_np1 = 2*(v_n + dv + $rtoi((du * v_n + dv * u_n) * 2**(-n)));

            // if n=0 ^ du=0 ^ dv=+-1 then
            //u_np1 = 2*(u_n +  0 - dv * v_n);
            //v_np1 = 2*(v_n + dv + dv * u_n);

            // if n=0 ^ du=+-1 ^ dv=0 then
            //u_np1 = 2*(u_n + du + du * u_n);
            //v_np1 = 2*(v_n +  0 + du * v_n);

            // if n=1 ^ du=0 ^ dv=+-1 then
            //u_np1 = 2*(u_n +  0 - dv * v_n * 2**(-1));
            //v_np1 = 2*(v_n + dv + dv * u_n * 2**(-1));



         end
         else begin

            // Calculate u and v
            u_np1 = 2*(u_n + du + du * u_n * 2**(-n));
            v_np1 = 0;

         end

      end

      tb_u_np1 = (u_np1);
      tb_v_np1 = (v_np1);

      //tb_u_np1 = (u_np1+1.0-1.0);
      //tb_v_np1 = (v_np1+1.0-1.0);

      run_clk(1);

   end

// *****************************************************************************

endtask

