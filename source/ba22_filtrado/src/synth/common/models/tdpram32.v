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
//  File          : tdpram32.v
//
//  Dependencies  : tdpram8.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : True Dual Port RAM - 32 bit data
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

module tdpram32 (
        clk, 
        we_a,
        we_b,
        byte_en_a,
        byte_en_b,
        addr_a,
        addr_b,
        wdata_a,
        wdata_b,
        rdata_a,
        rdata_b
        );

   parameter ADDR_WIDTH =  13;

   input clk; 
   input we_a;
   input we_b;
   input [3:0] byte_en_a;
   input [3:0] byte_en_b;
   input[ADDR_WIDTH-1:0] addr_a;
   input[ADDR_WIDTH-1:0] addr_b;
   input[31:0] wdata_a; 
   input[31:0] wdata_b; 
   output wire [31:0] rdata_a;
   output wire [31:0] rdata_b;
 
   wire [3:0] we_byte_a;
   wire [3:0] we_byte_b;

   assign we_byte_a[0] = we_a & byte_en_a[0];
   assign we_byte_a[1] = we_a & byte_en_a[1];
   assign we_byte_a[2] = we_a & byte_en_a[2];
   assign we_byte_a[3] = we_a & byte_en_a[3];

   assign we_byte_b[0] = we_b & byte_en_b[0];
   assign we_byte_b[1] = we_b & byte_en_b[1];
   assign we_byte_b[2] = we_b & byte_en_b[2];
   assign we_byte_b[3] = we_b & byte_en_b[3];

   tdpram8 #(ADDR_WIDTH) u_tdpram8_7_0(
        .clk (clk), 
        .we_a  (we_byte_a[0]),
        .we_b  (we_byte_b[0]),
        .addr_a (addr_a[ADDR_WIDTH-1:0]),
        .addr_b (addr_b[ADDR_WIDTH-1:0]),
        .wdata_a (wdata_a[7:0]),
        .wdata_b (wdata_b[7:0]),
        .rdata_a (rdata_a[7:0]),
        .rdata_b (rdata_b[7:0]));

   tdpram8 #(ADDR_WIDTH) u_tdpram8_15_8(
        .clk (clk), 
        .we_a  (we_byte_a[1]),
        .we_b  (we_byte_b[1]),
        .addr_a (addr_a[ADDR_WIDTH-1:0]),
        .addr_b (addr_b[ADDR_WIDTH-1:0]),
        .wdata_a (wdata_a[15:8]),
        .wdata_b (wdata_b[15:8]),
        .rdata_a (rdata_a[15:8]),
        .rdata_b (rdata_b[15:8]));

   tdpram8 #(ADDR_WIDTH) u_tdpram8_23_16(
        .clk (clk), 
        .we_a  (we_byte_a[2]),
        .we_b  (we_byte_b[2]),
        .addr_a (addr_a[ADDR_WIDTH-1:0]),
        .addr_b (addr_b[ADDR_WIDTH-1:0]),
        .wdata_a (wdata_a[23:16]),
        .wdata_b (wdata_b[23:16]),
        .rdata_a (rdata_a[23:16]),
        .rdata_b (rdata_b[23:16]));

   tdpram8 #(ADDR_WIDTH) u_tdpram8_31_24(
        .clk (clk), 
        .we_a  (we_byte_a[3]),
        .we_b  (we_byte_b[3]),
        .addr_a (addr_a[ADDR_WIDTH-1:0]),
        .addr_b (addr_b[ADDR_WIDTH-1:0]),
        .wdata_a (wdata_a[31:24]),
        .wdata_b (wdata_b[31:24]),
        .rdata_a (rdata_a[31:24]),
        .rdata_b (rdata_b[31:24]));

endmodule
