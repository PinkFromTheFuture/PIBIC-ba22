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
//  File          : tdpram8.v
//
//  Dependencies  : 
//
//  Model Type:   : Synthesizable core
//
//  Description   : True Dual Port 8bit RAM
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

module tdpram8 (
        clk, 
        we_a,
        we_b,
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
   input[ADDR_WIDTH-1:0] addr_a;
   input[ADDR_WIDTH-1:0] addr_b;
   input[7:0] wdata_a; 
   input[7:0] wdata_b; 
   output reg [7:0] rdata_a;
   output reg [7:0] rdata_b;

   reg [7:0] ram[0:(1<<ADDR_WIDTH)-1];


   // PortA
   always @(posedge clk)
   begin : p_RAM_a
      if (we_a)
      begin
         ram[addr_a] <= wdata_a;
         rdata_a <= wdata_a;
      end
      else
         rdata_a <= ram[addr_a];
   end

   // PortB
   always @(posedge clk)
   begin : p_RAM_b
      if (we_b)
      begin
         ram[addr_b] <= wdata_b;
         rdata_b <= wdata_b;
      end
      else
         rdata_b <= ram[addr_b];
   end

endmodule
