#####################################################################################
#
# Copyright (c) 2014 Microelectronics Lab. FIUBA.
# Copyright (c) 2014 uLab UTN-FRBA.
# All Rights Reserved.
#
# The information contained in this file is confidential and proprietary.
# Any reproduction, use or disclosure, in whole or in part, of this
# program, including any attempt to obtain a human-readable version of this
# program, without the express, prior written consent of Microelectronics Lab.
# FIUBA and uLab UTN-FRBA is strictly prohibited.
#
#####################################################################################
#
# File name:
# ----------
#
# syn_setup.tcl
#
#####################################################################################
#
# Description:
# ------------
#
# Synthesis configuration scripts for Synopsys Design Compiler.
#
#
#   Variables description:
#
#   ----- Optimization options -----
#   - flat_design           : Makes the design flat, destroying all hierarchies.
#   - constraint_design     : Has into account design constraints.
#   - constraints_first     : Constraints are met before fixing DRC rules.
#   - remove_assigns        : Aliased ports are replaced by means of buffer insertion.
#   - leakage_optimization  : Allows using multi-Vt libraries.
#   - fsm_minimization      : Allows to minimize redundancy in FSM coding.
#   - bit_blasting          : Bit-blast all buses and ports in the design.
#
#  ----- Low power options -----
#  - insert_clk_gating      : Inserts clock gating logic.
#  - clk_gating_min_num     : Minimum number of registers grouped by the same ICG cell.
#  - dynamic_optimization   : Allows boolean optimization for dynamic power reduction.
#  - xor_gating             : Allows insert XOR-gating.
#
#  ----- DFT options -----
#  - scan_design            : Inserts scan chain logic.
#  - scan_chains_num        : Number of scan chains to insert.
#  - non_inverting_scan     : Avoid using QN output of DFF in scan propagation.
#  - fix_dft_violations     : Fixes DFT violations (clocks dividers, active resets, etc.).
#  - insert_test_points     : Inserts test point logic in order to increase testabiliy.
#
#####################################################################################

#####################################################################################
# Edit synthesis options
#####################################################################################

# ----- Optimization options -----
set flat_design            "false"
set constraint_design      "true"
set constraints_first      "false"
set remove_assigns         "true"
set leakage_optimization   "true"
set fsm_minimization       "false"
set bit_blasting           "false"

# ----- Low power options -----
set insert_clk_gating      "true"
set clk_gating_min_num     3
set dynamic_optimization   "false"
set xor_gating             "false"

# ----- DFT options -----
set scan_design            "true"
set scan_chains_num        1
set non_inverting_scan     "false"
set fix_dft_violations     "false"
set insert_test_points     "false"
