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
//  File          : monitor.v
//
//  Dependencies  : bench_defines.v, qmem_defines.v, bench_constants.v
//
//  Model Type:   : Simulation Model
//
//  Description   : Memory and AHB/WB monitor
//
//  Designer      : NS
//
//  QA Engineer   : JS
//
//  Creation Date : Sept 6, 2011
//
//  Last Update   : Sept 10, 2012
//
//  Version       : 1.04
//
//  File History  : March 28, 2012 (1.01) : Initial release
//                  April 05, 2012 (1.02) : Check iqmem_addr changes in BA22_QMEM_SEPARATED
//                  Sept  10, 2012 (1.04) : Include 32-bit iqmem_data; BA22_IQMEM32_IMPLEMENTED
//
//----------------------------------------------------------------------

//`include "timescale.v"
// `include "bench_defines.v"
// `include "../synth/synth/common/ba22/bench_constants.v"

/*path laico: */
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/synth/common/ba22/timescale.v"
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/sim/bench_constants.v"
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/synth/config/de_fpu32_dfchip/qmem_defines.v"
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/sim/bench_defines.v"

/*path casa: */
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/synth/common/ba22/timescale.v"
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/sim/bench_constants.v"
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/synth/config/de_fpu32_dfchip/qmem_defines.v"
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/sim/bench_defines.v"

/*path relativo: */
`include "../synth/common/ba22/timescale.v"
`include "./bench_constants.v"
`include "../synth/config/de_fpu32_dfchip/qmem_defines.v"
`include "./bench_defines.v"

module monitor (
    clk,
    rst_i,
    iqmem_stb, 
    iqmem_ack, 
    dqmem_ack, 
    iqmem_data, 
    dqmem_data, 
    dqmem_wdata, 
    iqmem_addr,
    `ifdef BA22_QMEM_UNIFIED_SP
    mem_addr,
    `endif
    dqmem_addr,
    dqmem_we, 
    intr,
	//saida dos displays para os leds.
	LEDR, //vou mostrar om esse aqui os dados
	dados
    );
	
	
	
    input clk;
    input rst_i;
    input iqmem_stb;
    input iqmem_ack;
    input dqmem_ack;
    `ifdef BA22_IQMEM32_IMPLEMENTED
       input [31:0] iqmem_data;
    `else
       input [63:0] iqmem_data;
    `endif
    input [31:0] dqmem_data;
    input [31:0] dqmem_wdata;
    input [31:0] iqmem_addr;
    `ifdef BA22_QMEM_UNIFIED_SP
    input [31:0] mem_addr;
    `endif
    input [31:0] dqmem_addr;
    input dqmem_we;
    output reg [`BA22_PIC_INTS-1:0] intr;
	output reg [9:0] LEDR;
	input [ `BA22_AHB_WDATA_RANGE ] dados;


  // integer logfile;
  // integer instr_log;
  // integer ram_log;
  reg dqmem_ack_r;
  reg iqmem_ack_r;
  reg end_sim;

  // initial
  // begin
     // logfile <= $fopen (`BA22_LOG);
     // instr_log <= $fopen (`INSTR_LOG);
     // ram_log <= $fopen ( `RAM_LOG  );
  // end
  


  always @(posedge clk)
  begin
     iqmem_ack_r  <= iqmem_ack;
     dqmem_ack_r  <= dqmem_ack;
  end

// ***************************
// Monitor for Memory (QMEM)
// ***************************
`ifdef BA22_QMEM_UNIFIED_SP
     reg[31:0] memaddr_r;
  
     always @(posedge clk)
        memaddr_r <= mem_addr;

     always @(posedge clk)
     begin
        if (memaddr_r != mem_addr)
        begin
           if (dqmem_ack_r)
           begin 
              //$fdisplay (ram_log, $stime, "ns  RAM data at address %h is: %h", memaddr_r, dqmem_data);
              `ifdef DEBUG_PRINT
                 $display ($stime, "ns  RAM data at address %h is: %h", memaddr_r, dqmem_data);
              `endif
           end
           else if (iqmem_ack_r)
           begin 
             // $fdisplay (instr_log, $stime, "ns  Instruction data at memory address %h is: %h", memaddr_r, iqmem_data);
              `ifdef DEBUG_PRINT
                 $display ($stime, "ns  Instruction data at memory address %h is: %h", memaddr_r, iqmem_data);
              `endif
           end
        end
     end

`endif

