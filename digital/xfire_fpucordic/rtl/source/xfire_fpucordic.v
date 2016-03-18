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
// xfire_fpucordic.v
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
//    - format    : Format code (logic, 2 bits). (00) int, (01) long, (10) float, (11) double.
//    - op        : Operation code (logic, 5 bits).
//    - rx        : Register X input variable (two's complement, W bits).
//    - ry        : Register Y input variable (two's complement, W bits).
//
//  Data outputs:
//    - rz        : Register Z output result (two's complement, W bits).
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
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-03-15 - ilesser   - Translated cordic_float VHDL into xfire_fpucordic Verilog
//    - 2016-03-02 - pdk_admin - Original version.
//
// -----------------------------------------------------------------------------

`include "xfire_fpucordic.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module xfire_fpucordic #(
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
    input reg  [W-1:0]        rx,
    input reg  [W-1:0]        ry,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output reg [W-1:0]        rz,
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
   // Constants defined in xfire_fpucordic.vh
   //constant E_SIZE_S:   integer := 8;
   //constant F_SIZE_S:   integer := 23;
   //constant E_SIZE_D:   integer := 11;
   //constant F_SIZE_D:   integer := 52;

   reg               start_reg;
   reg   [1:0]       format_reg;
   reg   [OPSIZE-1]  op_reg;

   wire  [FSIZE-1:0] cor_flags;

   wire  [1:0]       cp_xy;

   wire              f_z; // TODO f_z is of type range_t

   wire              cor_start,
                     cor_done,
                     cor_ov,
                     cor_zero,
                     cor_in_sel,
                     mapped_out,
                     signed_out,
                     format_64;

   // Variables for:    RX       |     RY       |     RZ
   //                --------------------------------------
   wire  [W-1:0]     xi_muxed,      yi_muxed,      zi_muxed,
                     xo_muxed,      yo_muxed,      zo_muxed;

   wire  [W-1:0]     rx_reg,        ry_reg,        rz_reg,
                     rx_fix,        ry_fix,        rz_fix,
                     rx_cor,        ry_cor,        rz_cor,
                     rx_map_i,      ry_map_i,
                     rx_map_o,      ry_map_o,
                                                   rz_flo,
                                                   rz_mux,
                                                   rz_map;

   wire  [5:0]       dec_size_x,    dec_size_y,    dec_size_z,
                                                   dec_size_z_32,
                                                   dec_size_z_64;

   wire              tc_x_done,     tc_y_done,     tc_z_done,
                     inf_x,         inf_y,         inf_z,
                     nan_x,         nan_y,         nan_z,
                     ov32_x,        ov32_y,        ov32_z,
                     ov64_x,        ov64_y,        ov64_z,
                     cp_x,          cp_y,
                     mapped_in_x,   mapped_in_y,
                     tc_i_x_start,  tc_i_y_start,  tc_z_start;


   // -----------------------------------------------------

   always @(posedge clk or posedge arst) begin
      if (arst) begin
         XXXXX
      end
      else if (srst) begin
         XXXXX
      end
      else if (enable) begin
         XXXXX
      end
   end

   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // MUX: mapper's input selector
   always @* begin
      if ( cor_in_sel == 1'b1 ) begin
         rx_map_i = rx_fix;
         ry_map_i = ry_fix;
      end else begin
         rx_map_i = rx_reg;
         ry_map_i = ry_reg;
      end
   end

   // MUX selector de la entrada X del nucleo del cordic
   always @* begin
      if ( mapped_in_x == 1'b1 ) begin
         rx_cor = rx_map_o;
      end else begin
         rx_cor = rx_map_i;
      end
   end

   // MUX selector de la entrada Y del nucleo del cordic
   always @* begin
      if ( mapped_in_y == 1'b1 ) begin
         ry_cor = ry_map_o;
      end else begin
         ry_cor = ry_map_i;
      end
   end

   // MUX selector de la salida del nucleo del cordic
   always @* begin
      if ( mapped_out == 1'b1 ) begin
         rz_fix = rz_map;
      end else begin
         rz_fix = rz_cor;
      end
   end

   // MUX selector de la cantidad de parte entera para los conversores

   // Entrada X
   always @* begin
      if ( mapped_in_x == 1'b1 ) begin
         if ( format_64 == 1'b1 ) begin
            dec_size_x = DEC_SIZE_F180_64;
         end else begin
            dec_size_x = DEC_SIZE_F180_32;
         end
      end else begin
         if ( format_64 == 1'b1 ) begin
            dec_size_x = DEC_SIZE_F1_64;
         end else begin
            dec_size_x = DEC_SIZE_F1_32;
         end
      end
   end

   // Entrada Y
   always @* begin
      if ( mapped_in_y == 1'b1 ) begin
         if ( format_64 == 1'b1 ) begin
            dec_size_y = DEC_SIZE_F180_64;
         end else begin
            dec_size_y = DEC_SIZE_F180_32;
         end
      end else begin
         if ( format_64 == 1'b1 ) begin
            dec_size_y = DEC_SIZE_F1_64;
         end else begin
            dec_size_x = DEC_SIZE_F1_32;
         end
      end
   end

   // Salida
   always @* begin
      case(F_z)
         RANGE_1:    dec_size_z_64 = DEC_SIZE_F1_64;
                     dec_size_z_32 = DEC_SIZE_F1_32;
         RANGE_2:    dec_size_z_64 = DEC_SIZE_F2_64;
                     dec_size_z_32 = DEC_SIZE_F2_32;
         RANGE_4:    dec_size_z_64 = DEC_SIZE_F4_64;
                     dec_size_z_32 = DEC_SIZE_F4_32;
         RANGE_180:  dec_size_z_64 = DEC_SIZE_F180_64;
                     dec_size_z_32 = DEC_SIZE_F180_32;
         default:    dec_size_z_64 = {W{1'b0}};
                     dec_size_z_32 = {W{1'b0}};
      endcase
   end

   always @* begin
      if ( format_64 == 1'b1 ) begin
         dec_size_z = dec_size_z_64;
      end else begin
         dec_size_z = dec_size_z_32;
      end
   end

// MUX selector RZ_MUX
   always @* begin
      if ( cor_in_sel == 1'b1 ) begin
         rz_mux = rz_flo;
      end else begin
         rz_mux = rz_fix;
      end
   end

   assign cp_xy = {cp_x, cp_y};

// MUX selector de la salida
   always @* begin
      case (cp_xy)
         "11":       rz_o = rx_reg;
         "10":       rz_o = rx_reg;
         "01":       rz_o = ry_reg;
         "00":       rz_o = rz_mux;
         default:    rz_o = {W{1'b0}};
      end case;
   end
   // -----------------------------------------------------

   // -----------------------------------------------------
   // Modules instantiation
   // -----------------------------------------------------

   // This is the blababalbaba
   top_register_i #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .OPSIZE              (OPSIZE)
   ) in_register_0 (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk_i               (clk_i),
      .start_i             (start_i),
      .arst_i              (arst_i),
      .srst_i              (srst_i),
      .ena_i               (ena_i),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .format_i            (format_i),
      .op_i                (op_i),
      .rx_i                (rx_i),
      .ry_i                (ry_i),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .start_reg           (start_reg),
      .format_reg          (format_reg),
      .op_reg              (op_reg),
      .rx_reg              (rx_reg),
      .ry_reg              (ry_reg)
   );

   // This is the blababalbaba
   cordic_float_logic logic_0 (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk_i               (clk_i),
      .rst_i               (arst_i),
      .ena_i               (ena_i),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start_i             (start_reg),
      .clear_i             (start_i),
      .format_i            (format_reg),
      .tc_x_done           (tc_x_done),
      .tc_y_done           (tc_y_done),
      .tc_z_done           (tc_z_done),
      .inf_x               (inf_x),
      .nan_x               (nan_x),
      .ov32_x              (ov32_x),
      .ov64_x              (ov64_x),
      .inf_y               (inf_y),
      .nan_y               (nan_y),
      .ov32_y              (ov32_y),
      .ov64_y              (ov64_y),
      .cor_done            (cor_done),
      .cor_ov              (cor_ov),
      .cor_zero            (cor_zero),
      .op_i                (op_reg),
      .format_64           (format_64),
      .tc_i_x_start        (tc_i_x_start),
      .tc_i_y_start        (tc_i_y_start),
      .tc_o_start          (tc_z_start),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .cor_start           (cor_start),
      .cor_in_sel          (cor_in_sel), 
      .mapped_in_x         (mapped_in_x),
      .mapped_in_y         (mapped_in_y),
      .mapped_z            (mapped_out),
      .f_z                 (f_z),
      .S_z                 (signed_out),
      .cpx_o               (cp_x),
      .cpy_o               (cp_y),
      .finish              (done_o),
      .flags_o             (flags_o)
   );

 tc_float_to_fix #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) float_to_fixed_X (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk_i               (clk_i),
      .rst_i               (srst_i),
      .ena_i               (ena_i),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x_i                 (rx_reg),
      .in_64               (format_64),
      .clear               (start_i),
      .start               (tc_i_x_start),
      .fixed               ('1'),
      .dec_size            (dec_size_x),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (rx_fix),
      .NaN                 (nan_x),
      .Inf                 (inf_x),
      .ov_32               (ov32_x),
      .ov_64               (ov64_x),
      .zero                (open),
      .done                (tc_x_done)
   );

   tc_float_to_fix #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) float_to_fixed_Y (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk_i               (clk_i),
      .rst_i               (srst_i),
      .ena_i               (ena_i),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x_i                 (ry_reg),
      .in_64               (format_64),
      .clear               (start_i),
      .start               (tc_i_y_start),
      .fixed               ('1'),
      .dec_size            (dec_size_y),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (ry_fix),
      .NaN                 (nan_y),
      .Inf                 (inf_y),
      .ov_32               (ov32_y),
      .ov_64               (ov64_y),
      .zero                (open),
      .done                (tc_y_done)
   );

   mapper_in_32_64 #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) mapper_in_X (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x_i                 (rx_map_i),
      .format_64           (format_64),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x_o                 (rx_map_o)
   );

   mapper_in_32_64 #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) mapper_in_Y (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x_i                 (ry_map_i),
      .format_64           (format_64),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x_o                 (ry_map_o)
   );


   cordic_fixed #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .LOG2W               (LOG2W),
      .N                   (N),
      .LOG2N               (LOG2N
   ) cordic_fixed_0 (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk_i               (clk_i),
      .arst_i              (arst_i),
      .srst_i              (srst_i),
      .ena_i               (ena_i),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .start_i             (cor_start),
      .format_i            (format_64),
      .op_i                (op_reg),
      .rx_i                (rx_cor),
      .ry_i                (ry_cor),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .flags_o             (cor_flags),
      .rz_o                (rz_cor),
      .done_o              (cor_done
   );


   assign cor_ov     = cor_flags(FLO_FLAG_OV_POS);
   assign cor_zero   = cor_flags(FLO_FLAG_ZERO_POS);

   mapper_out_32_64 #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W)
   ) mapper_out_Z (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x_i                 (rz_cor),
      .format_64           (format_64),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .x_o                 (rz_map)
   );

   tc_fix_to_float (#
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (W),
      .E_SIZE_S            (E_SIZE_S),
      .F_SIZE_S            (F_SIZE_S),
      .E_SIZE_D            (E_SIZE_D),
      .F_SIZE_D            (F_SIZE_D)
   ) fixed_to_float_Z (
    // ----------------------------------
    // Clock, reset & enable inputs
    // ----------------------------------
      .clk_i               (clk_i),
      .rst_i               (srst_i),
      .ena_i               (ena_i),
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .x_i                 (rz_fix),
      .format_i_64         (format_64),
      .format_o_64         (format_64),
      .clear               (start_i),
      .start               (tc_z_start),
      .signed_i            (signed_out),
      .fixed               ('1'),
      .dec_size            (dec_size_z),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .X_out               (rz_flo),
      .zero                (open),
      .done                (tc_z_done)
   );
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

