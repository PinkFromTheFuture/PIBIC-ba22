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
//  File          : tdpram64_32.v
//
//  Dependencies  : tdpram32.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : Dual Port RAM - 64 bit data on PortA and 32-bit on PortB
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

module tdpram64_32 (
        clk, 
        we_64,
        we_32,
        rd_32,
        byte_en_64,
        byte_en_32,
        addr_64,
        addr_32,
        wdata_64,
        wdata_32,
        rdata_64,
        rdata_32
        );

   parameter ADDR_WIDTH =  13;

   input clk; 
   input we_64;
   input we_32;
   input rd_32;
   input [7:0] byte_en_64;
   input [3:0] byte_en_32;
   input[ADDR_WIDTH-1:0] addr_64;
   input[ADDR_WIDTH:0] addr_32;
   input[63:0] wdata_64; 
   input[31:0] wdata_32; 
   output wire [63:0] rdata_64;
   output wire [31:0] rdata_32;
 
   //wire rd_32ul;
   wire [7:0] byte_en_32ul;
   wire [31:0] rdata_32_l;
   wire [31:0] rdata_32_u;
   reg [ADDR_WIDTH:0] addr_32_reg;

   assign byte_en_32ul = (addr_32[0]) ? {4'h0, byte_en_32} : {byte_en_32, 4'h0};
   //assign rd_32ul = (addr_32[0]) ? {1'h0, rd_32} : {rd_32, 1'h0};

   always @(posedge clk)
   begin
      if (rd_32)
         addr_32_reg <= addr_32;
   end

   assign rdata_32 = (addr_32_reg[0]) ? rdata_32_l : rdata_32_u;

   tdpram32 #(ADDR_WIDTH) u_tdpram32_31_0(
        .clk (clk), 
        .we_a  (we_64),
        .we_b  (we_32),
        .byte_en_a  (byte_en_64[3:0]),
        .byte_en_b  (byte_en_32ul[3:0]),
        .addr_a (addr_64[ADDR_WIDTH-1:0]),
        .addr_b (addr_32[ADDR_WIDTH:1]),
        .wdata_a (wdata_64[31:0]),
        .wdata_b (wdata_32[31:0]),
        .rdata_a (rdata_64[31:0]),
        .rdata_b (rdata_32_l[31:0]));

   tdpram32 #(ADDR_WIDTH) u_tdpram32_63_32(
        .clk (clk), 
        .we_a  (we_64),
        .we_b  (we_32),
        .byte_en_a  (byte_en_64[7:4]),
        .byte_en_b  (byte_en_32ul[7:4]),
        .addr_a (addr_64[ADDR_WIDTH-1:0]),
        .addr_b (addr_32[ADDR_WIDTH:1]),
        .wdata_a (wdata_64[63:32]),
        .wdata_b (wdata_32[31:0]),
        .rdata_a (rdata_64[63:32]),
        .rdata_b (rdata_32_u[31:0]));

endmodule
