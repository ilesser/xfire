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
// Binary to CSD to binary test
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bin2csd2bin_test.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-18 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
task bin2csd2bin_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      $monitor("Time = %8t \n\ttb_x_bin = %b \n\ttb_y_bin = %b \n\ttb_z_bin = %b \n\tz_bin    = %b\n",
               $time, tb_x_bin, tb_y_bin, tb_z_bin, z_bin);
      $dumpfile("../waves/tb_csd_add_subb_bin2csd2bin_test.vcd");
      $dumpvars();

      load_operands( 1'b0, 1'b0, 4'b0000, 4'b0000, 1'b0, 4'b0000 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b0001, 1'b0, 4'b0001 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b0010, 1'b0, 4'b0010 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b0011, 1'b0, 4'b0011 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b0100, 1'b0, 4'b0100 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b0101, 1'b0, 4'b0101 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b0110, 1'b0, 4'b0110 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b0111, 1'b0, 4'b0111 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b1000, 1'b1, 4'b1000 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b1001, 1'b1, 4'b1001 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b1010, 1'b1, 4'b1010 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b1011, 1'b1, 4'b1011 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b1100, 1'b1, 4'b1100 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b1101, 1'b1, 4'b1101 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b1110, 1'b1, 4'b1110 );
      load_operands( 1'b0, 1'b0, 4'b0000, 4'b1111, 1'b1, 4'b1111 );

      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0000, 1'b0, 4'b0001 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0001, 1'b0, 4'b0010 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0010, 1'b0, 4'b0011 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0011, 1'b0, 4'b0100 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0100, 1'b0, 4'b0101 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0101, 1'b0, 4'b0110 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0110, 1'b0, 4'b0111 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0111, 1'b0, 4'b1000 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b1000, 1'b1, 4'b1001 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b1001, 1'b1, 4'b1010 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b1010, 1'b1, 4'b1011 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b1011, 1'b1, 4'b1100 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b1100, 1'b1, 4'b1101 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b1101, 1'b1, 4'b1110 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b1110, 1'b1, 4'b1111 );
      load_operands( 1'b0, 1'b0, 4'b0001, 4'b1111, 1'b0, 4'b0000 );



      load_operands( 1'b0, 1'b1, 4'b0101, 4'b0011, 1'b0, 4'b0010 );

      load_operands( 1'b1, 1'b1, 4'b0101, 4'b0011, 1'b1, 4'b1000 );

      load_operands( 1'b0, 1'b0, 4'b0001, 4'b0111, 1'b0, 4'b1000 );
   end

// *****************************************************************************

endtask

// *****************************************************************************
// Interface
// *****************************************************************************
task load_operands;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   input             subb_x;
   input             subb_y;
   input [W-1:0]     x;
   input [W-1:0]     y;
   input             c;
   input [W-1:0]     z;

   reg               c_res;
   reg   [W-1:0]     z_res;
   // -----------------------------------------------------

   begin

      tb_subb_x   = subb_x;
      tb_subb_y   = subb_y;
      tb_x_bin    = x;
      tb_y_bin    = y;
      tb_z_bin    = z;
      #1

      if (c_bin != c || z_bin != z) begin
         `ERR_MSG4(\tExpected result: %b %b\n\t\tObtained result: %b %b\t\t, c, z, c_bin, z_bin);
         $display("");
      end

   end

// *****************************************************************************

endtask
