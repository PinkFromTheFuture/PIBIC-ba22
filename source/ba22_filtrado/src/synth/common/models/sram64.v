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
//  File          : sram64.v
//
//  Dependencies  : sram32.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : Synchronous Static RAM - 64 bit data
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
//`include "timescale.v"

module sram64 (
        clk, 
        rd,
        we,
        byte_en,
        addr,
        wdata,
        rdata
        );

   parameter ADDR_WIDTH =  11;

   input clk; 
   input rd;
   input we;
   input [7:0] byte_en;
   input[ADDR_WIDTH-1:0] addr;
   input[63:0] wdata; 
   output wire [63:0] rdata;

   sram32 #(ADDR_WIDTH) u_sram32_31_0(
        .clk (clk), 
        .rd (rd),
        .we (we),
        .byte_en (byte_en[3:0]),
        .addr (addr[ADDR_WIDTH-1:0]),
        .wdata (wdata[31:0]),
        .rdata (rdata[31:0])
        );

   sram32 #(ADDR_WIDTH) u_sram32_63_32(
        .clk (clk), 
        .rd (rd),
        .we  (we),
        .byte_en  (byte_en[7:4]),
        .addr (addr[ADDR_WIDTH-1:0]),
        .wdata (wdata[63:32]),
        .rdata (rdata[63:32])
        );

endmodule
