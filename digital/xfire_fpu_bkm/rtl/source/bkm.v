// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// BKM
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// bkm.v
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
//    - mode      : Operation mode (logic, 1 bit).
//    - format    : Format code (logic, 2 bits).   FF
//                                                 ||--> Precision:  0 for 64 bit, 1 for 32 bit
//                                                 |---> Complex:    0 for complex args, 1 for real args
//    - E_r_in    : Real      part of Exponential input (two's complement, W bits).
//    - E_i_in    : Imaginary part of Exponential input (two's complement, W bits).
//    - L_r_in    : Real      part of Logarithmic input (two's complement, W bits).
//    - L_i_in    : Imaginary part of Logarithmic input (two's complement, W bits).
//
//  Data outputs:
      // TODO: move to Zn zn notation?
//    - E_r_out   : Real      part of Exponential input (two's complement, W bits).
//    - E_i_out   : Imaginary part of Exponential input (two's complement, W bits).
//    - L_r_out   : Real      part of Logarithmic input (two's complement, W bits).
//    - L_i_out   : Imaginary part of Logarithmic input (two's complement, W bits).
//    - Z_r_out   : Real      part of the result (two's complement, W bits).
//    - Z_i_out   : Imaginary part of the result (two's complement, W bits).
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
//    - 2016-04-19 - ilesser - Built architecture scafold.
//    - 2016-04-04 - ilesser - Original version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module bkm #(
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
    input wire                mode,
    input wire [1:0]          format,
    input wire [W-1:0]        E_r_in,
    input wire [W-1:0]        E_i_in,
    input wire [W-1:0]        L_r_in,
    input wire [W-1:0]        L_i_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    // TODO: move to Zn zn notation?
    //output reg  [W-1:0]        E_r_out,
    //output reg  [W-1:0]        E_i_out,
    //output reg  [W-1:0]        L_r_out,
    //output reg  [W-1:0]        L_i_out,
    output reg  [W-1:0]       Z_r_out,
    output reg  [W-1:0]       Z_i_out,
    output wire [`FSIZE-1:0]  flags,
    output wire               done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   reg   [W-1:0]  E_r_in_reg;
   reg   [W-1:0]  E_i_in_reg;
   reg   [W-1:0]  L_r_in_reg;
   reg   [W-1:0]  L_i_in_reg;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Input register
   // -----------------------------------------------------
   always @(posedge clk or posedge arst) begin
      if (arst) begin
         E_r_in_reg = {W{1'b0}};
         E_i_in_reg = {W{1'b0}};
         L_r_in_reg = {W{1'b0}};
         L_i_in_reg = {W{1'b0}};
      end
      else if (srst) begin
         E_r_in_reg = {W{1'b0}};
         E_i_in_reg = {W{1'b0}};
         L_r_in_reg = {W{1'b0}};
         L_i_in_reg = {W{1'b0}};
      end
      else if (enable) begin
         E_r_in_reg = E_r_in;
         E_i_in_reg = E_i_in;
         L_r_in_reg = L_r_in;
         L_i_in_reg = L_i_in;
      end
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Input precision selection
   // -----------------------------------------------------
   input_precision_selection #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) input_precision_selection (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .format              (format),
      .E_r_in              (E_r_in_reg),
      .E_i_in              (E_i_in_reg),
      .L_r_in              (L_r_in_reg),
      .L_i_in              (L_i_in_reg),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .E_r_out             (E_r_prec_in),
      .E_i_out             (E_i_prec_in),
      .L_r_out             (L_r_prec_in),
      .L_i_out             (L_i_prec_in)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Range reduction
   // -----------------------------------------------------
   bkm_range_reduction #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bkm_range_reduction (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (range_red_enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start               (range_red_start),
      .mode                (mode),
      .format              (format),
      .E_r_in              (E_r_prec_in),
      .E_i_in              (E_i_prec_in),
      .L_r_in              (L_r_prec_in),
      .L_i_in              (L_i_prec_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      //TODO: add the different constants for range reduction
      .E_r_out             (E_r_0),
      .E_i_out             (E_i_0),
      .L_r_out             (L_r_0),
      .L_i_out             (L_i_0),
      .done                (range_red_done)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM First step
   // -----------------------------------------------------
   bkm_first_step #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W),
      .N                   (N),
      .LOG2N               (LOG2N)
   ) bkm_first_step (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (bkm_step_1_enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start               (bkm_step_1_start),
      .mode                (mode),
      .format              (format),
      .E_r_in              (E_r_0),
      .E_i_in              (E_i_0),
      .L_r_in              (L_r_0),
      .L_i_in              (L_i_0),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      // TODO: move to Zn zn notation?
      //.E_r_out             (E_r_N),
      //.E_i_out             (E_i_N),
      //.L_r_out             (L_r_N),
      //.L_i_out             (L_i_N),
      .Z_r_out             (Z_r_1),
      .Z_i_out             (Z_i_1),
      .z_r_out             (z_r_1),
      .z_i_out             (z_i_1),
      .flags               (bkm_step_1_flags),
      .done                (bkm_step_1_done)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Steps
   // -----------------------------------------------------
   // Here you can choose differents architectures for the
   // steps: rolled, unrolled, pipelined or mixed.
   // -----------------------------------------------------
   bkm_steps_rolled #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W),
      .N                   (N),
      .LOG2N               (LOG2N)
   ) bkm_steps (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (bkm_steps_enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start               (bkm_steps_start),
      .mode                (mode),
      .format              (format),
      // TODO: move to Zn zn notation?
      //.E_r_in              (E_r_1),
      //.E_i_in              (E_i_1),
      //.L_r_in              (L_r_1),
      //.L_i_in              (L_i_1),
      .Z_r_in              (Z_r_1),
      .Z_i_in              (Z_i_1),
      .z_r_in              (z_r_1),
      .z_i_in              (z_i_1),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      // TODO: move to Zn zn notation?
      //.E_r_out             (E_r_N),
      //.E_i_out             (E_i_N),
      //.L_r_out             (L_r_N),
      //.L_i_out             (L_i_N),
      .Z_r_out             (Z_r_N),
      .Z_i_out             (Z_i_N),
      //.z_r_out             (z_r_N),
      //.z_i_out             (z_i_N),
      .flags               (bkm_steps_flags),
      .done                (bkm_steps_done)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Range extension
   // -----------------------------------------------------
   bkm_range_extension #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) bkm_range_extension (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (range_ext_enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start               (range_ext_start),
      .mode                (mode),
      .format              (format),
      //TODO: add the different constants from range reduction
      // TODO: move to Zn zn notation?
      //.E_r_in              (E_r_prec_in),
      //.E_i_in              (E_i_prec_in),
      //.L_r_in              (L_r_prec_in),
      //.L_i_in              (L_i_prec_in),
      .Z_r_in              (Z_r_N),
      .Z_i_in              (Z_i_N),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      // TODO: move to Zn zn notation?
      //.E_r_out             (E_r_0),
      //.E_i_out             (E_i_0),
      //.L_r_out             (L_r_0),
      //.L_i_out             (L_i_0),
      .Z_r_out             (Z_r_range_ext),
      .Z_i_out             (Z_i_range_ext),
      .flags               (range_ext_flags),
      .done                (range_ext_done)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Output precision selection
   // -----------------------------------------------------
   output_precision_selection #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) output_precision_selection (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .format              (format),
      // TODO: move to Zn zn notation?
      //.E_r_in              (E_r_range_ext),
      //.E_i_in              (E_i_range_ext),
      //.L_r_in              (L_r_range_ext),
      //.L_i_in              (L_i_range_ext),
      .Z_r_in              (Z_r_range_ext),
      .Z_i_in              (Z_i_range_ext),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      // TODO: move to Zn zn notation?
      //.E_r_out             (E_r_prec_out),
      //.E_i_out             (E_i_prec_out),
      //.L_r_out             (L_r_prec_out),
      //.L_i_out             (L_i_prec_out)
      .Z_r_out             (Z_r_prec_out),
      .Z_i_out             (Z_i_prec_out)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Output register
   // -----------------------------------------------------
   always @(posedge clk or posedge arst) begin
      if (arst) begin
      // TODO: move to Zn zn notation?
         //E_r_out = {W{1'b0}};
         //E_i_out = {W{1'b0}};
         //L_r_out = {W{1'b0}};
         //L_i_out = {W{1'b0}};
         Z_r_out = {W{1'b0}};
         Z_i_out = {W{1'b0}};
      end
      else if (srst) begin
         //E_r_out = {W{1'b0}};
         //E_i_out = {W{1'b0}};
         //L_r_out = {W{1'b0}};
         //L_i_out = {W{1'b0}};
         Z_r_out = {W{1'b0}};
         Z_i_out = {W{1'b0}};
      end
      else if (enable) begin
         //E_r_out = E_r_prec_out;
         //E_i_out = E_i_prec_out;
         //L_r_out = L_r_prec_out;
         //L_i_out = L_i_prec_out;
         Z_r_out = Z_r_prec_out;
         Z_i_out = Z_i_prec_out;
      end
   end
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

