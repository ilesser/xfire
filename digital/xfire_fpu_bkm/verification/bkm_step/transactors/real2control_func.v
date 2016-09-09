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
// Function to convert from real to BKM control signal.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// real2control.v
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
function [`WC-1:0] real2control;
   input real x_real;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   wire  [`WCI-1:0]  x_int;
   wire  [`WCF-1:0]  x_frac;
   // -----------------------------------------------------

   x_int          = $rtoi( x_real );
   x_frac         = $rtoi( (x_real - x_int) * 2.0**(`WCF) );
   real2control   =  {x_int, x_frac};

// *****************************************************************************

endfunction
