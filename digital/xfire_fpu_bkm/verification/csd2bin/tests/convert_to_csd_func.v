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
// Convert to csd functin for bin2csd block.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// convert_to_csd_func.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-06-12 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Function
// *****************************************************************************
function [`W2-1:0] convert_to_csd;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   input [`W-1:0]    x;
   reg   [`W2-1:0]   csd;
   reg   [1:0]       di, dip1;
   integer           i,j,k;
   integer           start_ones, end_ones;
   // -----------------------------------------------------

   begin

      // Convert to signed digit representation
      for(i=0; i < `W; i=i+1) begin
         csd[2*i+1]   = 1'b0;
         csd[2*i]     = x[i];
      end

      // TODO: Routine is working but has errors when the MSBs bits are 10 in binary


      i=0;
      while (i < `W-1) begin  // I dont need to change the MSB

         // get the ith csd digit
         //di    = csd[(2*i)+1:2*i];
         di[1] = csd[2*i+1];
         di[0] = csd[2*i];

         // If current one is 0 continue
         if (di == `CSD_0) begin
            i = i+1;
            continue;
         end
         else begin

            // get the (i+1)th csd digit
            //dip1  = csd[2*i+3:2*i+2];
            dip1  = csd[2*i+3];
            dip1  = csd[2*i+2];

            // If next one is 0 continue
            if (dip1 == `CSD_0) begin
               i = i+2;
               continue;
            end
            else begin

               start_ones = i;
               while (di != `CSD_0) begin
                  i = i+1;
                  //di    = csd[(2*i)+1:2*i];
                  di[1] = csd[2*i+1];
                  di[0] = csd[2*i];
               end
               end_ones = i;

               // put a -1 in position 2*start_ones
               j = 2*start_ones;
               //csd[j+1:j]     = `CSD_m1;
               csd[j+1] = 1'b1;
               csd[j]   = 1'b0;

               // put a +1 in position 2*end_ones
               k = 2*end_ones;
               //csd[k+1:k]     = `CSD_p1;
               csd[k+1] = 1'b0;
               csd[k]   = 1'b1;

               // put a 00 in between
               //csd[k-1:j+2]   = `CSD_0;
               for (j = 2*start_ones+2; j < k; j = j+2) begin
                  //csd[j+1:j] = `CSD_0;
                  csd[j+1] = 1'b0;
                  csd[j]   = 1'b0;
               end

            end // if (dip1 == `CSD_0)

         end // if (di == `CSD_0) begin

      end // while (i<`W)



      convert_to_csd = csd;
   end

// *****************************************************************************

endfunction

