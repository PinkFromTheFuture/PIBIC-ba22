//////////////////////////////////////////////////////////////////////
////                                                              ////
////  AMBA AHB Master                                             ////
////                                                              ////
////  Description                                                 ////
////      <This file is part of Advanced High Preformance Bus>    ////
////      <AHB  defines                                      >    ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2006 Beyond Semiconductor                      ////
////                                                              ////
//// Licensing info at http://www.beyondsemi.com                  ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
`include "ba22_constants.v"

//`define AHB_RST_ACT                 1'b1
//`define AHB_RST_EVENT               or posedge(ahb_rstn_i)
`define AHB_RST_ACT                 `BA22_AHB_RST_ACT
`define AHB_RST_EVENT               `BA22_AHB_RST_EVENT
`define AHB_BUS_DW                  32
`define AHB_BUS_AW                  32

// ba22
`define AHB_BYTE_ON_LBYTE

// define if lsu data is big endian (reverse bytes)
//`define AHB_LSU_BIG_ENDIAN

// used by pcie
`define AHB_SIZE_BYTE               3'b000
`define AHB_SIZE_HALF               3'b001
`define AHB_SIZE_WORD               3'b010
`define AHB_SIZE_2WORD              3'b011
`define AHB_SIZE_4WORD              3'b100
`define AHB_SIZE_8WORD              3'b101

/*
`define AHB_HTRANS_RANGE            1:0

`define AHB_HTRANS_IDLE             2'b00
`define AHB_HTRANS_BUSY             2'b01
`define AHB_HTRANS_NONSEQ           2'b10
`define AHB_HTRANS_SEQ              2'b11



// HSIZE
`define AHB_HSIZE_RANGE              2:0

`define AHB_SIZE_BYTE               3'b000
`define AHB_SIZE_HALF               3'b001
`define AHB_SIZE_WORD               3'b010
`define AHB_SIZE_2WORD              3'b011
`define AHB_SIZE_4WORD              3'b100
`define AHB_SIZE_8WORD              3'b101

//HBURST
`define AHB_HBURST_RANGE            2:0

`define AHB_HBURST_SINGLE           3'b000
`define AHB_HBURST_INCR             3'b001
`define AHB_HBURST_WRAP4            3'b010
`define AHB_HBURST_INCR4            3'b011
`define AHB_HBURST_WRAP8            3'b100
`define AHB_HBURST_INCR8            3'b101
`define AHB_HBURST_WRAP16           3'b110
`define AHB_HBURST_INCR16           3'b111


// HPROT
`define AHB_HPROT_RANGE             3:0


// HRESP
`define AHB_HRESP_RANGE             1:0

`define AHB_HRESP_OKAY              2'b00
`define AHB_HRESP_ERROR             2'b01
`define AHB_HRESP_RETRY             2'b10
`define AHB_HRESP_SPLIT             2'b11

`define AHB_ADDR_RANGE            31:0
`define AHB_WDATA_RANGE           31:0
`define AHB_RDATA_RANGE           31:0

`define AHB_BYTE_ON_LBYTE
*/
