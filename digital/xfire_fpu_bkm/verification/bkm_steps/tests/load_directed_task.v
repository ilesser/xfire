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
// Load directed operands task for bkm_steps block.
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
//    - 2016-08-15 - ilesser - Initial version.
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
   input [`WD-1:0]    X_in;
   input [`WD-1:0]    Y_in;
   input [`WC-1:0]    u_in;
   input [`WC-1:0]    v_in;
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

      dir_cnt[`CNT_SIZE-1                 ]  =  mode  ;
      dir_cnt[`CNT_SIZE-2     :`CNT_SIZE-3]  =  format;
      dir_cnt[2*`WC+2*`WD-1   :2*`WC+1*`WD]  =  X_in  ;
      dir_cnt[2*`WC+1*`WD-1   :2*`WC+0*`WD]  =  Y_in  ;
      dir_cnt[2*`WC+0*`WD-1   :1*`WC+0*`WD]  =  u_in  ;
      dir_cnt[1*`WC+0*`WD-1   :0*`WC+0*`WD]  =  v_in  ;

      load_operands(dir_cnt);

   end

// *****************************************************************************

endtask

