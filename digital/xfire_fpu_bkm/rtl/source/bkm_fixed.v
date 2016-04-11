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
//    - x3        : Real      part of zo output (two's complement, W bits).
//    - y3        : Imaginary part of zo output (two's complement, W bits).
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
//    - 2016-04-04 - ilesser - Connected BKM Pre, Core and Post to Control Logic.
//    - 2016-04-04 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_fixed_defs.vh"

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
    input   wire                 clk,
    input   wire                 arst,
    input   wire                 srst,
    input   wire                 enable,
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input   wire                 start,
    input   wire  [1:0]          format,
    input   wire  [`OPSIZE-1:0]  op,
    input   reg   [W-1:0]        x1,
    input   reg   [W-1:0]        y1,
    input   reg   [W-1:0]        x2,
    input   reg   [W-1:0]        y2,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  reg   [W-1:0]        x3,
    output  reg   [W-1:0]        y3,
    output  wire  [`FSIZE-1:0]   flags,
    output  wire                 done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // BKM Pre control wires
   wire                 bkm_pre_enable;
   wire                 bkm_pre_start;
   wire  [1:0]          bkm_pre_format;
   wire  [`OPSIZE-1:0]  bkm_pre_op;
   wire                 bkm_pre_done;

   // BKM Core control wires
   wire                 bkm_core_enable;
   wire                 bkm_core_start;
   wire  [1:0]          bkm_core_format;
   wire                 bkm_core_mode;
   wire                 bkm_core_done;
   wire  [`FSIZE-1:0]   bkm_core_flags;

   // BKM Core Signal Path
   wire  [W-1:0]        E_r_in;
   wire  [W-1:0]        E_i_in;
   wire  [W-1:0]        L_r_in;
   wire  [W-1:0]        L_i_in;
   wire  [W-1:0]        E_r_out;
   wire  [W-1:0]        E_i_out;
   wire  [W-1:0]        L_r_out;
   wire  [W-1:0]        L_i_out;

   // BKM Post control wires
   wire                 bkm_post_enable;
   wire                 bkm_post_start;
   wire  [1:0]          bkm_post_format;
   wire                 bkm_post_op;
   wire                 bkm_post_done;
   wire  [`FSIZE-1:0]   bkm_post_flags;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Pre Processign
   // -----------------------------------------------------
   bkm_pre_processing #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bkm_pre_processign (
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
      .x1                  (x1),
      .y1                  (y1),
      .x2                  (x2),
      .y2                  (y2),
      .x3                  (x3),
      .y3                  (y3),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .E_r                 (E_r_in),
      .E_i                 (E_i_in),
      .L_r                 (L_r_in),
      .L_i                 (L_i_in),
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
      .E_r_in              (E_r_in),
      .E_i_in              (E_i_in),
      .L_r_in              (L_r_in),
      .L_i_in              (L_i_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .E_r_out             (E_r_out),
      .E_i_out             (E_i_out),
      .L_r_out             (L_r_out),
      .L_i_out             (L_i_out),
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
      .W                   (W)
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
      .E_r                 (E_r_out),
      .E_i                 (E_i_out),
      .L_r                 (L_r_out),
      .L_i                 (L_i_out),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x                   (x3),
      .y                   (y3),
      .flags               (bkm_post_flags),
      .done                (bkm_post_done)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Fixed Control Logic
   // -----------------------------------------------------
   bkm_fixed_control_logic
   bkm_fixed_control_logic (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      // From outer world
      .start               (start),
      .format              (format),
      .op                  (op),

      // From BKM Pre
      .bkm_pre_done        (bkm_pre_done),

      // From BKM Core
      .bkm_core_done       (bkm_core_done),
      .bkm_core_flags      (bkm_core_flags),

      // From BKM Post
      .bkm_post_done       (bkm_post_done),
      .bkm_post_flags      (bkm_post_flags),

    // ----------------------------------
    // Data outputs
    // ----------------------------------
      // To BKM Pre
      .bkm_pre_enable      (bkm_pre_enable),
      .bkm_pre_start       (bkm_pre_start),
      .bkm_pre_format      (bkm_pre_format),
      .bkm_pre_op          (bkm_pre_op),

      // To BKM Core
      .bkm_core_enable      (bkm_core_enable),
      .bkm_core_start       (bkm_core_start),
      .bkm_core_format      (bkm_core_format),
      .bkm_core_mode        (bkm_core_mode),

      // To BKM Post
      .bkm_post_enable      (bkm_post_enable),
      .bkm_post_start       (bkm_post_start),
      .bkm_post_format      (bkm_post_format),
      .bkm_post_op          (bkm_post_op),

      // To outer world
      .flags               (flags),
      .done                (done)
   );
   // -----------------------------------------------------


// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   //XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

