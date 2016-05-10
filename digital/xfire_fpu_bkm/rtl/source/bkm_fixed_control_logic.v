// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// XXXXX FILL IN HERE XXXXX
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_fixed_control_logic.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - clk       : Posedge active clock input (logic, 1 bit).
//    - arst      : Active high asynchronous reset (logic, 1 bit).
//    - enable    : Active high synchronous enable (logic, 1 bit).
//    - srst      : Active high synchronous reset (logic, 1 bit).
//
//  Data inputs:
//    - start     : Active high start strobe signal (logic, 1 bit).
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for 64 bit, 1 for 32 bit
//                                                 |---> Complex:    0 for complex args, 1 for real args
//    - op        : Operation code (logic, XXX bits).
//    - x1        : Real      part of z1 input (two's complement, W bits).
//    - y1        : Imaginary part of z1 input (two's complement, W bits).
//    - x2        : Real      part of z2 input (two's complement, W bits).
//    - y2        : Imaginary part of z2 input (two's complement, W bits).
//
//  Data outputs:
//    - x3        : Real      part of zo output (two's complement, W bits).
//    - y3        : Imaginary part of zo output (two's complement, W bits).
//    - flags     : Result flags (logic, 4 bits).
//    - done      : Active high done strobe signal (logic, 1 bit).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-10 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_fixed_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_fixed_control_logic
  (
   // ----------------------------------
   // Clock, reset & enable inputs
   // ----------------------------------
   input   reg                  clk,
   input   reg                  arst,
   input   reg                  srst,
   input   reg                  enable,
   // ----------------------------------
   // Data inputs
   // ----------------------------------
   // From outer world
   input   reg                  start,
   input   reg   [1:0]          format,
   input   reg   [`OPSIZE-1:0]  op,
   // From BKM Pre
   input   reg                  bkm_pre_done,
   // From BKM Core
   input   reg                  bkm_core_done,
   input   reg   [`FSIZE-1:0]   bkm_core_flags,
   // From BKM Post
   input   reg                  bkm_post_done,
   input   reg   [`FSIZE-1:0]   bkm_post_flags,
   // ----------------------------------
   // Data outputs
   // ----------------------------------
   // To BKM Pre
   output  reg                  bkm_pre_enable,
   output  reg                  bkm_pre_start,
   output  reg   [1:0]          bkm_pre_format,
   output  reg   [`OPSIZE-1:0]  bkm_pre_op,
   // To BKM Core
   output  reg                  bkm_core_enable,
   output  reg                  bkm_core_start,
   output  reg   [1:0]          bkm_core_format,
   output  reg                  bkm_core_mode,
   // To BKM Post
   output  reg                  bkm_post_enable,
   output  reg                  bkm_post_start,
   output  reg   [1:0]          bkm_post_format,
   output  reg   [`OPSIZE-1:0]  bkm_post_op,
   // To outer world
   output  reg   [`FSIZE-1:0]   flags,
   output  reg                  done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg           dummy;
   // -----------------------------------------------------

   always @(posedge clk or posedge arst) begin
      if (arst) begin
         dummy = 1'b0;
      end
      else if (srst) begin
         dummy = 1'b0;
      end
      else if (enable) begin
         dummy = 1'b1;
      end
   end

// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   //XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

