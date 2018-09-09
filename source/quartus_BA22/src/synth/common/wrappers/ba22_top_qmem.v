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
//  File          : ba22_top_qmem.v
//
//  Dependencies  : ba22_top.v, qmem_arbiter.v, sram64.v, sram32.v, 
//                  tdpram8.v, tdpram32.v, tdpram64_32.v,
//                  ba22_constants, qmem_defines.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : Wrapper of ba22_top with qmem
//
//  Designer      : NS
//
//  QA Engineer   : JS
//
//  Creation Date : Sept 6, 2011
//
//  Last Update   : Sept 7, 2012
//
//  Version       : 1.04
//
//  File History  : March 28, 2012 (1.01) : Initial release
//                  April 05, 2012 (1.02) : dqmem_addr32 size for BA22_QMEM_SEPARATED
//                  April 30, 2012 (1.03) : combined sim and synth version
//                  Sept 7, 2012   (1.04) : Included BA22_IQMEM32_IMPLEMENTED
//
//----------------------------------------------------------------------

// INCLUDE QMEm_defines
//Write access port to the instruction memory if it is defined
`define EXT_IQMEM_WRITE

//-------------------------------------------------
// One one of the following should be defined to define the QMEM 
//-------------------------------------------------
`undef BA22_QMEM_SEPARATED    // 2 seperate SRAMS (one for I and one for D)
`undef BA22_QMEM_UNIFIED_SP   // QMEM Arbiter and 1 SRAM
`define BA22_QMEM_UNIFIED_DP     // 1 DPRAM

`ifdef BA22_QMEM_SEPARATED
   `define IQMEM_AW 13        // Address width for 64 bit I memory = 1k x 64 =64k bits
   `define DQMEM_AW 14        // Address width for 32 bit D memory = 2k x 32 =64k bits
`endif
`ifdef BA22_QMEM_UNIFIED_SP
   `define IDQMEM_AW 13       // Address width for 64 bit I memory with D 32 bit access =128K
                              // also accessible by 32 bit D
`endif
`ifdef BA22_QMEM_UNIFIED_DP
   `define IDQMEM_AW 13       // Address width for 64 bit I memory with D 32 bit access =128K
                              // also accessible by 32 bit D
`endif


//`include "timescale.v"
//`include "ba22_constants.v"
//`include "qmem_defines.v"

