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
//  File          : initram32.v
//
//  Dependencies  : bench_defines.v
//
//  Model Type:   : Simulation Model
//
//  Description   : Reading instruction data from a file
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

`define EOF 32'hFFFF_FFFF
`define NULL 0
`define INSTR_FILE "rom.verilog"

module initram32(
  input clk,
  input start_load,
  output reg [31:0] addr,
  output reg [31:0] data,
  output reg [3:0] byte_en,
  output reg load_done
);

parameter DELAY = 5;

integer file, c, r;
reg [31:0] theaddress;
//reg [8*`MAX_LINE_LENGTH:0] line; /* Line of text read from file */
reg [7:0] x1, x2, x3, x4;
integer safety;

task dowrite;
 input [31:0] a;
 input [31:0] d;
 input [3:0] s; // select
begin
 #DELAY addr <= a;
 #DELAY data <= d;
 #DELAY byte_en <= s;
 @(posedge clk);
end
endtask

initial
begin : file_block
    #DELAY load_done <= 0;
    #DELAY addr <= 0;
    #DELAY data <= 0;
    #DELAY byte_en <= 0;
    @(posedge start_load);
    @(posedge clk);
    file = $fopen(`INSTR_FILE,"r");
    if (file == `NULL) // If error opening file
        disable file_block; // Just quit

    c = $fgetc(file);
    while (c != `EOF)
    begin
       if (c == "/" || c == "#") // COMMENTS
       begin
           r = $fscanf(file, "\n");
           c = $fgetc(file);
       end 
       else if (c == "@") // ADDRESS SPECIFIER
       begin
           //@00000000             
           r = $fscanf(file,"%h\n", theaddress);
           `ifdef DEBUG_PRINT $display("the address is now %h", theaddress); `endif
           c = $fgetc(file);
       end
       else // read data
       begin
           // Push the character back to the file then read the next time
	   //
	   safety=0;
	   while (c != "\n" && c != `EOF && c != "@" && c != "\r") //maquina de estados
           begin
              `ifdef DEBUG_PRINT $display("'%c'", c);  `endif
              r = $ungetc(c, file);
              r = $fscanf(file,"%h %h %h %h",x1, x2, x3, x4);
              // note that fscanf will eat whitespace also
              //write it!
	      case (r)
                    0: begin
                      `ifdef DEBUG_PRINT $display("error-nothing on the line"); `endif
                       end
		    1: begin  //0001
                    `ifdef DEBUG_PRINT $display("writing1 %h %h", theaddress, {x1, 24'h000000}); `endif
                       dowrite(theaddress,{x1,24'h000000},4'b1000);
                       theaddress = theaddress + 1;
                       end
		    2: begin //0010
                    `ifdef DEBUG_PRINT $display("writing2 %h %h", theaddress, {x1, x2, 16'h0000}); `endif
                       dowrite(theaddress,{x1,x2,16'h0000},4'b1100);
                       theaddress = theaddress + 2;
                       end
		    3: begin //0011
                    `ifdef DEBUG_PRINT $display("writing3 %h %h", theaddress, {x1, x2, x3, 8'h00}); `endif
                       dowrite(theaddress,{x1,x2,x3,8'h00},4'b1110);
                       theaddress = theaddress + 3;
                       end
		    4: begin //0100
                    `ifdef DEBUG_PRINT $display("writing4 %h %h", theaddress, {x1, x2, x3, x4}); `endif
                       dowrite(theaddress,{x1,x2,x3,x4},4'b1111);
                       theaddress = theaddress + 4;
                       end
              endcase	
	      //$display("after fscan '%c'", c);
              c = $fgetc(file);
              while (c == " " || c == "\r")
                 c = $fgetc(file);

              safety = safety + 1;
              if (safety == 8)
              begin
                 $display("we seem to be erroneously reading too much from one line");
                 $stop;
	      end
              
           end
	   if (c == "\n")
           begin
              r = $fscanf(file,"\n");
              c = $fgetc(file);
           end
       end // read data
   end // while not EOF
   $fclose(file);
   #DELAY load_done <= 1;
   #DELAY addr <= 0;
   #DELAY data <= 0;
   #DELAY byte_en <= 0;	
   $display("the load is completed");
end // initial

endmodule 

