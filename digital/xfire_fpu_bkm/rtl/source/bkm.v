// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Implements the BKM algorithm for the inputs E = E_x + j E_y and L = L_x + j L_y.
// Use mode to determine if you are in E-mode (1'b0) or L-mode (1'b0).
// Use format to determine the format of the inputs/outputs. You can choose
// between 32/64 bit complex or real data.
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
//    - 2016-08-15 - ilesser - Updated parameters to work with W, WD and WC.
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
   // Local parameters
   // La entrada seria  con W=64 y representaria un numero en 11Q53
   //                   con W=32 y representaria un numero en  9Q23
   // TODO: WD necesita dos bits de guarda superiores, uno al multipicar por d_n y otro al acumularlo.
   // TODO: WC tiene q tener una resolucion de 4 bits (??averiguar) en la parte decimal
   //       mas tres bits de guarda por todo el proceso de BKM por lo que seria 14Q4 (12Q4)
   //       (necesita uno mas que WD xq multiplica todo por 2)
   //
   //    Upper guard bits are to avoid overflow.
   //    Lower guard bits are to preserve the data value after dividing by 2^n
   //
   //                   +-----------+-----------+--------+
   //                   |  Upper    |  Word     |  Lower |
   //                   |  guard    |  size     |  guard |
   //                   |  bits     |           |  bits  |
   //                   +-----------+-----------+--------+
   localparam  WD       = 2         +  W        +  LOG2W ;
   localparam  LOG2WD   = 1         +  LOG2W    +  0     ;  // TODO the lower guard bits are harcodfed???
   localparam  WC       = 3         +  W/4      +  1     ;
   localparam  LOG2WC   = 1         +  LOG2W-2  +  0     ;
   //                   +-----------+-----------+--------+

   // Input register
   reg                  input_reg_enable;
   reg                  mode_latched;
   reg   [1:0]          format_latched;
   reg   [W-1:0]        E_x_in_latched;
   reg   [W-1:0]        E_y_in_latched;
   reg   [W-1:0]        L_x_in_latched;
   reg   [W-1:0]        L_y_in_latched;

   // Input precision selection
   wire  [W-1:0]        E_x_prec_in;
   wire  [W-1:0]        E_y_prec_in;
   wire  [W-1:0]        L_x_prec_in;
   wire  [W-1:0]        L_y_prec_in;

   // BKM Range reduction
   // entra en W y sale en WD
   reg                  range_red_enable;
   reg                  range_red_start;
   wire                 range_red_done;
   wire  [WD-1:0]       E_x_0;
   wire  [WD-1:0]       E_y_0;
   wire  [WD-1:0]       L_x_0;
   wire  [WD-1:0]       L_y_0;
   wire  [WD-1:0]       a;
   wire  [WD-1:0]       b;
   wire  [WD-1:0]       k1;
   wire  [WD-1:0]       k2;
   wire  [WD-1:0]       k3;

   // BKM Pre step
   reg                  bkm_pre_step_enable;
   reg                  bkm_pre_step_start;
   wire                 bkm_pre_step_done;
   wire  [WD-1:0]       X_1;
   wire  [WD-1:0]       Y_1;
   wire  [WC-1:0]       u_1;
   wire  [WC-1:0]       v_1;

   // BKM Steps
   reg                  bkm_steps_enable;
   reg                  bkm_steps_start;
   wire                 bkm_steps_done;
   wire  [`FSIZE-1:0]   bkm_steps_flags;
   wire  [WD-1:0]       X_N;
   wire  [WD-1:0]       Y_N;
   wire  [WC-1:0]       u_N;
   wire  [WC-1:0]       v_N;

   // BKM Range extension
   // entra en WD y sale en W
   reg                  range_ext_enable;
   reg                  range_ext_start;
   wire                 range_ext_done;
   wire  [`FSIZE-1:0]   range_ext_flags;
   wire  [W-1:0]        X_range_ext;
   wire  [W-1:0]        Y_range_ext;

   // Output precision selection
   wire  [W-1:0]        X_prec_out;
   wire  [W-1:0]        Y_prec_out;

   // Output register
   reg                  output_reg_enable;
   // -----------------------------------------------------

   // TODO: ENABLES and STARTS/DONE!!
   always @(*) begin
      input_reg_enable    = enable;
      range_red_enable    = enable;
      bkm_pre_step_enable = enable;
      bkm_steps_enable    = enable;
      range_ext_enable    = enable;
      output_reg_enable   = enable;

      //     range_red_start  <-- start
      bkm_pre_step_start  = range_red_done;
      bkm_steps_start     = bkm_pre_step_done;
      range_ext_start     = bkm_steps_done;
      //     done             <-- range_ext_done
   end

   // -----------------------------------------------------
   // Input register
   // -----------------------------------------------------
   always @(posedge clk or posedge arst) begin
      if (arst) begin
         range_red_start   <= 1'b0;
         mode_latched      <= 1'b0;
         format_latched    <= 2'b00;
         E_x_in_latched    <= {W{1'b0}};
         E_y_in_latched    <= {W{1'b0}};
         L_x_in_latched    <= {W{1'b0}};
         L_y_in_latched    <= {W{1'b0}};
      end
      else if (srst) begin
         range_red_start   <= 1'b0;
         mode_latched      <= 1'b0;
         format_latched    <= 2'b00;
         E_x_in_latched    <= {W{1'b0}};
         E_y_in_latched    <= {W{1'b0}};
         L_x_in_latched    <= {W{1'b0}};
         L_y_in_latched    <= {W{1'b0}};
      end
      else if (input_reg_enable) begin
         range_red_start   <= start;
         mode_latched      <= mode;
         format_latched    <= format;
         E_x_in_latched    <= E_x_in;
         E_y_in_latched    <= E_y_in;
         L_x_in_latched    <= L_x_in;
         L_y_in_latched    <= L_y_in;
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
      .format              (format_latched),
      .E_x_in              (E_x_in_latched),
      .E_y_in              (E_y_in_latched),
      .L_x_in              (L_x_in_latched),
      .L_y_in              (L_y_in_latched),
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
      .W                   (W),
      .WD                  (WD)
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
      .mode                (mode_latched),
      .format              (format_latched),
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
   // BKM Pre step
   // -----------------------------------------------------
   bkm_pre_step #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .WD                  (WD),
      .WC                  (WC)
   ) bkm_pre_step (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk                 (clk),
      .arst                (arst),
      .srst                (srst),
      .enable              (bkm_pre_step_enable),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start               (bkm_pre_step_start),
      .mode                (mode_latched),
      .format              (format_latched),
      .E_x_in              (E_x_0),
      .E_y_in              (E_y_0),
      .L_x_in              (L_x_0),
      .L_y_in              (L_y_0),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (X_1),
      .Y_out               (Y_1),
      .u_out               (u_1),
      .v_out               (v_1),
      .done                (bkm_pre_step_done)
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
      .N                   (N),
      .LOG2N               (LOG2N),
      .WD                  (WD),
      .LOG2WD              (LOG2WD),
      .WC                  (WC),
      .LOG2WC              (LOG2WC)
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
      .mode                (mode_latched),
      .format              (format_latched),
      .X_in                (X_1),
      .Y_in                (Y_1),
      .u_in                (u_1),
      .v_in                (v_1),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (X_N),
      .Y_out               (Y_N),
      .u_out               (u_N),
      .v_out               (v_N),
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
      .WD                  (WD),
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
      .mode                (mode_latched),
      .format              (format_latched),
      .a                   (a),
      .b                   (b),
      .k1                  (k1),
      .k2                  (k2),
      .k3                  (k3),
      .X_in                (X_N),
      .Y_in                (Y_N),
      .flags_in            (bkm_steps_flags),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (X_range_ext),
      .Y_out               (Y_range_ext),
      .flags_out           (range_ext_flags),
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
         X_out <= {W{1'b0}};
         Y_out <= {W{1'b0}};
         flags <= {`FSIZE{1'b0}};
         done  <= 1'b0;
      end
      else if (srst) begin
         X_out <= {W{1'b0}};
         Y_out <= {W{1'b0}};
         flags <= {`FSIZE{1'b0}};
         done  <= 1'b0;
      end
      else if (output_reg_enable) begin
         X_out <= X_prec_out;
         Y_out <= Y_prec_out;
         flags <= range_ext_flags;
         done  <= range_ext_done;
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