module ba22_top_qmem
(

    input               clk_i           ,
    input               rst_i           ,

 `ifdef EXT_IQMEM_WRITE
    input               iqmem_stb        ,
    input               iqmem_we         ,
    input   [31: 0]     iqmem_addr       ,
    `ifdef BA22_QMEM_SEPARATED 
       `ifdef BA22_IQMEM32_IMPLEMENTED
          input   [3: 0]      iqmem_byte_en    ,
          input   [31: 0]     iqmem_wdata      ,
       `else
          input   [7: 0]      iqmem_byte_en    ,
          input   [63: 0]     iqmem_wdata      ,
       `endif
    `else
       input   [3: 0]      iqmem_byte_en    ,
       input   [31: 0]     iqmem_wdata      ,
    `endif
 `endif

    input   [31: 0]     cpuid_i         ,
    input               boot_devsel_i   ,
    input               ben_le_sel_i    ,
`ifdef BA22_AHB
    input               dahb_clk_i      ,
    input               dahb_rstn_i     ,
    output  [31: 0]     dahb_addr_o     ,
    output  [ 1: 0]     dahb_trans_o    ,
    output              dahb_write_o    ,
    output  [ 2: 0]     dahb_size_o     ,
    output  [ 2: 0]     dahb_burst_o    ,
    output  [ 3: 0]     dahb_prot_o     ,
    output  [31: 0]     dahb_wdata_o    ,
    input   [31: 0]     dahb_rdata_i    ,
    input               dahb_ready_i    ,
    input   [ 1: 0]     dahb_resp_i     ,
    output              dahb_busreq_o   ,
    output              dahb_lock_o     ,
    input               dahb_grant_i    ,
   `ifdef BA22_CMMU
    input               iahb_clk_i      ,
    input               iahb_rstn_i     ,
    output  [31: 0]     iahb_addr_o     ,
    output  [ 1: 0]     iahb_trans_o    ,
    output              iahb_write_o    ,
    output  [ 2: 0]     iahb_size_o     ,
    output  [ 2: 0]     iahb_burst_o    ,
    output  [ 3: 0]     iahb_prot_o     ,
    output  [31: 0]     iahb_wdata_o    ,
    input   [31: 0]     iahb_rdata_i    ,
    input               iahb_ready_i    ,
    input   [ 1: 0]     iahb_resp_i     ,
    output              iahb_busreq_o   ,
    output              iahb_lock_o     ,
    input               iahb_grant_i    ,
   `endif
`else
    input               dwb_clk_i       ,       // wishbone clock
    input   [31: 0]     dwb_dat_i       ,       // input data bus
    input               dwb_ack_i       ,       // normal termination
    input               dwb_err_i       ,       // termination w/ error
    input               dwb_rty_i       ,       // termination w/ retry
    output  [31: 0]     dwb_adr_o       ,       // address bus outputs
    output  [31: 0]     dwb_dat_o       ,       // output data bus
    output              dwb_we_o        ,       // indicates write transfer
    output  [ 3: 0]     dwb_sel_o       ,       // byte select outputs
    output              dwb_stb_o       ,       // strobe output
    output              dwb_cyc_o       ,       // cycle valid output
    output  [ 2: 0]     dwb_cti_o       ,       // cycle type identifier
    output  [ 1: 0]     dwb_bte_o       ,       // burst type extension
    output              dwb_lock_o      ,
   `ifdef BA22_CMMU
    input   [31: 0]     iwb_dat_i       ,
    input               iwb_ack_i       ,
    input               iwb_err_i       ,
    input               iwb_rty_i       ,
    output  [31: 0]     iwb_adr_o       ,
    output  [31: 0]     iwb_dat_o       ,
    output              iwb_we_o        ,
    output  [ 3: 0]     iwb_sel_o       ,
    output              iwb_stb_o       ,
    output              iwb_cyc_o       ,
    output  [ 2: 0]     iwb_cti_o       ,
    output  [ 1: 0]     iwb_bte_o       ,
   `endif  //BA22_CMMU
`endif  //BA22_AHB
    input               dbg_stall_i     ,
    input               dbg_ewt_i       ,
    output  [ 3: 0]     dbg_lss_o       ,
    output  [ 1: 0]     dbg_is_o        ,
    output  [10: 0]     dbg_wp_o        ,
    output              dbg_bp_o        ,
    input               dbg_stb_i       ,
    input               dbg_we_i        ,
    input   [15: 0]     dbg_adr_i       ,
    input   [31: 0]     dbg_dat_i       ,
    output  [31: 0]     dbg_dat_o       ,
    output              dbg_ack_o       ,

    input   [`BA22_PIC_INTS-1: 0]   pic_int_i   ,

    input               pm_clk_i        ,
    input               pm_stall_i      ,
    output              pm_stalled_o    ,
    input   [ 7: 0]     pm_clmode_i     ,
    output              pm_event_o      ,

    input               du_clk_i        ,
    output              du_clk_en_o     ,
    input               rf_clk_i        ,
    output              rf_clk_en_o
) ;

wire            iqmem_stb_o ;
wire            iqmem_keep_o;
wire            iqmem_ack_i ;
wire            iqmem_err_i ;
wire    [31: 0] iqmem_adr_o ;
`ifdef BA22_IQMEM32_IMPLEMENTED
   wire [31:0] iqmem_dat_i;
`else
   wire [63:0] iqmem_dat_i;
