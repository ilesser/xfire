// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Barrel shifter in CSD
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// barrel_shifter_csd.v
//
// -----------------------------------------------------------------------------
// Interface:
// ----------
//
//  Clock, reset & enable inputs:
//    - None
//
//  Data inputs:
//    - dir       : Direction of the shift: 1 for left      0 for right    (logic, 1 bit).
//    - op        : Operation of the shift: 1 for rotation  0 for shifting (logic, 1 bit).
//    - shift_t   : Type of the shift:      1 for aritmetic 0 for logic    (logic, 1 bit).
//    - sel       : Shift selector (unsigned, LOG2W bits).
//    - in        : Input to shift (CSD, 2*W bits).
//
//  Data outputs:
//    - out       : Shifted result (CSD, 2*W bits).
//
//  Parameters:
//    - W         : Word width (natural, default: 64).
//    - LOG2W     : Logarithm of base 2 of the word width (natural, default: 6).
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-19 - ilesser - Deleted op and shift_t inputs.
//    - 2016-07-19 - ilesser - Changed decision logic.
//    - 2016-07-18 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
module barrel_shifter_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
    parameter W      = 64,
    parameter LOG2W  = 6
  ) (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
    input   wire              dir,
    //input   wire              op,
    // TODO: delete shift_t because there is no such thing as logic or arith shift
    //       because the sign is not in the MSB.
    //       In CSD you always add 0 from the left.
    //input   wire              shift_t,
    input   wire  [LOG2W-1:0] sel,
    input   wire  [2*W-1:0]   in,
    // ----------------------------------
    // Data outputs
    // ----------------------------------
    output  wire  [2*W-1:0]   out
  );
// *****************************************************************************

