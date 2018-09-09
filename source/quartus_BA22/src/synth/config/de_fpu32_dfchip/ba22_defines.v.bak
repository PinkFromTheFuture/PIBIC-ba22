//////////////////////////////////////////////////////////////////////
////                                                              ////
////  BA22 32-bit processor                                       ////
////                                                              ////
////  Description                                                 ////
////      <This file is part of BA22 32-bit processor project>    ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2006 Beyond Semiconductor                      ////
////                                                              ////
//// Licensing info at http://www.bsemi.com                       ////
////                                                              ////
////////////////////////////////////////////////////////////////////// 
`include "ba22_revision.v"
//`timescale 1ns / 1ps
/*
    comment the following parameter for synthesis
    uncomment the following parameter for simulation
*/
//`define BA22_SIM

/* comment the following define if the desired RST value is low */
/* cpu reset active high */
//`define BA22_RST_ACT_HIGH
/* cpu reset asynchronous, comment the define to make the reset synchronous */
`define BA22_RST_ASYNC
/* Register Instruction fetch pipeline stage */
`define BA22_INSN_FETCH_PIPE_STAGE

/* GPR31 used as Program Counter register */ 
//`define BA22_PC_MAPPED_TO_GPRS

/* Increase Data Cache latency by one cycle */
//`define BA22_DC_INCREASELATENCY

/*
    Endianness - BA22_ENDIANNESS
    1'b0          -> Big endian
    1'b1          -> Little endian
    <not defined> -> In system selectable via ben_le_sel_i
*/
//`define BA22_ENDIANNESS 1'b0

/*--------------------------------------------------------------*/
/* Features select                                              */
/*--------------------------------------------------------------*/
/* To implement the following units uncomment the defines */

/* Implement Data Cache Store Buffer */
//`define BA22_DC_STORE_BUFFER

/* Implement Debug Unit                         */
`define BA22_DU_IMPLEMENTED
/* Implement Tick Timer                         */
`define BA22_TT_IMPLEMENTED
/* Implement Data MMU                           */
//`define BA22_DMMU_IMPLEMENTED
/* Implement Instruction MMU                    */
//`define BA22_IMMU_IMPLEMENTED
/* Implement Data Cache                         */
//`define BA22_DC_IMPLEMENTED
/* Implement Instruction Cache                  */
//`define BA22_IC_IMPLEMENTED
/* Implement Programmable Interrupt Controller  */
`define BA22_PIC_IMPLEMENTED
/* Implemet Power management unit               */
`define BA22_PM_IMPLEMENTED
/* Divider Implemented                          */
`define BA22_DIV_IMPLEMENTED
/* Multiplier Implemented                       */
`define BA22_MUL_IMPLEMENTED
/* Multipy accumulate unit implemented          */
`define BA22_MAC_IMPLEMENTED
/* Single precission floationg point unit       */
`define BA22_FPU32_IMPLEMENTED
/* Implement live QMEM interface                */
`define BA22_QMEM_IMPLEMENTED
/* Implement 32 bit Instruction QMEM interface  */
//`define BA22_IQMEM32_IMPLEMENTED
/* Implement saturating arithmetics instructions*/
`define BA22_SATARITH_IMPLEMENTED
/* Implement DSP extensions                     */
//`define BA22_DSP_IMPLEMENTED
/* Implement Square root                        */
//`define BA22_SQRT_IMPLEMENTED
/* Implement only 16 or less GPRs               */
//`define BA22_16GPRS
/* Implement AHB interface                      */
`define BA22_AHB
/* AHB reset active high                        */
//`define BA22_AHB_RST_ACT_HIGH

/*--------------------------------------------------------------*/
/* Debug unit                                                   */
/*--------------------------------------------------------------*/
/* >>> uncommnet following defines to imlement the following debug unit registers   */
`ifdef BA22_DU_IMPLEMENTED
/* Implement Trace Buffer                   */
    `define BA22_DU_TB_IMPLEMENTED
    `ifdef BA22_DU_TB_IMPLEMENTED
/* define log 2 of the trace buffer depth   */
        `define BA22_DU_TB_DEPTH        11
    `endif
/* Implement hardware breakpoints           */
    `define BA22_DU_HWBKPTS
    `ifdef BA22_DU_HWBKPTS
/* Implement DVR/DCR pairs               */
        `define BA22_DU_PAIR0_IMPLEMENTED
        `define BA22_DU_PAIR1_IMPLEMENTED
        `define BA22_DU_PAIR2_IMPLEMENTED
        `define BA22_DU_PAIR3_IMPLEMENTED
        `define BA22_DU_PAIR4_IMPLEMENTED
        `define BA22_DU_PAIR5_IMPLEMENTED
        `define BA22_DU_PAIR6_IMPLEMENTED
        `define BA22_DU_PAIR7_IMPLEMENTED
    `endif