`endif

wire            dqmem_stb_o ;
wire            dqmem_we_o  ;
wire    [ 3: 0] dqmem_sel_o ;
wire            dqmem_ack_i ;
wire            dqmem_err_i ;
wire    [31: 0] dqmem_adr_o ;
wire    [31: 0] dqmem_dat_i ;
wire    [31: 0] dqmem_dat_o ;


////////////////////////////////////////////////////////////////////////////////
// BA22_TOP instantiation/assignments
////////////////////////////////////////////////////////////////////////////////

ba22_top i_ba22_top
(

// System   
    .clk_i          (   clk_i           ),
    .rst_i          (   rst_i           ),
    .cpuid_i        (   cpuid_i         ),
    .boot_devsel_i  (   boot_devsel_i   ),
    .ben_le_sel_i   (   ben_le_sel_i    ),

    .trp_clk_o      (   ),
    .trp_vld_o      (   ),
    .trp_dat_o      (   ),

   `ifdef BA22_AHB
    .dahb_clk_i     (   dahb_clk_i      ),
    .dahb_rstn_i    (   dahb_rstn_i     ),
    .dahb_addr_o    (   dahb_addr_o     ),
    .dahb_trans_o   (   dahb_trans_o    ),
    .dahb_write_o   (   dahb_write_o    ),
    .dahb_size_o    (   dahb_size_o     ),
    .dahb_burst_o   (   dahb_burst_o    ),
    .dahb_prot_o    (   dahb_prot_o     ),
    .dahb_wdata_o   (   dahb_wdata_o    ),
    .dahb_rdata_i   (   dahb_rdata_i    ),
    .dahb_ready_i   (   dahb_ready_i    ),
    .dahb_resp_i    (   dahb_resp_i     ),
    .dahb_busreq_o  (   dahb_busreq_o   ),
    .dahb_lock_o    (   dahb_lock_o     ),
    .dahb_grant_i   (   dahb_grant_i    ),
    `ifdef BA22_CMMU
    .iahb_clk_i     (   iahb_clk_i      ),
    .iahb_rstn_i    (   iahb_rstn_i     ),
    .iahb_addr_o    (   iahb_addr_o     ),
    .iahb_trans_o   (   iahb_trans_o    ),
    .iahb_write_o   (   iahb_write_o    ),
    .iahb_size_o    (   iahb_size_o     ),
    .iahb_burst_o   (   iahb_burst_o    ),
    .iahb_prot_o    (   iahb_prot_o     ),
    .iahb_wdata_o   (   iahb_wdata_o    ),
    .iahb_rdata_i   (   iahb_rdata_i    ),
    .iahb_ready_i   (   iahb_ready_i    ),
    .iahb_resp_i    (   iahb_resp_i     ),
    .iahb_busreq_o  (   iahb_busreq_o   ),
    .iahb_lock_o    (   iahb_lock_o     ),
    .iahb_grant_i   (   iahb_grant_i    ),
    `endif
   `else
    // WISHBONE interface
    .dwb_clk_i      (   dwb_clk_i    ),
    .dwb_dat_i      (   dwb_dat_i   ),
    .dwb_ack_i      (   dwb_ack_i   ),
    .dwb_err_i      (   dwb_err_i   ),
    .dwb_rty_i      (   dwb_rty_i   ),
    .dwb_adr_o      (   dwb_adr_o   ),
    .dwb_dat_o      (   dwb_dat_o   ),
    .dwb_we_o       (   dwb_we_o    ),
    .dwb_sel_o      (   dwb_sel_o   ),
    .dwb_stb_o      (   dwb_stb_o   ),
    .dwb_cyc_o      (   dwb_cyc_o   ),
    .dwb_cti_o      (   dwb_cti_o   ),
    .dwb_bte_o      (   dwb_bte_o   ),
    .dwb_lock_o     (   dwb_lock_o  ),
    `ifdef BA22_CMMU
    .iwb_dat_i      (   iwb_dat_i   ),
    .iwb_ack_i      (   iwb_ack_i   ),
    .iwb_err_i      (   iwb_err_i   ),
    .iwb_rty_i      (   iwb_rty_i   ),
    .iwb_adr_o      (   iwb_adr_o   ),
    .iwb_dat_o      (   iwb_dat_o   ),
    .iwb_we_o       (   iwb_we_o    ),
    .iwb_sel_o      (   iwb_sel_o   ),
    .iwb_stb_o      (   iwb_stb_o   ),
    .iwb_cyc_o      (   iwb_cyc_o   ),
    .iwb_cti_o      (   iwb_cti_o   ),
    .iwb_bte_o      (   iwb_bte_o   ),
    `endif
   `endif  //BA22_AHB
