// -----------------------------------------------------------------------------
//  Copyright (c) 2016 Microelectronics Lab. FIUBA.
//  All Rights Reserved.
//
//  The information contained in this file is confidential and proprietary.
//  Any reproduction, use or disclosure, in whole or in part, of this
//  program, including any attempt to obtain a human-readable version of this
//  program, without the express, prior written consent of Microelectronics Lab.
//  FIUBA is strictly prohibited.
//
// -----------------------------------------------------------------------------
// Description:
// ------------
//
// Sequential test for barrel shifter CSD.
//
// -----------------------------------------------------------------------------
// File name:
// ----------
//
// seq_test.v
//
// -----------------------------------------------------------------------------
// History:
// --------
//
//    - 2016-07-18 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------

`include "bkm_defs.vh"

// *****************************************************************************
// Interface
// *****************************************************************************
task seq_test;
// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      ena         = 1'b0;
      rst         = 1'b0;
      run_clk(1);
      rst         = 1'b1;
      run_clk(1);
      rst         = 1'b0;
      run_clk(1);
      ena         = 1'b1;

      repeat(2**(`CNT_SIZE))
         load_operands(cnt);

   end

// *****************************************************************************

endtask

// *****************************************************************************
// Interface
// *****************************************************************************
task load_operands;

   // ----------------------------------
   // Data inputs
   // ----------------------------------
   input [`CNT_SIZE-1:0]   cnt;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   reg   [1:0] lsb;
   // -----------------------------------------------------

   begin

      tb_dir      = cnt[`CNT_SIZE-1];
      //tb_op       = cnt[`W+`LOG2W+1];
      //tb_shift_t  = cnt[`W+`LOG2W];
      tb_sel      = cnt[`W+`LOG2W-1:`W];
      tb_in       = cnt[`W-1:0];

      //tb_dir      = `DIR_RIGHT;
      //tb_op       = `OP_SHIFT;
      //tb_shift_t  = `SHIFT_ARITH;
      //tb_sel      = `LOG2W'd1;
      //tb_in       = `W'd0;

      //case (cnt[`W+`LOG2W+2:`W+`LOG2W])
        ////{`DIR_RIGHT, `OP_SHIFT, `SHIFT_LOGIC}:  tb_out = srl(tb_in, tb_sel);
        //{`DIR_RIGHT, `OP_SHIFT, `SHIFT_LOGIC}:  tb_out = sra(tb_in, tb_sel);
        //{`DIR_RIGHT, `OP_SHIFT, `SHIFT_ARITH}:  tb_out = sra(tb_in, tb_sel);
        //{`DIR_RIGHT, `OP_ROT  , `SHIFT_LOGIC}:  tb_out = ror(tb_in, tb_sel);
        //{`DIR_RIGHT, `OP_ROT  , `SHIFT_ARITH}:  tb_out = ror(tb_in, tb_sel);
        ////{`DIR_LEFT , `OP_SHIFT, `SHIFT_LOGIC}:  tb_out = sll(tb_in, tb_sel);
        //{`DIR_LEFT , `OP_SHIFT, `SHIFT_LOGIC}:  tb_out = sla(tb_in, tb_sel);
        //{`DIR_LEFT , `OP_SHIFT, `SHIFT_ARITH}:  tb_out = sla(tb_in, tb_sel);
        //{`DIR_LEFT , `OP_ROT  , `SHIFT_LOGIC}:  tb_out = rol(tb_in, tb_sel);
        //{`DIR_LEFT , `OP_ROT  , `SHIFT_ARITH}:  tb_out = rol(tb_in, tb_sel);
      //endcase

      case (tb_dir)
         `DIR_RIGHT: tb_out = sra(tb_in, tb_sel);
         `DIR_LEFT : tb_out = sla(tb_in, tb_sel);
      endcase

      lsb = in_csd[1:0];


      run_clk(1);

      if( lsb == `CSD_0_0 || lsb == `CSD_0_1 )
         $display("tb_in=%6d in_csd = %b lsb = %b is EVEN", tb_in, in_csd, lsb);
      else
         $display("tb_in=%6d in_csd = %b lsb = %b is ODD", tb_in, in_csd, lsb);

   end

// *****************************************************************************

endtask


// Rotate left
function [`W-1:0] rol;

   input [`W-1:0] data;
   input [`LOG2W-1:0] sel;

   integer i,n;
   reg   [`W-1:0] tmp;

   begin
      n   = sel;
      tmp = data;

      for (i=1; i<=n; i=i+1)
         tmp = {tmp[`W-2:0], tmp[`W-1]};

      rol = tmp;
   end

endfunction

// Rotate right
function [`W-1:0] ror;

   input [`W-1:0] data;
   input [`LOG2W-1:0] sel;

   integer i,n;
   reg   [`W-1:0] tmp;

   begin
      n   = sel;
      tmp = data;

      for (i=1; i<=n; i=i+1)
         tmp = {tmp[0], tmp[`W-1:1]};

      ror = tmp;
   end

endfunction

// Shift right logical
function [`W-1:0] srl;

   input [`W-1:0] data;
   input [`LOG2W-1:0] sel;

   integer i,n;
   reg   [`W-1:0] tmp;

   begin
      n   = sel;
      tmp = data;

      for (i=1; i<=n; i=i+1)
         tmp = {1'b0, tmp[`W-1:1]};

      srl = tmp;
   end

endfunction

// Shift left logical
function [`W-1:0] sll;

   input [`W-1:0] data;
   input [`LOG2W-1:0] sel;

   integer i,n;
   reg   [`W-1:0] tmp;

   begin
      n   = sel;
      tmp = data;

      for (i=1; i<=n; i=i+1)
         tmp = {tmp[`W-2:0], 1'b0};

      sll = tmp;
   end

endfunction

// Shift right arithmetic
function [`W-1:0] sra;

   input [`W-1:0] data;
   input [`LOG2W-1:0] sel;

   integer i,n;
   reg   [`W-1:0] tmp;

   begin
      n   = sel;
      tmp = data;

      for (i=1; i<=n; i=i+1)
         tmp = {tmp[`W-1], tmp[`W-1:1]};

      sra = tmp;
   end

endfunction

// Shift left arithmetic
function [`W-1:0] sla;

   input [`W-1:0] data;
   input [`LOG2W-1:0] sel;

   integer i,n;
   reg   [`W-1:0] tmp;

   begin
      n   = sel;
      tmp = data;

      for (i=1; i<=n; i=i+1)
         tmp = {tmp[`W-2:0], 1'b0};

      sla = tmp;
   end

endfunction

