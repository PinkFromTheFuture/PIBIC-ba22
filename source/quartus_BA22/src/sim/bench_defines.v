//----------------------------------------------------------------------
//
// Copyright (c) 2011-2012 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//--------------------------------------------------------------------
//
//  Project       : BA22 
//
//  File          : bench_defines.v
//
//  Description   : defines used in bench
//
//  Designer      : NS
//
//  QA Engineer   : JS
//
//  Creation Date : Sept 6, 2011
//
//  Last Update   : March 28, 2012
//
//  Version       : 1.01
//
//  File History  : March 28, 2012 (1.01) : Initial release
//
//----------------------------------------------------------------------

`include "ba22_constants.v"

`define BENCH bench

// for Post-routed simulation; OUTPUT_DELAY is added in QMEM outputs and
// AHB/Wishbone bus interface
`define OUTPUT_DELAY 10

// to print those $display for debug
//`define DEBUG_PRINT

// log files
`define BA22_LOG  "ba22.log"
`define INSTR_LOG "instr.log"
`define RAM_LOG   "ram.log"

// delay used in initram32
`define DELAY 5

//--------------------------
// CLOCKS CONFIGURATION   //
//--------------------------
// define reference clock period - equal or less than
// minimum actual clock period needed
`define BA_BENCH_REF_CLK_PER 60

// define default CPU clock divider - WB clock divider is determined
// from default/power up clock ratio defined in ba22_defines.v
`define BA_BENCH_DEFAULT_CPU_CLK_DIV 4

// define constant PM clock divider
`define BA_BENCH_PM_CLK_DIV 4


//----------
// WISHBONE
//----------
`define WB_DATA_WIDTH 32
`define WB_ADDR_WIDTH 32  
`define WB_RAM_SIZE 512 

//-------------------------------------
// BUS_ADDRESS for AHB/WISHBONE 
//-------------------------------------
`define CAST_CHAR        32'h90000000
`define CAST_NUM         32'h90000004
`define CAST_INTRMASK    32'h9000000C   // interrupt info
`define CAST_INTRSR      32'h90000010   // active interrupt
`define CAST_INTRCLR     32'h90000020   // Set interrupt to 1 or 0
`define CAST_SR          32'h90000014   // interrupt status register
`define CAST_TT_CNT      32'h90000018   // tick timer happen
`define CAST_TT_INT      32'h9000001C   // tick timer happen
`define CAST_ENDSIM      32'h900000F0   // End of Simulation

