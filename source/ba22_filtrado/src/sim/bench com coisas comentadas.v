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
//  Dependencies  : ba22_top_qmem.v, .v, monitor.v, qmem_ctrl.v,
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



//`include "timescale.v"
// `include "bench_defines.v"
// `include "bench_constants.v"
// `include "ba22_constants.v"
// `include "qmem_defines.v"

/*path laico: */
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/synth/common/ba22/timescale.v"
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/sim/bench_defines.v"
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/sim/bench_constants.v"
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/synth/common/ba22/ba22_constants.v"
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/synth/config/de_fpu32_dfchip/qmem_defines.v"


/*path casa: */
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/synth/common/ba22/timescale.v"
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/sim/bench_defines.v"
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/sim/bench_constants.v"
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/synth/common/ba22/ba22_constants.v"
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/synth/config/de_fpu32_dfchip/qmem_defines.v"


/*path relativo: */
`include "../synth/common/ba22/timescale.v"
`include "./bench_defines.v"
`include "./bench_constants.v"
`include "../synth/common/ba22/ba22_constants.v"
`include "../synth/config/de_fpu32_dfchip/qmem_defines.v"

module bench(
		// input CLOCK_50, 	//clock da placa
		// input [0:0] KEY, 	//o botão de reset da placa - só liga ele no clockgen
		// input [0:0] SW, //switch da placa para o clock ir rápido(normal) ou lento.
		// output [3:0] LEDG, //vou mostrar o load_done aqui
		// output [9:0] LEDR
	);
	
//simulação:	
	reg CLOCK_50; //clock da placa //CLOCK_50
	reg KEY; //o botão de reset da placa - só liga ele no clockgen //KEY
	reg [0:0] SW;
	wire [3:0] LEDG;
	wire [9:0] LEDR;
	
	initial	
	begin : initclock
		CLOCK_50 =1'b0;
		SW [0] = 1'b0;
		KEY = 1'b0; //reset ativo
		#60 KEY = 1'b1; //reset volta pra 1 (desapertado) depois de alguns instantes
	end
	
	always
	#30 CLOCK_50 = ~CLOCK_50;  //a cada 30ns chaveio o clock. o periodo dele é 60ns
	
always @(posedge CLOCK_50)
begin
	if(KEY == 0) begin
		CLOCK_LENTO		= 1'b0;
		clock_slower	= 18'b000000000000000000;
	end
	else begin
		if ( SW == 0 ) begin
			// CLOCK_LENTO <= CLOCK_50;
			CLOCK_LENTO <= ~CLOCK_LENTO;
		end
		if ( SW == 1 ) begin
			if( clock_slower == 18'b111101000010010000 ) begin //250000
				// CLOCK_LENTO <= CLOCK_50;
				CLOCK_LENTO <= ~CLOCK_LENTO;
				clock_slower = 0;
			end
			// else begin
				clock_slower = clock_slower + 1;
			// end
		end
	end
end

assign LEDG[3] = CLOCK_LENTO;
assign LEDG[2] =  start_load;


//`define BA22_CPU `BENCH.i_ba22_top_qmem.i_ba22_top.i_cpu

reg 	CLOCK_LENTO;
reg		[17:0] clock_slower; //contador que vai fazer o clock ir mais lento para ver o programa executar na máquina. vai de 0 a 250000 para fazer a simulação rodar em aprox 1 minuto ao invés de 0.00024s




reg  [`BA22_PIC_INTS-1: 0]   pic_int_i       ;
wire  clk;
wire  rst;
wire  wb_rst; //reset do whishbone
//wire  wb_clk_i; //clock do whishbone

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
// reg          clk_load;
wire 			clk_load; // troco para wire porque faço um assign para que seja usado o mesmo clk pra tudo, o da placa.
reg				start_load;
reg [2:0]		count_delay;
reg				count_delay_en;
wire            clk_mux;
wire            load_done;
wire [31:0]     initram_addr;
wire [31:0]     initram_data;
wire [3:0]      initram_byte_en;
wire             initram_stb;
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



`ifdef BA22_QMEM_UNIFIED_SP //parece que não está definido
wire 	[31:0] 	idqmem_addr	;
`endif
wire            iqmem_stb_o ;
wire            iqmem_ack_i ;
wire    [31: 0] iqmem_adr_o ;
`ifdef BA22_IQMEM32_IMPLEMENTED
   wire [31:0] 	iqmem_dat_i	;
`else
   wire [63:0] 	iqmem_dat_i	;
