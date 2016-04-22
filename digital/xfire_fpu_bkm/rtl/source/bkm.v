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
//    - E_x_in    : Real      part of Exponential input (two's complement, W bits).
//    - E_y_in    : Imaginary part of Exponential input (two's complement, W bits).
//    - L_x_in    : Real      part of Logarithmic input (two's complement, W bits).
//    - L_y_in    : Imaginary part of Logarithmic input (two's complement, W bits).
//
//  Data outputs:
//    - X_out     : Real      part of the result (two's complement, W bits).
//    - Y_out     : Imaginary part of the result (two's complement, W bits).
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
    input wire [W-1:0]        E_x_in,
    input wire [W-1:0]        E_y_in,
    input wire [W-1:0]        L_x_in,
    input wire [W-1:0]        L_y_in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg  [W-1:0]       X_out,
    output reg  [W-1:0]       Y_out,
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
   // Input register
   reg   [W-1:0]     E_x_in_reg;
   reg   [W-1:0]     E_y_in_reg;
   reg   [W-1:0]     L_x_in_reg;
   reg   [W-1:0]     L_y_in_reg;

   // Input precision selection
   wire  [W-1:0]     E_x_prec_in;
   wire  [W-1:0]     E_y_prec_in;
   wire  [W-1:0]     L_x_prec_in;
   wire  [W-1:0]     L_y_prec_in;

   // BKM Range reduction
   wire  [W-1:0]     E_x_0;
   wire  [W-1:0]     E_y_0;
   wire  [W-1:0]     L_x_0;
   wire  [W-1:0]     L_y_0;

   // BKM First step
   wire  [2*W-1:0]   X_1;
   wire  [2*W-1:0]   Y_1;
   wire  [W-1:0]     x_1;
   wire  [W-1:0]     y_1;

   // BKM Steps
   wire  [2*W-1:0]   X_N;
   wire  [2*W-1:0]   Y_N;

   // BKM Range extension
   wire  [W-1:0]     X_range_ext;
   wire  [W-1:0]     Y_range_ext;

   // BKM Range extension
   wire  [W-1:0]     X_prec_out;
   wire  [W-1:0]     Y_prec_out;
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Input register
   // -----------------------------------------------------
   always @(posedge clk or posedge arst) begin
      if (arst) begin
         E_x_in_reg = {W{1'b0}};
         E_y_in_reg = {W{1'b0}};
         L_x_in_reg = {W{1'b0}};
         L_y_in_reg = {W{1'b0}};
      end
      else if (srst) begin
         E_x_in_reg = {W{1'b0}};
         E_y_in_reg = {W{1'b0}};
         L_x_in_reg = {W{1'b0}};
         L_y_in_reg = {W{1'b0}};
      end
      else if (enable_input__reg) begin
         E_x_in_reg = E_x_in;
         E_y_in_reg = E_y_in;
         L_x_in_reg = L_x_in;
         L_y_in_reg = L_y_in;
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
      .E_x_in              (E_x_in_reg),
      .E_y_in              (E_y_in_reg),
      .L_x_in              (L_x_in_reg),
      .L_y_in              (L_y_in_reg),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .E_x_out             (E_x_prec_in),
      .E_y_out             (E_y_prec_in),
      .L_x_out             (L_x_prec_in),
      .L_y_out             (L_y_prec_in)
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
      .E_x_in              (E_x_prec_in),
      .E_y_in              (E_y_prec_in),
      .L_x_in              (L_x_prec_in),
      .L_y_in              (L_y_prec_in),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .E_x_out             (E_x_0),
      .E_y_out             (E_y_0),
      .L_x_out             (L_x_0),
      .L_y_out             (L_y_0),
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
      .E_x_in              (E_x_0),
      .E_y_in              (E_y_0),
      .L_x_in              (L_x_0),
      .L_y_in              (L_y_0),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (X_1),
      .Y_out               (Y_1),
      .x_out               (x_1),
      .y_out               (y_1),
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
      .X_in                (X_1),
      .Y_in                (Y_1),
      .x_in                (x_1),
      .y_in                (y_1),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (X_N),
      .Y_out               (Y_N),
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
      .X_in                (X_N),
      .Y_in                (Y_N),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (X_range_ext),
      .Y_out               (Y_range_ext),
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
      .X_in                (X_range_ext),
      .Y_in                (Y_range_ext),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (X_prec_out),
      .Y_out               (Y_prec_out)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Output register
   // -----------------------------------------------------
   always @(posedge clk or posedge arst) begin
      if (arst) begin
         X_out = {W{1'b0}};
         Y_out = {W{1'b0}};
      end
      else if (srst) begin
         X_out = {W{1'b0}};
         Y_out = {W{1'b0}};
      end
      else if (enable_output_reg) begin
         X_out = X_prec_out;
         Y_out = Y_prec_out;
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

