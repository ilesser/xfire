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
// Directed test for bkm_steps block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// dir_test.v
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
task dir_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      ena         = 1'b0;
      arst        = 1'b0;
      srst        = 1'b0;
      load        = 1'b0;
      cnt_load    = {`CNT_SIZE{1'b0}};
      cnt_step    = {{`CNT_SIZE-1{1'b0}},1'b1};
      run_clk(1);
      arst        = 1'b1;
      run_clk(1);
      arst        = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      // operands     mode     format               X_in        Y_in        u_in        v_in
      load_directed( `MODE_E, `FORMAT_CMPLX_DW, `WD'd00037, `WD'd00036, `WC'd00037, `WC'd00036);
      load_directed( `MODE_L, `FORMAT_CMPLX_DW, `WD'd00033, `WD'd00039, `WC'd00040, `WC'd00028);

      //run_clk(1);
      //arst        = 1'b1;
      //run_clk(1);
      //arst        = 1'b0;
      //run_clk(1);
      //load        = 1'b1;
      //run_clk(1);
      //load        = 1'b0;

      //repeat(2**00) begin
         //repeat(2**`WD)
            //repeat(2**`WC)
               //repeat(2**`WC)
                  //load_operands(cnt);
      //end
   end

// *****************************************************************************

endtask