`endif
wire            dqmem_we_o  ;
wire            dqmem_ack_i ;
wire    [31: 0] dqmem_adr_o ;
wire    [31: 0] dqmem_dat_i ;
wire    [31: 0] dqmem_dat_o ;




////////////////////////////////////////////////////////////////
//// conexão entre a ROM e a RAM
////////////////////////////////////////////////////////////////
wire [13:0] addr_rom; //o default é 14 bits, então auqi deixo 13 down to 1. o certo seria fazer parametrizado...
wire [31:0] data_rom;

////////////////////////////////////////////////////////////////////////////////
// Testbench initialization
////////////////////////////////////////////////////////////////////////////////





	
// assign clk_load = (!load_done) ? CLOCK_50 : 0; //por simplicidade utilizo o clock da placa como clock para carregar na memória. quando acaba o load, esse clock para.
assign clk_load = (!load_done) ? CLOCK_LENTO : 0; //por simplicidade utilizo o clock da placa como clock para carregar na memória. quando acaba o load, esse clock para.
assign LEDG[0] = load_done;
assign LEDG[1] = SW[0];


/* initial 
begin : initbench
//   `BA22_CPU.i_ba22_sys.i_reg_eea.q = 32'h0000_0000;
//   `BA22_CPU.i_ba22_sys.i_reg_epc.q = 32'h0000_0000;
//   `BA22_CPU.i_ba22_sys.reg_esr_q   = 16'h8001     ;
   //`BENCH.i_clgen.rst_do;
   clk_load = 1'b1;
   start_load = 1'b0;
   @ (posedge clk_load);
   #(`DELAY) start_load = 1'b1;
   @ (posedge clk_load);
   #(`DELAY) start_load = 1'b0;
   @ (posedge clk_load & load_done);
   @ (posedge clk_load);
   @ (posedge clk_load);
   //`BENCH.i_clgen.rst_done;
end */


	


/* always
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
end */

//---------------------
// interrupt activity
//---------------------
initial
begin : init_interrupt
	pic_int_i = 0;
   // pic_int_i = {`BA22_PIC_INTS{1'b0}};
   // wait (int_val == {`BA22_PIC_INTS{1'b0}});
   // begin : pic_loop
      // integer i;
      // for (i=0; i < `BA22_PIC_INTS; i=i+1)
      // begin
         // pic_int_i[i] = 1'b1;
         // `ifdef DEBUG_PRINT $display ($stime, "ns  PIC_INTERRUPT is Active %b", pic_int_i); `endif
         // wait (int_val[i] == 1'b1);
         // pic_int_i[i] = 1'b0;
         // #1000 pic_int_i[i] = 1'b0;
         // `ifdef DEBUG_PRINT $display ($stime, "ns  PIC_INTERRUPT is Inactive %b", pic_int_i); `endif
      // end
   // end
end
     
//-------------------------------------
// reading instruction data from a file
//-------------------------------------
//Instanciar o modulo da rom (ROM_ba22) - tem parametro do ADDR_WIDTH que é 14 default (14 bits = 16kb)
//instanciar o initram32 que eu fiz - não tem parametros


ROM_ba22 #(.ADDR_WIDTH (14) )
u_rom (
	.clk ( clk_load ),  //in
	.addr ( addr_rom ), //in //?? passo endereço inicial? como 0?
	.data_out ( data_rom ) //out //wire [31:0] initram_data;
);	

initram32 u_initram32(
	.clk (clk_load) , //in 
	.rst (start_load) , //in
	.data_out_rom ( data_rom ) , //input [31:0] 
	.addr_rom ( addr_rom ) , //output reg [13:0] //aqui é variavel, o default é 14 bits. 
	.addr_ram (initram_addr) , //output reg [13:0] //fixo pq a ram tem sempre 32 bits
	.data_in_ram (initram_data) , //output reg [31:0] 
	.byte_en (initram_byte_en),  // 4bit  //out
	//.we (  ), //output reg //isso ja esta ai em baixo
	.load_done(load_done) //output reg 
);	

// initram32 #(.DELAY (`DELAY ))
  // u_initram32(
    // .clk (clk_load), 			//in
    // .start_load (start_load),  //in //reg start_load
    // .addr (initram_addr),  //out
    // .data (initram_data),  //32 bit  //out
    // .byte_en (initram_byte_en),  // 4bit  //out
    // .load_done (load_done) //out
// );


