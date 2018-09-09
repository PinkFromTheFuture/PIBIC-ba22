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
//  File          : bench.v
//
//  Dependencies  : ba22_top_qmem.v, initram32.v, monitor.v, qmem_ctrl.v,
//                  c_clgen.v, ahb_slave_behavioral.v, wb_slave_behavioral.v
//                  bench_defines.v, bench_constants.v, qmem_defines.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : Simple testbench module
//                     DUT instantiations
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
//                  April 30, 2012 (1.02) : Added qmem_ctrl module
//                  Sept  10, 2012 (1.04) : Include BA22_IQMEM32_IMPLEMENTED
//
//----------------------------------------------------------------------

`include "timescale.v"
`include "bench_defines.v"
`include "bench_constants.v"
`include "ba22_constants.v"
`include "qmem_defines.v"

module bench();

//`define BA22_CPU `BENCH.i_ba22_top_qmem.i_ba22_top.i_cpu

reg  [`BA22_PIC_INTS-1: 0]   pic_int_i       ;
wire  clk;
wire  rst;
wire  wb_rst;
wire  wb_clk_i;

`ifdef BA22_AHB
   wire                                dahb_clk_i      = clk   ;
   wire                                dahb_rstn_i     = rst   ;
   wire    [ `BA22_AHB_ADDR_RANGE  ]   dahb_addr_o     ; 
   wire    [ `BA22_AHB_HTRANS_RANGE]   dahb_trans_o    ;
   wire                                dahb_write_o    ;
   wire    [ `BA22_AHB_HSIZE_RANGE ]   dahb_size_o     ;
   wire    [ `BA22_AHB_HBURST_RANGE]   dahb_burst_o    ;
   wire    [ `BA22_AHB_HPROT_RANGE ]   dahb_prot_o     ;
   wire    [ `BA22_AHB_WDATA_RANGE ]   dahb_wdata_o    ;
   wire    [ `BA22_AHB_RDATA_RANGE ]   dahb_rdata_i    ;
   wire                                dahb_ready_i    ;
   wire    [ `BA22_AHB_HRESP_RANGE ]   dahb_resp_i     ;
   wire                                dahb_busreq_o   ;
   wire                                dahb_lock_o     ;
   wire                                dahb_grant_i    ;
   wire                                iahb_clk_i      = clk   ;
   wire                                iahb_rstn_i     = rst   ;
   wire    [ `BA22_AHB_ADDR_RANGE  ]   iahb_addr_o     ; 
   wire    [ `BA22_AHB_HTRANS_RANGE]   iahb_trans_o    ;
   wire                                iahb_write_o    ;
   wire    [ `BA22_AHB_HSIZE_RANGE ]   iahb_size_o     ;
   wire    [ `BA22_AHB_HBURST_RANGE]   iahb_burst_o    ;
   wire    [ `BA22_AHB_HPROT_RANGE ]   iahb_prot_o     ;
   wire    [ `BA22_AHB_WDATA_RANGE ]   iahb_wdata_o    ;
   wire    [ `BA22_AHB_RDATA_RANGE ]   iahb_rdata_i    ;
   wire                                iahb_ready_i    ;
   wire    [ `BA22_AHB_HRESP_RANGE ]   iahb_resp_i     ;
   wire                                iahb_busreq_o   ;
   wire                                iahb_lock_o     ;
   wire                                iahb_grant_i    ;
`endif

wire    [31: 0] dwb_dat_i   ;
wire            dwb_ack_i   ;
wire            dwb_err_i   ;
wire            dwb_rty_i   ;
wire    [31: 0] dwb_adr_o   ;
wire    [31: 0] dwb_dat_o   ;
wire            dwb_we_o    ;
wire    [ 3: 0] dwb_sel_o   ;
wire            dwb_stb_o   ;
wire            dwb_cyc_o   ;
wire    [ 2: 0] dwb_cti_o   ;
wire    [ 1: 0] dwb_bte_o   ;

wire    [31: 0] iwb_dat_i   ;
wire            iwb_ack_i   ;
wire            iwb_err_i   ;
wire            iwb_rty_i   ;
wire    [31: 0] iwb_adr_o   ;
wire    [31: 0] iwb_dat_o   ;
wire            iwb_we_o    ;
wire    [ 3: 0] iwb_sel_o   ;
wire            iwb_stb_o   ;
wire            iwb_cyc_o   ;
wire    [ 2: 0] iwb_cti_o   ;
wire    [ 1: 0] iwb_bte_o   ;

wire            pm_stall_i      ;
wire            pm_stalled_o    ;
wire            pm_event_o      ;
wire            du_clk_en_o  ;
wire            rf_clk_en_o  ;
wire [8-1: 0]   pm_fscale_o     ;
wire [32-1: 0]  pm_freq_i       = 32'hd15ab1ed;
wire [8-1: 0]   pm_clmode_i     ;

reg             du_clk_en   ;
reg             rf_clk_en   ;

wire [63:0]     idqmem_wdata;
reg             start_load, clk_load;
wire            clk_mux;
wire            load_done;
wire [31:0]     initram_addr;
wire [31:0]     initram_data;
wire [3:0]      initram_byte_en;
reg             initram_stb;
wire [`BA22_PIC_INTS-1:0] int_val;

wire iqmem_stb, iqmem_we;
wire [31: 0] iqmem_addr;
`ifdef BA22_QMEM_SEPARATED
   `ifdef BA22_IQMEM32_IMPLEMENTED
      wire [3: 0]  iqmem_byte_en;
      wire [31: 0] iqmem_wdata;
   `else
      wire [7: 0]  iqmem_byte_en_64;
      wire [63: 0] iqmem_wdata_64;
   `endif
`else
   wire [3: 0]  iqmem_byte_en;
   wire [31: 0] iqmem_wdata;
`endif

wire    du_clk_i    = du_clk_en ? clk : 1'b0  ;
wire	rf_clk_i    = rf_clk_en & clk;

always @(negedge clk)
    du_clk_en   <= du_clk_en_o  ;

always @(negedge clk)
    rf_clk_en   <= rf_clk_en_o  ;

assign wb_rst = rst;

wire ben_le_sel = 1'b0;


////////////////////////////////////////////////////////////////////////////////
// Testbench initialization
////////////////////////////////////////////////////////////////////////////////
initial 
begin : initbench
//   `BA22_CPU.i_ba22_sys.i_reg_eea.q = 32'h0000_0000;
//   `BA22_CPU.i_ba22_sys.i_reg_epc.q = 32'h0000_0000;
//   `BA22_CPU.i_ba22_sys.reg_esr_q   = 16'h8001     ;
   `BENCH.i_clgen.rst_do;
   clk_load = 1'b1;
   start_load = 1'b0;
   @ (posedge clk_load);
   #(`DELAY) start_load = 1'b1;
   @ (posedge clk_load);
   #(`DELAY) start_load = 1'b0;
   @ (posedge clk_load & load_done);
   @ (posedge clk_load);
   @ (posedge clk_load);
   `BENCH.i_clgen.rst_done;
end

always
begin
   #20 clk_load = ~clk_load;
   if (load_done)
   begin
      #20 clk_load = ~clk_load;
      #20 clk_load = ~clk_load;
      #20 clk_load = ~clk_load;
      #20 clk_load = ~clk_load;
      #20 clk_load = ~clk_load;
      #20 clk_load = ~clk_load;
      #20 clk_load = ~clk_load;
      #20 clk_load = ~clk_load;
      #20 clk_load = ~clk_load;
      clk_load = 1'b0;
      forever #100000;
   end
end

//---------------------
// interrupt activity
//---------------------
initial
begin : init_interrupt
   pic_int_i = {`BA22_PIC_INTS{1'b0}};
   wait (int_val == {`BA22_PIC_INTS{1'b0}});
   begin : pic_loop
      integer i;
      for (i=0; i < `BA22_PIC_INTS; i=i+1)
      begin
         pic_int_i[i] = 1'b1;
         `ifdef DEBUG_PRINT $display ($stime, "ns  PIC_INTERRUPT is Active %b", pic_int_i); `endif
         wait (int_val[i] == 1'b1);
         pic_int_i[i] = 1'b0;
         #1000 pic_int_i[i] = 1'b0;
         `ifdef DEBUG_PRINT $display ($stime, "ns  PIC_INTERRUPT is Inactive %b", pic_int_i); `endif
      end
   end
end
     
//-------------------------------------
// reading instruction data from a file
//-------------------------------------
initram32 #(.DELAY (`DELAY ))
  u_initram32(
    .clk (clk_load),
    .start_load (start_load),
    .addr (initram_addr),
    .data (initram_data),  //32 bit
    .byte_en (initram_byte_en),  // 4bit
    .load_done (load_done)
);

// use for writing enable of initram data to sram
always @(posedge clk_load)
begin
   if (start_load)
      initram_stb <= 1'b1;
   else if (load_done)
      initram_stb <= 1'b0;
end

assign clk_mux = (!load_done) ? clk_load : clk;

////////////////////////////////////////////////////////////////////////////////
// BA22_TOP instantiation/assignments
////////////////////////////////////////////////////////////////////////////////

`ifdef EXT_IQMEM_WRITE
qmem_ctrl u_qmem_ctrl
(
    .initram_addr    (initram_addr),
    .initram_data    (initram_data),
    .initram_byte_en (initram_byte_en),
    .initram_stb     (initram_stb),
    .ben_le_sel_i    (ben_le_sel),
    .iqmem_stb       (iqmem_stb),
    .iqmem_we        (iqmem_we),
   `ifdef BA22_QMEM_SEPARATED
      `ifdef BA22_IQMEM32_IMPLEMENTED
         .iqmem_byte_en   (iqmem_byte_en),
         .iqmem_wdata     (iqmem_wdata),
      `else
         .iqmem_byte_en   (iqmem_byte_en_64),
         .iqmem_wdata     (iqmem_wdata_64),
      `endif
   `else
    .iqmem_byte_en   (iqmem_byte_en),
    .iqmem_wdata     (iqmem_wdata),
   `endif
    .iqmem_addr      (iqmem_addr)
);
`endif

ba22_top_qmem i_ba22_top_qmem
(

// System   
    .clk_i                (clk_mux),
    .rst_i                (rst),

`ifdef EXT_IQMEM_WRITE
    .iqmem_stb            (iqmem_stb),
    .iqmem_we             (iqmem_we),
    .iqmem_addr           (iqmem_addr),
   `ifdef BA22_QMEM_SEPARATED
      `ifdef BA22_IQMEM32_IMPLEMENTED
         .iqmem_byte_en    (iqmem_byte_en),
         .iqmem_wdata      (iqmem_wdata),
      `else
         .iqmem_byte_en    (iqmem_byte_en_64),
         .iqmem_wdata      (iqmem_wdata_64),
      `endif
   `else
      .iqmem_byte_en       (iqmem_byte_en),
      .iqmem_wdata         (iqmem_wdata),
   `endif
`endif

    .cpuid_i               (0),
    .boot_devsel_i         (1'b0),
    .ben_le_sel_i          (ben_le_sel),

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
    .dwb_clk_i      (   wb_clk_i    ),
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
    .dwb_lock_o     (               ),
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
`endif
// External Debug Interface
    .dbg_stall_i    ( 1'b0 ), 
    .dbg_ewt_i      ( 1'b0 ),
    .dbg_lss_o      (   ),
    .dbg_is_o       (   ),
    .dbg_wp_o       (   ),
    .dbg_bp_o       (   ),
    .dbg_stb_i      ( 1'b0  ),
    .dbg_we_i       ( 1'b0  ),
    .dbg_adr_i      ( 16'd0  ),
    .dbg_dat_i      ( 32'd0  ),
    .dbg_dat_o      (   ),
    .dbg_ack_o      (   ),
    
//PIC
    .pic_int_i      (   pic_int_i   ),
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
// Clock/reset instantiation/assignments
////////////////////////////////////////////////////////////////////////////////
c_clgen #(
    .ref_clk_per    (   `BA_BENCH_REF_CLK_PER         ),
    .clk_div        (   `BA_BENCH_DEFAULT_CPU_CLK_DIV ),
    .pm_clk_div     (   `BA_BENCH_PM_CLK_DIV          ))
 i_clgen (
    .rst_o       (   rst        ),
    .pm_clk_o    (   pm_clk_i   ),
    .clk_o       (   clk        ),
    .wb_clk_o    (   wb_clk_i   )
`ifdef BA22_PM_IMPLEMENTED
    ,
    .pm_stall_o  (  pm_stall_i  ),
    .pm_stalled_i(  pm_stalled_o)
`endif
);

///////////////////////////////////////////////////////////////////////////////
// AHB SLAVE instantiation/assignments
///////////////////////////////////////////////////////////////////////////////
`ifdef BA22_IAHB_IMPLEMENTED

   wire iahb_grant_i_nd, iahb_ready_i_nd;
   wire [ `BA22_AHB_HRESP_RANGE ] iahb_resp_i_nd     ;
   wire [ `BA22_AHB_RDATA_RANGE ] iahb_rdata_i_nd    ;

    ahb_slave_behavioral #(
        .ahb_monitor    (   1'b0            )
    )i_iahbs(
        .ahb_clk_i      (   iahb_clk_i      ),
        .ahb_rstn_i     (   iahb_rstn_i     ),

        .ahb_hgrant_o   (   iahb_grant_i_nd ),
        .ahb_hready_o   (   iahb_ready_i_nd ),
        .ahb_hresp_o    (   iahb_resp_i_nd  ),
        .ahb_hrdata_o   (   iahb_rdata_i_nd ),

        .ahb_hbusreq_i  (   iahb_busreq_o   ),
        .ahb_htrans_i   (   iahb_trans_o    ),
        .ahb_haddr_i    (   iahb_addr_o     ),
        .ahb_hwrite_i   (   iahb_write_o    ),
        .ahb_hsize_i    (   iahb_size_o     ),
        .ahb_hburst_i   (   iahb_burst_o    ),
        .ahb_hprot_i    (   iahb_prot_o     ),
        .ahb_hlock_i    (   iahb_lock_o     ),
        .ahb_hwdata_i   (   iahb_wdata_o    )
    );

    assign #`OUTPUT_DELAY iahb_grant_i = iahb_grant_i_nd;
    assign #`OUTPUT_DELAY iahb_ready_i = iahb_ready_i_nd;
    assign #`OUTPUT_DELAY iahb_resp_i  = iahb_resp_i_nd;
    assign #`OUTPUT_DELAY iahb_rdata_i = iahb_rdata_i_nd;
`endif

`ifdef BA22_DAHB_IMPLEMENTED
   wire dahb_grant_i_nd, dahb_ready_i_nd;
   wire [ `BA22_AHB_HRESP_RANGE ] dahb_resp_i_nd     ;
   wire [ `BA22_AHB_RDATA_RANGE ] dahb_rdata_i_nd    ;

    ahb_slave_behavioral #(
        .ahb_monitor    (   1'b0            )
    )i_dahbs(
        .ahb_clk_i      (   dahb_clk_i      ),
        .ahb_rstn_i     (   dahb_rstn_i     ),       
    
        .ahb_hgrant_o   (   dahb_grant_i_nd ), 
        .ahb_hready_o   (   dahb_ready_i_nd ), 
        .ahb_hresp_o    (   dahb_resp_i_nd  ), 
        .ahb_hrdata_o   (   dahb_rdata_i_nd ), 

        .ahb_hbusreq_i  (   dahb_busreq_o   ), 
        .ahb_htrans_i   (   dahb_trans_o    ), 
        .ahb_haddr_i    (   dahb_addr_o     ), 
        .ahb_hwrite_i   (   dahb_write_o    ), 
        .ahb_hsize_i    (   dahb_size_o     ), 
        .ahb_hburst_i   (   dahb_burst_o    ), 
        .ahb_hprot_i    (   dahb_prot_o     ), 
        .ahb_hlock_i    (   dahb_lock_o     ),
        .ahb_hwdata_i   (   dahb_wdata_o    )
    );    
    assign #`OUTPUT_DELAY dahb_grant_i = dahb_grant_i_nd;
    assign #`OUTPUT_DELAY dahb_ready_i = dahb_ready_i_nd;
    assign #`OUTPUT_DELAY dahb_resp_i  = dahb_resp_i_nd;
    assign #`OUTPUT_DELAY dahb_rdata_i = dahb_rdata_i_nd;
`endif

///////////////////////////////////////////////////////////////////////////////
// WISHBONE SLAVE instantiation/assignments
///////////////////////////////////////////////////////////////////////////////
`ifdef BA22_IWB_IMPLEMENTED

   wire iwb_ack_i_nd;
   wire [31:0] iwb_dat_i_nd;

// no ERR_O(iwb_err_i), RTY_O(iwb_rty_i), CTI_I(iwb_cti_o), and BTE_I(iwb_bte_o)
//  90000000-900000FF - port -> monitor
//  90000100-900001FF - goes to Cache ram.
   assign iwb_err_i = 1'b0;
   assign iwb_rty_i = 1'b0;

   wb_slave_behavioral i_iwbs(
        .clk_i  (   wb_clk_i    ),
        .rst_i  (   wb_rst      ),
        .ack_o  (   iwb_ack_i_nd),
        .adr_i  (   iwb_adr_o   ),
        .cyc_i  (   iwb_cyc_o   ),
        .dat_o  (   iwb_dat_i_nd),
        .dat_i  (   iwb_dat_o   ),
        .sel_i  (   iwb_sel_o   ),
        .stb_i  (   iwb_stb_o   ),
        .we_i   (   iwb_we_o    ));

    assign #`OUTPUT_DELAY iwb_ack_i = iwb_ack_i_nd;
    assign #`OUTPUT_DELAY iwb_dat_i = iwb_dat_i_nd;

`endif

`ifdef BA22_DWB_IMPLEMENTED
   wire dwb_ack_i_nd;
   wire [31:0] dwb_dat_i_nd;

   assign dwb_err_i = 1'b0;
   assign dwb_rty_i = 1'b0;
   wb_slave_behavioral i_dwbs(
        .clk_i  (   wb_clk_i    ),
        .rst_i  (   wb_rst      ),
        .ack_o  (   dwb_ack_i_nd),
        .adr_i  (   dwb_adr_o   ),
        .cyc_i  (   dwb_cyc_o   ),
        .dat_o  (   dwb_dat_i_nd),
        .dat_i  (   dwb_dat_o   ),
        .sel_i  (   dwb_sel_o   ),
        .stb_i  (   dwb_stb_o   ),
        .we_i   (   dwb_we_o    ));

    assign #`OUTPUT_DELAY dwb_ack_i = dwb_ack_i_nd;
    assign #`OUTPUT_DELAY dwb_dat_i = dwb_dat_i_nd;

`endif

//////////////////////////////////
// MONITOR - QMEM and AHB/WB Bus
//////////////////////////////////
monitor  u_monitor(
   .clk         (clk),
   .rst_i       (rst),
   .iqmem_stb   (i_ba22_top_qmem.iqmem_stb_o),
   .iqmem_ack   (i_ba22_top_qmem.iqmem_ack_i),
   .dqmem_ack   (i_ba22_top_qmem.dqmem_ack_i),
   .iqmem_data  (i_ba22_top_qmem.iqmem_dat_i),
   .dqmem_data  (i_ba22_top_qmem.dqmem_dat_i),
   .dqmem_wdata (i_ba22_top_qmem.dqmem_dat_o),
   .iqmem_addr  (i_ba22_top_qmem.iqmem_adr_o),
   `ifdef BA22_QMEM_UNIFIED_SP
   .mem_addr    (i_ba22_top_qmem.idqmem_addr),
   `endif
   .dqmem_addr  (i_ba22_top_qmem.dqmem_adr_o),
   .dqmem_we    (i_ba22_top_qmem.dqmem_we_o),
   .intr        (int_val)
  );


endmodule
