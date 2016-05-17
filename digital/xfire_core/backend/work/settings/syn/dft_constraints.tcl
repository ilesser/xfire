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
# dft_constraints.tcl
#
#####################################################################################
#
# Description:
# ------------
#
# DFT contraints.
#
#####################################################################################

#####################################################################################
# Sintax examples
#####################################################################################
#
# Exclude elements:
# -----------------
# set_scan_element false <seq_instance_path>
#
# Define test protocol timing:
# ----------------------------
# test_default_period <test_clock_period_nanosecs> -------------> scan clock period
# test_default_delay <scan_input_delay_nanosecs> ---------------> must be less than scan_output_strobe and less than the capture clock edge.
# test_default_strobe <scan_output_strobe_time_nanosecs> -------> must be less or equal than test_clock_period
# test_default_strobe_width <scan_output_hold_time_nanosecs> ---> strobe_width + scan_output_strobe_time must be less or equal than
#
# Mixed clock scan_chains for clock domains crossings
# ---------------------------------------------------
# set_dft_equivalent_signals {<clock_name_1> <clock_name_2> ... <clock_name_n>}

#####################################################################################
# Edit DFT contraints here!!!
#####################################################################################
set scan_in_signal      "scan_si"
set scan_out_signal     "scan_so"
set scan_shift_signal   "scan_se"
set scan_clock_signal   "scan_ck"
set scan_mode_signal    "scan_sm"
