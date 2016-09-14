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
// Load operands task for bkm_step block.
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
//    - 2016-09-14 - ilesser - Updated to use real number model.
//    - 2016-09-05 - ilesser - Changed bkm_step_task inputs to real type.
//    - 2016-08-15 - ilesser - Changed architecture. Now I have a task that calculates a single step.
//    - 2016-08-11 - ilesser - Updated for WD and WC.
//    - 2016-07-06 - ilesser - Initial version.
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
   reg   [`WD-1:0]   X_n_bin,       Y_n_bin;
   reg   [`WD-1:0]   lut_X_n_bin,   lut_Y_n_bin;
   reg   [`WC-1:0]   u_n_bin,       v_n_bin;
   reg   [`WC-1:0]   lut_u_n_bin,   lut_v_n_bin;
   // -----------------------------------------------------

   begin

      // Apply values to testbench

      tb_mode     = cnt[`CNT_SIZE-1                               ];
      tb_format   = cnt[`CNT_SIZE-2          :`CNT_SIZE-3         ];

      tb_n        = cnt[`CNT_SIZE-4          :`CNT_SIZE-5-`LOG2N  ];
      tb_d_x_n    = cnt[`CNT_SIZE-6-`LOG2N   :`CNT_SIZE-7-`LOG2N  ];
      tb_d_y_n    = cnt[`CNT_SIZE-8-`LOG2N   :`CNT_SIZE-9-`LOG2N  ];

      X_n_bin     = cnt[4*`WC+4*`WD-1           :4*`WC+3*`WD];
      Y_n_bin     = cnt[4*`WC+3*`WD-1           :4*`WC+2*`WD];
      u_n_bin     = cnt[4*`WC+2*`WD-1           :3*`WC+2*`WD];
      v_n_bin     = cnt[3*`WC+2*`WD-1           :2*`WC+2*`WD];
      lut_X_n_bin = cnt[2*`WC+2*`WD-1           :2*`WC+1*`WD];
      lut_Y_n_bin = cnt[2*`WC+1*`WD-1           :2*`WC      ];
      lut_u_n_bin = cnt[2*`WC-1                 :1*`WC      ];
      lut_v_n_bin = cnt[1*`WC-1                 :0*`WC      ];

      tb_X_n      = data2real   (X_n_bin     );
      tb_Y_n      = data2real   (Y_n_bin     );
      tb_u_n      = control2real(u_n_bin     );
      tb_v_n      = control2real(v_n_bin     );
      tb_lut_X_n  = data2real   (lut_X_n_bin );
      tb_lut_Y_n  = data2real   (lut_Y_n_bin );
      tb_lut_u_n  = control2real(lut_u_n_bin );
      tb_lut_v_n  = control2real(lut_v_n_bin );

      // Calculate the results
      bkm_step (
         // ----------------------------------
         // Data inputs
         // ----------------------------------
         tb_mode,
         tb_format,
         tb_n,
         tb_d_x_n,   tb_d_y_n,
         tb_X_n,     tb_Y_n,
         tb_u_n,     tb_v_n,
         tb_lut_X_n, tb_lut_Y_n,
         tb_lut_u_n, tb_lut_v_n,
         // ----------------------------------
         // Data outputs
         // ----------------------------------
         tb_X_np1,   tb_Y_np1,
         tb_u_np1,   tb_v_np1
      );

      run_clk(1);

   end

// *****************************************************************************

endtask