`ifdef BA22_QMEM_UNIFIED_DP
     reg[31:0] iqmem_addr_r;
     reg[31:0] dqmem_addr_r;
     reg dqmem_we_r;

     always @(posedge clk)
     begin
        iqmem_addr_r <= iqmem_addr;
        dqmem_addr_r <= dqmem_addr;
        dqmem_we_r   <= dqmem_we;
     end

     always @(posedge clk)
     begin
        if (dqmem_ack_r && dqmem_we_r)
        begin 
           //$fdisplay (ram_log, $stime, "ns  Write data to RAM; address : %h data : %h", dqmem_addr_r, dqmem_wdata);
           `ifdef DEBUG_PRINT
               $display ($stime, "ns  Write data to RAM; address: %h data : %h", dqmem_addr_r, dqmem_wdata);
           `endif
        end
     end

     always @(posedge clk)
     begin
        if (dqmem_ack_r && !dqmem_we_r)
        begin 
           //$fdisplay (ram_log, $stime, "ns  RAM data at address %h is: %h", dqmem_addr_r, dqmem_data);
           `ifdef DEBUG_PRINT
               $display ($stime, "ns  RAM data at address %h is: %h", dqmem_addr_r, dqmem_data);
           `endif
        end
     end

     always @(posedge clk)
     begin
        if (iqmem_addr_r != iqmem_addr)
        begin 
           if (iqmem_ack_r)
           begin 
             // $fdisplay (instr_log, $stime, "ns  Instruction data at memory address %h is: %h", iqmem_addr_r, iqmem_data);
              `ifdef DEBUG_PRINT
                  $display ($stime, "ns  Instruction data at memory address %h is: %h", iqmem_addr_r, iqmem_data);
               `endif
           end
        end
     end
`endif

`ifdef BA22_QMEM_SEPARATED
     reg[31:0] iqmem_addr_r;
     reg[31:0] dqmem_addr_r;
     reg dqmem_we_r;

     always @(posedge clk)
     begin
        iqmem_addr_r <= iqmem_addr;
        dqmem_addr_r <= dqmem_addr;
        dqmem_we_r   <= dqmem_we;
     end

     always @(posedge clk)
     begin
        if (dqmem_ack_r && !dqmem_we_r)
        begin 
           //$fdisplay (ram_log, $stime, "ns  RAM data at address %h is: %h", dqmem_addr_r, dqmem_data);
           `ifdef DEBUG_PRINT
               $display ($stime, "ns  RAM data at address %h is: %h", dqmem_addr_r, dqmem_data);
           `endif
        end
     end

     always @(posedge clk)
     begin
        if (iqmem_addr_r != iqmem_addr)
        begin 
           if (iqmem_ack_r)
           begin 
             // $fdisplay (instr_log, $stime, "ns  Instruction data at memory address %h is: %h", iqmem_addr_r, iqmem_data);
              `ifdef DEBUG_PRINT
                  $display ($stime, "ns  Instruction data at memory address %h is: %h", iqmem_addr_r, iqmem_data);
               `endif
           end
        end
     end

`endif


//////////////////////////////
// Counting # of Interrupt
//////////////////////////////
  reg [7:0] ttvec_cnt;
  reg [7:0] ext_intr_cnt;

  always @ (posedge clk `BA22_RST_I_EVENT)
  begin
     if(`BA22_RST_I_ACT)
        ttvec_cnt <= 8'd0;
     else if (iqmem_stb && iqmem_addr == `BA22_EXC_VECT_TICK_TIMER)
        ttvec_cnt <= ttvec_cnt + 1'b1;
  end

  always @ (posedge clk `BA22_RST_I_EVENT)
  begin
     if(`BA22_RST_I_ACT)
        ext_intr_cnt <= 8'd0;
     else if (iqmem_stb && iqmem_addr == `BA22_EXC_VECT_INT)
        ext_intr_cnt <= ext_intr_cnt + 1'b1;
  end

