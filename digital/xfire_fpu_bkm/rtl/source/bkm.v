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
    output reg  [`FSIZE-1:0]  flags,
    output reg                done
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   // Input register
   reg               input_reg_enable;
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
   reg               range_red_enable;
   reg               range_red_start;
   reg               range_red_done;
   wire  [W-1:0]     E_x_0;
   wire  [W-1:0]     E_y_0;
   wire  [W-1:0]     L_x_0;
   wire  [W-1:0]     L_y_0;
   wire  [W-1:0]     a;
   wire  [W-1:0]     b;
   wire  [W-1:0]     k1;
   wire  [W-1:0]     k2;
   wire  [W-1:0]     k3;

   // BKM First step
   reg               bkm_step_1_enable;
   reg               bkm_step_1_start;
   reg               bkm_step_1_done;
   wire  [W-1:0]     X_1;
   wire  [W-1:0]     Y_1;
   wire  [W-1:0]     x_1;
   wire  [W-1:0]     y_1;

   // BKM Steps
   reg               bkm_steps_enable;
   reg               bkm_steps_start;
   reg               bkm_steps_done;
   wire  [W-1:0]     X_N;
   wire  [W-1:0]     Y_N;

   // BKM Range extension
   reg               range_ext_enable;
   reg               range_ext_start;
   reg               range_ext_done;
   wire  [W-1:0]     X_range_ext;
   wire  [W-1:0]     Y_range_ext;

   // Output precision selection
   wire  [W-1:0]     X_prec_out;
   wire  [W-1:0]     Y_prec_out;

   // Output register
   wire              output_reg_enable;
   // -----------------------------------------------------

   // TODO: ENABLES and STARTS/DONE!!
   assign input_reg_enable    = enable;
   assign range_red_enable    = enable;
   assign bkm_step_1_enable   = enable;
   assign bkm_steps_enable    = enable;
   assign range_ext_enable    = enable;
   assign output_reg_enable   = enable;

   //     range_red_start  <-- start
   assign bkm_step_1_start    = range_red_done;
   assign bkm_steps_start     = bkm_step_1_done;
   assign range_ext_start     = bkm_steps_done;
   //     done             <-- range_ext_done

   // -----------------------------------------------------
   // Input register
   // -----------------------------------------------------
   always @(posedge clk or posedge arst) begin
      if (arst) begin
         range_red_start = 1'b0;
         E_x_in_reg = {W{1'b0}};
         E_y_in_reg = {W{1'b0}};
         L_x_in_reg = {W{1'b0}};
         L_y_in_reg = {W{1'b0}};
      end
      else if (srst) begin
         range_red_start = 1'b0;
         E_x_in_reg = {W{1'b0}};
         E_y_in_reg = {W{1'b0}};
         L_x_in_reg = {W{1'b0}};
         L_y_in_reg = {W{1'b0}};
      end
      else if (input_reg_enable) begin
         range_red_start = start;
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
      .a                   (a),
      .b                   (b),
      .k1                  (k1),
      .k2                  (k2),
      .k3                  (k3),
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
      //.flags               (bkm_step_1_flags),
      .done                (bkm_step_1_done)
   );
   // -----------------------------------------------------

   // -----------------------------------------------------
   // BKM Steps
   // -----------------------------------------------------
   // Here you can choose differents architectures for the
   // steps: rolled, unrolled, pipelined or mixed.
   // -----------------------------------------------------
   bkm_steps #(
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
      .a                   (a),
      .b                   (b),
      .k1                  (k1),
      .k2                  (k2),
      .k3                  (k3),
      .X_in                (X_N),
      .Y_in                (Y_N),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (X_range_ext),
      .Y_out               (Y_range_ext),
      //.flags               (range_ext_flags),
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
         done     = 1'b0;
         X_out = {W{1'b0}};
         Y_out = {W{1'b0}};
      end
      else if (srst) begin
         done     = 1'b0;
         X_out = {W{1'b0}};
         Y_out = {W{1'b0}};
      end
      else if (output_reg_enable) begin
         done  = range_ext_done;
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

