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
//  File          : qmem_arbiter.v
//
//  Dependencies  :
//
//  Model Type:   : Synthesizable core
//
//  Description   : Arbiter for iqmem and dqmem to use single RAM
//
//  Designer      : NS
//
//  QA Engineer   : JS
//
//  Creation Date : Sept 6, 2011
//
//  Last Update   : March28, 2012
//
//  Version       : 1.01
//
//  File History  : March 28, 2012 (1.01) : Initial release
//
//----------------------------------------------------------------------
`include "timescale.v"

module qmem_arbiter (
        clk, 
        i_stb,
        i_addr,
        d_stb,
        d_addr,
        d_byte_en,
        mem_ack,
        mem_rdata,
        d_wdata,

        mem_stb,
        mem_addr,
        d_rdata,
        i_rdata,
        mem_byte_en,
        mem_wdata,
        d_ack,
        i_ack
        );

   input clk; 
   input d_stb;
   input i_stb;
   input[3:0] d_byte_en;
   input[31:0] d_addr;
   input[31:0] i_addr;
   input[31:0] d_wdata; 
   input mem_ack; 
   input[63:0] mem_rdata; 

   output wire mem_stb;
   output wire [31:0] mem_addr;
   output reg [31:0] d_rdata;
   output wire [63:0] i_rdata;
   output wire [7:0] mem_byte_en;
   output wire [63:0] mem_wdata;
   output wire d_ack;
   output wire i_ack;

   reg d_stb_r;
   reg i_stb_r;
   reg [31:0] mem_addr_r;
   wire [2:0] addr_sel;

   assign mem_stb = d_stb | i_stb;
   assign mem_addr = (d_stb)? d_addr : i_addr;
   assign addr_sel = mem_addr[2:0];

   // writing section; data input 32 bit-> data out 64 bit
   //                  byte_en input 4 bit -> byte_en output 8 bit
   // initram32 use dqmem bus (32bit), since no writing in iqmem bus
   assign mem_wdata = (mem_addr[2])? {32'h00000000, d_wdata} : {d_wdata, 32'h00000000};
   assign mem_byte_en = (mem_addr[2])? {4'h0, d_byte_en} : {d_byte_en, 4'h0};

   always @(posedge clk)
   begin
      d_stb_r <= d_stb;
      i_stb_r <= i_stb;
   end

   always @(posedge clk)
   begin
      if (d_stb)
         mem_addr_r <= mem_addr;
   end

   // 32 bit data -> check upper 32 bit or lower 32 bit
   always @(*)
   begin
      if (mem_addr_r[2])
         d_rdata = mem_rdata[31:0];
      else
         d_rdata = mem_rdata[63:32];
   end

   // 64 bit data
   assign i_rdata = (i_stb_r && !d_stb_r)? mem_rdata : {64{1'b0}};

   assign d_ack = (d_stb)? mem_ack : 1'b0;
   assign i_ack = (i_stb && !d_stb)? mem_ack : 1'b0;

endmodule
