//////////////////////////////////////////////////////////////////////
////                                                              ////
////  AMBA AHB Slave Behavioral                                   ////
////                                                              ////
////  Description                                                 ////
////      <This file is part of AHB slave Behavioral         >    ////
////      <                                                  >    ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2006 Beyond Semiconductor                      ////
////                                                              ////
//// Licensing info at http://www.beyondsemi.com                  ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "bench_defines.v"
`include "ahb_master_defines.v"
//synopsys translate_off
`include "timescale.v"
//synopsys translate_on

// if DISABLE_RANDOM_BUS_RESPONSE is defined
// -grant is always granted
// -no retry/split response
// need to be used for benchmark tests
`define     DISABLE_RANDOM_BUS_RESPONSE

module ahb_slave_behavioral #(
    parameter       ahb_monitor = 0
    )(   
    ahb_clk_i       ,
    ahb_rstn_i      ,       
 
    ahb_hgrant_o    , 
    ahb_hready_o    , 
    ahb_hresp_o     , 
    ahb_hrdata_o    , 

    ahb_hbusreq_i   , 
    ahb_htrans_i    , 
    ahb_haddr_i     , 
    ahb_hwrite_i    , 
    ahb_hsize_i     , 
    ahb_hburst_i    , 
    ahb_hprot_i     , 
    ahb_hlock_i     ,
    ahb_hwdata_i 
);
    
// AMBA AHB HTRANS defines
`define AHB_HTRANS_IDLE    2'b00
`define AHB_HTRANS_BUSY    2'b01
`define AHB_HTRANS_NONSEQ  2'b10
`define AHB_HTRANS_SEQ     2'b11
// AMBA AHB HRESP defines
`define AHB_HRESP_OKAY     2'b00
`define AHB_HRESP_ERROR    2'b01
`define AHB_HRESP_RETRY    2'b10
`define AHB_HRESP_SPLIT    2'b11

    input           ahb_clk_i           ;
    input           ahb_rstn_i          ;

    inout           ahb_hgrant_o        ; 
    inout           ahb_hready_o        ; 
    inout   [ 1: 0] ahb_hresp_o         ; 
    inout   [31: 0] ahb_hrdata_o        ; 

    reg             ahb_hgrant          ; 
    reg     [ 1: 0] ahb_hresp           ;
    wire            ahb_hready          ; 
    wire  [31: 0]   ahb_hrdata          ; 

assign  ahb_hgrant_o = (ahb_monitor) ? 1'bz : ahb_hgrant;
assign  ahb_hresp_o = (ahb_monitor) ? 2'bz : ahb_hresp;   
assign  ahb_hready_o = (ahb_monitor) ? 1'bz : ahb_hready;
assign  ahb_hrdata_o = (ahb_monitor) ? 32'bz : ahb_hrdata;

    input           ahb_hbusreq_i       ;
    input   [ 1: 0] ahb_htrans_i        ;
    input   [31: 0] ahb_haddr_i         ;
    input           ahb_hwrite_i        ;
    input   [ 2: 0] ahb_hsize_i         ;
    input   [ 2: 0] ahb_hburst_i        ;
    input   [ 3: 0] ahb_hprot_i         ;
    input           ahb_hlock_i         ;
    input   [31: 0] ahb_hwdata_i        ;

    reg     [31: 0] daddr       ;
    reg     [ 2: 0] dsize       ;
    reg     [ 3: 0] dsel        ;
    reg             ddir        ;
    reg     [31: 0] rdata       ;
    reg     [31: 0] wdata       ;
    reg     [ 1: 0] error       ;
    reg     [ 1: 0] retry       ;

    reg [31: 0] cur_arb_waits       ;
    reg [31: 0] cur_bus_waits       ;
    reg [31: 0] cur_bsize           ;
    reg [31: 0] wrap_mask           ;
    reg [31: 0] start_adr           ;
    reg [31: 0] cur_adr             ;
    reg [ 2: 0] start_size          ;
    reg [ 2: 0] burst               ;
    reg         idle, data_phase, write ;
    reg         gnt_reg             ;
    reg         allow_seq           ;
    reg         ready, gnt          ;
    reg         rnd_ready, rnd_gnt  ;

    reg         retry_split=0       ;
        
    reg         disabled_gnt=0      ;
    
`ifdef  DISABLE_RANDOM_BUS_RESPONSE
    reg         random_bus_response = 0;        
`else    
    reg         random_bus_response = 1;
`endif   

    reg [9:0]   ahb_read_cnt    ;
    reg [9:0]   ahb_write_cnt   ;

