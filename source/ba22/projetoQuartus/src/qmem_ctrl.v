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
//  File          : qmem_ctrl.v
//
//  Dependencies  : ba22_defines, qmem_defines.v, bench_defines.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : Qmem's controlller muxes; init qmem for simulation
//                  big or little endians
//
//  Designer      : NS
//
//  QA Engineer   : JS
//
//  Creation Date : April 30, 2012
//
//  Last Update   : Sept 10, 2012
//
//  Version       : 1.04
//
//  File History  : April 30, 2012 (1.01) : Initial release
//                  Sept  10, 2012 (1.04) : Include BA22_IQMEM32_IMPLEMENTED
//
//----------------------------------------------------------------------

`include "timescale.v"
`include "ba22_defines.v"
`include "qmem_defines.v"

module qmem_ctrl
(
    input   [31: 0]     initram_addr,
    input   [31: 0]     initram_data,
    input   [3: 0]      initram_byte_en,
    input               initram_stb,
    wire                ben_le_sel_i,

    output              iqmem_stb,
    output              iqmem_we,
   `ifdef BA22_QMEM_SEPARATED
      `ifdef BA22_IQMEM32_IMPLEMENTED
         output   [3: 0]      iqmem_byte_en    ,
         output   [31: 0]     iqmem_wdata      ,
      `else
         output   [7: 0]     iqmem_byte_en,
         output   [63: 0]    iqmem_wdata,
      `endif
   `else
       output   [3: 0]     iqmem_byte_en,
       output   [31: 0]    iqmem_wdata,
   `endif
    output   [31: 0]    iqmem_addr
) ;

wire    [31: 0] initram_data_le ;
wire    [31: 0] initram_data_bele ;
wire    [3: 0]  initram_byte_en_le ;
wire    [3: 0]  initram_byte_en_bele ;
wire    [31: 0] initram_addr_le;
wire    [31: 0] initram_addr_bele;
wire            ben_le_sel;

///////////////////////////////////////////////////
// Arrange iqmem data for LE and BE 
///////////////////////////////////////////////////
`ifdef BA22_ENDIANNESS
   assign ben_le_sel  = `BA22_ENDIANNESS;
`else
   assign ben_le_sel  = ben_le_sel_i;
`endif

   assign initram_data_le = {initram_data[7:0], initram_data[15:8], initram_data[23:16], initram_data[31:24]};
   assign initram_data_bele = (ben_le_sel) ? initram_data_le : initram_data;

   assign initram_byte_en_le = {initram_byte_en[0], initram_byte_en[1], initram_byte_en[2], initram_byte_en[3]};
   assign initram_byte_en_bele = (ben_le_sel) ? initram_byte_en_le : initram_byte_en;

   assign initram_addr_le = {initram_addr[31:3], ~initram_addr[2], initram_addr[1:0]};
   assign initram_addr_bele = (ben_le_sel) ? initram_addr_le : initram_addr;

   assign iqmem_stb     = initram_stb;
   assign iqmem_we      = initram_stb;
   assign iqmem_addr    = initram_addr_bele;

`ifdef BA22_QMEM_SEPARATED
   `ifdef BA22_IQMEM32_IMPLEMENTED
      assign iqmem_byte_en = initram_byte_en_bele;
      assign iqmem_wdata   = initram_data_bele;
   `else
      // 32bit init data -> 64bit data iqmem (upper or lower)
      assign iqmem_byte_en = (initram_addr_bele[2]) ? {4'h0, initram_byte_en_bele} :
                                                      {initram_byte_en_bele, 4'h0};
      assign iqmem_wdata   = (initram_addr_bele[2]) ? {32'h00000000, initram_data_bele} :
                                                      {initram_data_bele, 32'h00000000};
   `endif
`endif

`ifdef BA22_QMEM_UNIFIED_DP
   assign iqmem_byte_en = initram_byte_en_bele;
   assign iqmem_wdata   = initram_data_bele;
`endif

`ifdef BA22_QMEM_UNIFIED_SP
   assign iqmem_byte_en = initram_byte_en_bele;
   assign iqmem_wdata   = initram_data_bele;
`endif

endmodule
