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
// Convert to bin functin for csd2bin block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// convert_to_bin_func.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-03 - ilesser - Changed architecture to automatically generate results.
//    - 2016-09-03 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Function
// *****************************************************************************
function [`W-1:0] convert_to_bin;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   input [`WCSD-1:0] csd;
   reg   [1:0]       csd_digit_bin[0:`W-1];
   real              csd_digit[0:`W-1];
   real              x;
   integer           i, n;
   // -----------------------------------------------------

   begin

      x = 0.0;

      for(i=0; i < `W; i=i+1) begin
         // Get the values for each digit
         csd_digit_bin[i][1] = csd[2*i+1];
         csd_digit_bin[i][0] = csd[2*i];

         if(      csd_digit_bin[i] == `CSD_m1 ) begin
            csd_digit[i] = -1.0;
         end
         else if( csd_digit_bin[i] == `CSD_p1 ) begin
            csd_digit[i] = +1.0;
         end
         else begin
            csd_digit[i] = +0.0;
         end

         // Sum all the digits
         x = x + csd_digit[i] * 2.0**i;
      end

      convert_to_bin = x;
   end

// *****************************************************************************

endfunction

