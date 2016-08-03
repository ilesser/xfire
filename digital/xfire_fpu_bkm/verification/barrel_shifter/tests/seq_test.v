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
// Sequential test for barrel shifter.
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
//    - 2016-06-13 - ilesser - Initial version.
//
// -----------------------------------------------------------------------------
`define DIR_RIGHT 1'b0
`define DIR_LEFT  1'b1

`define OP_SHIFT  1'b0
`define OP_ROT    1'b1

`define SHIFT_T_LOGIC   1'b0
`define SHIFT_T_ARITH   1'b1

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
   input [2+`LOG2W+`W:0]   cnt;
   // ----------------------------------

// *****************************************************************************

// *****************************************************************************
// Functionality
// *****************************************************************************

   // -----------------------------------------------------
   // Internal variables and signals
   // -----------------------------------------------------
   // -----------------------------------------------------

   begin

      tb_dir      = cnt[`W+`LOG2W+2];
      tb_op       = cnt[`W+`LOG2W+1];
      tb_shift_t  = cnt[`W+`LOG2W];
      //tb_dir      = 1'b1;
      //tb_op       = 1'b1;
      //tb_shift_t  = 1'b1;
      tb_sel      = cnt[`W+`LOG2W-1:`W];
      tb_in       = cnt[`W-1:0];

      case (cnt[`W+`LOG2W+2:`W+`LOG2W])
        {`DIR_RIGHT, `OP_SHIFT, `SHIFT_T_LOGIC}:  tb_out = srl(tb_in, tb_sel);
        {`DIR_RIGHT, `OP_SHIFT, `SHIFT_T_ARITH}:  tb_out = sra(tb_in, tb_sel);
        {`DIR_RIGHT, `OP_ROT  , `SHIFT_T_LOGIC}:  tb_out = ror(tb_in, tb_sel);
        {`DIR_RIGHT, `OP_ROT  , `SHIFT_T_ARITH}:  tb_out = ror(tb_in, tb_sel);
        {`DIR_LEFT , `OP_SHIFT, `SHIFT_T_LOGIC}:  tb_out = sll(tb_in, tb_sel);
        {`DIR_LEFT , `OP_SHIFT, `SHIFT_T_ARITH}:  tb_out = sla(tb_in, tb_sel);
        {`DIR_LEFT , `OP_ROT  , `SHIFT_T_LOGIC}:  tb_out = rol(tb_in, tb_sel);
        {`DIR_LEFT , `OP_ROT  , `SHIFT_T_ARITH}:  tb_out = rol(tb_in, tb_sel);
      endcase

      run_clk(1);

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