`endif

    
/* Multiplier   */
    
`ifdef  BA22_MUL_IMPLEMENTED
/* >>> uncomment the define if 3 stage multiplier is desired */
/* Three stage multiplier   */
    `define BA22_MUL_3STAGE
//    `define BA22_MUL_MADD_REG
//    `define BA22_MUL_SHR_REG
//    `define BA22_MUL_RND_REG
`endif

/*--------------------------------------------------------------*/
/* Exception model                                              */
/*--------------------------------------------------------------*/

/* >>> Alter following defines if others exception vectors are needed <<<   */
/* Exception vector prefix                          */
`define BA22_EXC_VECT_EPH              32'hf0000000
/* exception vectors */
/* Reset exception vector                           */
`define BA22_EXC_VECT_RESET            32'h0000_0100
/* Instruction TLB miss vector                      */
`define BA22_EXC_VECT_ITLB_MISS        32'h0000_0A00
/* Instruction Page Fault vector                    */
`define BA22_EXC_VECT_IPAGE_FAULT      32'h0000_0400
/* Instruction TLB miss vector                      */
`define BA22_EXC_VECT_INSN_BUS_ERR     32'h0000_0200
/* Illegal instruction vector                       */
`define BA22_EXC_VECT_UNDEF_INST       32'h0000_0700
/* Unaligned memory access vector                   */
`define BA22_EXC_VECT_UNALIGNED        32'h0000_0600
/* System call vector                               */
`define BA22_EXC_VECT_SYSCALL          32'h0000_0C00
/* Trap exception                                   */
`define BA22_EXC_VECT_TRAP             32'h0000_0E00
/* Data TLB miss vector                             */
`define BA22_EXC_VECT_DTLB_MISS        32'h0000_0900
/* Data Page Fault vector                           */
`define BA22_EXC_VECT_DPAGE_FAULT      32'h0000_0300
/* Bus error vector                                 */
`define BA22_EXC_VECT_DBUS_ERR         32'h0000_0200
/* Tick Timer vector                                */
`define BA22_EXC_VECT_TICK_TIMER       32'h0000_0500
/* External Interrupt vector                        */
`define BA22_EXC_VECT_INT              32'h0000_0800
/* floating point exception                         */
`define BA22_EXC_VECT_FP               32'h0000_0d00


/*--------------------------------------------------------------*/
/* Memory management                                            */
/*--------------------------------------------------------------*/
`ifdef BA22_SIM
/* definitions are in ba22_constants.v */
`else
// QMEM address width definition - size = (8 << BA22_QMEM_AW)
// BA22_QMEM_AW is the address width for word (64) access
// 16k memory  = 2kx8  (11 bits) or 512x32 (9 bits) or 256x64 (8 bits)
// 32k memory  = 4kx8  (12 bits) or 1kx32 (10 bits) or 512x64 (9 bits)
// 64k memory  = 8kx8  (13 bits) or 2kx32 (11 bits) or 1kx64 (10 bits)
// 128k memory = 16kx8 (14 bits) or 4kx32 (12 bits) or 2kx64 (11 bits)
// 256k memory = 32kx8 (15 bits) or 8kx32 (13 bits) or 4kx64 (12 bits)
// 512k memory = 64kx8 (16 bits) or 16kx32(14 bits) or 8kx64 (13 bits)
    `define BA22_QMEM_AW                     13
    `define BA22_DQMEM_BASE_ADDR_DEC_BITS    31:16
    `define BA22_DQMEM_BASE_ADDR             32'h00000000
    `define BA22_IQMEM_BASE_ADDR             `BA22_DQMEM_BASE_ADDR
    `define BA22_IQMEM_BASE_ADDR_DEC_BITS    `BA22_DQMEM_BASE_ADDR_DEC_BITS
`endif

/* Noncacheable regions                                         */

/* define two non cachable virtual address regions              */
`define BA22_NON_CACHEABLE_REGION0
//`define BA22_NON_CACHEABLE_REGION1

/* Bits used to decode noncachable regions                      */
`define BA22_NON_CACHEABLE_REGION0_DEC_BITS  31:31
`define BA22_NON_CACHEABLE_REGION1_DEC_BITS  31:31

/* Noncacheable regions base addresses                          */
`define BA22_NON_CACHEABLE_REGION0_DEC_ADDR  32'h80000000
`define BA22_NON_CACHEABLE_REGION1_DEC_ADDR  32'h80000000

// Custom noncacheable region - enter custom code
`define BA22_NON_CACHEABLE_CUSTOM_REGION0   // | (                               (reg_pvpn < 32'h00008000) ) 
`define BA22_NON_CACHEABLE_CUSTOM_REGION1   // | ( (reg_pvpn >= 32'h08010000) &  (reg_pvpn < 32'ha0010000) ) 
`define BA22_NON_CACHEABLE_CUSTOM_REGION2   // | ( (reg_pvpn >= 32'ha0020000)                              ) 


/*--------------------------------------------------------------*/
/* Data Cache                                                   */
/*--------------------------------------------------------------*/

/* define the size of the DC way in bytes as a power of 2       */
`define BA22_DC_WAYSIZE     13

/* define DC asociativity                                       */

