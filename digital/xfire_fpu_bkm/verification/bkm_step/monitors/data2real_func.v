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
// Function to convert from a BKM data signal to real.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// data2real.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-09-09 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Interface
// *****************************************************************************
function real data2real;
   input [`WD-1:0] x_bin;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   real           x_int, x_frac;
   // -----------------------------------------------------

   x_int       =  $signed(x_bin[`WD-1  :`WD-`WDI]);
   x_frac      =  $itor(  x_bin[`WDF-1 :       0]) / 2.0**`WDF;
   data2real   =  x_int + x_frac;

// *****************************************************************************

endfunction
