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
   real                    du,                        dv;
   real                    u_n,                       v_n;
   real                    u_np1,                     v_np1;
   real                    lut_u,                     lut_v;
   real                    u_n_plus_d_u_n_r,          v_n_plus_d_v_n_r;
   real                    u_n_times_d_n_r,           v_n_times_d_n_r;
   real                    u_n_times_d_n_div_2_n_r,   v_n_times_d_n_div_2_n_r;
   real                    sign_u,                    sign_v;
   real test_u, test_v;
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


         // Calculate u and v

         u_n_plus_d_u_n_r        = u_n + du;
         u_n_times_d_n_r         = (du * u_n - dv * v_n);

         v_n_plus_d_v_n_r        = v_n + dv;
         v_n_times_d_n_r         = (du * v_n + dv * u_n);

         //u_n_times_d_n_div_2_n_r =      ((u_n_times_d_n_r + 0) * 2**(-n));
         //v_n_times_d_n_div_2_n_r =      ((v_n_times_d_n_r + 0) * 2**(-n));
         //u_n_times_d_n_div_2_n_r = $rtoi((u_n_times_d_n_r + 0) * 2**(-n));
         //v_n_times_d_n_div_2_n_r = $rtoi((v_n_times_d_n_r + 0) * 2**(-n));

         sign_u = u_n_times_d_n_r >= 0 ? 0.0 : 1.0;
         sign_v = v_n_times_d_n_r >= 0 ? 0.0 : 1.0;

         //u_n_times_d_n_div_2_n_r = $rtoi((u_n_times_d_n_r + (-1)**(sign_u)) * 2**(-n));
         //v_n_times_d_n_div_2_n_r = $rtoi((v_n_times_d_n_r + (-1)**(sign_v)) * 2**(-n));
         //u_n_times_d_n_div_2_n_r = u_n_times_d_n_r >= 0  ?  $rtoi((u_n_times_d_n_r            ) * 2**(-n)):
                                                            //$rtoi((u_n_times_d_n_r - 1        ) * 2**(-n));
         //v_n_times_d_n_div_2_n_r = v_n_times_d_n_r >= 0  ?  $rtoi((v_n_times_d_n_r            ) * 2**(-n)):
                                                            //$rtoi((v_n_times_d_n_r - 1        ) * 2**(-n));

         //TODO: this is ok but not fixed
         u_n_times_d_n_div_2_n_r = $rtoi(div_2_n(u_n_times_d_n_r, n));
         v_n_times_d_n_div_2_n_r = $rtoi(div_2_n(v_n_times_d_n_r, n));

         if (complex==1'b1) begin

            //u_np1 = 2*(u_n + du + $rtoi((du * u_n - dv * v_n) * 2**(-n)));
            //v_np1 = 2*(v_n + dv + $rtoi((du * v_n + dv * u_n) * 2**(-n)));
            u_np1 = 2*( u_n_plus_d_u_n_r + u_n_times_d_n_div_2_n_r );
            v_np1 = 2*( v_n_plus_d_v_n_r + v_n_times_d_n_div_2_n_r );

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
            u_np1 = 2*( u_n_plus_d_u_n_r + u_n_times_d_n_div_2_n_r );
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

function real div_2_n;
   input real x;
   input real n;
   begin
      if (n == 0.0) begin
         div_2_n = x;
      end
      else begin
         x = 2 * x;
         x = x/(2**n);
         if (x%2 == 0) begin
            // even
            div_2_n = x/2;
         end
         else begin
            //odd
            div_2_n = (x-1)/2;
         end
      end
   end
endfunction

//task div_by_2_n;
   //input real x;
   //input real n;
   //output real div_2_n;
   //begin
      //if (n == 0.0) begin
         //div_2_n = x;
      //end
      //else begin
         //x = 2 * x;
         //x = x/(2**n);
         //if (x%2 == 0) begin
            //// even
            //div_2_n = x/2;
         //end
         //else begin
            ////odd
            //div_2_n = (x-1)/2;
         //end
      //end
   //end
//endtask
