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
// Function to convert from a BKM control signal to real.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// control2real.v
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
function real control2real;
   input [`WC-1:0] x_bin;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   real           x_int, x_frac;
   // -----------------------------------------------------

   x_int          =  $signed(x_bin[`WC-1  :`WC-`WCI]);
   x_frac         =  $itor(  x_bin[`WCF-1 :       0]) / 2.0**`WCF;
   control2real   =  x_int + x_frac;

// *****************************************************************************

endfunction

