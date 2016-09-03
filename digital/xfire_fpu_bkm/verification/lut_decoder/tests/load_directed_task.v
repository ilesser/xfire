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
// Load directed operands task for lut_decoder block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// load_directed_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-01 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task load_directed;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input              mode;
   input [1:0]        format;
   input [`LOG2N-1:0] n;
   input [1:0]        d_y_n;
   input [1:0]        d_x_n;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   reg   [`CNT_SIZE-1:0] dir_cnt;
   // -----------------------------------------------------

   begin

      dir_cnt[`CNT_SIZE-1]                       = mode    ;
      dir_cnt[`CNT_SIZE-2          :`CNT_SIZE-3] = format  ;
      dir_cnt[2*`D_SIZE+`LOG2N-1   :2*`D_SIZE  ] = tb_n    ;
      dir_cnt[2*`D_SIZE-1          :1*`D_SIZE  ] = tb_d_y_n;
      dir_cnt[1*`D_SIZE-1          :0*`D_SIZE  ] = tb_d_x_n;

      load_operands(dir_cnt);

   end

// *****************************************************************************

endtask

