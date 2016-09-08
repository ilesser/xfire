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
// Gets the decision variable for a bkm step.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// get_d_task.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-03 - ilesser - Initial version using real number modeling.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task get_d_n;

      // ----------------------------------
      // Data inputs
      // ----------------------------------
      input             mode;
      input    real     u, v;
      // ----------------------------------

      // ----------------------------------
      // Data outputs
      // ----------------------------------
      output   real     d_x, d_y;
      output   [1:0]    d_x_bin, d_y_bin;
      // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------


   begin
      if (mode==`MODE_E) begin
         // Calculate d_n for E mode
         d_x      =  u <= -0.625    ? -1     :
                     u >=  0.375    ?  1     :
                                       0     ;
         d_y      =  v <= -0.8125   ? -1     :
                     v >=  0.8125   ?  1     :
                                       0     ;
         d_x_bin  =  u <= -0.625    ? 2'b11  :
                     u >=  0.375    ? 2'b01  :
                                      2'b00  ;
         d_y_bin  =  v <= -0.8125   ? 2'b11  :
                     v >=  0.8125   ? 2'b01  :
                                      2'b00  ;
      end
      else if ( mode == `MODE_L ) begin
         // Calculate d_n for L mode
         d_x      =  u <= -0.500    ? -1     :
                     u >=  0.500    ?  1     :
                                       0     ;
         d_y      =  v <= -0.500    ? -1     :
                     v >=  0.500    ?  1     :
                                       0     ;
         d_x_bin  =  u <= -0.500    ? 2'b11  :
                     u >=  0.500    ? 2'b01  :
                                      2'b00  ;
         d_y_bin  =  v <= -0.500    ? 2'b11  :
                     v >=  0.500    ? 2'b01  :
                                      2'b00  ;
      end
   end

// *****************************************************************************

endtask