// External Debug Interface
    .dbg_stall_i    ( dbg_stall_i  ),
    .dbg_ewt_i      ( dbg_ewt_i    ),
    .dbg_lss_o      ( dbg_lss_o    ),
    .dbg_is_o       ( dbg_is_o     ),
    .dbg_wp_o       ( dbg_wp_o     ),
    .dbg_bp_o       ( dbg_bp_o     ),
    .dbg_stb_i      ( dbg_stb_i    ),
    .dbg_we_i       ( dbg_we_i     ),
    .dbg_adr_i      ( dbg_adr_i    ),
    .dbg_dat_i      ( dbg_dat_i    ),
    .dbg_dat_o      ( dbg_dat_o    ),
    .dbg_ack_o      ( dbg_ack_o    ),
    
//Instruction QMEM
    .iqmem_ack_i    (   iqmem_ack_i ),
    .iqmem_err_i    (   iqmem_err_i ),
    .iqmem_dat_i    (   iqmem_dat_i ),
    .iqmem_stb_o    (   iqmem_stb_o ),
    .iqmem_keep_o   (   iqmem_keep_o),
    .iqmem_adr_o    (   iqmem_adr_o ),
    
//Data QMEM
    .dqmem_ack_i    (   dqmem_ack_i ),
    .dqmem_err_i    (   dqmem_err_i ),
    .dqmem_dat_i    (   dqmem_dat_i ),
    .dqmem_we_o     (   dqmem_we_o  ),
    .dqmem_stb_o    (   dqmem_stb_o ),
    .dqmem_sel_o    (   dqmem_sel_o ),
    .dqmem_adr_o    (   dqmem_adr_o ),
    .dqmem_dat_o    (   dqmem_dat_o ),

