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
//  File          : dpram8.v
//
//  Dependencies  :
//
//  Model Type:   : Synthesizable core
//
//  Description   : Synchronous Dual Port RAM - 8bit data
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

//`include "timescale.v"

module dpram8 (
        wclk, 
        rclk, 
        we,
        rd,
        waddr,
        raddr,
        wdata,
        rdata
        );

   parameter ADDR_WIDTH =  11;

   input wclk; 
   input rclk; 
   input we;
   input rd;
   input [ADDR_WIDTH-1:0] waddr;
   input [ADDR_WIDTH-1:0] raddr;
   input [7:0] wdata; 
   output wire [7:0] rdata;

   reg [7:0] ram[0:(1<<ADDR_WIDTH)-1];
   reg [7:0] rdata_r;


   // Write RAM block
   always @(posedge wclk)
   begin : pWriteRAM
      if (we)
         ram[waddr] <= wdata;
   end

   // output data assignment
   always @(posedge rclk)
   begin : pReadRAM
      if (rd)
         rdata_r <= ram[raddr];
   end

   assign rdata = rdata_r;

endmodule
