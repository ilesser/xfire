// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Definitions for bkm.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_defs.vh
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-13 - ilesser - Renamed FORMAT defs 32/64 to W/DW.
//    - 2016-07-10 - ilesser - Added ADD/SUBB for adders.
//    - 2016-04-10 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

// *****************************************************************************
// Definitions
// *****************************************************************************

// --------------------------------------------------------
// Define size for flags
// --------------------------------------------------------
`define FSIZE     4
// --------------------------------------------------------

// --------------------------------------------------------
// Define operation modes
// --------------------------------------------------------
`define MODE_E 1'b0
`define MODE_L 1'b1
// --------------------------------------------------------

// --------------------------------------------------------
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for word size args,   1 for double word size args
//                                                 |---> Complex:    0 for real args,        1 for complex args
// --------------------------------------------------------

`define FORMAT_REAL_W   2'b00
`define FORMAT_REAL_DW  2'b01
`define FORMAT_CMPLX_W  2'b10
`define FORMAT_CMPLX_DW 2'b11
// --------------------------------------------------------

// --------------------------------------------------------
// Barrel shifter
// --------------------------------------------------------
`define DIR_RIGHT    1'b0
`define DIR_LEFT     1'b1

`define OP_SHIFT     1'b0
`define OP_ROT       1'b1

`define SHIFT_LOGIC  1'b0
`define SHIFT_ARITH  1'b1
// --------------------------------------------------------

// --------------------------------------------------------
// d_n index in one's complement
// --------------------------------------------------------
`define D_SIGN      1
`define D_DATA      0
// --------------------------------------------------------

// --------------------------------------------------------
// CSD values
// --------------------------------------------------------
`define CSD_0_0   2'b00
`define CSD_0_1   2'b11
`define CSD_p1    2'b01
`define CSD_m1    2'b10
// --------------------------------------------------------

// --------------------------------------------------------
// ADD/SUB
// --------------------------------------------------------
`define ADD       1'b0
`define SUBB      1'b1
// --------------------------------------------------------

// *****************************************************************************