//PIC
    .pic_int_i      (   pic_int_i   ),

    .vct_int_i      (   1'b0        ),
    .vct_dat_i      (   32'd0       ),
// PM
    .pm_clk_i       (   pm_clk_i    ),
    .pm_stall_i     (   pm_stall_i  ),
    .pm_stalled_o   (   pm_stalled_o),
    .pm_clmode_i    (   pm_clmode_i ),
    .pm_event_o     (   pm_event_o  ),

    .du_clk_i       (   du_clk_i    ),
    .du_clk_en_o    (   du_clk_en_o ),
    .rf_clk_i       (   rf_clk_i    ),
    .rf_clk_en_o    (   rf_clk_en_o )
) ;

///////////////////////////////////////////////////////////////////////////////
// QMEM instantiation/assignments
// Address width - Memory size
// *QMEM_AW is the address width for byte access
// (for word and half word address, the i/dqmem_adrr need to be shifted)
// 16k memory  = 2kx8  (11 bits) or 512x32 (9 bits) or 256x64 (8 bits)   
// 32k memory  = 4kx8  (12 bits) or 1kx32 (10 bits) or 512x64 (9 bits)   
// 64k memory  = 8kx8  (13 bits) or 2kx32 (11 bits) or 1kx64 (10 bits)   
// 128k memory = 16kx8 (14 bits) or 4kx32 (12 bits) or 2kx64 (11 bits)   
// 256k memory = 32kx8 (15 bits) or 8kx32 (13 bits) or 4kx64 (12 bits)   
// 512k memory = 64kx8 (16 bits) or 16kx32(14 bits) or 8kx64 (13 bits)   
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////
// Arrange the dqmem and iqmem data for LE and BE 
///////////////////////////////////////////////////
wire    [31: 0] dqmem_addr_le;
wire    [31: 0] dqmem_addr;

`ifdef BA22_ENDIANNESS
   assign ben_le_sel  = `BA22_ENDIANNESS;
`else
   assign ben_le_sel  = ben_le_sel_i;
`endif

assign dqmem_addr_le = {dqmem_adr_o[31:3], ~dqmem_adr_o[2], dqmem_adr_o[1:0]};
assign dqmem_addr = (ben_le_sel) ? dqmem_addr_le : dqmem_adr_o;

// iqmem_stb_o -> for reading only;
assign iqmem_err_i = 1'b0  ;
assign dqmem_err_i = 1'b0  ;

`ifdef BA22_QMEM_SEPARATED

   wire dqmem_rd, dqmem_we;
   wire [`IQMEM_AW-1:0] iqmem_sep_addr;
   wire [`DQMEM_AW-1:0] dqmem_addr32;
   wire iqmem_sep_we;
   `ifdef BA22_IQMEM32_IMPLEMENTED
      wire [3:0] iqmem_sep_byte_en;
      wire [31:0] iqmem_sep_wdata;
      wire [3:0] byte_en_zero;
      wire [31:0] wdata_zero;
      assign byte_en_zero = 4'h0;
      assign wdata_zero = 32'd0;
   `else
      wire [7:0] iqmem_sep_byte_en;
      wire [63:0] iqmem_sep_wdata;
      wire [7:0] byte_en_zero;
      wire [63:0] wdata_zero;
      assign byte_en_zero = 8'h00;
      assign wdata_zero = 64'd0;
   `endif

   assign iqmem_ack_i = iqmem_stb_o;
   assign dqmem_ack_i = dqmem_stb_o;
   assign dqmem_rd = (dqmem_stb_o & !dqmem_we_o);
   assign dqmem_we = (dqmem_stb_o & dqmem_we_o);
   assign dqmem_addr32 = dqmem_addr[`DQMEM_AW+1:2];

  `ifdef EXT_IQMEM_WRITE
      assign iqmem_sep_we      = iqmem_we;
      assign iqmem_sep_byte_en = iqmem_byte_en;
      assign iqmem_sep_wdata   = iqmem_wdata;
    `ifdef BA22_IQMEM32_IMPLEMENTED
      assign iqmem_sep_addr    = (iqmem_we) ? iqmem_addr[`IQMEM_AW+1:2] : iqmem_adr_o[`IQMEM_AW+1:2];
    `else
      assign iqmem_sep_addr    = (iqmem_we) ? iqmem_addr[`IQMEM_AW+2:3] : iqmem_adr_o[`IQMEM_AW+2:3];
    `endif
  `else
      assign iqmem_sep_we      = 1'b0;
      assign iqmem_sep_byte_en = byte_en_zero;
      assign iqmem_sep_wdata   = wdata_zero;
    `ifdef BA22_IQMEM32_IMPLEMENTED
      assign iqmem_sep_addr    = iqmem_adr_o[`IQMEM_AW+1:2];
    `else
      assign iqmem_sep_addr    = iqmem_adr_o[`IQMEM_AW+2:3];
    `endif
  `endif

   // Instruction ROM
 `ifdef BA22_IQMEM32_IMPLEMENTED
   sram32 #(.ADDR_WIDTH (`IQMEM_AW))
 `else
   sram64 #(.ADDR_WIDTH (`IQMEM_AW))
 `endif
     u_iqmem (
      .clk       (clk_i),
      .rd        (iqmem_stb_o),
      .we        (iqmem_sep_we),
      .byte_en   (iqmem_sep_byte_en),
      .wdata     (iqmem_sep_wdata),
      .addr      (iqmem_sep_addr),
      .rdata     (iqmem_dat_i));  // 64-bit

   // Data RAM
   sram32 #(
      .ADDR_WIDTH (`DQMEM_AW))
     u_dqmem (
      .clk       (clk_i),
      .rd        (dqmem_rd),
      .we        (dqmem_we),
      .byte_en   (dqmem_sel_o),
      .addr      (dqmem_addr32),
      .wdata     (dqmem_dat_o),
      .rdata     (dqmem_dat_i));