////////////////////////////////////
// DEBUG - PRINTING Exceptions
////////////////////////////////////
always @(iqmem_addr)
begin
   case (iqmem_addr)
      `BA22_EXC_VECT_EPH: begin
                 $display ($stime, "ns  Exception Vector Prefix, IMEM addr: 32'hF0000000");
                 // //$fdisplay (logfile, $stime, "ns  Exception Vector Prefix, IMEM addr: 32'hF0000000");
               end
      `BA22_EXC_VECT_RESET: begin
                 $display ($stime, "ns  Reset Exception Vector, IMEM addr: 32'h00000100");
                 // //$fdisplay (logfile, $stime, "ns  Reset Exception Vector, IMEM addr: 32'h00000100");
               end
      `BA22_EXC_VECT_ITLB_MISS: begin
                 $display ($stime, "ns  Exception: Instruction TLB Miss Vector, IMEM addr: 32'h00000A00");
                 // //$fdisplay (logfile, $stime, "ns  Exception: Instruction TLB Miss Vector, IMEM addr: 32'h00000A00");
               end
      `BA22_EXC_VECT_IPAGE_FAULT: begin
                 $display ($stime, "ns  Exception: Instruction Page Fault Vector, IMEM addr: 32'h00000400");
                 // //$fdisplay (logfile, $stime, "ns  Exception: Instruction Page Fault Vector, IMEM addr: 32'h00000400");
               end
      `BA22_EXC_VECT_DBUS_ERR: begin
                 $display ($stime, "ns  Exception: Bus Error Vector, IMEM addr: 32'h00000200");
                 // //$fdisplay (logfile, $stime, "ns  Exception: Bus Error Vector, IMEM addr: 32'h00000200");
               end
      `BA22_EXC_VECT_UNDEF_INST: begin
                 $display ($stime, "ns  Exception: Illegal Instruction Vector, IMEM addr: 32'h00000700");
                 // //$fdisplay (logfile, $stime, "ns  Exception: Illegal Instruction Vector, IMEM addr: 32'h00000700");
               end
      `BA22_EXC_VECT_UNALIGNED: begin
                 $display ($stime, "ns  Exception: Unaligned Memory Access Vector, IMEM addr: 32'h00000600");
                 //$fdisplay (logfile, $stime, "ns  Exception: Unaligned Memory Access Vector, IMEM addr: 32'h00000600");
               end
      `BA22_EXC_VECT_SYSCALL: begin
                 $display ($stime, "ns  Exception: System Call Vector, IMEM addr: 32'h00000C00");
                 //$fdisplay (logfile, $stime, "ns  Exception: System Call Vector, IMEM addr: 32'h00000C00");
               end
      `BA22_EXC_VECT_TRAP: begin
                 $display ($stime, "ns  Trap Exception, IMEM addr: 32'h00000E00");
                 //$fdisplay (logfile, $stime, "ns  Trap Exception, IMEM addr: 32'h00000E00");
               end
      `BA22_EXC_VECT_DTLB_MISS: begin
                 $display ($stime, "ns  Exception: Data TLB Miss Vector, IMEM addr: 32'h00000900");
                 //$fdisplay (logfile, $stime, "ns  Exception: Data TLB Miss Vector, IMEM addr: 32'h00000900");
               end
      `BA22_EXC_VECT_DPAGE_FAULT: begin
                 $display ($stime, "ns  Exception: Data Page Fault Vector, IMEM addr: 32'h00000300");
                 //$fdisplay (logfile, $stime, "ns  Exception: Data Page Fault Vector, IMEM addr: 32'h00000300");
               end
      `BA22_EXC_VECT_TICK_TIMER: begin
                 $display ($stime, "ns  Exception: Tick Timer Vector, IMEM addr: 32'h00000500");
                 //$fdisplay (logfile, $stime, "ns  Exception: Tick Timer Vector, IMEM addr: 32'h00000500");
               end
      `BA22_EXC_VECT_INT: begin
                 $display ($stime, "ns  Exception: External Interrupt Vector, IMEM addr: 32'h00000800");
                 //$fdisplay (logfile, $stime, "ns  Exception: External Interrupt Vector, IMEM addr: 32'h00000800");
               end
      `BA22_EXC_VECT_FP: begin
                 $display ($stime, "ns  Exception: Floating Point Exception, IMEM addr: 32'h00000d00");
                 //$fdisplay (logfile, $stime, "ns  Exception: Floating Point Exception, IMEM addr: 32'h00000d00");
               end
   endcase
end