/* If multiple options are selected, the option with            */
/* the highest number of ways is selected                       */
`define BA22_DC_WAYS_4
`define BA22_DC_WAYS_3
`define BA22_DC_WAYS_2
`define BA22_DC_WAYS_1
   
/* define replacement strategy - supported options:             */
/* BINTREE when using 4 ways                                    */
/* LRU when using 3 ways                                        */
/* LRU when using 2 ways                                        */
`define BA22_DC_REPLACEMENT_BINTREE
//`define BA22_DC_REPLACEMENT_LRU
   
/*--------------------------------------------------------------*/
/* Instruction Cache                                            */
/*--------------------------------------------------------------*/

/* define the size of the IC way in bytes as a power of 2       */
`define BA22_IC_WAYSIZE     13
   
/* define IC asociativity                                       */

/* If multiple options are selected, the option with            */
/* the highest number of ways is selected                       */
`define BA22_IC_WAYS_4
`define BA22_IC_WAYS_3
`define BA22_IC_WAYS_2
`define BA22_IC_WAYS_1

/* define replacement strategy - supported options:             */
/* BINTREE when using 4 ways                                    */
/* LRU when using 3 ways                                        */
/* LRU when using 2 ways                                        */
`define BA22_IC_REPLACEMENT_BINTREE
//`define BA22_IC_REPLACEMENT_LRU

/*--------------------------------------------------------------*/
/* Data MMU (IMMU)                                              */
/*--------------------------------------------------------------*/
/* define DTLB asociativity                                     */

/* If multiple option are selected, the option with the highest */
/* number of ways is selected                                   */
`define BA22_DTLB_WAYS_4
`define BA22_DTLB_WAYS_3
`define BA22_DTLB_WAYS_2
`define BA22_DTLB_WAYS_1

/* define replacement strategy                                  */
/* Supported options:                                           */
/* BINTREE when using 4 ways                                    */
/* LRU when using 3 ways                                        */
/* LRU when using 2 ways                                        */
`define BA22_DTLB_REPLACEMENT_BINTREE
//`define BA22_DTLB_REPLACEMENT_LRU

/* Data MMU TLB entries                                         */
/* Total number of DTLB entires is defined by the following     */
/* expression: ENTRIES = WAYS * ENTRIES_PER_WAY                 */
/*                                                              */
/* define number of DTLB entries per way as a power of 2        */
`define BA22_DTLB_ENTRIES_PER_WAY   6

/*--------------------------------------------------------------*/
/* Instruction MMU (IMMU)                                       */
/*--------------------------------------------------------------*/
/* define ITLB asociativity                                     */
/* If multiple option are selected, the option with the highest */
/* number of ways is selected                                   */
`define BA22_ITLB_WAYS_4
`define BA22_ITLB_WAYS_3
`define BA22_ITLB_WAYS_2
`define BA22_ITLB_WAYS_1

/* define replacement strategy                                  */
/* Supported options:                                           */
/* BINTREE when using 4 ways                                    */
/* LRU when using 3 ways                                        */
/* LRU when using 2 ways                                        */
`define BA22_ITLB_REPLACEMENT_BINTREE
//`define BA22_ITLB_REPLACEMENT_LRU

/* define number of ITLB entries per way as a power of 2        */
`define BA22_ITLB_ENTRIES_PER_WAY   6

/*--------------------------------------------------------------*/
/* Programmable Interupt Controller (PIC)                       */
/*--------------------------------------------------------------*/
/* Define number of interrupt inputs (2-32)                     */
`define BA22_PIC_INTS 3
/* Define if more than 32 interrupt inputs are implemented */
//`define BA22_PIC_PIC64

/*--------------------------------------------------------------*/
/* Power management                             */
/*--------------------------------------------------------------*/
// comment out this macro if you always use equal BUS and CPU clocks
// define this macro if you use different frequency(ies) for BUS and CPU clocks
//`define BA22_PM_BUS_CLK_NEQ_CPU_CLK

// this macro is used only if BA22_PM_BUS_WB_CLK_NEQ_CPU_CLK is also defined
// define this macro if BUS to CPU clock ratio in your design is always equal
// define fixed ratio using BA22_PM_PWR_UP_CLK_RATIO
//`define BA22_PM_FIXED_CLK_RATIO

// set default (power up/reset/fixed) BUS to CPU clock ratio here
// used only if BA22_PM_BUS_CLK_NEQ_CPU_CLK is defined
`ifdef BA22_SIM
`else
    `define BA22_PM_PWR_UP_CLK_RATIO 3'b000
`endif

// define this macro if you want to use Power Management Event (signal and control register)
`define BA22_PM_EVENT_IMPL

// define this macro if you want to use Units power down control register
`define BA22_PM_UNIT_PD_IMPL
// define power up value for debug unit clock enable
`define BA22_PM_PWR_UP_DU_CLK_EN 1'b0

// uncomment at most one of the following defines
//`define BA22_TARGET_FPGA_XILINX_V5
//`define BA22_TARGET_FPGA_XILINX_V4


/* Custom features -- do not change */
//`define BA22_REG_DC
