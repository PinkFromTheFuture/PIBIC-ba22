//----------------------------------------------------------------------
//
// Copyright (c) 2005-2012 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//--------------------------------------------------------------------
//
//  Project       : BA22
//
//  File          : wb_slave_behavioral.v
//
//  Dependencies  : bench_defines.v
//
//  Model Type:   : Simulation model
//
//  Description   : Wishbone 32/64/128-bit Slave RAM model
//
//  Designer      : PV
//
//  QA Engineer   : JS
//
//  Creation Date : 25-May-2005
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

module wb_slave_behavioral (clk_i, rst_i, sel_i, dat_i, adr_i, cyc_i, stb_i, we_i, ack_o, dat_o);

   input clk_i;                  // Wishbone slave clock
   input rst_i;                  // Wishbone slave reset
   input[`WB_DATA_WIDTH/8-1:0] sel_i; // Wishbone slave select
   input[`WB_DATA_WIDTH-1:0] dat_i;   // Wishbone slave data input
   input[`WB_ADDR_WIDTH-1:0] adr_i; // Wishbone slave address
   input cyc_i;                  // Wishbone slave cycle
   input stb_i;                  // Wishbone slave strobe
   input we_i;                   // Wishbone slave Write/Read
   output ack_o;                 // Wishbone slave acknowledge output
   wire ack_o;
   output[`WB_DATA_WIDTH-1:0] dat_o;  // Wishbone slave data output
   reg[`WB_DATA_WIDTH-1:0] dat_o;

   // The RAM start from 0's -> used for CACHE RAM
   //reg[`WB_DATA_WIDTH-1:0] ram[0:`WB_RAM_SIZE-1];
   //

   wire [7:0] ack_delay = 8'd1;          // acknowledge delay
   wire ack;
   reg [7:0] ackcnt;
   reg [9:0] wb_read_cnt    ;
   reg [9:0] wb_write_cnt   ;

   
   // Acknowledge delay counter
   always @(posedge clk_i or posedge rst_i)
   begin : pACK_R
      if (rst_i == 1'b1)
         ackcnt <= 8'b00000000;
      else
      begin
         if (!cyc_i)
            ackcnt <= 8'b0000000;
         else if (stb_i & cyc_i)
         begin
            if (ackcnt >= ack_delay)
               ackcnt <= 8'b0000000;
            else
               ackcnt <= ackcnt + 1;
         end
      end
   end

   // Acknowledge
   assign ack = (ackcnt >= ack_delay) ? (stb_i & cyc_i) : 1'b0;
   assign ack_o = ack;

   // RAM block
   // no reset; default data in the ram is X's
   /*
   always @(posedge clk_i)
   begin : pRAM
      if (cyc_i & stb_i & we_i & ack)
      begin : loop_1
         integer i,j;
         for(i = 0; i <= `WB_DATA_WIDTH/8-1; i = i + 1)
         begin
            if (sel_i[i])
            begin
               for(j = 0; j <= 7; j = j + 1)
                  ram[adr_i][i*8+j] <= dat_i[i*8+j];
            end
         end
      end
   end

   // output data assignment
   always @(adr_i)
   begin
      dat_o = ram[adr_i];
   end
   //
   */

// WB monitor the number of AHB read and AHB write
   always @ (posedge clk_i or posedge rst_i)
   begin
      if(rst_i == 1'b1)
      begin
         wb_read_cnt <= 10'd0;
         wb_write_cnt <= 10'd0;
      end
      else if (cyc_i && stb_i && ack)
      begin
         if (adr_i == `CAST_CHAR || adr_i == `CAST_NUM || adr_i == `CAST_INTRCLR ||
             adr_i == `CAST_INTRMASK || adr_i == `CAST_INTRSR || adr_i == `CAST_SR ||
             adr_i == `CAST_TT_CNT || adr_i == `CAST_TT_INT || adr_i == `CAST_ENDSIM)
         begin
            if (!we_i)
               wb_read_cnt <= wb_read_cnt + 1'b1;
            else // (we_i)
               wb_write_cnt <= wb_write_cnt + 1'b1;
         end
      end
   end


endmodule
