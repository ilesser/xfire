// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// BKM Based fixed point mathematical co processor
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm_fixed.v
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
//    - xo        : Real      part of zo output (two's complement, W bits).
//    - yo        : Imaginary part of zo output (two's complement, W bits).
//    - flags     : Result flags (logic, 4 bits).
//    - done      : Active high done strobe signal (logic, 1 bit).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//    - LOG2W     : Logarithm of base 2 of the word width (natural, default: 6).
//    - N         : Number of steps in the cordic algorithm (natural, default: 64).
//    - LOG2N     : Logarithm of base 2 of the number of steps in the cordic
//                  algorithm (natural, default 6).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-04-04 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_fixed.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm_fixed #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64,
    parameter LOG2W  = 6,
    parameter N      = 64,
    parameter LOG2N  = 6
  ) (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
    input wire                clk,
    input wire                arst,
    input wire                srst,
    input wire                enable,
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input wire                start,
    input wire [1:0]          format,
    input wire [OPSIZE-1:0]   op,
    input reg  [W-1:0]        x1,
    input reg  [W-1:0]        y1,
    input reg  [W-1:0]        x2,
    input reg  [W-1:0]        y2,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    input reg  [W-1:0]        xo,
    input reg  [W-1:0]        yo,
    output wire[FLO_FSIZE-1:0]flags,
    output wire               done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   wire [XXXXX-1:0]  XXXXX;
   reg  [XXXXX-1:0]  XXXXX;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Pre Processign
   // -----------------------------------------------------
   bkm_pre_processing #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W),
      .N                   (N),
      .LOG2N               (LOG2N)
   ) bkm_post_processign (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (bkm_pre_enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start               (bkm_pre_start),
      .format              (bkm_pre_format),
      .op                  (bkm_pre_op),
      .E_r_in              (E_r_pre),
      .E_i_in              (E_i_pre),
      .L_r_in              (L_r_pre),
      .L_i_in              (L_i_pre),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .E_r_out             (E_r_0),
      .E_i_out             (E_i_0),
      .L_r_out             (L_r_0),
      .L_i_out             (L_i_0),
      .done                (bkm_pre_done)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Core
   // -----------------------------------------------------
   bkm #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W),
      .N                   (N),
      .LOG2N               (LOG2N)
   ) bkm_core (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (bkm_core_enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start               (bkm_core_start),
      .mode                (bkm_core_mode),
      .format              (bkm_core_format),
      .E_r_in              (E_r_0),
      .E_i_in              (E_i_0),
      .L_r_in              (L_r_0),
      .L_i_in              (L_i_0),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .E_r_out             (E_r_Np1),
      .E_i_out             (E_i_Np1),
      .L_r_out             (L_r_Np1),
      .L_i_out             (L_i_Np1),
      .flags               (bkm_core_flags),
      .done                (bkm_core_done)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Post Processign
   // -----------------------------------------------------
   bkm_post_processing #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W),
      .N                   (N),
      .LOG2N               (LOG2N)
   ) bkm_post_processign (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (bkm_post_enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start               (bkm_post_start),
      .format              (bkm_post_format),
      .op                  (bkm_post_op),
      .E_r_in              (E_r_Np1),
      .E_i_in              (E_i_Np1),
      .L_r_in              (L_r_Np1),
      .L_i_in              (L_i_Np1),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x                   (E_r_post),
      .y                   (E_i_post),
      .flags               (bkm_post_flags),
      .done                (bkm_post_done)
   );


   // -----------------------------------------------------

   // -----------------------------------------------------
   // Control logic
   // -----------------------------------------------------


   // -----------------------------------------------------


// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

