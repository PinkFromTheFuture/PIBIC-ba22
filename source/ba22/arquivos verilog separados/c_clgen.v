//////////////////////////////////////////////////////////////////////
////                                                              ////
////  BA testbench module                                         ////
////                                                              ////
////  Description                                                 ////
////      DUT, memory instantiations                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2006 Beyond Semiconductor                      ////
////                                                              ////
//// Licensing info at http://www.beyondsemi.com                  ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
`include "timescale.v"
`include "bench_defines.v"

module c_clgen(
    rst_o       ,
    clk_o       ,
    wb_clk_o    ,
    pm_clk_o
`ifdef BA22_PM_IMPLEMENTED
    ,
    pm_stall_o,
    pm_stalled_i
`endif
);
parameter   ref_clk_per = 0.0   ;
parameter   clk_div     = 0     ;
parameter   pm_clk_div  = 0     ;

output  rst_o       ;
output  clk_o       ;
output  wb_clk_o    ;
output  pm_clk_o    ;

`ifdef BA22_PM_IMPLEMENTED
output  pm_stall_o  ;
reg     pm_stall_o  = 1'b0;
input   pm_stalled_i;
`endif

reg rst_o       ;
reg ref_clk     ;
reg clk_o       ;
reg wb_clk_o    ;
reg pm_clk_o    ;

wire rst_i = rst_o;

reg[8:0] ref_clk_per_reg = ref_clk_per;
reg[8:0] ref_clk_per_reg4 = ref_clk_per/4.0;

always
begin:ref_clk_gen_blk
    ref_clk <= 1'b0 ;
    #(ref_clk_per/4.000) ;
//        #(2.5);
    ref_clk <= 1'b1 ;
    #(ref_clk_per/4.000) ;
//        #(2.5);
end

initial
begin
    `ifdef BA22_PM_BUS_CLK_NEQ_CPU_CLK
       set_clks(clk_div, `BA22_PM_PWR_UP_CLK_RATIO);
     `else
       set_clks(clk_div, 8'b00000000);
     `endif
end

always
begin:clk_gen_blk
    reg [14: 0] ref_div     ;
    reg         clk_run     ;
    reg         clk_stopped ;

    clk_o   <= 1'b1 ;

    repeat(ref_div)
        @(posedge ref_clk) ;
     
    clk_o   <= 1'b0 ;
    repeat(ref_div)
        @(posedge ref_clk);

    if (clk_run === 1'b0)
    begin
        clk_stopped <= 1'b1 ;
        wait(clk_run !== 1'b0)  ;
        clk_stopped <= 1'b0     ;
    end
end


always
begin:wb_clk_gen_blk
    reg [14: 0] ref_div     ;
    reg         clk_run     ;
    reg         clk_stopped ;

    wb_clk_o   <= 1'b1  ;

    repeat(ref_div)
        @(posedge ref_clk) ;

    wb_clk_o    <= 1'b0 ;
    repeat(ref_div)
        @(posedge ref_clk);
        
    if (clk_run === 1'b0)
    begin
        clk_stopped <= 1'b1 ;
        wait(clk_run !== 1'b0)  ;
        clk_stopped <= 1'b0     ;
    end
end

always
begin:pm_clk_gen_blk
    pm_clk_o    <= 1'b1 ;

    repeat(pm_clk_div)
        @(posedge ref_clk) ;

    pm_clk_o    <= 1'b0 ;

    repeat(pm_clk_div)
        @(posedge ref_clk) ;
end

task set_clks   ;
    input   [14: 0] cpu_clk_div ;
    input   [7: 0]  clmode_i    ;
begin

    if(clmode_i!=8'b0) begin
        if(clmode_i[7]) begin
            clk_gen_blk.ref_div = 1;
            if(clmode_i[6:0]==7'b0) begin
                wb_clk_gen_blk.ref_div = 1;
            end else begin
                wb_clk_gen_blk.ref_div = clmode_i[6:0];
            end
            clk_gen_blk.ref_div = 1;
            `ifdef DEBUG_PRINT
             $display("cpu_clk=%d * bus_clk @ %t", wb_clk_gen_blk.ref_div, $time);
            `endif 
        end else begin
            if(clmode_i[6:0]==7'b0) begin
                clk_gen_blk.ref_div = 1;
            end else begin
                clk_gen_blk.ref_div = clmode_i[6:0];
            end            
            wb_clk_gen_blk.ref_div = 1;        
            `ifdef DEBUG_PRINT
            $display("bus_clk=%d * cpu_clk @ %t", clk_gen_blk.ref_div, $time);
            `endif
        end
    end else begin
        clk_gen_blk.ref_div = 1;
        wb_clk_gen_blk.ref_div = 1;
    end
    // start clocks
//    clk_gen_blk.ref_div     <= cpu_clk_div      ;
//    wb_clk_gen_blk.ref_div  <= get_wb_clk_div(cpu_clk_div, clmode_i) ;
end
endtask // set_clks

initial
begin
    rst_o = `BA22_RST_I_VAL ;
end

task rst_do ;
    reg rst_i   ;
begin
    rst_i   = 1'b0  ;
    if (!(rst_i == `BA22_RST_I_VAL))
        rst_i = 1'b1    ;
    // stop clocks
    i_clgen.wb_clk_stop  ;
    i_clgen.clk_stop     ;

    rst_o       <= rst_i    ;
end
endtask

task rst_done   ;
    reg rst_i   ;
begin
    rst_i   = 1'b0  ;
    if (rst_i == `BA22_RST_I_VAL)
        rst_i = 1'b1    ;

    @(posedge pm_clk_o) ;
    clk_gen_blk.clk_run     <= 1'b1 ;
    wb_clk_gen_blk.clk_run  <= 1'b1 ;
    fork
        repeat(15) @(posedge pm_clk_o);
        repeat(15) @(posedge wb_clk_o);
        repeat(15) @(posedge clk_o   );
    join
    rst_o   <= rst_i    ;
end
endtask

task wb_clk_stop    ;
begin
    @(negedge ref_clk) ;
    wb_clk_gen_blk.clk_run  <= 1'b0             ;
    wait(wb_clk_gen_blk.clk_stopped === 1'b1)   ;
end
endtask

task clk_stop   ;
begin
    @(negedge ref_clk) ;
    clk_gen_blk.clk_run  <= 1'b0     ;
    wait(clk_gen_blk.clk_stopped === 1'b1)      ;
end
endtask


endmodule // c_clgen
