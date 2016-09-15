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
// Get min and max value of a real variable
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// min_max.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-14 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "/home/ilesser/simlib/simlib_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module min_max (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input wire               clk,
   input wire               arst,
   input wire               srst,
   input wire               enable,
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input wire               start,
   input wire               done,
   input real               tb,
   input real               res,
   input real               max_abs_delta,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   output wire               war,
   output wire               err,
   output real               delta,
   output real               min_delta,
   output real               max_delta
   );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   assign delta = abs(tb - res);
   assign war   = tb != res;
   assign err   = abs(delta) > max_abs_delta;

   always @(posedge clk or posedge arst) begin
      if (arst==1'b1) begin
         max_delta <= 0.0;
         min_delta <= 0.0;
      end
      else begin
         if (srst) begin
            max_delta <= 0.0;
            min_delta <= 0.0;
         end
         else if (enable&done==1'b1) begin
            if ( delta > max_delta )
               max_delta <= delta;
            else
               max_delta <= max_delta;

            if ( delta < min_delta )
               min_delta <= delta;
            else
               min_delta <= min_delta;
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