//`ifdef PERIPHERALS_AHB_BUS
//   `define BENCH_BUS `BENCH.i_dahbs 
//`else
   `ifdef BA22_AHB
      `ifdef BA22_DAHB_IMPLEMENTED
         `define BENCH_BUS `BENCH.i_dahbs 
      `else
         `ifdef BA22_IAHB_IMPLEMENTED
            `define BENCH_BUS `BENCH.i_iahbs 
         `endif
      `endif
   `else
      `ifdef BA22_DWB_IMPLEMENTED
         `define BENCH_BUS `BENCH.i_dwbs 
      `else
         `ifdef BA22_IWB_IMPLEMENTED
            `define BENCH_BUS `BENCH.i_iwbs 
         `endif
      `endif
   `endif
//`endif

always @(posedge clk)
begin
	LEDR [9:0] = dados [9:0]; //descarto os bits mais significativos dos dados
end

/*
`ifdef BA22_AHB
   wire bus_clk = `BENCH_BUS.ahb_clk_i ;
   wire reset = `BENCH_BUS.ahb_rstn_i ;
   //wire reset_act = `AHB_RST_ACT;
   wire reset_act   = `BA22_RST_I_VAL;
   wire enable = (`BENCH_BUS.ahb_hbusreq_i & `BENCH_BUS.data_phase);
   wire write_enb = `BENCH_BUS.ahb_hwrite_i & `BENCH_BUS.ddir;
   wire read_enb = !`BENCH_BUS.ahb_hwrite_i & !`BENCH_BUS.ddir;
   wire [`BA22_AHB_ADDR_RANGE ] address = `BENCH_BUS.ahb_haddr_i ;
   wire [`BA22_AHB_RDATA_RANGE ] rdata = `BENCH_BUS.ahb_hrdata_o ;
   wire [`BA22_AHB_WDATA_RANGE ] wdata = `BENCH_BUS.ahb_hwdata_i ;
   wire [9:0] bus_rdcnt = `BENCH_BUS.ahb_read_cnt;
   wire [9:0] bus_wrcnt = `BENCH_BUS.ahb_write_cnt;
   parameter BA22_BUS = "AHB"; 
`endif

always @(posedge clk)
begin
	LEDR [9:0] = dados [9:0]; //descarto os bits mais significativos dos dados
end

always @ (posedge bus_clk or reset)
begin
   if(reset == reset_act)
   begin
       end_sim <= 1'b0;
       intr <= {`BA22_PIC_INTS{1'b1}};
   end
   else if (enable)
   begin
      if (read_enb)
      begin
        case (address)
         `CAST_CHAR : begin
                         $display ($stime, "ns  >>>>>>>> %s read addr %h - Character is ** %c **", BA22_BUS, address, rdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s read addr %h - Character is ** %c **", BA22_BUS, address, rdata);
                      end
         `CAST_NUM  : begin
                         $display ($stime, "ns  >>>>>>>> %s read addr %h - Data: %h", BA22_BUS, address, rdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s read addr %h - Data: %h", BA22_BUS, address, rdata);
                      end
         `CAST_INTRMASK : begin
                         $display ($stime, "ns  >>>>>>>> %s read addr %h  - Interrupt Mask : %h", BA22_BUS, address, rdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s read addr %h  - Interrupt Mask : %h", BA22_BUS, address, rdata);
                      end
         `CAST_INTRSR  : begin
                         $display ($stime, "ns  >>>>>>>> %s read addr %h - Interrupt %h are active", BA22_BUS, address, rdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s read addr %h - Interrupt %h are active", BA22_BUS, address, rdata);
                      end
         `CAST_SR :   begin
                         $display ($stime, "ns  >>>>>>>> %s read addr %h - Interrupt Status Register is %h", BA22_BUS, address, rdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s read addr %h - Interrupt Status Register is %h", BA22_BUS, address, rdata);
                      end
         `CAST_TT_CNT:begin
                         $display ($stime, "ns  >>>>>>>> %s read addr %h - Tick Timer Event; data is %h", BA22_BUS, address, rdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s read addr %h - Tick Timer Event; data is %h", BA22_BUS, address, rdata);
                      end
         `CAST_TT_INT:begin
                         $display ($stime, "ns  >>>>>>>> %s read addr %h - Interrupt Tick Timer Event; data is %h", BA22_BUS, address, rdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s read addr %h - Interrupt Tick Timer Event; data is %h", BA22_BUS, address, rdata);
                      end
         default:     begin
                         $display ($stime, "ns  >>>>>>>> %s Read >>> address %h, and read data is %h", BA22_BUS, address, rdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s Read >>> address %h, and read data is %h", BA22_BUS, address, rdata);
                      end
        endcase
      end
      else if (write_enb)
      begin
        case (address)
         `CAST_CHAR : begin
                         $display ($stime, "ns  >>>>>>>> %s write to %h - Character is ** %c **", BA22_BUS, address, wdata);
                         //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s write to %h - Character is ** %c **", BA22_BUS, address, wdata);
                      end
         `CAST_NUM:   begin
                        $display ($stime,"ns  >>>>>>>> %s write to %h - Data: %h", BA22_BUS, address, wdata);
                        //$fdisplay (logfile, $stime,"ns  >>>>>>>> %s write to %h - Data: %h", BA22_BUS, address, wdata);
                      end
         `CAST_INTRMASK : begin
                        $display ($stime, "ns  >>>>>>>> %s write to %h  - Interrupt Mask : %h", BA22_BUS, address, wdata);
                        //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s write to %h  - Interrupt Mask : %h", BA22_BUS, address, wdata);
                      end
         `CAST_INTRSR : begin
                        $display ($stime, "ns  >>>>>>>> %s write to %h - Interrupt %h are active", BA22_BUS, address, wdata);
                        //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s write to %h - Interrupt %h are active", BA22_BUS, address, wdata);
                      end
         `CAST_SR :   begin
                        $display ($stime, "ns  >>>>>>>> %s write to %h - Interrupt Status Register is %h", BA22_BUS, address, wdata);
                        //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s write to %h - Interrupt Status Register is %h", BA22_BUS, address, wdata);
                      end
         `CAST_TT_CNT: begin
                        $display ($stime, "ns  >>>>>>>> %s write to %h - Tick Timer Event; data is %h", BA22_BUS, address, wdata);
                        //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s write to %h - Tick Timer Event; data is %h", BA22_BUS, address, wdata);
                      end
         `CAST_TT_INT: begin
                        $display ($stime, "ns  >>>>>>>> %s write to %h - Interrupt Tick Timer Event; data is %h", BA22_BUS, address, wdata);
                        //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s write to %h - Interrupt Tick Timer Event; data is %h", BA22_BUS, address, wdata);
                      end
         `CAST_INTRCLR: begin
                        $display ($stime, "ns  >>>>>>>> %s write to %h - Clear the interrupt; data is %h", BA22_BUS, address, wdata);
                        //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s write to %h - Clear the interrupt; data is %h", BA22_BUS, address, wdata);
                        intr <= wdata[`BA22_PIC_INTS-1: 0];
                      end
         `CAST_ENDSIM: begin
                        $display ($stime, "ns  >>>>>>>> %s write to %h - End of Simulation", BA22_BUS, address);
                        //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s write to %h - End of Simulation", BA22_BUS, address);
                        end_sim <= 1'b1;
                      end
         default :    begin
                        $display ($stime, "ns  >>>>>>>> %s Write >>> address %h, and data is %h", BA22_BUS, address, wdata);
                        //$fdisplay (logfile, $stime, "ns  >>>>>>>> %s Write >>> address %h, and data is %h", BA22_BUS, address, wdata);
                      end
        endcase
      end
   end
end

*/

always @(posedge clk)
begin
   if (end_sim) begin
      $display ($stime, "ns  ***********************End of Simulation");
      $display ($stime, "ns  *********Number of Tick Timer Interrupts: %d ", ttvec_cnt);
      $display ($stime, "ns  *********Number of External Interrupts: %d ", ext_intr_cnt);
      // $display ($stime, "ns  *********Number of %s READ is: %d ", BA22_BUS, bus_rdcnt);
	  

	  
      // $display ($stime, "ns  *********Number of %s WRITE is: %d ", BA22_BUS, bus_wrcnt);

	  
      //$fdisplay (logfile, $stime, "ns  ***********************End of Simulation");
      //$fdisplay (logfile, $stime, "ns  *********Number of Tick Timer Interrupts: %d ", ttvec_cnt);
      //$fdisplay (logfile, $stime, "ns  *********Number of External Interrupts: %d ", ext_intr_cnt);
      //$fdisplay (logfile, $stime, "ns  *********Number of %s READ is: %d ", BA22_BUS, bus_rdcnt);
      //$fdisplay (logfile, $stime, "ns  *********Number of %s WRITE is: %d ", BA22_BUS, bus_wrcnt);
      $stop;
   end
end

endmodule
