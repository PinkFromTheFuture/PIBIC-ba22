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
//  File          : sram8.v
//
//  Dependencies  : dpram8.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : Synchronous Static RAM - 8bit data
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

module sram8 (
        clk, 
        we,
        rd,
        addr,
        wdata,
        rdata
        );

   parameter ADDR_WIDTH =  11;

   input clk; 
   input we;
   input rd;
   input [ADDR_WIDTH-1:0] addr;
   input [7:0] wdata; 
   output wire [7:0] rdata;


  dpram8 #(ADDR_WIDTH) u_dpram8(
     .wclk (clk), 
     .rclk (clk), 
     .we (we),
     .rd (rd),
     .waddr (addr),
     .raddr (addr),
     .wdata (wdata),
     .rdata (rdata)
     );

endmodule
