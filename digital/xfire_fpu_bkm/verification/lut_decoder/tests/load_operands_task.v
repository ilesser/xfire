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
// Load operands task for lut_decoder block.
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
//    - 2016-08-28 - ilesser - Initial version.
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
   // -----------------------------------------------------

   begin

      // Apply values to testbench
      tb_mode     = cnt[`CNT_SIZE-1                      ];
      tb_format   = cnt[`CNT_SIZE-2          :`CNT_SIZE-3];
      tb_n        = cnt[2*`D_SIZE+`LOG2N-1   :2*`D_SIZE  ];
      tb_d_x_n    = cnt[2*`D_SIZE-1          :1*`D_SIZE  ];
      tb_d_y_n    = cnt[1*`D_SIZE-1          :0*`D_SIZE  ];

      run_clk(1);

   end

// *****************************************************************************

endtask