wire        burst_trans_active=(ahb_htrans_i[1] & ahb_hburst_i!=3'b000);

// used to determine burst ending (to change burst_resp_type)
reg         burst_trans_active_reg;
always @ (posedge ahb_clk_i `AHB_RST_EVENT)
    if (ahb_rstn_i == `AHB_RST_ACT) 
        burst_trans_active_reg <= 1'b0;
    else 
        burst_trans_active_reg <= burst_trans_active;

// burst cycle response type (4 types, change type every burst)
reg[1:0]    burst_resp_type;

    always @ (posedge ahb_clk_i `AHB_RST_EVENT)
        if(ahb_rstn_i == `AHB_RST_ACT)
            burst_resp_type <= 3'b0;
        else if(burst_trans_active_reg & !burst_trans_active)
                burst_resp_type <= burst_resp_type + 1'b1;                

    // synthesis translate_off
    // synopsys translate_off
    reg  [8*20:1] burst_resp_type_ascii;
    always @(burst_resp_type) begin
        if      (burst_resp_type==2'b00)    burst_resp_type_ascii <= "leave";
        else if (burst_resp_type==2'b01)    burst_resp_type_ascii <= "grant";
        else if (burst_resp_type==2'b10)    burst_resp_type_ascii <= "retry_split";
        else if (burst_resp_type==2'b11)    burst_resp_type_ascii <= "random";
        else                                burst_resp_type_ascii <= "ERROR";
    end
    // synopsys translate_on
    // synthesis translate_on


    event   rx, tx, cphase, dphase ;

    integer     file;

    assign  ahb_hrdata    = (data_phase && !ddir && ahb_hready_o) ? rdata : {32{1'bx}}       ;

/* --------------------------------------------------------------------  */
/* added by CAST */

    // use counter data instead of random
    always @ (posedge ahb_clk_i `AHB_RST_EVENT)
    begin
        if(ahb_rstn_i == `AHB_RST_ACT)
           rdata <= {32{1'b0}};
        else
           rdata <= rdata + 1'b1;
    end
 
    // AHB monitor the number of AHB read and AHB write
    always @ (posedge ahb_clk_i `AHB_RST_EVENT)
    begin
       if(ahb_rstn_i == `AHB_RST_ACT)
       begin
          ahb_read_cnt <= 10'd0;
          ahb_write_cnt <= 10'd0;
       end
       else if (data_phase && ahb_hbusreq_i)
       begin
          if (ahb_haddr_i == `CAST_CHAR || ahb_haddr_i == `CAST_NUM || ahb_haddr_i == `CAST_INTRCLR ||
              ahb_haddr_i == `CAST_INTRMASK || ahb_haddr_i == `CAST_INTRSR || ahb_haddr_i == `CAST_SR ||
              ahb_haddr_i == `CAST_TT_CNT || ahb_haddr_i == `CAST_TT_INT || ahb_haddr_i == `CAST_ENDSIM)
          begin
             if (!ahb_hwrite_i && !ddir)
                ahb_read_cnt <= ahb_read_cnt + 1'b1;
             else if (ahb_hwrite_i && ddir)
                ahb_write_cnt <= ahb_write_cnt + 1'b1;
          end
       end
    end

/* --------------------------------------------------------------------  */

    assign  ahb_hready    =
            (gnt_reg && ahb_htrans_i[1] && ready && !data_phase)
        ||  (ahb_hbusreq_i && ahb_hgrant_o && ready && !data_phase)
        ||  (data_phase && ready && !(error[0] || retry[0]))
        ||  (error[1] || retry[1])
        ||  (!error && !retry && !data_phase && rnd_ready)
    ;


reg[1:0]     burst_gnt_cnt;
reg[1:0]     current_burst_gnt_cnt;

wire    burst_grant;
assign  burst_grant = (current_burst_gnt_cnt==burst_gnt_cnt) ? 1'b0 : 1'b1;

reg     burst_n_gnt_done;
reg     burst_n2_gnt_done;

// select appropriate grant
always @(*) begin
    if(!ahb_hbusreq_i) 
        ahb_hgrant <= rnd_gnt;
    else begin
        if(burst_trans_active) begin
            if((burst_resp_type==2'b01 | burst_resp_type==2'b11) & random_bus_response)
                ahb_hgrant <= burst_grant;
            else
                ahb_hgrant <= 1'b1;
        end else begin
            ahb_hgrant <= gnt & !disabled_gnt;
        end
    end
end

// counters used for removing grant on burst transfers (burst_resp_type==grant)
    always @ (posedge ahb_clk_i `AHB_RST_EVENT)
        if (ahb_rstn_i == `AHB_RST_ACT) begin
            burst_gnt_cnt <= 2'b0;
            current_burst_gnt_cnt <= 2'b0;
        end else begin
//            if((burst_trans_active_reg & !burst_trans_active) & (burst_resp_type==2'b01 | burst_resp_type==2'b11)) burst_gnt_cnt <= burst_gnt_cnt + 1'b1;
              if((burst_trans_active_reg & !burst_trans_active) & burst_resp_type==2'b01) burst_gnt_cnt <= burst_gnt_cnt + 1'b1;
            
            if(!burst_trans_active) current_burst_gnt_cnt <= 2'b0;
            else current_burst_gnt_cnt <= current_burst_gnt_cnt + 1'b1;
        end

// used for removing grant on burst transfers
    always @ (posedge ahb_clk_i `AHB_RST_EVENT)
        if (ahb_rstn_i == `AHB_RST_ACT) begin
            burst_n_gnt_done <= 1'b0;
        end else begin
            if(burst_trans_active & !ahb_hgrant_o)
                burst_n_gnt_done <= 1'b1;
            else if(!burst_trans_active)
                burst_n_gnt_done <= 1'b0;
        end

// used for re-granting grant on burst transfers        
    always @ (posedge ahb_clk_i)
        if(burst_n_gnt_done & ahb_hgrant_o)
            burst_n2_gnt_done <= 1'b1;
        else if(!burst_trans_active)
            burst_n2_gnt_done <= 1'b0;
        
        
    reg dummy;
    always @ (posedge ahb_clk_i)
    begin:random_gnt_ready_gen_blk
        reg [31: 0] rnd_num ;

        if (((rnd_num ^ rnd_num) !== 0) || (rnd_num === 0))
        begin
            rnd_num = $random   ;
        end

        if(random_bus_response)
            {rnd_gnt, rnd_ready}    <= rnd_num[ 1: 0]   ;
        else begin
            {dummy, rnd_ready}    <= rnd_num[ 1: 0]   ;
            rnd_gnt = 1;        
        end
        rnd_num = rnd_num >> 2 ;
    end
    

    always @ (posedge ahb_clk_i or data_phase or error or retry or ready or ahb_htrans_i or gnt_reg or retry_split)
    begin
        if (data_phase && error[0] || error[1])
            ahb_hresp <= `AHB_HRESP_ERROR  ;
        else if (data_phase && retry[0] || retry[1])
            ahb_hresp <= (retry_split) ? `AHB_HRESP_RETRY : `AHB_HRESP_SPLIT  ;        
//            ahb_hresp <= `AHB_HRESP_RETRY;
//            ahb_hresp <= `AHB_HRESP_SPLIT;
        else if (data_phase)
            ahb_hresp <= `AHB_HRESP_OKAY ;
        else
            ahb_hresp <= $random              ;
//            ahb_hresp <= `AHB_HRESP_OKAY ;
    end

    always @(ahb_rstn_i)
    begin
        ready           <= 1'b1                 ;
//        gnt             <= 1'b1                 ;
        gnt             <= 1'b0                 ;
        gnt_reg         <= 1'b0                 ;
        idle            <= 1'b1                 ;
        data_phase      <= 1'b0                 ;
        rnd_gnt         <= 1'b0                 ;
        rnd_ready       <= 1'b0                 ;
        ahb_hresp     <= `AHB_HRESP_OKAY ;

        error           <= 'h0  ;
        retry           <= 'h0  ;

        cur_arb_waits   <= 0 ;
        cur_bus_waits   <= 0 ;
    end
    
    reg[3:0]    re_grant_cnt;
    
    always @ (posedge ahb_clk_i)
    begin
        if (!(ahb_rstn_i === `AHB_RST_ACT))
        begin

        // remove grant on split response (re-grant after random counter)
        if(random_bus_response) begin
            if(!ahb_hready_o & ahb_hresp_o==`AHB_HRESP_SPLIT & !burst_trans_active) begin
                gnt <= 1'b0;
                re_grant_cnt <= $random;
            end else if(ahb_hbusreq_i & !disabled_gnt) begin
                if(re_grant_cnt!='h0)
                    re_grant_cnt <= re_grant_cnt - 1'b1;
                else gnt <= 1'b1;
            end
        end else gnt <= 1'b1;
                        
            // randomly remove grant on non-burst transfers
            if(random_bus_response)
                disabled_gnt <= $random;
            else
                disabled_gnt <= 1'b0;
                
            if (ahb_hready_o)
            begin
                gnt_reg     <= ahb_hgrant_o                 ;
                data_phase  <= gnt_reg && ahb_htrans_i[1] && (allow_seq || !ahb_htrans_i[0])  ;
                idle        <= !(gnt_reg && ahb_htrans_i[1]) ;
                allow_seq   <= 
                        ahb_hgrant_o
                    &&  
                        (
                           (gnt_reg && (ahb_htrans_i === `AHB_HTRANS_NONSEQ) && |ahb_hburst_i)
                        || allow_seq && ahb_htrans_i[0] 
                        )
                    ;

                if (allow_seq && !ahb_htrans_i[0] && |burst[2:1])
                begin
                    // check short burst length
                    if (cur_bsize !== ((1 << start_size) * (2 << burst[2:1])))
                        $display("%m @ %t, unexpected end-of-burst!", $time) ;
                end

                if ((ahb_htrans_i === `AHB_HTRANS_NONSEQ) && gnt_reg)
                begin
                    write       = ahb_hwrite_i      ;
                    cur_bsize   = 1 << ahb_hsize_i  ;
                    start_adr   = ahb_haddr_i       ;
                    start_size  = ahb_hsize_i       ;
                    cur_adr     = ahb_haddr_i       ;
                    burst       = ahb_hburst_i      ;

                    if (ahb_hburst_i[0])
                        wrap_mask = 0 ;
                    else
                        wrap_mask   = (1 << ahb_hsize_i) * (2 << ahb_hburst_i[2:1]) ;
                end

                if (ahb_htrans_i == `AHB_HTRANS_SEQ)
                begin
                    if (!allow_seq || |burst[2:1] && (cur_bsize >= ((1 << start_size) * (2 << burst[2:1])))) begin
                        $display("%m @ %t, unexpected sequential transfer!", $time) ;
                        #100;
                        $finish;
                    end

                    cur_adr = (start_adr & ~(wrap_mask -1)) + (cur_bsize & ~(wrap_mask -1)) + ((start_adr + cur_bsize) & (wrap_mask -1)) ; 
                    if (cur_adr !== ahb_haddr_i) begin
                        $display("%m @ %t, unexpected burst address! got %x expected %x", $time, ahb_haddr_i, cur_adr) ;
                        $finish;
                    end

                    if (!(cur_adr % 1024) & burst==3'b001) begin
                        $display("%m at %t, address crossed 1KB bound during burst!", $time) ;
                        $finish;
                    end

                    if (start_size !== ahb_hsize_i) begin
                        $display("%m @ %t, transfer size changed during burst!", $time) ;
                        $finish;
                    end

                    if (ahb_hwrite_i !== write) begin
                        $display("%m @ %t, transfer direction changed during burst!", $time) ;
                        $finish;
                    end

                    if (ahb_hburst_i !== burst) begin
                        $display("%m @ %t, burst type changed during burst!", $time) ;
                        $finish;
                    end

                    if (!ahb_hburst_i || !burst) begin
                        $display("%m @ %t, burst longer than 1 marked as single transfer!", $time) ;
                        $finish;
                    end
                end

                if (ahb_htrans_i[1] && gnt_reg && (allow_seq || !ahb_htrans_i[0]))
                begin   
                    -> cphase ;
                    daddr   <= ahb_haddr_i  ;
                    dsize   <= ahb_hsize_i  ;
                    ddir    <= ahb_hwrite_i ;
                    dsel    <= sz2sel(ahb_haddr_i[ 1: 0], ahb_hsize_i)  ;
                end

//                if(gnt_reg & ahb_htrans_i !== `AHB_HTRANS_NONSEQ) cur_bsize   = cur_bsize + (1 << ahb_hsize_i) ;
                if(gnt_reg & ahb_htrans_i == `AHB_HTRANS_SEQ) cur_bsize   = cur_bsize + (1 << ahb_hsize_i) ;

                if (data_phase)
                begin
                    if (ddir) begin
                        wdata   = ahb_hwdata_i ;
                        -> rx   ;
                    end else
                        -> tx   ;                        
                    -> dphase ;
                end

            end

            if ((ahb_hresp_o !== `AHB_HRESP_OKAY) && (error || retry))
            begin
                error   <= error << 1 ;
                retry   <= retry << 1 ;
            end

            if (!ahb_hready_o && (ahb_hresp_o !== `AHB_HRESP_OKAY) && data_phase)
            begin
                -> dphase   ;
                data_phase  <= 1'b0 ;
                allow_seq   <= 1'b0 ;
            end

            if (ahb_hbusreq_i && !ahb_hgrant_o)
                cur_arb_waits   <= cur_arb_waits +1'b1 ;
            else
                cur_arb_waits   <= 0 ;

            if ((ahb_htrans_i !== `AHB_HTRANS_IDLE) && !ahb_hready_o)
                cur_bus_waits   <= cur_bus_waits +1'b1  ;
            else if ((data_phase === 1'b1) && !ahb_hready_o)
                cur_bus_waits   <= cur_bus_waits +1'b1  ;
            else
                cur_bus_waits   <= 0    ;
        end
    end

    function [ 3: 0]    sz2sel  ;
        input   [ 1: 0] ofs_i   ;
        input   [ 2: 0] sz_i    ;
    begin
        sz2sel  = 4'b0000   ;
        repeat(1 << sz_i)
            sz2sel  = {1'b1, sz2sel[3:1]}   ;
    
        sz2sel  = sz2sel >> ofs_i   ;
    end
    endfunction
    
endmodule //ahb_slave_behavioral.v