// *****************************************************************************
// Architecture
// *****************************************************************************
// TODO: try adding 1 to the lsb before shifting, that might save us the logic
//       used to decide

   // -----------------------------------------------------
   // Internal signals
   // -----------------------------------------------------
   localparam        K = 1;
   wire              in_odd;
   wire  [1:0]       c;
   wire  [1:0]       in_lsb, shifted_lsb;
   wire  [2*K-1:0]   s, comp, shifted_lsbs;
   reg   [1:0]       in_sel;
   wire  [2*W-1:0]   in_comp;
   wire  [2*W-1:0]   shifted_comp;

   //wire  [2*W-1:0]   shifted;
   wire  [2*W+1:0]   shifted;
   wire  [LOG2W+1:0] sel_ext;
   wire  [2*W+1:0]   in_ext;
   wire  [2*W-1:0]   out_left, out_right;


   wire [W-1:0] eq_m1, eq_m1_mask, or_eq_m1;
   wire         add_m1;
   // -----------------------------------------------------


   // -----------------------------------------------------
   // Combinational logic
   // -----------------------------------------------------

   // -----------------------------------------------------
   // 1 CSD bit adder for truncation
   // -----------------------------------------------------

   //assign comp = `CSD_p1;
   //assign comp = in_lsb;
   //assign comp = in_lsb == `CSD_p1  ?  `CSD_m1  :
                 //in_lsb == `CSD_m1  ?  `CSD_p1  :
                                       //`CSD_0_0 ;
   //add_subb_csd #(
    //// ----------------------------------
    //// Parameters
    //// ----------------------------------
      //.W                   (1)
   //) add_subb_csd (
    //// ----------------------------------
    //// Data inputs
    //// ----------------------------------
      //.subb_a              (`ADD),
      //.subb_b              (`ADD),
      //.a                   (shifted_lsbs),
      //.b                   (comp),
    //// ----------------------------------
    //// Data outputs
    //// ----------------------------------
      //.c                   (c),
      //.s                   (s)
   //);
   // -----------------------------------------------------

   //assign in_comp =  sel      == {LOG2W{1'b0}}  ?  in :  {in[2*W-1:2], s};
                     //in_lsb   == `CSD_m1        ?  shifted_comp   :
                                                   //shifted        ;

   // -----------------------------------------------------
   // Regular barrel shifter
   // -----------------------------------------------------
   barrel_shifter #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (2*W+2),
      .LOG2W               (LOG2W+1+1)
   ) barrel_shifter (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .dir                 (dir),
      //.op                  (op),
      //.shift_t             (shift_t), TODO
      .op                  (`OP_SHIFT),
      .shift_t             (`SHIFT_LOGIC),
      //.sel                 ({sel,1'b0}), // select with 2*sel
      .sel                 (sel_ext), // select with 2*sel
      .in                  (in_ext),
      //.in                  (in),
      //.in                  (in_comp),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .out                 (shifted)
   );
   // -----------------------------------------------------


   // Compensate rotation by adding/subbstracting one LSB

   // LSB of barrel shifter input and output
   //assign in_lsb        = in[1:0];
   //assign shifted_lsb   = shifted[1:0];
   //assign shifted_comp  = {shifted[2*W-1:2], s};
   //assign in_odd        = in_lsb == `CSD_p1 || in_lsb == `CSD_m1;


   //assign out  = sel    == {LOG2W{1'b0}}  ?  shifted        :
                 //in_lsb == `CSD_m1        ?  shifted_comp   :
                                             //shifted        ;




   // This does not depend on n because if n==0 then shifted_lsb == in_lsb
   // The idea is to mantain the lsb == -1 if in_lsb == -1
   //assign in_lsb        = in[1:0];
   //assign shifted_comp  = {shifted[2*W-1:2], `CSD_m1};
   //assign out  = dir    == `DIR_LEFT      ?  shifted        :
                 //in_lsb == `CSD_m1        ?  shifted_comp   :
                                             //shifted        ;

   //always@(*) begin
      //if (sel==0) begin
         //in_sel[1] = 0;
         //in_sel[0] = 0;
      //end
      //else begin
         //in_sel[1] = in[2*sel-1];
         //in_sel[0] = in[2*sel-2];
      //end
   //end
   //always@(*) begin
      //if (dir==`DIR_LEFT) begin
         //out = shifted;
      //end
      //else begin
         //if ( in_sel == `CSD_m1 ) begin
            //out = shifted_comp;
         //end
         //else begin
            //out = shifted;
         //end
      //end
   //end



   add_subb_csd #(
    // ----------------------------------
    // Parameters
    // ----------------------------------
      .W                   (K)
   ) add_subb_csd (
    // ----------------------------------
    // Data inputs
    // ----------------------------------
      .subb_a              (`ADD),
      .subb_b              (`ADD),
      .a                   (shifted_lsbs),
      .b                   (comp),
    // ----------------------------------
    // Data outputs
    // ----------------------------------
      .c                   (c),
      .s                   (s)
   );


   //assign shifted_lsbs = shifted[2*K-1:0];
   //assign shifted_comp  = (shifted[1:0] == `CSD_m1) ? {shifted[2*W-1:2*(K+1)], c, s} : {shifted[2*W-1:2*K], s};
   ////assign comp = {`CSD_0_0, `CSD_0_0, `CSD_m1};
   ////assign comp = {`CSD_0_0, `CSD_m1};
   //assign comp = {{2*K{1'b0}},`CSD_m1};
   //assign in_lsb        = in[1:0];
   //assign shifted_lsb   = shifted[1:0];
   assign in_odd        = in_lsb == `CSD_p1 || in_lsb == `CSD_m1;
   assign or_eq_m1 = eq_m1 & eq_m1_mask;
   assign add_m1   = | or_eq_m1;

   genvar i;
   generate
      for (i=0; i < W; i=i+1) begin

         // check for the csd ith digit to be -1
         assign eq_m1[i]   = in[2*i+1:2*i] == `CSD_m1;

         assign eq_m1_mask[i] = sel < i+1 ? 1'b0 : 1'b1;
         //if (sel < i)
            //assign eq_m1_mask[i] = 1'b1;
         //else
            //assign eq_m1_mask[i] = 1'b0;
      end
   endgenerate

   //assign out  = dir    == `DIR_LEFT      ?  shifted        :
                 //add_m1 == 1'b1           ?  shifted_comp   :
                                             //shifted        ;



   //assign out_right_lsb = shifted[1:0] == `CSD_m1  ?  `CSD_m1  :  shifted[3:2];
   //assign out_right  = {shifted[2*W+1:4], out_right_lsb};

   assign in_ext  = {in, `CSD_0_0};
   assign sel_ext = ({2'b00, sel} + 0) * 2;

   assign out_right  = shifted[1:0] == `CSD_m1  ?  {shifted[2*W+1:4], `CSD_m1}   :
                                                    shifted[2*W+1:2]             ;
   assign out_left   =                              shifted[2*W+1:2]             ;

   assign out        = dir == `DIR_LEFT ?  out_left :  out_right;



   //assign out = shifted;


// *****************************************************************************

// *****************************************************************************
// Assertions and debugging
// *****************************************************************************
`ifdef RTL_DEBUG

   //XXXXX TO FILL IN HERE XXXXX

`endif
// *****************************************************************************

endmodule