always @(posedge clk_load)
begin
	if(KEY == 0) begin
		count_delay 	= 0;
		count_delay_en 	= 1'b1;
		start_load 		= 1'b0;
	end
	else begin
		if (count_delay_en == 1 ) begin
			count_delay = count_delay + 1;
		end
		if (count_delay > 6) begin
			count_delay_en = 1'b0;
		end
		else begin
			count_delay_en = 1'b1;
		end
		if ((count_delay > 2) && (count_delay < 5)) begin
			start_load = 1'b1;
		end
		else begin
			start_load = 1'b0;
		end
		// if (load_done == 1'b1) begin
			// initram_stb <= 1'b0;
		// end
		// else begin
			// initram_stb <= 1'b1;
		// end
		
		
		
		
		
	end
end //end always

assign initram_stb = ~load_done;

// use for writing enable of initram data to sram -------- feito acima
// always @(posedge clk_load)
// begin
   // if (start_load)
      // initram_stb <= 1'b1;
   // else if (load_done)
      // initram_stb <= 1'b0;
// end

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

//`ifdef BA22_AHB
    .dahb_clk_i     (   clk     ),
    .dahb_rstn_i    (   1'b1     ),
    
    .dahb_addr_o    (       ),
    // .dahb_addr_o    (   dahb_addr_o     ),
    .dahb_trans_o   (   dahb_trans_o    ),
    .dahb_write_o   (   dahb_write_o    ),
    .dahb_size_o    (   dahb_size_o     ),
    .dahb_burst_o   (       ),
    // .dahb_burst_o   (   dahb_burst_o    ),
    .dahb_prot_o    (   dahb_prot_o     ),
    
    .dahb_wdata_o   (   dahb_wdata_o    ),
    .dahb_rdata_i   (   0    ),
    
    .dahb_ready_i   (   1'b1    ),
    .dahb_resp_i    (   2'b00     ),
    
    .dahb_busreq_o  (      ),
    // .dahb_busreq_o  (   dahb_busreq_o   ),
    .dahb_lock_o    (        ),
    // .dahb_lock_o    (   dahb_lock_o     ),
    .dahb_grant_i   (   1'b1    ),
    
    // `ifdef BA22_CMMU
    // .iahb_clk_i     (   iahb_clk_i      ),
    // .iahb_rstn_i    (   iahb_rstn_i     ),
    
    // .iahb_addr_o    (   iahb_addr_o     ),
    // .iahb_trans_o   (   iahb_trans_o    ),
    // .iahb_write_o   (   iahb_write_o    ),
    // .iahb_size_o    (   iahb_size_o     ),
    // .iahb_burst_o   (   iahb_burst_o    ),
    // .iahb_prot_o    (   iahb_prot_o     ),
    
    // .iahb_wdata_o   (   iahb_wdata_o    ),
    // .iahb_rdata_i   (   iahb_rdata_i    ),
    
    // .iahb_ready_i   (   iahb_ready_i    ),
    // .iahb_resp_i    (   iahb_resp_i     ),
    
    // .iahb_busreq_o  (   iahb_busreq_o   ),
    // .iahb_lock_o    (   iahb_lock_o     ),
    // .iahb_grant_i   (   iahb_grant_i    ),
    // `endif
//`else
// WISHBONE interface


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
    .rf_clk_en_o    (   rf_clk_en_o ),
	

//ligação direta:	
	.iqmem_stb_o		( iqmem_stb_o	),
	.iqmem_ack_i		( iqmem_ack_i	),
	.dqmem_ack_i		( dqmem_ack_i	),
	.iqmem_dat_i		( iqmem_dat_i	),
	.dqmem_dat_i		( dqmem_dat_i	),
	.dqmem_dat_o		( dqmem_dat_o	),
	.iqmem_adr_o		( iqmem_adr_o	),
	`ifdef BA22_QMEM_UNIFIED_SP //parece que não está definido
		.idqmem_addr	( idqmem_addr	),
	`endif
	.dqmem_adr_o		( dqmem_adr_o	),
	.dqmem_we_o			( dqmem_we_o	)
) ;


///////////////////////////////////////////////////////////////////////////////
// Clock/reset instantiation/assignments
////////////////////////////////////////////////////////////////////////////////
// c_clgen #(
    // .ref_clk_per    (   `BA_BENCH_REF_CLK_PER         ), //parametro, default: 0.0 | passado: 60
    // .clk_div        (   `BA_BENCH_DEFAULT_CPU_CLK_DIV ), //parametro, default: 0	  | passado: 4
    // .pm_clk_div     (   `BA_BENCH_PM_CLK_DIV          )) //parametro, default: 0	  | passado: 4
 // i_clgen (
    // .rst_o       (   rst        ),
    // .pm_clk_o    (   pm_clk_i   ),
    // .clk_o       (   clk        )
// `ifdef BA22_PM_IMPLEMENTED
    // ,
    // .pm_stall_o  (  pm_stall_i  ),
    // .pm_stalled_i(  pm_stalled_o)
// `endif
// );

c_clgen i_clgen(
	.clk		 ( 	 CLOCK_LENTO/*clock da placa*/	), //in
	// .clk		 ( 	 CLOCK_50/*clock da placa*/	), //in
	.rst      	 (   KEY/*rst do botao*/   ), //in
	.load_done	 (   load_done   ), //in
	.clk_o       (   clk /*default*/    ), //out
    .pm_clk_o    (   pm_clk_i /*default*/),//out
	.rst_o       (   rst /*default*/    ) //out
	`ifdef BA22_PM_IMPLEMENTED //está implementado sim
		,
		.pm_stalled_i(  pm_stalled_o /*default*/),//in
		.pm_stall_o  (  pm_stall_i /*default*/ )  //out
	`endif
);







///////////////////////////////////////////////////////////////////////////////
// AHB SLAVE instantiation/assignments
///////////////////////////////////////////////////////////////////////////////


// `ifdef BA22_DAHB_IMPLEMENTED
   // wire dahb_grant_i_nd, dahb_ready_i_nd;
   // wire [ `BA22_AHB_HRESP_RANGE ] dahb_resp_i_nd     ;
   // wire [ `BA22_AHB_RDATA_RANGE ] dahb_rdata_i_nd    ;

    // ahb_slave_behavioral #(
        // .ahb_monitor    (   1'b0            )
    // )i_dahbs(
        // .ahb_clk_i      (   dahb_clk_i      ),
        // .ahb_rstn_i     (   dahb_rstn_i     ),       
    
        // .ahb_hgrant_o   (   dahb_grant_i_nd ), 
        // .ahb_hready_o   (   dahb_ready_i_nd ), 
        // .ahb_hresp_o    (   dahb_resp_i_nd  ), 
        // .ahb_hrdata_o   (   dahb_rdata_i_nd ), 

        // .ahb_hbusreq_i  (   dahb_busreq_o   ), 
        // .ahb_htrans_i   (   dahb_trans_o    ), 
        // .ahb_haddr_i    (   dahb_addr_o     ), 
        // .ahb_hwrite_i   (   dahb_write_o    ), 
        // .ahb_hsize_i    (   dahb_size_o     ), 
        // .ahb_hburst_i   (   dahb_burst_o    ), 
        // .ahb_hprot_i    (   dahb_prot_o     ), 
        // .ahb_hlock_i    (   dahb_lock_o     ),
        // .ahb_hwdata_i   (   dahb_wdata_o    )
    // );    
    // assign #`OUTPUT_DELAY dahb_grant_i = dahb_grant_i_nd;
    // assign #`OUTPUT_DELAY dahb_ready_i = dahb_ready_i_nd;
    // assign #`OUTPUT_DELAY dahb_resp_i  = dahb_resp_i_nd;
    // assign #`OUTPUT_DELAY dahb_rdata_i = dahb_rdata_i_nd;
	assign #`OUTPUT_DELAY dahb_grant_i = 1;
    assign #`OUTPUT_DELAY dahb_ready_i = 1;
    assign #`OUTPUT_DELAY dahb_resp_i  = 0;
    assign #`OUTPUT_DELAY dahb_rdata_i = 0;
// `endif



//////////////////////////////////
// MONITOR - QMEM and AHB/WB Bus
//////////////////////////////////
monitor  u_monitor(
   .clk         (clk),
   .rst_i       (rst),
   .iqmem_stb   (iqmem_stb_o),
   .iqmem_ack   (iqmem_ack_i),
   .dqmem_ack   (dqmem_ack_i),
   .iqmem_data  (iqmem_dat_i),
   .dqmem_data  (dqmem_dat_i),
   .dqmem_wdata (dqmem_dat_o),
   .iqmem_addr  (iqmem_adr_o),
   `ifdef BA22_QMEM_UNIFIED_SP //parece que não está definido
   .mem_addr    (idqmem_addr),
   `endif
   .dqmem_addr  (dqmem_adr_o),
   .dqmem_we    (dqmem_we_o),
   .intr        (int_val),
   .LEDR		(LEDR),
   .dados	  	(dahb_wdata_o)
  );



endmodule