`endif

`ifdef BA22_QMEM_UNIFIED_DP
   wire dqmem_rd, dqmem_we;
   wire tdpram_we32, tdpram_stb;
   wire [`IDQMEM_AW:0] tdpram_addr32;
   wire [3:0] tdpram_byte_enb32;
   wire [31:0] tdpram_wdata32;
   wire [`IDQMEM_AW-1:0] iqmem_addr_dp;

   assign iqmem_ack_i = iqmem_stb_o;
   assign dqmem_ack_i = dqmem_stb_o;

  `ifdef EXT_IQMEM_WRITE
      assign tdpram_byte_enb32 = (iqmem_we) ? iqmem_byte_en : dqmem_sel_o;
      assign tdpram_we32       = (iqmem_we) ? iqmem_we : dqmem_we_o;
      assign tdpram_addr32     = (iqmem_we) ? iqmem_addr[`IDQMEM_AW+2:2] : dqmem_addr[`IDQMEM_AW+2:2]; 
      assign tdpram_wdata32    = (iqmem_we) ? iqmem_wdata : dqmem_dat_o;
      assign tdpram_stb        = (iqmem_we) ? iqmem_stb : dqmem_stb_o;
  `else
      assign tdpram_byte_enb32 = dqmem_sel_o;
      assign tdpram_we32       = dqmem_we_o;
      assign tdpram_addr32     = dqmem_addr[`IDQMEM_AW+2:2]; 
      assign tdpram_wdata32    = dqmem_dat_o;
      assign tdpram_stb        = dqmem_stb_o;
  `endif

   assign dqmem_rd    = (tdpram_stb & !tdpram_we32);
   assign dqmem_we    = (tdpram_stb & tdpram_we32);

 `ifdef BA22_IQMEM32_IMPLEMENTED
   assign iqmem_addr_dp = iqmem_adr_o[`IDQMEM_AW+1:2];
   tdpram32 #(
      .ADDR_WIDTH   (`IDQMEM_AW))
      u_dpram32 (
        .clk        (clk_i),
        .we_a       (dqmem_we),
        .byte_en_a  (tdpram_byte_enb32),
        .addr_a     (tdpram_addr32[`IDQMEM_AW-1:0]),
        .wdata_a    (tdpram_wdata32),
        .rdata_a    (dqmem_dat_i),
        .we_b       (1'b0),
        .byte_en_b  (4'h0),
        .addr_b     (iqmem_addr_dp),
        .wdata_b    (32'd0),
        .rdata_b    (iqmem_dat_i));
 `else
   assign iqmem_addr_dp = iqmem_adr_o[`IDQMEM_AW+2:3];
   tdpram64_32 #(
      .ADDR_WIDTH   (`IDQMEM_AW))
      u_dpram64_32 (
        .clk         (clk_i),
        .rd_32       (dqmem_rd),
        .we_32       (dqmem_we),
        .byte_en_32  (tdpram_byte_enb32),
        .addr_32     (tdpram_addr32),
        .wdata_32    (tdpram_wdata32),
        .rdata_32    (dqmem_dat_i),
        .we_64       (1'b0),
        .byte_en_64  (8'h00),
        .addr_64     (iqmem_addr_dp),
        .wdata_64    (64'd0),
        .rdata_64    (iqmem_dat_i));  // 64-bit
 `endif
`endif

`ifdef BA22_QMEM_UNIFIED_SP

   wire qmem_stb;
   wire idqmem_ack;
   wire idqmem_stb;
 `ifdef BA22_IQMEM32_IMPLEMENTED
   wire [31:0] idqmem_rdata;
 `else
   wire [63:0] idqmem_rdata;
 `endif
   wire [7:0] idqmem_byte_en;
   wire [63:0] idqmem_wdata;   
   wire [31:0] idqmem_addr;
   wire idqmem_rd, idqmem_we;
   wire [`IDQMEM_AW-1:0] idqmem_addr_sp;
   wire iqmem_we_sp;
   wire [3:0] qmem_byte_enb;
   wire [31:0] qmem_wdata;
   wire [31:0] qmem_addr;
   wire qmem_we, dqmem_we;

   assign dqmem_we    = (dqmem_stb_o & dqmem_we_o);

  `ifdef EXT_IQMEM_WRITE
      assign qmem_stb      = (iqmem_we) ? iqmem_stb : dqmem_stb_o;
      assign qmem_byte_enb = (iqmem_we) ? iqmem_byte_en : dqmem_sel_o;
      assign qmem_we       = (iqmem_we) ? iqmem_we : dqmem_we;
      assign qmem_addr     = (iqmem_we) ? iqmem_addr : dqmem_addr; 
      assign qmem_wdata    = (iqmem_we) ? iqmem_wdata : dqmem_dat_o;
  `else
      assign qmem_stb      = dqmem_stb_o;
      assign qmem_byte_enb = dqmem_sel_o;
      assign qmem_we       = dqmem_we;
      assign qmem_addr     = dqmem_addr; 
      assign qmem_wdata    = dqmem_dat_o;
  `endif

  // qmem_arbiter:
  // writing section; data input 32 bit-> data out 64 bit
  //                  byte_en input 4 bit -> byte_en output 8 bit
  // arbitration logic only works for 0 delay memory
 `ifdef BA22_IQMEM32_IMPLEMENTED
   reg d_stb_r, i_stb_r;
   wire [3:0] idqmem_byte_en_sp;
   wire [31:0] idqmem_wdata_sp;

   assign idqmem_stb = dqmem_stb_o | iqmem_stb_o;
   assign idqmem_addr = (dqmem_stb_o)? dqmem_adr_o : iqmem_adr_o;

   always @(posedge clk)
   begin
      d_stb_r <= qmem_stb;
      i_stb_r <= iqmem_stb_o;
   end
 
   // mask when not valid to make easier to view
   assign iqmem_dat_i = (i_stb_r && !d_stb_r)? idqmem_rdata : {32{1'b0}};
   assign dqmem_dat_i = idqmem_rdata;
   assign dqmem_ack_i = (qmem_stb)? idqmem_ack : 1'b0;
   assign iqmem_ack_i = (iqmem_stb_o && !qmem_stb)? idqmem_ack : 1'b0;
   assign idqmem_addr_sp = idqmem_addr[`IDQMEM_AW+1:2];  //byte -> word address
   assign idqmem_byte_en_sp = qmem_byte_en;
   assign idqmem_wdata_sp = qmem_wdata;

 `else
    wire [7:0] idqmem_byte_en_sp;
    wire [63:0] idqmem_wdata_sp;

    qmem_arbiter   u_qmem_arbiter (
      .clk          (clk_i),
   // I PORT
      .i_stb        (iqmem_stb_o),  // active during reading
      .i_addr       (iqmem_adr_o),
      .i_rdata      (iqmem_dat_i),  // 64bit
      .i_ack        (iqmem_ack_i),
       // output
   // D PORT
      .d_stb        (qmem_stb),
      .d_byte_en    (qmem_byte_enb),  
      .d_addr       (qmem_addr),
       // output
      .d_rdata      (dqmem_dat_i),   //32bit
      .d_wdata      (qmem_wdata),  //32bit
      .d_ack        (dqmem_ack_i),
    // MEM PORT
      .mem_ack      (idqmem_ack),
      .mem_rdata    (idqmem_rdata),  //64bit
       // output
      .mem_stb      (idqmem_stb),  // dqmem_stb_o or iqmem_stb_o
      .mem_byte_en  (idqmem_byte_en),
      .mem_wdata    (idqmem_wdata),
      .mem_addr     (idqmem_addr)); // either dqmem_adr_o or iqmem_adr_o for byte

   assign idqmem_addr_sp = idqmem_addr[`IDQMEM_AW+2:3];  //byte -> word address
   assign idqmem_byte_en_sp = idqmem_byte_en;
   assign idqmem_wdata_sp = idqmem_wdata;

 `endif

   assign idqmem_rd = idqmem_stb & !qmem_we;
   assign idqmem_we = idqmem_stb & qmem_we;
   assign idqmem_ack = idqmem_stb;

 `ifdef BA22_IQMEM32_IMPLEMENTED
   sram32 #(.ADDR_WIDTH (`IDQMEM_AW)) u_idqmem (
 `else
   sram64 #(.ADDR_WIDTH (`IDQMEM_AW)) u_idqmem (
 `endif
    .clk     (clk_i),
    .rd      (idqmem_rd),
    .we      (idqmem_we),
    .byte_en (idqmem_byte_en_sp),
    .addr    (idqmem_addr_sp),
    .wdata   (idqmem_wdata_sp),
    .rdata   (idqmem_rdata));
`endif

endmodule
