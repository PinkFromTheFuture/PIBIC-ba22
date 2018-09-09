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
//  File          : sram32.v
//
//  Dependencies  : sram8.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : Synchronous Static RAM - 32 bit data
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

`include "timescale.v"
`include "bench_defines.v"

module sram32 (
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
   input [3:0] byte_en;
   input[ADDR_WIDTH-1:0] addr;
   input[31:0] wdata; 
   output wire [31:0] rdata;
 
   wire [3:0] we_byte;
   wire [31:0] rdata_nd;

   assign we_byte[0] = we & byte_en[0];
   assign we_byte[1] = we & byte_en[1];
   assign we_byte[2] = we & byte_en[2];
   assign we_byte[3] = we & byte_en[3];

   sram8 #(ADDR_WIDTH) u_sram8_7_0(
        .clk (clk), 
        .rd (rd),
        .we  (we_byte[0]),
        .addr (addr[ADDR_WIDTH-1:0]),
        .wdata (wdata[7:0]),
        .rdata (rdata_nd[7:0]));

   sram8 #(ADDR_WIDTH) u_sram8_15_8(
        .clk (clk), 
        .rd (rd),
        .we  (we_byte[1]),
        .addr (addr[ADDR_WIDTH-1:0]),
        .wdata (wdata[15:8]),
        .rdata (rdata_nd[15:8]));

   sram8 #(ADDR_WIDTH) u_sram8_23_16(
        .clk (clk), 
        .rd (rd),
        .we  (we_byte[2]),
        .addr (addr[ADDR_WIDTH-1:0]),
        .wdata (wdata[23:16]),
        .rdata (rdata_nd[23:16]));

   sram8 #(ADDR_WIDTH) u_sram8_31_24(
        .clk (clk), 
        .rd (rd),
        .we  (we_byte[3]),
        .addr (addr[ADDR_WIDTH-1:0]),
        .wdata (wdata[31:24]),
        .rdata (rdata_nd[31:24]));

   assign #`OUTPUT_DELAY rdata = rdata_nd;

endmodule
