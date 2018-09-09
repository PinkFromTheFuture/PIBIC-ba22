//////////////////////////////////////////////////////////////////////
////                                                              ////
////  BA22 32-bit processor                                       ////
////                                                              ////
////  Description                                                 ////
////      <This file is part of BA22 32-bit processor project>    ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2006-2009 Beyond Semiconductor                 ////
////                                                              ////
//// Licensing info at http://www.bsemi.com                       ////
////                                                              ////
////////////////////////////////////////////////////////////////////// 

// `include "ba22_defines.v"


/*path laico: */
// `include "C:/Dropbox/Bolsista Eduardo/ba22_filtrado/src/synth/config/de_fpu32_dfchip/ba22_defines.v"

/*path casa: */
// `include "C:/Dropbox/TRABALHO/Bolsista Eduardo/ba22_filtrado/src/synth/config/de_fpu32_dfchip/ba22_defines.v"

/*path relativo: */
`include "../../config/de_fpu32_dfchip/ba22_defines.v"

/* Constants: DO NOT EDIT!! */


/* CPU Version Register             */
`define BA22_VERSION            32'h22005001
                                    
// decoded address bits during SPR access
`define BA22_PM_OFS_BITS 1: 0
// power management event control register offset
`define BA22_PM_OFS_PM_EVENT    2'b00
// units power down control register offset
`define BA22_PM_OFS_PM_UNITS_PD 2'b10

/////////////////////////////////////////////////////
`define BA22_SPR_GROUP_BITS     15:11

// Width of the group bits
`define BA22_SPR_GROUP_WIDTH    5

// Bits that define offset inside the group
`define BA22_SPR_OFS_BITS       10:0
`define BA22_SPR_OFS_WIDTH      11

// List of groups
`define BA22_SPR_GROUP_SYS      5'd00
`define BA22_SPR_GROUP_DMMU     5'd01
`define BA22_SPR_GROUP_IMMU     5'd02
`define BA22_SPR_GROUP_DC       5'd03
`define BA22_SPR_GROUP_IC       5'd04
`define BA22_SPR_GROUP_MAC      5'd05
`define BA22_SPR_GROUP_DU       5'd06
`define BA22_SPR_GROUP_PC       5'd07
`define BA22_SPR_GROUP_PM       5'd08
`define BA22_SPR_GROUP_PIC      5'd09
`define BA22_SPR_GROUP_TT       5'd10
`define BA22_SPR_GROUP_MDB      5'd11

`define BA22_SPR_CFGR           7'd0
`define BA22_SPR_DCFGR          4'h7
`define BA22_SPR_RF             6'd32   // 1024 >> 5
`define BA22_SPR_NPC            11'd16
`define BA22_SPR_SR             11'd17
`define BA22_SPR_PPC            11'd18
`define BA22_SPR_UR             11'd19
`define BA22_SPR_EPCR           11'd32
`define BA22_SPR_EEAR           11'd48
`define BA22_SPR_ESR            11'd64
`define BA22_SPR_EUR            11'd80

`define BA22_SPR_VECT_VR        11'b000_0000_0000
`define BA22_SPR_VECT_UP        11'b000_0000_0001
`define BA22_SPR_VECT_CFGR      11'b000_0000_0010
`define BA22_SPR_VECT_DCFGR     11'b000_0000_0111
`define BA22_SPR_VECT_CPUID     11'b000_0000_1001
`define BA22_SPR_VECT_REVISION  11'b000_0000_1111
`define BA22_SPR_VECT_RF        11'b10?_????_????
`define BA22_SPR_VECT_NPC       11'b000_0001_0000
`define BA22_SPR_VECT_SR        11'b000_0001_0001
`define BA22_SPR_VECT_UR        11'b000_0001_0011
`define BA22_SPR_VECT_PC        11'b000_0001_0000
`define BA22_SPR_VECT_EPCR      11'b000_0010_????
`define BA22_SPR_VECT_EEAR      11'b000_0011_????
`define BA22_SPR_VECT_ESR       11'b000_0100_????
`define BA22_SPR_VECT_EUR       11'b000_0101_????
`define BA22_SPR_VECT_JPC       11'b000_1000_0000

`define BA22_SPR_VECT_DMMUCFGR  11'b000_0000_0011
`define BA22_SPR_VECT_IMMUCFGR  11'b000_0000_0100
`define BA22_SPR_VECT_DCCFGR    11'b000_0000_0101
`define BA22_SPR_VECT_ICCFGR    11'b000_0000_0110
`define BA22_SPR_VECT_DCFGR     11'b000_0000_0111

//
// SR bits
//
`define BA22_SR_WIDTH 25
`define BA22_SR_SM   0
`define BA22_SR_TEE  1
`define BA22_SR_IEE  2
`define BA22_SR_DCE  3
`define BA22_SR_ICE  4
`define BA22_SR_DME  5
`define BA22_SR_IME  6
`define BA22_SR_LEE  7
`define BA22_SR_CE   8
`define BA22_SR_F    9
`define BA22_SR_CY   10 // Unused
`define BA22_SR_OV   11 // Unused
`define BA22_SR_TED  12 // Unused
`define BA22_SR_DSX  13 // Unused
`define BA22_SR_EPH  14
`define BA22_SR_FO   15
`define BA22_SR_FPEE_FOV    16
`define BA22_SR_FPEE_FUN    17
`define BA22_SR_FPEE_FSN    18
`define BA22_SR_FPEE_FQN    19
`define BA22_SR_FPEE_FZ     20
`define BA22_SR_FPEE_FIX    21
`define BA22_SR_FPEE_FIV    22
`define BA22_SR_FPEE_FIN    23
`define BA22_SR_FPEE_FDZ    24
`define BA22_SR_FPEE `BA22_SR_FPEE_FDZ : `BA22_SR_FPEE_FOV

`define BA22_SR_CID  31:28      // Unimplemented

`ifdef BA22_FPU32_IMPLEMENTED 
    `define BA22_UR_IMPLEMENTED
`else
    `ifdef BA22_MAC_FLAGS_IMPLEMENTED
        `define BA22_UR_IMPLEMENTED
    `else
        `ifdef BA22_DMMU_IMPLEMENTED
            `define BA22_UR_IMPLEMENTED
        `endif
    `endif
`endif

`define BA22_UR_WIDTH 32
`define BA22_UR_MACCY 10
`define BA22_UR_MACOVH 11
`define BA22_UR_MACOVL 12
`define BA22_UR_FRM  26:25
`define BA22_UR_FOV  16 
`define BA22_UR_FUN  17 
`define BA22_UR_FSN  18 
`define BA22_UR_FQN  19 
`define BA22_UR_FZ   20 
`define BA22_UR_FIX  21 
`define BA22_UR_FIV  22 
`define BA22_UR_FIN  23 
`define BA22_UR_FDZ  24
`define BA22_UR_DPFW 31


`define BA22_UR_FPU_FLAGS   `BA22_UR_FDZ:`BA22_UR_FOV

`define BA22_EXC_HIGH       32'hF000_0000
`define BA22_EXC_LOW        32'h0000_0000

`define BA22_F_FLAG_POS 0
`define BA22_C_FLAG_POS 1
`define BA22_O_FLAG_POS 2



/////////////////////////////////////////////////////
//
// Debug Unit (DU)
//
`define BA22_DU_SPR_RANGE    10:0 
// Define it if you want DU implemented
//
// Enable support for any combination of four types of debugging
//
// SW Breakpoint (l.trap)    -> DSR[TE]==0 -> Resident debugger (trap exception)
// SW Breakpoint (l.trap)    -> DSR[TE]==1 -> Host debugger (JTAG)
// HW Breakpoint (DVRx/DCRx) -> DSR[TE]==0 -> Resident debugger (trap exception)
// HW Breakpoint (DVRx/DCRx) -> DSR[TE]==1 -> Host debugger (JTAG)
//
//

// Number of DVR/DCR pairs if HW breakpoints enabled
//      Comment / uncomment DU_DVRn / DU_DCRn pairs bellow according to this number ! 
//      DU_DVR0..DU_DVR7 should be uncommented for 8 DU_DVRDCR_PAIRS 
`define BA22_DU_DVRDCR_PAIRS 8

// Define if you want trace buffer
// (for now only available for Xilinx Virtex FPGAs)
//`ifdef BA22_ASIC
//`else
//`define BA22_DU_TB_IMPLEMENTED
//`endif

//
// Address offsets of DU registers inside DU group
//
// To not implement a register, doq not define its address
//      Comment / uncomment DU_DVRn / DU_DCRn pairs according to the number above ! 
//      DU_DVR0..DU_DVR7 should be uncommented for 8 DU_DVRDCR_PAIRS 


// Position of offset bits inside SPR address
`define BA22_DUOFS_BITS 10:0

// DCR bits
`define BA22_DU_DCR_DP  0
`define BA22_DU_DCR_CC  3:1
`define BA22_DU_DCR_SC  4
`define BA22_DU_DCR_CT  7:5

// DMR1 bits
`define BA22_DU_DMR1_CW0        1:0
`define BA22_DU_DMR1_CW1        3:2
`define BA22_DU_DMR1_CW2        5:4
`define BA22_DU_DMR1_CW3        7:6
`define BA22_DU_DMR1_CW4        9:8
`define BA22_DU_DMR1_CW5        11:10
`define BA22_DU_DMR1_CW6        13:12
`define BA22_DU_DMR1_CW7        15:14
`define BA22_DU_DMR1_CW8        17:16
`define BA22_DU_DMR1_CW9        19:18
`define BA22_DU_DMR1_CW10       21:20
`define BA22_DU_DMR1_ST 22
`define BA22_DU_DMR1_BT 23
`define BA22_DU_DMR1_DXFW       24
`define BA22_DU_DMR1_ETE        25

// DMR2 bits
`define BA22_DU_DMR2_WCE0       0
`define BA22_DU_DMR2_WCE1       1
`define BA22_DU_DMR2_AWTC       11:2
`define BA22_DU_DMR2_WGB        21:12
`define BA22_DU_DMR2_WBS        31:22
// DWCR bits
`define BA22_DU_DWCR_COUNT      15:0
`define BA22_DU_DWCR_MATCH      31:16

// DSR bits
`define BA22_DU_DSR_WIDTH       14
`define BA22_DU_DSR_RSTE        0
`define BA22_DU_DSR_BUSEE       1
`define BA22_DU_DSR_DPFE        2
`define BA22_DU_DSR_IPFE        3
`define BA22_DU_DSR_TTE 4
`define BA22_DU_DSR_AE  5
`define BA22_DU_DSR_IIE 6
`define BA22_DU_DSR_INTE        7
`define BA22_DU_DSR_DME 8
`define BA22_DU_DSR_IME 9
`define BA22_DU_DSR_RE  10
`define BA22_DU_DSR_SCE 11
`define BA22_DU_DSR_FPE 12
`define BA22_DU_DSR_TE  13

// DRR bits
`define BA22_DU_DRR_RSTE        0
`define BA22_DU_DRR_BUSEE       1
`define BA22_DU_DRR_DPFE        2
`define BA22_DU_DRR_IPFE        3
`define BA22_DU_DRR_TTE 4
`define BA22_DU_DRR_AE  5
`define BA22_DU_DRR_IIE 6
`define BA22_DU_DRR_IE  7
`define BA22_DU_DRR_DME 8
`define BA22_DU_DRR_IME 9
`define BA22_DU_DRR_RE  10
`define BA22_DU_DRR_SCE 11
`define BA22_DU_DRR_FPE 12
`define BA22_DU_DRR_TE  13

// Trace port (uses masks)
`define BA22_DU_TRP_EN  32'h00000001
`define BA22_DU_TRP_OVR 32'h00000002
`define BA22_DU_TRP_SYN 32'h00000004

// Define if reading DU regs is allowed
`define BA22_DU_READREGS

// Define if unused DU registers bits should be zero
`define BA22_DU_UNUSED_ZERO

// Define if IF/LSU status is not needed by devel i/f
`define BA22_DU_STATUS_UNIMPLEMENTED

`define BA22_DTLB_INDXL `BA22_DMMU_PS                        // 13                    13
`define BA22_DTLB_INDXH `BA22_DMMU_PS+`BA22_DTLB_INDXW-1     // 18                    19
`define BA22_DTLB_INDX  `BA22_DTLB_INDXH:`BA22_DTLB_INDXL    // 18:13                 19:13
`define BA22_DTLB_TAGW  32-`BA22_DTLB_INDXW-`BA22_DMMU_PS    // 13                    12
`define BA22_DTLB_TAGL  `BA22_DTLB_INDXH+1                   // 19                    20
`define BA22_DTLB_TAG   31:`BA22_DTLB_TAGL                   // 31:19                 31:20
`define BA22_DTLBMRW    `BA22_DTLB_TAGW+1                    // +1 because of V bit
`define BA22_DTLBTRW    32-`BA22_DMMU_PS+5                   // +5 because of protection bits and CI

`define BA22_DTLBMR_V_IMPLEMENTED       
//`define BA22_DTLBMR_CID_IMPLEMENTED   
//`define BA22_DTLBMR_RES_IMPLEMENTED   
`define BA22_DTLBMR_VPN_IMPLEMENTED     
                                        
//`define BA22_DTLBTR_CC_IMPLEMENTED    
`define BA22_DTLBTR_CI_IMPLEMENTED      
//`define BA22_DTLBTR_WBC_IMPLEMENTED   
//`define BA22_DTLBTR_WOM_IMPLEMENTED   
//`define BA22_DTLBTR_A_IMPLEMENTED     
//`define BA22_DTLBTR_D_IMPLEMENTED     
`define BA22_DTLBTR_URE_IMPLEMENTED     
`define BA22_DTLBTR_UWE_IMPLEMENTED     
`define BA22_DTLBTR_SRE_IMPLEMENTED     
`define BA22_DTLBTR_SWE_IMPLEMENTED     
//`define BA22_DTLBTR_RES_IMPLEMENTED   
`define BA22_DTLBTR_PPN_IMPLEMENTED     

`define BA22_DTLBMR_V_WIDTH      1       
`define BA22_DTLBMR_CID_WIDTH    4-1  +1 
`define BA22_DTLBMR_RES_WIDTH    12-5 +1 
`define BA22_DTLBMR_VPN_WIDTH    31-13+1 

`define BA22_DTLBTR_CC_WIDTH     1
`define BA22_DTLBTR_CI_WIDTH     1
`define BA22_DTLBTR_WBC_WIDTH    1
`define BA22_DTLBTR_WOM_WIDTH    1
`define BA22_DTLBTR_A_WIDTH      1
`define BA22_DTLBTR_D_WIDTH      1
`define BA22_DTLBTR_URE_WIDTH    1
`define BA22_DTLBTR_UWE_WIDTH    1
`define BA22_DTLBTR_SRE_WIDTH    1
`define BA22_DTLBTR_SWE_WIDTH    1
`define BA22_DTLBTR_RES_WIDTH    12-10+1
`define BA22_DTLBTR_PPN_WIDTH    31-13+1

`ifdef  BA22_DTLBMR_V_IMPLEMENTED
`define BA22_DTLBMR_V_IMPLWIDTH     `BA22_DTLBMR_V_WIDTH          
`else
`define BA22_DTLBMR_V_IMPLWIDTH     0
`endif                                                              
`ifdef  BA22_DTLBMR_CID_IMPLEMENTED
`define BA22_DTLBMR_CID_IMPLWIDTH   `BA22_DTLBMR_CID_WIDTH     
`else
`define BA22_DTLBMR_CID_IMPLWIDTH   0
`endif                                                              
`ifdef  BA22_DTLBMR_RES_IMPLEMENTED 
`define BA22_DTLBMR_RES_IMPLWIDTH   `BA22_DTLBMR_RES_WIDTH     
`else
`define BA22_DTLBMR_RES_IMPLWIDTH   0
`endif                                                              
`ifdef  BA22_DTLBMR_VPN_IMPLEMENTED 
`define BA22_DTLBMR_VPN_IMPLWIDTH   `BA22_DTLBMR_VPN_WIDTH     
`else
`define BA22_DTLBMR_VPN_IMPLWIDTH   0
`endif                                                              
`ifdef  BA22_DTLBTR_CC_IMPLEMENTED 
`define BA22_DTLBTR_CC_IMPLWIDTH    `BA22_DTLBTR_CC_WIDTH      
`else
`define BA22_DTLBTR_CC_IMPLWIDTH    0
`endif
`ifdef  BA22_DTLBTR_CI_IMPLEMENTED  
`define BA22_DTLBTR_CI_IMPLWIDTH    `BA22_DTLBTR_CI_WIDTH      
`else
`define BA22_DTLBTR_CI_IMPLWIDTH    0
`endif
`ifdef  BA22_DTLBTR_WBC_IMPLEMENTED  
`define BA22_DTLBTR_WBC_IMPLWIDTH   `BA22_DTLBTR_WBC_WIDTH     
`else
`define BA22_DTLBTR_WBC_IMPLWIDTH   0
`endif
`ifdef  BA22_DTLBTR_WOM_IMPLEMENTED 
`define BA22_DTLBTR_WOM_IMPLWIDTH   `BA22_DTLBTR_WOM_WIDTH     
`else
`define BA22_DTLBTR_WOM_IMPLWIDTH   0
`endif
`ifdef  BA22_DTLBTR_A_IMPLEMENTED 
`define BA22_DTLBTR_A_IMPLWIDTH     `BA22_DTLBTR_A_WIDTH       
`else
`define BA22_DTLBTR_A_IMPLWIDTH     0
`endif
`ifdef  BA22_DTLBTR_D_IMPLEMENTED   
`define BA22_DTLBTR_D_IMPLWIDTH     `BA22_DTLBTR_D_WIDTH       
`else
`define BA22_DTLBTR_D_IMPLWIDTH     0
`endif
`ifdef  BA22_DTLBTR_URE_IMPLEMENTED   
`define BA22_DTLBTR_URE_IMPLWIDTH   `BA22_DTLBTR_URE_WIDTH     
`else
`define BA22_DTLBTR_URE_IMPLWIDTH   0
`endif
`ifdef  BA22_DTLBTR_UWE_IMPLEMENTED 
`define BA22_DTLBTR_UWE_IMPLWIDTH   `BA22_DTLBTR_UWE_WIDTH     
`else
`define BA22_DTLBTR_UWE_IMPLWIDTH   0
`endif
`ifdef  BA22_DTLBTR_SRE_IMPLEMENTED 
`define BA22_DTLBTR_SRE_IMPLWIDTH   `BA22_DTLBTR_SRE_WIDTH     
`else
`define BA22_DTLBTR_SRE_IMPLWIDTH   0
`endif
`ifdef  BA22_DTLBTR_SWE_IMPLEMENTED 
`define BA22_DTLBTR_SWE_IMPLWIDTH   `BA22_DTLBTR_SWE_WIDTH     
`else
`define BA22_DTLBTR_SWE_IMPLWIDTH   0
`endif
`ifdef  BA22_DTLBTR_RES_IMPLEMENTED 
`define BA22_DTLBTR_RES_IMPLWIDTH   `BA22_DTLBTR_RES_WIDTH     
`else
`define BA22_DTLBTR_RES_IMPLWIDTH   0
`endif
`ifdef  BA22_DTLBTR_PPN_IMPLEMENTED 
`define BA22_DTLBTR_PPN_IMPLWIDTH   `BA22_DTLBTR_PPN_WIDTH     
`else
`define BA22_DTLBTR_PPN_IMPLWIDTH   0
`endif
`define BA22_MMU2_MODEL
`ifdef BA22_MMU2_MODEL
    `define BA22_DTLB_MEM_WIDTH 43
`else
    `define BA22_DTLB_MEM_WIDTH (`BA22_DTLBMR_V_IMPLWIDTH+`BA22_DTLBMR_CID_IMPLWIDTH+`BA22_DTLBMR_RES_IMPLWIDTH+`BA22_DTLBMR_VPN_IMPLWIDTH+`BA22_DTLBTR_CC_IMPLWIDTH+`BA22_DTLBTR_CI_IMPLWIDTH+`BA22_DTLBTR_WBC_IMPLWIDTH+`BA22_DTLBTR_WOM_IMPLWIDTH+`BA22_DTLBTR_A_IMPLWIDTH+`BA22_DTLBTR_D_IMPLWIDTH+`BA22_DTLBTR_URE_IMPLWIDTH+`BA22_DTLBTR_UWE_IMPLWIDTH+`BA22_DTLBTR_SRE_IMPLWIDTH+`BA22_DTLBTR_SWE_IMPLWIDTH+`BA22_DTLBTR_RES_IMPLWIDTH+`BA22_DTLBTR_PPN_IMPLWIDTH)
`endif

`define BA22_DTLB_MEM_RANGE     `BA22_DTLB_WAYS*`BA22_DTLB_MEM_WIDTH-1:0


`define BA22_DTLBMR_V_BITS      0
`define BA22_DTLBMR_CID_BITS    4:1
`define BA22_DTLBMR_RES_BITS    12:5
`define BA22_DTLBMR_VPN_BITS    31:13

`define BA22_DTLBTR_CC_BITS     0
`define BA22_DTLBTR_CI_BITS     1
`define BA22_DTLBTR_WBC_BITS    2
`define BA22_DTLBTR_WOM_BITS    3
`define BA22_DTLBTR_A_BITS      4
`define BA22_DTLBTR_D_BITS      5
`define BA22_DTLBTR_URE_BITS    6
`define BA22_DTLBTR_UWE_BITS    7
`define BA22_DTLBTR_SRE_BITS    8
`define BA22_DTLBTR_SWE_BITS    9
`define BA22_DTLBTR_RES_BITS    12:10
`define BA22_DTLBTR_PPN_BITS    31:13

`define BA22_DMMU_OFFSET        3:0 
`define BA22_DMMU_TLBTR2        4'b1010
`define BA22_DMMU_TLBMR2        4'b1000
`define BA22_DMMU_TLBTR         4'b0110
`define BA22_DMMU_TLBMR         4'b0100
`define BA22_DMMU_TLBEIR        4'b0010
`define BA22_DTLB_DAT_INV       {60'hxxxx_xxxx_xxxx_xxx,3'bxxx,1'b0}

`define BA22_DTLB_LRU           2:0
`define BA22_DTLB_LRU_W         3


/* INSTRUCTION MEMORY MANAGENMENT UNIT */

`define BA22_IMMU_OFFSET        3:0 
`define BA22_IMMU_TLBTR2        4'b1010
`define BA22_IMMU_TLBMR2        4'b1000
`define BA22_IMMU_TLBTR         4'b0110
`define BA22_IMMU_TLBMR         4'b0100
`define BA22_IMMU_TLBEIR        4'b0010
`define BA22_ITLB_DAT_INV       {60'hxxxx_xxxx_xxxx_xxx,3'bxxx,1'b0}


// ITLBMR fields implemented
//
`define BA22_ITLBMR_V_IMPLEMENTED
`define BA22_ITLBMR_CID_IMPLEMENTED 
`define BA22_ITLBMR_RES_IMPLEMENTED 
`define BA22_ITLBMR_VPN_IMPLEMENTED 

//
// ITLBTR fields implemented
//
//`define BA22_ITLBTR_CC_IMPLEMENTED  
`define BA22_ITLBTR_CI_IMPLEMENTED  
//`define BA22_ITLBTR_WBC_IMPLEMENTED 
//`define BA22_ITLBTR_WOM_IMPLEMENTED 
//`define BA22_ITLBTR_A_IMPLEMENTED   
//`define BA22_ITLBTR_D_IMPLEMENTED   
`define BA22_ITLBTR_SXE_IMPLEMENTED 
`define BA22_ITLBTR_UXE_IMPLEMENTED 
//`define BA22_ITLBTR_RES_IMPLEMENTED 
`define BA22_ITLBTR_PPN_IMPLEMENTED 

//
// ITLBMR widths
//

`define BA22_ITLBMR_V_WIDTH            1
`define BA22_ITLBMR_CID_WIDTH          4-1+1
`define BA22_ITLBMR_RES_WIDTH          12-5+1
`define BA22_ITLBMR_VPN_WIDTH          31-13+1

//
// ITLBTR widths
//
`define BA22_ITLBTR_CC_WIDTH            1
`define BA22_ITLBTR_CI_WIDTH            1
`define BA22_ITLBTR_WBC_WIDTH           1
`define BA22_ITLBTR_WOM_WIDTH           1
`define BA22_ITLBTR_A_WIDTH             1
`define BA22_ITLBTR_D_WIDTH             1
`define BA22_ITLBTR_SXE_WIDTH           1
`define BA22_ITLBTR_UXE_WIDTH           1
`define BA22_ITLBTR_RES_WIDTH           12-8+1
`define BA22_ITLBTR_PPN_WIDTH           31-13+1

`ifdef  BA22_ITLBMR_V_IMPLEMENTED
`define BA22_ITLBMR_V_IMPLWIDTH     `BA22_ITLBMR_V_WIDTH          
`else
`define BA22_ITLBMR_V_IMPLWIDTH     0
`endif                                                              
`ifdef  BA22_ITLBMR_CID_IMPLEMENTED
`define BA22_ITLBMR_CID_IMPLWIDTH   `BA22_ITLBMR_CID_WIDTH     
`else
`define BA22_ITLBMR_CID_IMPLWIDTH   0
`endif                                                              
`ifdef  BA22_ITLBMR_RES_IMPLEMENTED 
`define BA22_ITLBMR_RES_IMPLWIDTH   `BA22_ITLBMR_RES_WIDTH     
`else
`define BA22_ITLBMR_RES_IMPLWIDTH   0
`endif                                                              
`ifdef  BA22_ITLBMR_VPN_IMPLEMENTED 
`define BA22_ITLBMR_VPN_IMPLWIDTH   `BA22_ITLBMR_VPN_WIDTH     
`else
`define BA22_ITLBMR_VPN_IMPLWIDTH   0
`endif                                                              
`ifdef  BA22_ITLBTR_CC_IMPLEMENTED 
`define BA22_ITLBTR_CC_IMPLWIDTH    `BA22_ITLBTR_CC_WIDTH      
`else
`define BA22_ITLBTR_CC_IMPLWIDTH    0
`endif
`ifdef  BA22_ITLBTR_CI_IMPLEMENTED  
`define BA22_ITLBTR_CI_IMPLWIDTH    `BA22_ITLBTR_CI_WIDTH      
`else
`define BA22_ITLBTR_CI_IMPLWIDTH    0
`endif
`ifdef  BA22_ITLBTR_WBC_IMPLEMENTED  
`define BA22_ITLBTR_WBC_IMPLWIDTH   `BA22_ITLBTR_WBC_WIDTH     
`else
`define BA22_ITLBTR_WBC_IMPLWIDTH   0
`endif
`ifdef  BA22_ITLBTR_WOM_IMPLEMENTED 
`define BA22_ITLBTR_WOM_IMPLWIDTH   `BA22_ITLBTR_WOM_WIDTH     
`else
`define BA22_ITLBTR_WOM_IMPLWIDTH   0
`endif
`ifdef  BA22_ITLBTR_A_IMPLEMENTED 
`define BA22_ITLBTR_A_IMPLWIDTH     `BA22_ITLBTR_A_WIDTH       
`else
`define BA22_ITLBTR_A_IMPLWIDTH     0
`endif
`ifdef  BA22_ITLBTR_D_IMPLEMENTED   
`define BA22_ITLBTR_D_IMPLWIDTH     `BA22_ITLBTR_D_WIDTH       
`else
`define BA22_ITLBTR_D_IMPLWIDTH     0
`endif
`ifdef  BA22_ITLBTR_SXE_IMPLEMENTED   
`define BA22_ITLBTR_SXE_IMPLWIDTH   `BA22_ITLBTR_SXE_WIDTH     
`else
`define BA22_ITLBTR_SXE_IMPLWIDTH   0
`endif
`ifdef  BA22_ITLBTR_UXE_IMPLEMENTED 
`define BA22_ITLBTR_UXE_IMPLWIDTH   `BA22_ITLBTR_UXE_WIDTH     
`else
`define BA22_ITLBTR_UXE_IMPLWIDTH   0
`endif
`ifdef  BA22_ITLBTR_RES_IMPLEMENTED 
`define BA22_ITLBTR_RES_IMPLWIDTH   `BA22_ITLBTR_RES_WIDTH     
`else
`define BA22_ITLBTR_RES_IMPLWIDTH   0
`endif
`ifdef  BA22_ITLBTR_PPN_IMPLEMENTED 
`define BA22_ITLBTR_PPN_IMPLWIDTH   `BA22_ITLBTR_PPN_WIDTH     
`else
`define BA22_ITLBTR_PPN_IMPLWIDTH   0
`endif

`ifdef BA22_MMU2_MODEL
    `define BA22_ITLB_MEM_WIDTH 42
`else
`define BA22_ITLB_MEM_WIDTH (`BA22_ITLBMR_V_IMPLWIDTH+`BA22_ITLBMR_CID_IMPLWIDTH+`BA22_ITLBMR_RES_IMPLWIDTH+`BA22_ITLBMR_VPN_IMPLWIDTH+`BA22_ITLBTR_CC_IMPLWIDTH+`BA22_ITLBTR_CI_IMPLWIDTH+`BA22_ITLBTR_WBC_IMPLWIDTH+`BA22_ITLBTR_WOM_IMPLWIDTH+`BA22_ITLBTR_A_IMPLWIDTH+`BA22_ITLBTR_D_IMPLWIDTH+`BA22_ITLBTR_SXE_IMPLWIDTH+`BA22_ITLBTR_UXE_IMPLWIDTH+`BA22_ITLBTR_RES_IMPLWIDTH+`BA22_ITLBTR_PPN_IMPLWIDTH)
`endif
`define BA22_ITLB_MEM_RANGE     `BA22_ITLB_WAYS*`BA22_ITLB_MEM_WIDTH-1:0

/* Data page size (13 for 8KB)                                  */
`define BA22_DMMU_PS 13
/* Instruction page size (13 for 8KB)                           */
`define BA22_IMMU_PS 13

//
// ITLBMR fields
//

`define BA22_ITLBMR_V_BITS             0
`define BA22_ITLBMR_CID_BITS           4:1
`define BA22_ITLBMR_RES_BITS           12:5
`define BA22_ITLBMR_VPN_BITS           31:13

//
// ITLBTR fields
//
`define BA22_ITLBTR_CC_BITS            0
`define BA22_ITLBTR_CI_BITS            1
`define BA22_ITLBTR_WBC_BITS           2
`define BA22_ITLBTR_WOM_BITS           3
`define BA22_ITLBTR_A_BITS             4
`define BA22_ITLBTR_D_BITS             5
`define BA22_ITLBTR_SXE_BITS           6
`define BA22_ITLBTR_UXE_BITS           7
`define BA22_ITLBTR_RES_BITS           12:8
`define BA22_ITLBTR_PPN_BITS           31:13

//
// ITLB configuration
//
`define BA22_ITLB_INDXL `BA22_IMMU_PS                        // 13                    13
`define BA22_ITLB_INDXH `BA22_IMMU_PS+`BA22_ITLB_INDXW-1     // 18                    19
`define BA22_ITLB_INDX  `BA22_ITLB_INDXH:`BA22_ITLB_INDXL    // 18:13                 19:13
`define BA22_ITLB_TAGW  32-`BA22_ITLB_INDXW-`BA22_IMMU_PS    // 13                    12
`define BA22_ITLB_TAGL  `BA22_ITLB_INDXH+1                   // 19                    20
`define BA22_ITLB_TAG   31:`BA22_ITLB_TAGL                   // 31:19                 31:20
`define BA22_ITLBMRW    `BA22_ITLB_TAGW+1                    // +1 because of V bit
`define BA22_ITLBTRW    32-`BA22_IMMU_PS+3                   // +3 because of protection bits and CI

`define BA22_ITLB_LRU           2:0
`define BA22_ITLB_LRU_W         3


//
// Cache inhibit while IMMU is not enabled/implemented
// Note: combinations that use icpu_adr_i might cause async loop
//
// cache inhibited 0GB-4GB             1'b1
// cache inhibited 0GB-2GB             !icpu_adr_i[31]
// cache inhibited 0GB-1GB 2GB-3GB     !icpu_adr_i[30]
// cache inhibited 1GB-2GB 3GB-4GB     icpu_adr_i[30]
// cache inhibited 2GB-4GB (default)   icpu_adr_i[31]
// cached 0GB-4GB                      1'b0
//
`define BA22_IMMU_CI                   1'b0


// DATA CACHE

//`define BA22_DC_NB

`define BA22_DC_OFFSET     3:0
`define BA22_DC_DCBIR      4'b0011
`define BA22_DC_DCFRI      4'b0010

`define BA22_DC_BYTE_W  2
`define BA22_DC_BYTE    1:0

`define BA22_DC_BLCK_L  2
`define BA22_DC_BLCK_H  (`BA22_DC_BLCK_W + 2-1                    )    /*3                     */

`define BA22_DC_INDX_L  (`BA22_DC_BLCK_H + 1                      )   /*4                     */
`define BA22_DC_INDX_H  (`BA22_DC_INDX_L + `BA22_DC_INDX_W - 1    )   /*4+4   =8              */
`define BA22_DC_TAG_H   (31                                       )
`define BA22_DC_TAG_L   (`BA22_DC_INDX_H + 1                      )   /*9                     */
`define BA22_DC_TAG_W   (`BA22_DC_TAG_H - `BA22_DC_TAG_L + 1      )   /*31 - 9  + 1 = 22      */

`define BA22_DC_DAT_ADR `BA22_DC_INDX_H     : 0
`define BA22_DC_BLCK    `BA22_DC_BLCK_H     : `BA22_DC_BLCK_L       /*3:2                   */
`define BA22_DC_INDX    `BA22_DC_INDX_H     : `BA22_DC_INDX_L       /*13:4                  */
`define BA22_DC_TAG     `BA22_DC_TAG_H      : `BA22_DC_TAG_L        /*31:14                 */
`define BA22_DC_TAGV    `BA22_DC_TAG_H + 1  : `BA22_DC_TAG_L        /*32:14                 */
`define BA22_DC_V       `BA22_DC_TAG_H + 1                          /*32                    */

`define BA22_DC_LRU     2:0
`define BA22_DC_LRU_W   3

// INSTRUCTION CACHE


`define BA22_IC_OFFSET     4:0
`define BA22_IC_ICIR       4'b0010




// 2^BA22_IC_INDX_W * 2^ BA22_IC_BLCK_W * 4[Bytes per word] * 4[ways] = 2^6
// // * 2^3 * 2^2 * 2^2 = 2^(6+3+2+2) = 2^13 = 8Kbytes
//
`define BA22_IC_BLCK_L  2
`define BA22_IC_BLCK_H  (`BA22_IC_BLCK_W + 2-1                    )    /*3                     */

`define BA22_IC_INDX_L  (`BA22_IC_BLCK_H + 1                      )   /*4                     */
`define BA22_IC_INDX_H  (`BA22_IC_INDX_L + `BA22_IC_INDX_W - 1    )   /*4+4   =8              */
`define BA22_IC_TAG_H   (31                                       )
`define BA22_IC_TAG_L   (`BA22_IC_INDX_H + 1                      )   /*9                     */
`define BA22_IC_TAG_W   (`BA22_IC_TAG_H - `BA22_IC_TAG_L + 1      )   /*31 - 9  + 1 = 22      */

`define BA22_IC_DAT_ADR `BA22_IC_INDX_H     : 0
`define BA22_IC_BLCK    `BA22_IC_BLCK_H     : `BA22_IC_BLCK_L       /*3:2                   */
`define BA22_IC_INDX    `BA22_IC_INDX_H     : `BA22_IC_INDX_L       /*13:4                  */
`define BA22_IC_TAG     `BA22_IC_TAG_H      : `BA22_IC_TAG_L        /*31:14                 */
`define BA22_IC_TAGV    `BA22_IC_TAG_H + 1  : `BA22_IC_TAG_L        /*32:14                 */
`define BA22_IC_V       `BA22_IC_TAG_H + 1                          /*32                    */

`define BA22_IC_LRU     2:0
`define BA22_IC_LRU_W   3

// BRANCH TARGET CACHE
`define BA22_2WAY_BTC

`ifdef BA22_1WAY_BTC
//    `define SIM_BTC_ENABLE
    // | TAG | VALID | PC | BP |
    `define BA22_BTC_RAM_ADR_W  (`BA22_BTC_INDEX_W - 1)
    `define BA22_BTC_RAM_DAT_W  `BA22_BTC_TAG_H

    `define BA22_BTC_BP_W       2
    `define BA22_BTC_PC_W       32
    `define BA22_BTC_VALID_W    1
    `define BA22_BTC_LRU_W      1
    `define BA22_BTC_TAG_W      (32 - `BA22_BTC_INDEX_W)        //32 - 5 = 27
    `define BA22_BTC_INDEX_W    7
    
    `define BA22_BTC_BP_L      0
    `define BA22_BTC_BP_H      (`BA22_BTC_BP_L + `BA22_BTC_BP_W - 1)
    `define BA22_BTC_PC_L      (`BA22_BTC_BP_W)
    `define BA22_BTC_PC_H      (`BA22_BTC_PC_L + `BA22_BTC_PC_W - 1)
    `define BA22_BTC_VALID_L   (`BA22_BTC_BP_W + `BA22_BTC_PC_W)
    `define BA22_BTC_VALID_H   (`BA22_BTC_VALID_L + `BA22_BTC_VALID_W - 1)
    `define BA22_BTC_TAG_L     (`BA22_BTC_BP_W + `BA22_BTC_PC_W  + `BA22_BTC_VALID_W)
    `define BA22_BTC_TAG_H     (`BA22_BTC_TAG_L + `BA22_BTC_TAG_W - 1)
`endif

`ifdef BA22_2WAY_BTC
//  `define SIM_BTC_ENABLE
    // | WAY1_TAG | WAY1_LRU | WAY1_VALID | WAY1_PC | WAY1_BP | WAY0_TAG | WAY0_LRU | WAY0_VALID | WAY0_PC | WAY0_BP |
    `define BA22_BTC_RAM_ADR_W  (`BA22_BTC_INDEX_W - 1)
    `define BA22_BTC_RAM_DAT_W  `BA22_BTC_WAY1_TAG_H
    
    `define BA22_BTC_BP_W       2
    `define BA22_BTC_PC_W       32
    `define BA22_BTC_VALID_W    1
    `define BA22_BTC_LRU_W      1
    `define BA22_BTC_TAG_W      (32 - `BA22_BTC_INDEX_W)        //32 - 5 = 27
    `define BA22_BTC_INDEX_W    6
    
    `define BA22_BTC_WAY0_BP_L      0
    `define BA22_BTC_WAY0_BP_H      (`BA22_BTC_WAY0_BP_L + `BA22_BTC_BP_W - 1)
    `define BA22_BTC_WAY0_PC_L      (`BA22_BTC_BP_W)
    `define BA22_BTC_WAY0_PC_H      (`BA22_BTC_WAY0_PC_L + `BA22_BTC_PC_W - 1)
    `define BA22_BTC_WAY0_VALID_L   (`BA22_BTC_BP_W + `BA22_BTC_PC_W)
    `define BA22_BTC_WAY0_VALID_H   (`BA22_BTC_WAY0_VALID_L + `BA22_BTC_VALID_W - 1)
    `define BA22_BTC_WAY0_LRU_L     (`BA22_BTC_BP_W + `BA22_BTC_PC_W  + `BA22_BTC_VALID_W)
    `define BA22_BTC_WAY0_LRU_H     (`BA22_BTC_WAY0_LRU_L + `BA22_BTC_LRU_W  - 1)
    `define BA22_BTC_WAY0_TAG_L     (`BA22_BTC_BP_W + `BA22_BTC_PC_W  + `BA22_BTC_VALID_W + `BA22_BTC_LRU_W)
    `define BA22_BTC_WAY0_TAG_H     (`BA22_BTC_WAY0_TAG_L + `BA22_BTC_TAG_W - 1)
    
    `define BA22_BTC_WAY1_BP_L      (`BA22_BTC_BP_W + `BA22_BTC_PC_W + `BA22_BTC_VALID_W + `BA22_BTC_LRU_W + `BA22_BTC_TAG_W)
    `define BA22_BTC_WAY1_BP_H      (`BA22_BTC_WAY1_BP_L + `BA22_BTC_BP_W - 1)   
    `define BA22_BTC_WAY1_PC_L      (2*`BA22_BTC_BP_W + `BA22_BTC_PC_W + `BA22_BTC_VALID_W + `BA22_BTC_LRU_W + `BA22_BTC_TAG_W)
    `define BA22_BTC_WAY1_PC_H      (`BA22_BTC_WAY1_PC_L + `BA22_BTC_PC_W - 1)
    `define BA22_BTC_WAY1_VALID_L   (2*`BA22_BTC_BP_W + 2*`BA22_BTC_PC_W + `BA22_BTC_VALID_W + `BA22_BTC_LRU_W + `BA22_BTC_TAG_W)
    `define BA22_BTC_WAY1_VALID_H   (`BA22_BTC_WAY1_VALID_L + `BA22_BTC_VALID_W - 1)
    `define BA22_BTC_WAY1_LRU_L     (2*`BA22_BTC_BP_W + 2*`BA22_BTC_PC_W + 2*`BA22_BTC_VALID_W + `BA22_BTC_LRU_W + `BA22_BTC_TAG_W)
    `define BA22_BTC_WAY1_LRU_H     (`BA22_BTC_WAY1_LRU_L + `BA22_BTC_LRU_W - 1)
    `define BA22_BTC_WAY1_TAG_L     (2*`BA22_BTC_BP_W + 2*`BA22_BTC_PC_W + 2*`BA22_BTC_VALID_W + 2*`BA22_BTC_LRU_W + `BA22_BTC_TAG_W)
    `define BA22_BTC_WAY1_TAG_H     (`BA22_BTC_WAY1_TAG_L + `BA22_BTC_TAG_W - 1)
`endif


//`ifdef BA22_SIM
    `define BA22_PIPE_INST              /*pipeline instructions through the pipeline*/
//`endif

`ifdef BA22_RST_ACT_HIGH
    `define BA22_RST_I_VAL  (1'b1)
    `ifdef BA22_RST_ASYNC
        `define BA22_RST_I_EVENT or posedge rst_i
    `endif
`else
    `define BA22_RST_I_VAL  (1'b0)
    `ifdef BA22_RST_ASYNC
        `define BA22_RST_I_EVENT or negedge rst_i
    `endif
`endif

`define BA22_RST_I_ACT (rst_i == `BA22_RST_I_VAL)

`define BA22_INSN_WIDTH_ENC_WIDTH    4
`define BA22_INSN_WIDTH_RESERVED_ENC 4'h1, 4'hb
`define BA22_INSN_16BIT_WIDE_ENC     4'h0
`define BA22_INSN_24BIT_WIDE_ENC     4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7, 4'hf
`define BA22_INSN_32BIT_WIDE_ENC     4'hc, 4'hd
`define BA22_INSN_48BIT_WIDE_ENC     4'h8, 4'h9, 4'ha, 4'he
`define BA22_OPC_BT_MOVI            {4'h0,44'b00_??_???0_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BT_ADDI            {4'h0,44'b00_??_???1_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BT_MOV             {4'h0,44'b01_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BT_ADD             {4'h0,44'b10_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BT_J               {4'h0,44'b11_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SB              {4'h2,44'b00_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_LBZ             {4'h2,44'b01_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SH              {4'h2,44'b10_??_????_????_0???_????_????_????_????_????_????_????}
`define BA22_OPC_BN_LHZ             {4'h2,44'b10_??_????_????_1???_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SW              {4'h2,44'b11_??_????_????_00??_????_????_????_????_????_????_????}
`define BA22_OPC_BN_LWZ             {4'h2,44'b11_??_????_????_01??_????_????_????_????_????_????_????}
`define BA22_OPC_BN_LWS             {4'h2,44'b11_??_????_????_10??_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SD              {4'h2,44'b11_??_????_????_110?_????_????_????_????_????_????_????}
`define BA22_OPC_BN_LD              {4'h2,44'b11_??_????_????_111?_????_????_????_????_????_????_????}
`define BA22_OPC_BN_ADDI            {4'h3,44'b00_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_ANDI            {4'h3,44'b01_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_ORI             {4'h3,44'b10_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFEQI           {4'h3,44'b11_00_000?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFNEI           {4'h3,44'b11_00_001?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFGESI          {4'h3,44'b11_00_010?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFGEUI          {4'h3,44'b11_00_011?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFGTSI          {4'h3,44'b11_00_100?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFGTUI          {4'h3,44'b11_00_101?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFLESI          {4'h3,44'b11_00_110?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFLEUI          {4'h3,44'b11_00_111?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFLTSI          {4'h3,44'b11_01_000?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFLTUI          {4'h3,44'b11_01_001?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFEQ            {4'h3,44'b11_01_010?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFNE            {4'h3,44'b11_01_011?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFGES           {4'h3,44'b11_01_100?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFGEU           {4'h3,44'b11_01_101?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFGTS           {4'h3,44'b11_01_110?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SFGTU           {4'h3,44'b11_01_111?_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_EXTBZ           {4'h3,44'b11_10_?00?_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_BN_EXTBS           {4'h3,44'b11_10_?00?_????_????_?001_????_????_????_????_????_????}
`define BA22_OPC_BN_EXTHZ           {4'h3,44'b11_10_?00?_????_????_?010_????_????_????_????_????_????}
`define BA22_OPC_BN_EXTHS           {4'h3,44'b11_10_?00?_????_????_?011_????_????_????_????_????_????}
`define BA22_OPC_BN_FF1             {4'h3,44'b11_10_?00?_????_????_?100_????_????_????_????_????_????}
`define BA22_OPC_BN_CLZ             {4'h3,44'b11_10_?00?_????_????_?101_????_????_????_????_????_????}
`define BA22_OPC_BN_BITREV          {4'h3,44'b11_10_?00?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_SWAB            {4'h3,44'b11_10_?00?_????_????_?111_????_????_????_????_????_????}
`define BA22_OPC_BN_MFSR            {4'h3,44'b11_10_?01?_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_BN_MTSR            {4'h3,44'b11_10_?01?_????_????_?001_????_????_????_????_????_????}
`define BA22_OPC_BN_BEQI            {4'h4,44'b00_00_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BNEI            {4'h4,44'b00_01_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BGESI           {4'h4,44'b00_10_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BGTSI           {4'h4,44'b00_11_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BLESI           {4'h4,44'b01_00_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BLTSI           {4'h4,44'b01_01_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_J               {4'h4,44'b01_10_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BF              {4'h4,44'b01_11_0010_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BNF             {4'h4,44'b01_11_0011_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BO              {4'h4,44'b01_11_0100_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BNO             {4'h4,44'b01_11_0101_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BC              {4'h4,44'b01_11_0110_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_BNC             {4'h4,44'b01_11_0111_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_ENTRI           {4'h4,44'b01_11_1010_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_RETI            {4'h4,44'b01_11_1011_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_RTNEI           {4'h4,44'b01_11_1100_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_RETURN          {4'h4,44'b01_11_1101_??00_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_JALR            {4'h4,44'b01_11_1101_??01_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_JR              {4'h4,44'b01_11_1101_??10_????_????_????_????_????_????_????_????}

`define BA22_OPC_BN_JAL             {4'h4,44'b10_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_MLWZ            {4'h5,44'b00_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_MSW             {4'h5,44'b01_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BN_AND             {4'h6,44'b00_??_????_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_BN_OR              {4'h6,44'b00_??_????_????_????_?001_????_????_????_????_????_????}
`define BA22_OPC_BN_XOR             {4'h6,44'b00_??_????_????_????_?010_????_????_????_????_????_????}
`define BA22_OPC_BN_NAND            {4'h6,44'b00_??_????_????_????_?011_????_????_????_????_????_????}
`define BA22_OPC_BN_ADD             {4'h6,44'b00_??_????_????_????_?100_????_????_????_????_????_????}
`define BA22_OPC_BN_SUB             {4'h6,44'b00_??_????_????_????_?101_????_????_????_????_????_????}
`define BA22_OPC_BN_SLL             {4'h6,44'b00_??_????_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_SRL             {4'h6,44'b00_??_????_????_????_?111_????_????_????_????_????_????}
`define BA22_OPC_BN_SRA             {4'h6,44'b01_??_????_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_BN_ROR             {4'h6,44'b01_??_????_????_????_?001_????_????_????_????_????_????}
`define BA22_OPC_BN_CMOV            {4'h6,44'b01_??_????_????_????_?010_????_????_????_????_????_????}
`define BA22_OPC_BN_MUL             {4'h6,44'b01_??_????_????_????_?011_????_????_????_????_????_????}
`define BA22_OPC_BN_DIV             {4'h6,44'b01_??_????_????_????_?100_????_????_????_????_????_????}
`define BA22_OPC_BN_DIVU            {4'h6,44'b01_??_????_????_????_?101_????_????_????_????_????_????}
`define BA22_OPC_BN_ADDC            {4'h6,44'b01_??_????_????_????_?111_????_????_????_????_????_????}
`define BA22_OPC_BN_SUBB            {4'h6,44'b10_??_????_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_BN_FLB             {4'h6,44'b10_??_????_????_????_?001_????_????_????_????_????_????}
`define BA22_OPC_BN_MULHU           {4'h6,44'b10_??_????_????_????_?010_????_????_????_????_????_????}
`define BA22_OPC_BN_MULH            {4'h6,44'b10_??_????_????_????_?011_????_????_????_????_????_????}
`define BA22_OPC_BN_MOD             {4'h6,44'b10_??_????_????_????_?100_????_????_????_????_????_????}
`define BA22_OPC_BN_MODU            {4'h6,44'b10_??_????_????_????_?101_????_????_????_????_????_????}
`define BA22_OPC_BN_AADD            {4'h6,44'b10_??_????_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_CMPXCHG         {4'h6,44'b10_??_????_????_????_?111_????_????_????_????_????_????}
`define BA22_OPC_BN_SLLI            {4'h6,44'b11_??_????_????_????_??00_????_????_????_????_????_????}
`define BA22_OPC_BN_SRLI            {4'h6,44'b11_??_????_????_????_??01_????_????_????_????_????_????}
`define BA22_OPC_BN_SRAI            {4'h6,44'b11_??_????_????_????_??10_????_????_????_????_????_????}
`define BA22_OPC_BN_RORI            {4'h6,44'b11_??_????_????_????_??11_????_????_????_????_????_????}

`define BA22_OPC_FN_ADD_S           {4'h7,44'b00_??_????_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_FN_SUB_S           {4'h7,44'b00_??_????_????_????_?001_????_????_????_????_????_????}
`define BA22_OPC_FN_MUL_S           {4'h7,44'b00_??_????_????_????_?010_????_????_????_????_????_????}
`define BA22_OPC_FN_DIV_S           {4'h7,44'b00_??_????_????_????_?011_????_????_????_????_????_????}
`define BA22_OPC_FN_CEQ_S           {4'h7,44'b00_??_????_????_????_?100_????_????_????_????_????_????}
`define BA22_OPC_FN_CNE_S           {4'h7,44'b00_??_????_????_????_?101_????_????_????_????_????_????}
`define BA22_OPC_FN_CGE_S           {4'h7,44'b00_??_????_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_FN_CGT_S           {4'h7,44'b00_??_????_????_????_?111_????_????_????_????_????_????}
`define BA22_OPC_BN_ADDS            {4'h7,44'b01_??_????_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_BN_SUBS            {4'h7,44'b01_??_????_????_????_?001_????_????_????_????_????_????}
`define BA22_OPC_BN_XAADD           {4'h7,44'b01_??_????_????_????_?010_????_????_????_????_????_????}
`define BA22_OPC_BN_XCMPXCHG        {4'h7,44'b01_??_????_????_????_?011_????_????_????_????_????_????}
`define BA22_OPC_FN_FTOI_S          {4'h7,44'b11_10_??0?_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_FN_ITOF_S          {4'h7,44'b11_10_??0?_????_????_?001_????_????_????_????_????_????}

`define BA22_OPC_BW_SB              {4'h8,44'b00_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_LBZ             {4'h8,44'b01_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SH              {4'h8,44'b10_??_????_????_0???_????_????_????_????_????_????_????}
`define BA22_OPC_BW_LHZ             {4'h8,44'b10_??_????_????_1???_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SW              {4'h8,44'b11_??_????_????_00??_????_????_????_????_????_????_????}
`define BA22_OPC_BW_LWZ             {4'h8,44'b11_??_????_????_01??_????_????_????_????_????_????_????}
`define BA22_OPC_BW_LWS             {4'h8,44'b11_??_????_????_10??_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SD              {4'h8,44'b11_??_????_????_110?_????_????_????_????_????_????_????}
`define BA22_OPC_BW_LD              {4'h8,44'b11_??_????_????_111?_????_????_????_????_????_????_????}
`define BA22_OPC_BW_ADDI            {4'h9,44'b00_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_ANDI            {4'h9,44'b01_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_ORI             {4'h9,44'b10_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFEQI           {4'h9,44'b11_01_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFNEI           {4'h9,44'b11_01_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFGESI          {4'h9,44'b11_10_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFGEUI          {4'h9,44'b11_10_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFGTSI          {4'h9,44'b11_10_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFGTUI          {4'h9,44'b11_10_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFLESI          {4'h9,44'b11_11_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFLEUI          {4'h9,44'b11_11_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFLTSI          {4'h9,44'b11_11_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SFLTUI          {4'h9,44'b11_11_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BEQI            {4'ha,44'b00_00_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BNEI            {4'ha,44'b00_00_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BGESI           {4'ha,44'b00_00_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BGTSI           {4'ha,44'b00_00_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BLESI           {4'ha,44'b00_01_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BLTSI           {4'ha,44'b00_01_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BGEUI           {4'ha,44'b00_01_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BGTUI           {4'ha,44'b00_01_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BLEUI           {4'ha,44'b00_10_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BLTUI           {4'ha,44'b00_10_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BEQ             {4'ha,44'b00_10_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BNE             {4'ha,44'b00_10_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BGES            {4'ha,44'b00_11_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BGTS            {4'ha,44'b00_11_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BGEU            {4'ha,44'b00_11_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BGTU            {4'ha,44'b00_11_11??_????_????_????_????_????_????_????_????_????}

`define BA22_OPC_BW_JAL             {4'ha,44'b01_00_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_J               {4'ha,44'b01_00_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BF              {4'ha,44'b01_00_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_BNF             {4'ha,44'b01_00_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_JA              {4'ha,44'b01_01_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_JMA             {4'ha,44'b01_01_01??_???0_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_JMAL            {4'ha,44'b01_01_01??_???1_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_LMA             {4'ha,44'b01_01_10??_???0_????_????_????_????_????_????_????_????}
`define BA22_OPC_BW_SMA             {4'ha,44'b01_01_10??_???1_????_????_????_????_????_????_????_????}

`define BA22_OPC_FW_BEQ_S           {4'ha,44'b01_10_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_FW_BNE_S           {4'ha,44'b01_10_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_FW_BGE_S           {4'ha,44'b01_10_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_FW_BGT_S           {4'ha,44'b01_10_11??_????_????_????_????_????_????_????_????_????}

`define BA22_OPC_BW_MFSPR           {4'ha,44'b10_??_????_????_????_????_????_????_????_????_????_?000}
`define BA22_OPC_BW_MTSPR           {4'ha,44'b10_??_????_????_????_????_????_????_????_????_????_?001}
`define BA22_OPC_BW_ADDCI           {4'ha,44'b10_??_????_????_????_????_????_????_????_????_????_?010}
`define BA22_OPC_BW_DIVI            {4'ha,44'b10_??_????_????_????_????_????_????_????_????_????_?011}
`define BA22_OPC_BW_DIVUI           {4'ha,44'b10_??_????_????_????_????_????_????_????_????_????_?100}
`define BA22_OPC_BW_MULI            {4'ha,44'b10_??_????_????_????_????_????_????_????_????_????_?101}
`define BA22_OPC_BW_XORI            {4'ha,44'b10_??_????_????_????_????_????_????_????_????_????_?110}

`define BA22_OPC_BG_SB              {4'hc,44'b00_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_LBZ             {4'hc,44'b01_??_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_SH              {4'hc,44'b10_??_????_????_0???_????_????_????_????_????_????_????}
`define BA22_OPC_BG_LHZ             {4'hc,44'b10_??_????_????_1???_????_????_????_????_????_????_????}
`define BA22_OPC_BG_SW              {4'hc,44'b11_??_????_????_00??_????_????_????_????_????_????_????}
`define BA22_OPC_BG_LWZ             {4'hc,44'b11_??_????_????_01??_????_????_????_????_????_????_????}
`define BA22_OPC_BG_LWS             {4'hc,44'b11_??_????_????_10??_????_????_????_????_????_????_????}
`define BA22_OPC_BG_SD              {4'hc,44'b11_??_????_????_110?_????_????_????_????_????_????_????}
`define BA22_OPC_BG_LD              {4'hc,44'b11_??_????_????_111?_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BEQI            {4'hd,44'b00_00_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BNEI            {4'hd,44'b00_00_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BGESI           {4'hd,44'b00_00_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BGTSI           {4'hd,44'b00_00_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BLESI           {4'hd,44'b00_01_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BLTSI           {4'hd,44'b00_01_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BGEUI           {4'hd,44'b00_01_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BGTUI           {4'hd,44'b00_01_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BLEUI           {4'hd,44'b00_10_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BLTUI           {4'hd,44'b00_10_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BEQ             {4'hd,44'b00_10_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BNE             {4'hd,44'b00_10_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BGES            {4'hd,44'b00_11_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BGTS            {4'hd,44'b00_11_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BGEU            {4'hd,44'b00_11_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BGTU            {4'hd,44'b00_11_11??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_JAL             {4'hd,44'b01_00_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_J               {4'hd,44'b01_01_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BF              {4'hd,44'b01_10_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_BNF             {4'hd,44'b01_11_????_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_BG_ADDI            {4'hd,44'b10_??_????_????_????_????_????_????_????_????_????_????}

`define BA22_OPC_FG_BEQ_S           {4'hd,44'b11_00_00??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_FG_BNE_S           {4'hd,44'b11_00_01??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_FG_BGE_S           {4'hd,44'b11_00_10??_????_????_????_????_????_????_????_????_????}
`define BA22_OPC_FG_BGT_S           {4'hd,44'b11_00_11??_????_????_????_????_????_????_????_????_????}

`define BA22_OPC_BW_MULAS           {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??00_0000}
`define BA22_OPC_BW_MULUAS          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??00_0001}
`define BA22_OPC_BW_MULRAS          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??00_0010}
`define BA22_OPC_BW_MULURAS         {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??00_0011}
`define BA22_OPC_BW_MULSU           {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??00_0100}
`define BA22_OPC_BW_MULHSU          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??00_0101}
`define BA22_OPC_BW_MULHLSU         {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??00_0110}

`define BA22_OPC_BW_SMULTT          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_0000}
`define BA22_OPC_BW_SMULTB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_0001}
`define BA22_OPC_BW_SMULBB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_0010}
`define BA22_OPC_BW_SMULWB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_0011}
`define BA22_OPC_BW_SMULWT          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_0100}

`define BA22_OPC_BW_UMULTT          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_1000}
`define BA22_OPC_BW_UMULTB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_1001}
`define BA22_OPC_BW_UMULBB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_1010}
`define BA22_OPC_BW_UMULWB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_1011}
`define BA22_OPC_BW_UMULWT          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??10_1100}

`define BA22_OPC_BW_SMADTT          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_0000}
`define BA22_OPC_BW_SMADTB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_0001}
`define BA22_OPC_BW_SMADBB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_0010}
`define BA22_OPC_BW_SMADWB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_0011}
`define BA22_OPC_BW_SMADWT          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_0100}

`define BA22_OPC_BW_UMADTT          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_1000}
`define BA22_OPC_BW_UMADTB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_1001}
`define BA22_OPC_BW_UMADBB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_1010}
`define BA22_OPC_BW_UMADWB          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_1011}
`define BA22_OPC_BW_UMADWT          {4'hA,44'b11_??_????_????_????_????_????_????_????_????_??11_1100}

`define BA22_OPC_BN_SLLS            {4'h7,44'b10_??_????_????_????_??00_????_????_????_????_????_????}
`define BA22_OPC_BN_SLLIS           {4'h7,44'b10_??_????_????_????_??01_????_????_????_????_????_????}

`define BA22_OPC_BN_MAC             {4'h6,44'b01_00_000?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_MACS            {4'h6,44'b01_00_001?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_MACSU           {4'h6,44'b01_00_010?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_MACUU           {4'h6,44'b01_00_011?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_SMACTT          {4'h6,44'b01_00_100?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_SMACBB          {4'h6,44'b01_00_101?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_SMACTB          {4'h6,44'b01_00_110?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_UMACTT          {4'h6,44'b01_00_111?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_UMACBB          {4'h6,44'b01_01_000?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_UMACTB          {4'h6,44'b01_01_001?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_MSU             {4'h6,44'b01_01_010?_????_????_?110_????_????_????_????_????_????}
`define BA22_OPC_BN_MSUS            {4'h6,44'b01_01_011?_????_????_?110_????_????_????_????_????_????}

`define BA22_OPC_BN_ABS             {4'h3,44'b11_10_?10?_????_????_?000_????_????_????_????_????_????}
`define BA22_OPC_BN_SQR             {4'h3,44'b11_10_?10?_????_????_?001_????_????_????_????_????_????}
`define BA22_OPC_BN_SQRA            {4'h3,44'b11_10_?10?_????_????_?010_????_????_????_????_????_????}

`define BA22_OPC_BN_MAX             {4'h7,44'b01_??_????_????_????_?100_????_????_????_????_????_????}
`define BA22_OPC_BN_MIN             {4'h7,44'b01_??_????_????_????_?101_????_????_????_????_????_????}
`define BA22_OPC_BN_LIM             {4'h7,44'b01_??_????_????_????_?110_????_????_????_????_????_????}

`define BA22_OPC_BN_LWZA            {4'h5,44'b11_??_????_????_1100_????_????_????_????_????_????_????}
`define BA22_OPC_BN_SWA             {4'h5,44'b11_??_????_????_1101_????_????_????_????_????_????_????}
       
/*     
`define BA22_OPC_BW_ADDCI           {4'hd,44'b11_??_????_????_??00_????_????_????_????_????_????_????}
`define BA22_OPC_BW_DIVI            {4'hd,44'b11_??_????_????_??01_????_????_????_????_????_????_????}
`define BA22_OPC_BW_DIVUI           {4'hd,44'b11_??_????_????_??10_????_????_????_????_????_????_????}
`define BA22_OPC_BW_MULI            {4'hd,44'b11_??_????_????_??11_????_????_????_????_????_????_????}
*/

`define BA22_VLD_BT_MOVI       
`define BA22_VLD_BT_ADDI       
`define BA22_VLD_BT_MOV        
`define BA22_VLD_BT_ADD        
`define BA22_VLD_BT_J          
`define BA22_VLD_BN_SB         
`define BA22_VLD_BN_LBZ        
`define BA22_VLD_BN_SH         
`define BA22_VLD_BN_LHZ        
`define BA22_VLD_BN_SW         
`define BA22_VLD_BN_LWZ        
`define BA22_VLD_BN_LWS        
//`define BA22_VLD_BN_SD         
//`define BA22_VLD_BN_LD         
`define BA22_VLD_BN_ADDI       
`define BA22_VLD_BN_ANDI       
`define BA22_VLD_BN_ORI        
`define BA22_VLD_BN_SFEQI      
`define BA22_VLD_BN_SFNEI      
`define BA22_VLD_BN_SFGESI     
`define BA22_VLD_BN_SFGEUI     
`define BA22_VLD_BN_SFGTSI     
`define BA22_VLD_BN_SFGTUI     
`define BA22_VLD_BN_SFLESI     
`define BA22_VLD_BN_SFLEUI     
`define BA22_VLD_BN_SFLTSI     
`define BA22_VLD_BN_SFLTUI     
`define BA22_VLD_BN_SFEQ       
`define BA22_VLD_BN_SFNE       
`define BA22_VLD_BN_SFGES      
`define BA22_VLD_BN_SFGEU      
`define BA22_VLD_BN_SFGTS      
`define BA22_VLD_BN_SFGTU      
`define BA22_VLD_BN_EXTBZ      
`define BA22_VLD_BN_EXTBS      
`define BA22_VLD_BN_EXTHZ      
`define BA22_VLD_BN_EXTHS      
`define BA22_VLD_BN_FF1        
`define BA22_VLD_BN_CLZ        
`define BA22_VLD_BN_BITREV     
`define BA22_VLD_BN_SWAB       
`define BA22_VLD_BN_MFSR       
`define BA22_VLD_BN_MTSR       
`define BA22_VLD_BN_BEQI       
`define BA22_VLD_BN_BNEI       
`define BA22_VLD_BN_BGESI      
`define BA22_VLD_BN_BGTSI      
`define BA22_VLD_BN_BLESI      
`define BA22_VLD_BN_BLTSI      
`define BA22_VLD_BN_J          
`define BA22_VLD_BN_BF         
`define BA22_VLD_BN_BNF        
`ifdef BA22_CARRY_IMPLEMENTED
    `define BA22_VLD_BN_BO         
    `define BA22_VLD_BN_BNO        
    `define BA22_VLD_BN_BC         
    `define BA22_VLD_BN_BNC        
`endif
`define BA22_VLD_BN_ENTRI      
`define BA22_VLD_BN_RETI       
`define BA22_VLD_BN_RTNEI      
`define BA22_VLD_BN_RETURN     
`define BA22_VLD_BN_JALR       
`define BA22_VLD_BN_JR         
`define BA22_VLD_BN_JAL        
`define BA22_VLD_BN_MLWZ       
`define BA22_VLD_BN_MSW        
`define BA22_VLD_BN_AND        
`define BA22_VLD_BN_OR         
`define BA22_VLD_BN_XOR        
`define BA22_VLD_BN_NAND       
`define BA22_VLD_BN_ADD        
`define BA22_VLD_BN_SUB        
`define BA22_VLD_BN_SLL        
`define BA22_VLD_BN_SRL        
`define BA22_VLD_BN_SRA        
`define BA22_VLD_BN_ROR        
`define BA22_VLD_BN_CMOV       
`ifdef BA22_MUL_IMPLEMENTED
    `define BA22_VLD_BN_MUL        
    `define BA22_VLD_BN_MULH
    `define BA22_VLD_BN_MULHU
`endif
`ifdef BA22_DIV_IMPLEMENTED
    `define BA22_VLD_BN_DIV        
    `define BA22_VLD_BN_DIVU       
    `define BA22_VLD_BN_MOD             
    `define BA22_VLD_BN_MODU            
`endif

`define BA22_VLD_BN_CMPXCHG
`define BA22_VLD_BN_AADD
`define BA22_VLD_BN_XCMPXCHG
`define BA22_VLD_BN_XAADD

`ifdef BA22_MAC_IMPLEMENTED
    `define BA22_VLD_BN_MAC        
    `ifdef BA22_SATARITH_IMPLEMENTED
        `define BA22_VLD_BN_MACS        
    `endif
`endif
`ifdef BA22_CARRY_IMPLEMENTED
    `define BA22_VLD_BN_ADDC       
    `define BA22_VLD_BN_SUBB       
`endif
`define BA22_VLD_BN_FLB        
`define BA22_VLD_BN_SLLI       
`define BA22_VLD_BN_SRLI       
`define BA22_VLD_BN_SRAI       
`define BA22_VLD_BN_RORI       
`define BA22_VLD_BW_SB         
`define BA22_VLD_BW_LBZ        
`define BA22_VLD_BW_SH         
`define BA22_VLD_BW_LHZ        
`define BA22_VLD_BW_SW         
`define BA22_VLD_BW_LWZ        
`define BA22_VLD_BW_LWS        
//`define BA22_VLD_BW_SD         // do not uncomment - not implemented
//`define BA22_VLD_BW_LD         // do not uncomment - not implemented
`define BA22_VLD_BW_ADDI       
`define BA22_VLD_BW_ANDI       
`define BA22_VLD_BW_ORI        
`define BA22_VLD_BW_SFEQI      
`define BA22_VLD_BW_SFNEI      
`define BA22_VLD_BW_SFGESI     
`define BA22_VLD_BW_SFGEUI     
`define BA22_VLD_BW_SFGTSI     
`define BA22_VLD_BW_SFGTUI     
`define BA22_VLD_BW_SFLESI     
`define BA22_VLD_BW_SFLEUI     
`define BA22_VLD_BW_SFLTSI     
`define BA22_VLD_BW_SFLTUI     
`define BA22_VLD_BW_BEQI       
`define BA22_VLD_BW_BNEI       
`define BA22_VLD_BW_BGESI      
`define BA22_VLD_BW_BGTSI      
`define BA22_VLD_BW_BLESI      
`define BA22_VLD_BW_BLTSI      
`define BA22_VLD_BW_BGEUI      
`define BA22_VLD_BW_BGTUI      
`define BA22_VLD_BW_BLEUI      
`define BA22_VLD_BW_BLTUI      
`define BA22_VLD_BW_BEQ        
`define BA22_VLD_BW_BNE        
`define BA22_VLD_BW_BGES       
`define BA22_VLD_BW_BGTS       
`define BA22_VLD_BW_BGEU       
`define BA22_VLD_BW_BGTU       
`define BA22_VLD_BW_JAL        
`define BA22_VLD_BW_J          
`define BA22_VLD_BW_BF         
`define BA22_VLD_BW_BNF        
`define BA22_VLD_BW_JA         
`define BA22_VLD_BW_JMA 
`define BA22_VLD_BW_JMAL
`define BA22_VLD_BW_LMA 
`define BA22_VLD_BW_SMA 
`define BA22_VLD_BW_MFSPR      
`define BA22_VLD_BW_MTSPR      
`define BA22_VLD_BG_SB         
`define BA22_VLD_BG_LBZ        
`define BA22_VLD_BG_SH         
`define BA22_VLD_BG_LHZ        
`define BA22_VLD_BG_SW         
`define BA22_VLD_BG_LWZ        
`define BA22_VLD_BG_LWS        // do not uncomment - not implemented
//`define BA22_VLD_BG_SD         // do not uncomment - not implemented
//`define BA22_VLD_BG_LD         // do not uncomment - not implemented
`define BA22_VLD_BG_BEQI       
`define BA22_VLD_BG_BNEI       
`define BA22_VLD_BG_BGESI      
`define BA22_VLD_BG_BGTSI      
`define BA22_VLD_BG_BLESI      
`define BA22_VLD_BG_BLTSI      
`define BA22_VLD_BG_BGEUI      
`define BA22_VLD_BG_BGTUI      
`define BA22_VLD_BG_BLEUI      
`define BA22_VLD_BG_BLTUI      
`define BA22_VLD_BG_BEQ        
`define BA22_VLD_BG_BNE        
`define BA22_VLD_BG_BGES       
`define BA22_VLD_BG_BGTS       
`define BA22_VLD_BG_BGEU       
`define BA22_VLD_BG_BGTU       
`define BA22_VLD_BG_JAL        
`define BA22_VLD_BG_J          
`define BA22_VLD_BG_BF         
`define BA22_VLD_BG_BNF        
`define BA22_VLD_BG_ADDI       
`ifdef BA22_CARRY_IMPLEMENTED
    `define BA22_VLD_BW_ADDCI      
`endif
`ifdef BA22_DIV_IMPLEMENTED
    `define BA22_VLD_BW_DIVI       
    `define BA22_VLD_BW_DIVUI      
//    `define BA22_VLD_BN_MODI     
//    `define BA22_VLD_BN_MODUI    
`endif
`ifdef BA22_MUL_IMPLEMENTED
    `define BA22_VLD_BW_MULI       
`endif
`define BA22_VLD_BW_XORI       

`ifdef BA22_FPU32_IMPLEMENTED
    `define BA22_VLD_FN_ADD_S
    `define BA22_VLD_FN_SUB_S
    `define BA22_VLD_FN_MUL_S
    `define BA22_VLD_FN_DIV_S
    `define BA22_VLD_FN_CEQ_S
    `define BA22_VLD_FN_CNE_S
    `define BA22_VLD_FN_CGE_S
    `define BA22_VLD_FN_CGT_S

    `define BA22_VLD_FN_FTOI_S
    `define BA22_VLD_FN_ITOF_S
    
    `define BA22_VLD_FG_BEQ_S
    `define BA22_VLD_FG_BNE_S
    `define BA22_VLD_FG_BGE_S
    `define BA22_VLD_FG_BGT_S
    
    `define BA22_VLD_FW_BEQ_S
    `define BA22_VLD_FW_BNE_S
    `define BA22_VLD_FW_BGE_S
    `define BA22_VLD_FW_BGT_S
`endif

`ifdef BA22_SATARITH_IMPLEMENTED
    `define BA22_VLD_BN_ADDS            
    `define BA22_VLD_BN_SUBS            
`endif

`ifdef BA22_SQRT_IMPLEMENTED
    `define BA22_VLD_BN_SQR
    `define BA22_VLD_BN_SQRA
`endif

`ifdef BA22_DSP_IMPLEMENTED
        `define BA22_VLD_BN_LWZA 
        `define BA22_VLD_BN_SWA  
        `define BA22_VLD_BN_ABS
        `define BA22_VLD_BN_NEG
        `define BA22_VLD_BN_MAX
        `define BA22_VLD_BN_MIN
        `define BA22_VLD_BN_LIM
        `define BA22_VLD_BN_MACSU
        `define BA22_VLD_BN_MACUU
        `define BA22_VLD_BN_SMACTT
        `define BA22_VLD_BN_SMACBB
        `define BA22_VLD_BN_SMACTB
        `define BA22_VLD_BN_UMACTT
        `define BA22_VLD_BN_UMACBB
        `define BA22_VLD_BN_UMACTB
        `define BA22_VLD_BN_MSU
        `define BA22_VLD_BN_MSUS
        `define BA22_VLD_BW_SMULTT
        `define BA22_VLD_BW_SMULTB
        `define BA22_VLD_BW_SMULBB
        `define BA22_VLD_BW_SMULWB
        `define BA22_VLD_BW_SMULWT
        `define BA22_VLD_BW_UMULTT
        `define BA22_VLD_BW_UMULTB
        `define BA22_VLD_BW_UMULBB
        `define BA22_VLD_BN_SLLIS
        `define BA22_VLD_BN_SLLS
        `define BA22_VLD_BW_MULSU
        `define BA22_VLD_BW_MULHSU
        `define BA22_VLD_BW_MULHLSU
        `define BA22_VLD_BW_UMULWB
        `define BA22_VLD_BW_UMULWT
        `define BA22_VLD_BW_MULAS
        `define BA22_VLD_BW_MULUAS
        `define BA22_VLD_BW_MULRAS
        `define BA22_VLD_BW_MULURAS
        `define BA22_VLD_BW_SMADTT
        `define BA22_VLD_BW_SMADTB
        `define BA22_VLD_BW_SMADBB
        `define BA22_VLD_BW_SMADWB
        `define BA22_VLD_BW_SMADWT
        `define BA22_VLD_BW_UMADTT
        `define BA22_VLD_BW_UMADTB
        `define BA22_VLD_BW_UMADBB
        `define BA22_VLD_BW_UMADWB
        `define BA22_VLD_BW_UMADWT
`endif
`ifdef BA22_FPU32_IMPLEMENTED
    `define BA22_PIPE_FLAGS_WIDTH 32
`else
    `define BA22_PIPE_FLAGS_WIDTH 23
`endif
`define BA22_PIPE_FLAG_ADV                   0
`define BA22_PIPE_FLAG_BRANCH_TAKEN          1
`define BA22_PIPE_FLAG_EXC                   2
`define BA22_PIPE_FLAG_SETCYOF               3
`define BA22_PIPE_FLAG_NINT                  4

`define BA22_EXC_TYPE_WIDTH                  4
`define BA22_EXC_TYPE                      8:5

`define BA22_PIPE_FLAG_TRAP                  9
`define BA22_PIPE_FLAG_SYS                  10
`define BA22_PIPE_FLAG_TRAP_INHIBIT         11
`define BA22_PIPE_FLAG_TRAP_INST            15
`define BA22_PIPE_FLAG_FCO               14:12
`define BA22_ID_IST_FLAG                    12
`define BA22_ID_IST_CARRY                   13
`define BA22_ID_IST_OVERFLOW                14
`define BA22_PIPE_FLAG_MAC               17:16
`define BA22_PIPE_FLAG_NSLS                 18
`define BA22_PIPE_FLAG_JMALD                19
`define BA22_PIPE_FLAG_LAST                 20
`define BA22_PIPE_FLAG_SAT                  21
`define BA22_PIPE_FLAG_ATM                  22

// last flag 
`define BA22_PIPE_FLAG_MARKER               `BA22_PIPE_FLAG_ATM                  

`define BA22_PIPE_FLAGS_FOV                 `BA22_UR_FOV  - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FLAGS_FUN                 `BA22_UR_FUN  - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FLAGS_FQN                 `BA22_UR_FQN  - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FLAGS_FSN                 `BA22_UR_FSN  - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FLAGS_FZ                  `BA22_UR_FZ   - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FLAGS_FIX                 `BA22_UR_FIX  - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FLAGS_FIV                 `BA22_UR_FIV  - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FLAGS_FIN                 `BA22_UR_FIN  - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FLAGS_FDZ                 `BA22_UR_FDZ  - `BA22_UR_FOV + `BA22_PIPE_FLAG_MARKER + 1
`define BA22_PIPE_FPU_FLAGS                 `BA22_PIPE_FLAGS_FDZ  : `BA22_PIPE_FLAGS_FOV









/* exception flags  */
`define BA22_EXC_RESET                 `BA22_EXC_TYPE_WIDTH'd15
/*instruction fetch */
`define BA22_EXC_ITLB_MISS             `BA22_EXC_TYPE_WIDTH'd0
`define BA22_EXC_IPAGE_FAULT           `BA22_EXC_TYPE_WIDTH'd1
`define BA22_EXC_INSN_BUS_ERR          `BA22_EXC_TYPE_WIDTH'd2
//`define BA22_EXC_INVAL_INSN_WIDTH      `BA22_EXC_TYPE_WIDTH'd3

`define BA22_EXC_UNDEF_INST            `BA22_EXC_TYPE_WIDTH'd3
`define BA22_EXC_SYSCALL               `BA22_EXC_TYPE_WIDTH'd4
`define BA22_EXC_TRAP                  `BA22_EXC_TYPE_WIDTH'd5
`define BA22_EXC_DEBUG_TRAP            `BA22_EXC_TYPE_WIDTH'd6

`define BA22_EXC_UNALIGNED             `BA22_EXC_TYPE_WIDTH'd7
`define BA22_EXC_DTLB_MISS             `BA22_EXC_TYPE_WIDTH'd8
`define BA22_EXC_DPAGE_FAULT           `BA22_EXC_TYPE_WIDTH'd9

`define BA22_EXC_DBUS_ERR              `BA22_EXC_TYPE_WIDTH'd10
`define BA22_EXC_DTIME_ERR             `BA22_EXC_TYPE_WIDTH'd10
`define BA22_EXC_DRTY_ERR              `BA22_EXC_TYPE_WIDTH'd10

//`define BA22_PIPE_FLAG_RANGE                16
`define BA22_EXC_TICK_TIMER            `BA22_EXC_TYPE_WIDTH'd13
`define BA22_EXC_INTV                  `BA22_EXC_TYPE_WIDTH'd12
`define BA22_EXC_INT                   `BA22_EXC_TYPE_WIDTH'd14
`define BA22_EXC_FP                    `BA22_EXC_TYPE_WIDTH'd11

//`define BA22_PIPE_FLAG_EI                   19
//`define BA22_PIPE_FLAG_DI                   20

/* forwarding sources */
`define BA22_MM_DEP 2'b01
`define BA22_WC_DEP 2'b10
`define BA22_RF_DEP 2'b00


`define BA22_FRM_PTR 5'd1
/* instruction types */
`define BA22_ID_IT_LS   3'b?00       /* load store instructions  */
`define BA22_ID_IT_LSL  3'b100       /* load instructions        */
`define BA22_ID_IT_LSS  3'b000       /* store instructions       */
`define BA22_ID_IT_R2R  3'b101       /* register to register instructions */
`define BA22_ID_IT_SF   3'b001       /* set flag instructions    */
`define BA22_ID_IT_BRA  3'b010       /* conditional branch       */
`define BA22_ID_IT_J    3'b110       /* jump, rfe                */
`define BA22_ID_IT_MTS  3'b011       /* move to spr              */
`define BA22_ID_IT_MFS  3'b111       /* move from spr            */
`define BA22_ID_IT_SPR  3'b?11       /* special purpose register access  */
`define BA22_ID_IT_ANY  3'b???       /* Dohn't care  */

`define BA22_UC_LSL     `BA22_ID_IT_LSL
`define BA22_UC_LSS     `BA22_ID_IT_LSS
`define BA22_UC_R2R     `BA22_ID_IT_R2R
`define BA22_UC_SF      `BA22_ID_IT_SF 
`define BA22_UC_BRA     `BA22_ID_IT_BRA
`define BA22_UC_J       `BA22_ID_IT_J  
`define BA22_UC_MTS     `BA22_ID_IT_MTS
`define BA22_UC_MFS     `BA22_ID_IT_MFS





/* define types source register by jumps and maye branches (branches always have BA22_ID_IST_SRC_PC_PC_IA */
`define BA22_ID_IST_ALU_LO_POS   4
`define BA22_ID_IST_ALU_LO_RA    1'b0 
`define BA22_ID_IST_ALU_LO_PC    1'b1
                     
                     
/* define pc source */
`define BA22_ID_IST_PC_SRC_POS 5
`define BA22_ID_IST_PC_SRC_EPC 1'b0
`define BA22_ID_IST_PC_SRC_ALU 1'b1
        
/* jump instruction writes back to register */
`define BA22_ID_IST_J_RD_WR       (1`b1 << 2)

`define BA22_ID_IST_CMP_TYPE_POS    10
`define BA22_ID_IST_CMP_TYPE_FP     1'b1
`define BA22_ID_IST_CMP_TYPE_INT    1'b0
`define BA22_ID_IST_CMP_POS      8:5
`define BA22_ID_CMP_FLAGS       4'b1???
`define BA22_ID_CMP_VALS        4'b0???

/* define types of comparisons for branch and set flag instruction type*/ 
`define BA22_ID_IST_CMP_EQ      4'b0000
`define BA22_ID_IST_CMP_NE      4'b0001
`define BA22_ID_IST_CMP_GE      4'b0010
`define BA22_ID_IST_CMP_LT      4'b0011
`define BA22_ID_IST_CMP_GT      4'b0100
`define BA22_ID_IST_CMP_LE      4'b0101
`define BA22_ID_IST_CMP_F       4'b1000
`define BA22_ID_IST_CMP_NF      4'b1001
`define BA22_ID_IST_CMP_C       4'b1010
`define BA22_ID_IST_CMP_NC      4'b1011
`define BA22_ID_IST_CMP_O       4'b1100
`define BA22_ID_IST_CMP_NO      4'b1101

`define BA22_ID_IST_FCMP_EQ      4'b0110
`define BA22_ID_IST_FCMP_NE      4'b0111
`define BA22_ID_IST_FCMP_GE      4'b1000
`define BA22_ID_IST_FCMP_GT      4'b1001

`define BA22_ID_IST_CSU_POS      9
`define BA22_ID_IST_CSU_S        1'b1
`define BA22_ID_IST_CSU_U        1'b0

/* define alu and multiplier / divider operation codes for R2R instruction type and multicycle R2R instruction type*/

//`define BA22_ALU_ADDSUB_COMB
`define BA22_ALU_ADDSUB_SEMIPAR
`define BA22_ALU_SHIFT_BASIC


`define BA22_MCODE_FUNC_W       8

`define BA22_MCODE_W            (`BA22_MCODE_FUNC_W + 5)
`define BA22_MCODE              (`BA22_MCODE_W - 1):0
`define BA22_MCODE_FUNC         (`BA22_MCODE_W - 1):5

`define BA22_ID_IST_FUNC_POS        `BA22_MCODE_FUNC

`define BA22_ID_IST_FGRP            (`BA22_MCODE_W - 1):(`BA22_MCODE_W - 3)
`define BA22_ID_IST_FGRP_ALU        3'b000
`define BA22_ID_IST_FGRP_MUL        3'b001 
`define BA22_ID_IST_FGRP_DIV        3'b010 
`define BA22_ID_IST_FGRP_FPU        3'b011
`define BA22_ID_IST_FGRP_SQR        3'b100
`define BA22_ID_IST_FGRP_ANY        3'b???

`define BA22_ID_IST_FUNC_ADD        {`BA22_ID_IST_FGRP_ALU,5'b00000}
`define BA22_ID_IST_FUNC_ADDC       {`BA22_ID_IST_FGRP_ALU,5'b00001}
`define BA22_ID_IST_FUNC_SUB        {`BA22_ID_IST_FGRP_ALU,5'b00010}
`define BA22_ID_IST_FUNC_SUBB       {`BA22_ID_IST_FGRP_ALU,5'b00011}

`define BA22_ID_IST_FUNC_AND        {`BA22_ID_IST_FGRP_ALU,5'b00100}
`define BA22_ID_IST_FUNC_OR         {`BA22_ID_IST_FGRP_ALU,5'b00101}
`define BA22_ID_IST_FUNC_XOR        {`BA22_ID_IST_FGRP_ALU,5'b00110}
`define BA22_ID_IST_FUNC_NAND       {`BA22_ID_IST_FGRP_ALU,5'b00111}

`define BA22_ID_IST_FUNC_FF1        {`BA22_ID_IST_FGRP_ALU,5'b01000}
`define BA22_ID_IST_FUNC_CLZ        {`BA22_ID_IST_FGRP_ALU,5'b01001}
`define BA22_ID_IST_FUNC_FLB        {`BA22_ID_IST_FGRP_ALU,5'b01010}
`define BA22_ID_IST_FUNC_REV        {`BA22_ID_IST_FGRP_ALU,5'b01011}

`define BA22_ID_IST_FUNC_SLL        {`BA22_ID_IST_FGRP_ALU,5'b01100}
`define BA22_ID_IST_FUNC_SRL        {`BA22_ID_IST_FGRP_ALU,5'b01101}
`define BA22_ID_IST_FUNC_SRA        {`BA22_ID_IST_FGRP_ALU,5'b01110}
`define BA22_ID_IST_FUNC_ROR        {`BA22_ID_IST_FGRP_ALU,5'b01111}
                                 
`define BA22_ID_IST_FUNC_EXTBZ      {`BA22_ID_IST_FGRP_ALU,5'b10000}
`define BA22_ID_IST_FUNC_EXTBS      {`BA22_ID_IST_FGRP_ALU,5'b10001}
`define BA22_ID_IST_FUNC_EXTHZ      {`BA22_ID_IST_FGRP_ALU,5'b10010}
`define BA22_ID_IST_FUNC_EXTHS      {`BA22_ID_IST_FGRP_ALU,5'b10011}

`define BA22_ID_IST_FUNC_MOV        {`BA22_ID_IST_FGRP_ALU,5'b10100}
`define BA22_ID_IST_FUNC_CMOV       {`BA22_ID_IST_FGRP_ALU,5'b10101}
`define BA22_ID_IST_FUNC_MIN        {`BA22_ID_IST_FGRP_ALU,5'b10110}
`define BA22_ID_IST_FUNC_MAX        {`BA22_ID_IST_FGRP_ALU,5'b10111}

`define BA22_ID_IST_FUNC_SWAB       {`BA22_ID_IST_FGRP_ALU,5'b11000}
`define BA22_ID_IST_FUNC_ABS        {`BA22_ID_IST_FGRP_ALU,5'b11001}
`define BA22_ID_IST_FUNC_LIM        {`BA22_ID_IST_FGRP_ALU,5'b11010}

`define BA22_ID_IST_FUNC_SLLS       {`BA22_ID_IST_FGRP_ALU,5'b11100}


`define BA22_ID_IST_FUNC_MUL_UTUT       {`BA22_ID_IST_FGRP_MUL,5'h00} 
`define BA22_ID_IST_FUNC_MUL_UTUB       {`BA22_ID_IST_FGRP_MUL,5'h01} 
`define BA22_ID_IST_FUNC_MUL_UBUB       {`BA22_ID_IST_FGRP_MUL,5'h02} 
`define BA22_ID_IST_FUNC_MUL_UWUT       {`BA22_ID_IST_FGRP_MUL,5'h03} 
`define BA22_ID_IST_FUNC_MUL_UWUB       {`BA22_ID_IST_FGRP_MUL,5'h04} 
`define BA22_ID_IST_FUNC_MUL_STST       {`BA22_ID_IST_FGRP_MUL,5'h05} 
`define BA22_ID_IST_FUNC_MUL_STSB       {`BA22_ID_IST_FGRP_MUL,5'h06} 
`define BA22_ID_IST_FUNC_MUL_SBSB       {`BA22_ID_IST_FGRP_MUL,5'h07} 
`define BA22_ID_IST_FUNC_MUL_SWST       {`BA22_ID_IST_FGRP_MUL,5'h08} 
`define BA22_ID_IST_FUNC_MUL_SWSB       {`BA22_ID_IST_FGRP_MUL,5'h09} 

`define BA22_ID_IST_FUNC_MUL_ADD_UTUT   {`BA22_ID_IST_FGRP_MUL,5'h10} 
`define BA22_ID_IST_FUNC_MUL_ADD_UTUB   {`BA22_ID_IST_FGRP_MUL,5'h11} 
`define BA22_ID_IST_FUNC_MUL_ADD_UBUB   {`BA22_ID_IST_FGRP_MUL,5'h12} 
`define BA22_ID_IST_FUNC_MUL_ADD_UWUT   {`BA22_ID_IST_FGRP_MUL,5'h13} 
`define BA22_ID_IST_FUNC_MUL_ADD_UWUB   {`BA22_ID_IST_FGRP_MUL,5'h14} 
`define BA22_ID_IST_FUNC_MUL_ADD_STST   {`BA22_ID_IST_FGRP_MUL,5'h15} 
`define BA22_ID_IST_FUNC_MUL_ADD_STSB   {`BA22_ID_IST_FGRP_MUL,5'h16} 
`define BA22_ID_IST_FUNC_MUL_ADD_SBSB   {`BA22_ID_IST_FGRP_MUL,5'h17} 
`define BA22_ID_IST_FUNC_MUL_ADD_SWST   {`BA22_ID_IST_FGRP_MUL,5'h18} 
`define BA22_ID_IST_FUNC_MUL_ADD_SWSB   {`BA22_ID_IST_FGRP_MUL,5'h19} 

`define BA22_ID_IST_FUNC_MUL_SWSWL      {`BA22_ID_IST_FGRP_MUL,5'h0a} 
`define BA22_ID_IST_FUNC_MUL_SWUWL      {`BA22_ID_IST_FGRP_MUL,5'h0b} 
`define BA22_ID_IST_FUNC_MUL_UWUWL      {`BA22_ID_IST_FGRP_MUL,5'h0c} 
`define BA22_ID_IST_FUNC_MUL_SWSWH      {`BA22_ID_IST_FGRP_MUL,5'h1a} 
`define BA22_ID_IST_FUNC_MUL_SWUWH      {`BA22_ID_IST_FGRP_MUL,5'h1b} 
`define BA22_ID_IST_FUNC_MUL_UWUWH      {`BA22_ID_IST_FGRP_MUL,5'h1c} 

`define BA22_ID_IST_FUNC_MUL_UWUWSH     {`BA22_ID_IST_FGRP_MUL,5'h0d}
`define BA22_ID_IST_FUNC_MUL_SWSWSH     {`BA22_ID_IST_FGRP_MUL,5'h0e}
`define BA22_ID_IST_FUNC_MUL_UWUWSHR    {`BA22_ID_IST_FGRP_MUL,5'h1d}
`define BA22_ID_IST_FUNC_MUL_SWSWSHR    {`BA22_ID_IST_FGRP_MUL,5'h1e}
 
`define BA22_ID_IST_FUNC_DIVU       {`BA22_ID_IST_FGRP_DIV,5'b10000}
`define BA22_ID_IST_FUNC_DIV        {`BA22_ID_IST_FGRP_DIV,5'b10001}
`define BA22_ID_IST_FUNC_MODU       {`BA22_ID_IST_FGRP_DIV,5'b10010}
`define BA22_ID_IST_FUNC_MOD        {`BA22_ID_IST_FGRP_DIV,5'b10011}
`define BA22_ID_IST_DIV_SGN         {2'b00,5'b00001}
`define BA22_ID_IST_DIV_MOD         {2'b00,5'b00010}

`define BA22_ID_IST_FUNC_FPADD      {`BA22_ID_IST_FGRP_FPU,5'b00000}       // addition
`define BA22_ID_IST_FUNC_FPSUB      {`BA22_ID_IST_FGRP_FPU,5'b00001}       // subtraction
`define BA22_ID_IST_FUNC_FPMUL      {`BA22_ID_IST_FGRP_FPU,5'b00010}       // multiplication
`define BA22_ID_IST_FUNC_FPDIV      {`BA22_ID_IST_FGRP_FPU,5'b00011}       // division
`define BA22_ID_IST_FUNC_FPF2I      {`BA22_ID_IST_FGRP_FPU,5'b00100}       // float-to-integer conversion
`define BA22_ID_IST_FUNC_FPI2F      {`BA22_ID_IST_FGRP_FPU,5'b00101}       // integer-to-float conversion
`define BA22_ID_IST_FUNC_FPCEQ      {`BA22_ID_IST_FGRP_FPU,5'b00110}       // compare equal
`define BA22_ID_IST_FUNC_FPCNE      {`BA22_ID_IST_FGRP_FPU,5'b00111}       // compare not equal
`define BA22_ID_IST_FUNC_FPCGE      {`BA22_ID_IST_FGRP_FPU,5'b01000}       // compare greater-or-equal-than
`define BA22_ID_IST_FUNC_FPCGT      {`BA22_ID_IST_FGRP_FPU,5'b01001}       // compare greater-than
        

`define BA22_ID_IST_FUNC_SQR        {`BA22_ID_IST_FGRP_SQR,5'b10100}
`define BA22_ID_IST_FUNC_SQRA       {`BA22_ID_IST_FGRP_SQR,5'b10101}

/* short operation codes */
`define BA22_ID_IST_FGRP_ADDSUB  3'b000

`define BA22_ID_IST_FSHR_ADD     2'b00
`define BA22_ID_IST_FSHR_ADDC    2'b01
`define BA22_ID_IST_FSHR_SUB     2'b10
`define BA22_ID_IST_FSHR_SUBB    2'b11

`define BA22_ID_IST_FGRP_LOG     3'b001

`define BA22_ID_IST_FSHR_AND     2'b00
`define BA22_ID_IST_FSHR_OR      2'b01
`define BA22_ID_IST_FSHR_XOR     2'b10
`define BA22_ID_IST_FSHR_NAND    2'b11
                                      
`define BA22_ID_IST_FGRP_FFL     3'b010
`define BA22_ID_IST_FSHR_FF1     2'b00
`define BA22_ID_IST_FSHR_CLZ     2'b01
`define BA22_ID_IST_FSHR_FLB     2'b10
`define BA22_ID_IST_FSHR_REV     2'b11

`define BA22_ID_IST_FGRP_SHIFT   3'b011
`define BA22_ID_IST_FSHR_SLL     2'b00
`define BA22_ID_IST_FSHR_SRL     2'b01
`define BA22_ID_IST_FSHR_SRA     2'b10
`define BA22_ID_IST_FSHR_ROR     2'b11


`define BA22_ID_IST_FGRP_MOVE    3'b10?

`define BA22_ID_IST_FSHR_EXTBZ   3'b000
`define BA22_ID_IST_FSHR_EXTBS   3'b001
`define BA22_ID_IST_FSHR_EXTHZ   3'b010
`define BA22_ID_IST_FSHR_EXTHS   3'b011
`define BA22_ID_IST_FSHR_MOV     3'b100
`define BA22_ID_IST_FSHR_CMOV    3'b101
`define BA22_ID_IST_FSHR_MIN     3'b110
`define BA22_ID_IST_FSHR_MAX     3'b111

`define BA22_ID_IST_FGRP_SWAB    3'b110

`define BA22_ID_IST_FGRP_CUS     3'b111
`define BA22_ID_IST_FSHR_SLLS    2'b00


/* define ls_alu sources*/
`define BA22_EX_LS_ADD_X_RA     1'b0
`define BA22_EX_LS_ADD_X_EA     1'b1
`define BA22_EX_LS_ADD_Y_IMM    1'b0
`define BA22_EX_LS_ADD_Y_4      1'b1


/* define right alu or multicycle block operator source */
`define BA22_ID_IST_ALU_RO_POS      3
`define BA22_ID_IST_ALU_RO_IMM      1'b0
`define BA22_ID_IST_ALU_RO_REG      1'b1

/* define left source for comparation */
`define BA22_ID_IST_CMP_OP_POS       4
`define BA22_ID_IST_CMP_OP_IMM       1'b0
`define BA22_ID_IST_CMP_OP_REG       1'b1

/* define memory operand extension by load instructions */
`define BA22_ID_IST_MEXT_Z   1'b0
`define BA22_ID_IST_MEXT_S   1'b1
/* differentiate between load and store */
`define BA22_ID_IST_MEXT_POS 8
`define BA22_ID_IST_MDIR_L   1'b1
`define BA22_ID_IST_MDIR_S   1'b0
/*define size of memory operands */
`define BA22_ID_IST_MSIZ_POS 6:5
`define BA22_ID_IST_MSIZ_B   2'b00
`define BA22_ID_IST_MSIZ_H   2'b01
`define BA22_ID_IST_MSIZ_W   2'b10
`define BA22_ID_IST_MSIZ_D   2'b11
/* define cyclenumber by LS */
`define BA22_ID_IST_MSIN    1'b0
`define BA22_ID_IST_MMUL    1'b1
/* define burst bit */
`define BA22_ID_MBURST      10'b01_1111_1111
/* define signed division */

/* define special special purpose type */
`define BA22_ID_IST_EDI_POS 8:7
`define BA22_ID_IST_EI 2'b10       /* enable interupts  */
`define BA22_ID_IST_DI 2'b01       /* disable interupts */

/* for all instructions except R2R instrucions have alu function set to 0 ie ADD */
/* useful in cases such as EA calculation| BRANCH TARGET calculation */
/* absolute jumps are realized by RA + 0 */


`define BA22_ID_I_ADD    { (`BA22_ID_IST_FUNC_ADD  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_ADDI   { (`BA22_ID_IST_FUNC_ADD  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_ADDPCI { (`BA22_ID_IST_FUNC_ADD  /*5*/)   , (`BA22_ID_IST_ALU_LO_PC  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_ADDC   { (`BA22_ID_IST_FUNC_ADDC /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_ADDCI  { (`BA22_ID_IST_FUNC_ADDC /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
                                                                                                                                                
`define BA22_ID_I_SUB    { (`BA22_ID_IST_FUNC_SUB  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SUBB   { (`BA22_ID_IST_FUNC_SUBB /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
                                                                                                                                                
`define BA22_ID_I_NAND   { (`BA22_ID_IST_FUNC_NAND /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_AND    { (`BA22_ID_IST_FUNC_AND  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_ANDI   { (`BA22_ID_IST_FUNC_AND  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_OR     { (`BA22_ID_IST_FUNC_OR   /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_ORI    { (`BA22_ID_IST_FUNC_OR   /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_XOR    { (`BA22_ID_IST_FUNC_XOR  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_XORI   { (`BA22_ID_IST_FUNC_XOR  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
                                                                                                                                                
`define BA22_ID_I_MOV    { (`BA22_ID_IST_FUNC_MOV  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MOVI   { (`BA22_ID_IST_FUNC_MOV  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_CMOV   { (`BA22_ID_IST_FUNC_CMOV /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
                                                                                                                                                
`define BA22_ID_I_ROR    { (`BA22_ID_IST_FUNC_ROR  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_RORI   { (`BA22_ID_IST_FUNC_ROR  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SLL    { (`BA22_ID_IST_FUNC_SLL  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SLLI   { (`BA22_ID_IST_FUNC_SLL  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SRA    { (`BA22_ID_IST_FUNC_SRA  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SRAI   { (`BA22_ID_IST_FUNC_SRA  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SRL    { (`BA22_ID_IST_FUNC_SRL  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SRLI   { (`BA22_ID_IST_FUNC_SRL  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
                                                                                                                                                
`define BA22_ID_I_EXTBS  { (`BA22_ID_IST_FUNC_EXTBS/*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_EXTBZ  { (`BA22_ID_IST_FUNC_EXTBZ/*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_EXTHS  { (`BA22_ID_IST_FUNC_EXTHS/*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_EXTHZ  { (`BA22_ID_IST_FUNC_EXTHZ/*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
                                                                                                                                                
`define BA22_ID_I_FF1    { (`BA22_ID_IST_FUNC_FF1  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FLB    { (`BA22_ID_IST_FUNC_FLB  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_CLZ    { (`BA22_ID_IST_FUNC_CLZ  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_BITREV { (`BA22_ID_IST_FUNC_REV  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SWAB   { (`BA22_ID_IST_FUNC_SWAB /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
                                                                                                                                                 
                                                                                                                                                 
`define BA22_ID_I_FPADD  { (`BA22_ID_IST_FUNC_FPADD     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPSUB  { (`BA22_ID_IST_FUNC_FPSUB     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPMUL  { (`BA22_ID_IST_FUNC_FPMUL     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPDIV  { (`BA22_ID_IST_FUNC_FPDIV     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPF2I  { (`BA22_ID_IST_FUNC_FPF2I     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPI2F  { (`BA22_ID_IST_FUNC_FPI2F     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPCEQ  { (`BA22_ID_IST_FUNC_FPCEQ     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPCNE  { (`BA22_ID_IST_FUNC_FPCNE     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPCGE  { (`BA22_ID_IST_FUNC_FPCGE     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_FPCGT  { (`BA22_ID_IST_FUNC_FPCGT     )   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}

`define BA22_ID_I_MINI   { (`BA22_ID_IST_FUNC_MIN  /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}


/* BRANCHES COMPARE : */
/* RA <=> RB 
   SI <=> RB
   therefore right operand is implicity known !!!
*/

/* SETFLAGS COMPARE: */
/* RA <=> RB
   RA <=> LI
   therefore left operand is implicitly known!!!
*/
/* conclusion simple equations should privide necesary decoing */

`define BA22_ID_I_BEQ    {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_EQ    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BEQI   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_EQ    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BNE    {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_NE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BNEI   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_NE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
                                                                                                                                       
`define BA22_ID_I_BF     {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_F     /*5*/)   , (1'b0                    /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BNF    {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_NF    /*5*/)   , (1'b0                    /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BC     {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_C     /*5*/)   , (1'b0                    /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BNC    {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_NC    /*5*/)   , (1'b0                    /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BO     {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_O     /*5*/)   , (1'b0                    /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BNO    {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_NO    /*5*/)   , (1'b0                    /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
                                                                                                                                                                             
`define BA22_ID_I_BGES   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BGESI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_LE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BGEU   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BGEUI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_LE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
                                                                                                                                                                             
`define BA22_ID_I_BGTS   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BGTSI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_LT    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BGTU   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BGTUI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_LT    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}

`define BA22_ID_I_BLES   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_LE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BLESI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BLEU   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_LE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BLEUI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
                                                                                                                                                          
`define BA22_ID_I_BLTS   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_LT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BLTSI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BLTU   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_LT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_BLTUI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}

`define BA22_ID_I_FBEQ   {(`BA22_ID_IST_CMP_TYPE_FP ) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_FCMP_EQ    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_FBNE   {(`BA22_ID_IST_CMP_TYPE_FP ) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_FCMP_NE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_FBGE   {(`BA22_ID_IST_CMP_TYPE_FP ) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_FCMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}
`define BA22_ID_I_FBGT   {(`BA22_ID_IST_CMP_TYPE_FP ) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_FCMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_BRA}

// LEN = 10
/* SET FLAG instructions  are executed in comparator*/

`define BA22_ID_I_SFEQ   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_EQ    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF }
`define BA22_ID_I_SFEQI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_EQ    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF }
`define BA22_ID_I_SFNE   {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_NE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF }
`define BA22_ID_I_SFNEI  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_NE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF }
                                                                                                                                                         
`define BA22_ID_I_SFGES  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFGESI {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFGEU  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFGEUI {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_GE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
                                                                                                                     
`define BA22_ID_I_SFGTS  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFGTSI {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFGTU  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFGTUI {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_GT    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
                                                                                                                                                         
`define BA22_ID_I_SFLES  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_LE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFLESI {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_LE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFLEU  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_LE    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFLEUI {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_LE    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}

`define BA22_ID_I_SFLTS  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_LT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFLTSI {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_S /*9*/) ,(`BA22_ID_IST_CMP_LT    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFLTU  {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_LT    /*5*/)   , (`BA22_ID_IST_CMP_OP_REG /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
`define BA22_ID_I_SFLTUI {(`BA22_ID_IST_CMP_TYPE_INT) /*10*/,(`BA22_ID_IST_CSU_U /*9*/) ,(`BA22_ID_IST_CMP_LT    /*5*/)   , (`BA22_ID_IST_CMP_OP_IMM /*4*/) , (1'b0                   /*3*/) ,  `BA22_ID_IT_SF}
                                                                                                                                                         
`define BA22_ID_I_J      {(4'b0000 /*6*/) , (`BA22_ID_IST_PC_SRC_ALU /*5*/) , (`BA22_ID_IST_ALU_LO_PC  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_J }
`define BA22_ID_I_JAL    {(4'b0000 /*6*/) , (`BA22_ID_IST_PC_SRC_ALU /*5*/) , (`BA22_ID_IST_ALU_LO_PC  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_J }
`define BA22_ID_I_JR     {(4'b0000 /*6*/) , (`BA22_ID_IST_PC_SRC_ALU /*5*/) , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_J }
`define BA22_ID_I_JALR   {(4'b0000 /*6*/) , (`BA22_ID_IST_PC_SRC_ALU /*5*/) , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_J }
`define BA22_ID_I_RETURN {(4'b0000 /*6*/) , (`BA22_ID_IST_PC_SRC_ALU /*5*/) , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_J }
`define BA22_ID_I_JA     {(4'b0000 /*6*/) , (`BA22_ID_IST_PC_SRC_ALU /*5*/) , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_J }  // ra == 0
                                                                                                                                                                 
`define BA22_ID_I_RFE    {(4'b0000 /*6*/) , (`BA22_ID_IST_PC_SRC_EPC /*5*/) , (1'b0                    /*4*/) , (1'b0                    /*3*/) ,  `BA22_ID_IT_J }
                                                                                                                                                                 
/* GENERAL JUMPING RULES */                                                                                                                                      
/* JR and JALR must have RB decoded as register 0 */                                                                                                             
/* JAL and JALR must have RD decoded as #LINK*/                                                                                                                  
/* J and JR must have RD decoded as R0  !! */  
/* return must have RA  decoded as RLINK */                                                                                                                      
/* return must have RB decoded as R0 */                                                                                                                          
                                                                                                                                                                 
// LEN = 10 , 1 bit is be used to decode MULTI LS instructions)                                                                                              
//                              BURST           SIGN EXEND LOAD                 LOAD / STORE                            SIZE                                                                                         2..0 INSTRUCTION TYPE         
`define BA22_ID_I_LBZ    { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_B    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LD     { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_B    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LHZ    { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_H    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LWS    { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_S    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
                                                                                                                                                                                                               
`define BA22_ID_I_LWZ    { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LWZRR  { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LWZPR  { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_PC  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LWZPI  { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_PC  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
                                                                                                                                               
`define BA22_ID_I_SB     { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_B    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}
`define BA22_ID_I_SD     { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_D    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}
`define BA22_ID_I_SH     { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_H    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}
`define BA22_ID_I_SW     { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}
`define BA22_ID_I_SWRR   { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_LSS}
                                                                                                                                                                                                                
`define BA22_ID_I_MLWZ   { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_MSW    { (  1'b0 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}

`define BA22_ID_I_LBZ_B  { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_B    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LD_B   { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_B    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LHZ_B  { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_H    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_LWS_B  { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_S    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
                                                                                                                                                                                                               
`define BA22_ID_I_LWZ_B  { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
                                                                                                                                               
`define BA22_ID_I_SB_B   { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_B    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}
`define BA22_ID_I_SD_B   { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_D    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}
`define BA22_ID_I_SH_B   { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_H    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}
`define BA22_ID_I_SW_B   { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}
                                                                                                                                                                                                                
`define BA22_ID_I_MLWZ_B { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_L    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSL}
`define BA22_ID_I_MSW_B  { (  1'b1 /*9*/)  ,(`BA22_ID_IST_MEXT_Z    /*8*/)  ,(`BA22_ID_IST_MDIR_S    /*7*/)  ,  (`BA22_ID_IST_MSIZ_W    /*5*/)   , (`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_LSS}


`define BA22_ID_I_EI     {   1'b0,`BA22_ID_IST_EI ,`BA22_ID_IST_MSIZ_W, 1'b0, `BA22_ID_IST_ALU_RO_IMM , `BA22_ID_IT_MTS}
`define BA22_ID_I_DI     {   1'b0,`BA22_ID_IST_DI ,`BA22_ID_IST_MSIZ_W, 1'b0, `BA22_ID_IST_ALU_RO_IMM , `BA22_ID_IT_MTS}

`define BA22_ID_I_MTSR   {   1'b0, 2'b00          ,`BA22_ID_IST_MSIZ_W, 1'b0, `BA22_ID_IST_ALU_RO_IMM , `BA22_ID_IT_MTS}
`define BA22_ID_I_MFSR   {   1'b0, 2'b00          ,`BA22_ID_IST_MSIZ_W, 1'b0, `BA22_ID_IST_ALU_RO_IMM , `BA22_ID_IT_MFS}
`define BA22_ID_I_MTSPR  {   1'b0, 2'b00          ,`BA22_ID_IST_MSIZ_W, 1'b0, `BA22_ID_IST_ALU_RO_IMM , `BA22_ID_IT_MTS}
`define BA22_ID_I_MFSPR  {   1'b0, 2'b00          ,`BA22_ID_IST_MSIZ_W, 1'b0, `BA22_ID_IST_ALU_RO_IMM , `BA22_ID_IT_MFS}

`define BA22_ID_I_ABS           {(`BA22_ID_IST_FUNC_ABS        ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SQR           {(`BA22_ID_IST_FUNC_SQR        ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SQRA          {(`BA22_ID_IST_FUNC_SQRA       ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_NEG           {(`BA22_ID_IST_FUNC_NEG        ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MAX           {(`BA22_ID_IST_FUNC_MAX        ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MIN           {(`BA22_ID_IST_FUNC_MIN        ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_LIM           {(`BA22_ID_IST_FUNC_LIM        ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}

`define BA22_ID_I_SLLS          {(`BA22_ID_IST_FUNC_SLLS       ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_SLLIS         {(`BA22_ID_IST_FUNC_SLLS       ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}

`define BA22_ID_I_MUL_SWSWL     {(`BA22_ID_IST_FUNC_MUL_SWSWL  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_SWSWH     {(`BA22_ID_IST_FUNC_MUL_SWSWH  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_SWUWL     {(`BA22_ID_IST_FUNC_MUL_SWUWL  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_SWUWH     {(`BA22_ID_IST_FUNC_MUL_SWUWH  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UWUWL     {(`BA22_ID_IST_FUNC_MUL_UWUWL  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UWUWH     {(`BA22_ID_IST_FUNC_MUL_UWUWH  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UTUT      {(`BA22_ID_IST_FUNC_MUL_UTUT   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UTUB      {(`BA22_ID_IST_FUNC_MUL_UTUB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UBUB      {(`BA22_ID_IST_FUNC_MUL_UBUB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UWUT      {(`BA22_ID_IST_FUNC_MUL_UWUT   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UWUB      {(`BA22_ID_IST_FUNC_MUL_UWUB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_STST      {(`BA22_ID_IST_FUNC_MUL_STST   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_STSB      {(`BA22_ID_IST_FUNC_MUL_STSB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_SBSB      {(`BA22_ID_IST_FUNC_MUL_SBSB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_SWST      {(`BA22_ID_IST_FUNC_MUL_SWST   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_SWSB      {(`BA22_ID_IST_FUNC_MUL_SWSB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UWUWSH    {(`BA22_ID_IST_FUNC_MUL_UWUWSH ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_SWSWSH    {(`BA22_ID_IST_FUNC_MUL_SWSWSH ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_UWUWSHR   {(`BA22_ID_IST_FUNC_MUL_UWUWSHR),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_SWSWSHR   {(`BA22_ID_IST_FUNC_MUL_SWSWSHR),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}

`define BA22_ID_I_MUL_ADD_SWSWL {(`BA22_ID_IST_FUNC_MUL_ADD_SWSWL  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_SWSWH {(`BA22_ID_IST_FUNC_MUL_ADD_SWSWH  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_SWUWL {(`BA22_ID_IST_FUNC_MUL_ADD_SWUWL  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_SWUWH {(`BA22_ID_IST_FUNC_MUL_ADD_SWUWH  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_UWUWL {(`BA22_ID_IST_FUNC_MUL_ADD_UWUWL  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_UWUWH {(`BA22_ID_IST_FUNC_MUL_ADD_UWUWH  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_UTUT  {(`BA22_ID_IST_FUNC_MUL_ADD_UTUT   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_UTUB  {(`BA22_ID_IST_FUNC_MUL_ADD_UTUB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_UBUB  {(`BA22_ID_IST_FUNC_MUL_ADD_UBUB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_UWUT  {(`BA22_ID_IST_FUNC_MUL_ADD_UWUT   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_UWUB  {(`BA22_ID_IST_FUNC_MUL_ADD_UWUB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_STST  {(`BA22_ID_IST_FUNC_MUL_ADD_STST   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_STSB  {(`BA22_ID_IST_FUNC_MUL_ADD_STSB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_SBSB  {(`BA22_ID_IST_FUNC_MUL_ADD_SBSB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_SWST  {(`BA22_ID_IST_FUNC_MUL_ADD_SWST   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MUL_ADD_SWSB  {(`BA22_ID_IST_FUNC_MUL_ADD_SWSB   ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}

`define BA22_ID_I_MUL    {(`BA22_ID_IST_FUNC_MUL_SWSWL  /*5*/  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MULI   {(`BA22_ID_IST_FUNC_MUL_SWSWL  /*5*/  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MULH   {(`BA22_ID_IST_FUNC_MUL_SWSWH  /*5*/  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}
`define BA22_ID_I_MULHU  {(`BA22_ID_IST_FUNC_MUL_UWUWH  /*5*/  ),(`BA22_ID_IST_ALU_LO_RA  /*4*/) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R}


`define BA22_ID_I_DIV    {(`BA22_ID_IST_FUNC_DIV       )   , (`BA22_ID_IST_ALU_LO_RA       ) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R} 
`define BA22_ID_I_DIVU   {(`BA22_ID_IST_FUNC_DIVU      )   , (`BA22_ID_IST_ALU_LO_RA       ) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R} 
`define BA22_ID_I_DIVI   {(`BA22_ID_IST_FUNC_DIV       )   , (`BA22_ID_IST_ALU_LO_RA       ) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R} 
`define BA22_ID_I_DIVUI  {(`BA22_ID_IST_FUNC_DIVU      )   , (`BA22_ID_IST_ALU_LO_RA       ) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R} 
`define BA22_ID_I_MOD    {(`BA22_ID_IST_FUNC_MOD       )   , (`BA22_ID_IST_ALU_LO_RA       ) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R} 
`define BA22_ID_I_MODU   {(`BA22_ID_IST_FUNC_MODU      )   , (`BA22_ID_IST_ALU_LO_RA       ) , (`BA22_ID_IST_ALU_RO_REG /*3*/) ,  `BA22_ID_IT_R2R} 
`define BA22_ID_I_MODI   {(`BA22_ID_IST_FUNC_MOD       )   , (`BA22_ID_IST_ALU_LO_RA       ) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R} 
`define BA22_ID_I_MODUI  {(`BA22_ID_IST_FUNC_MODU      )   , (`BA22_ID_IST_ALU_LO_RA       ) , (`BA22_ID_IST_ALU_RO_IMM /*3*/) ,  `BA22_ID_IT_R2R} 

`define BA22_ID_I_LMA    `BA22_ID_I_LWZPR 




/*
`define BA22_EPC_MMPC           2'b00
`define BA22_EPC_EXPC           2'b01
`define BA22_EPC_EXNPC          2'b1x
*/

`define BA22_PC_EXNPC           2'b00
`define BA22_PC_EXPC            2'b01
`define BA22_PC_MMPC            2'b10

`define BA22_EX_C_NEXT_PC       2'b00
`define BA22_EX_C_RB            2'b01
`define BA22_EX_C_ALU           2'b10

`define BA22_EX_NEW_PC_EXC      2'b00
`define BA22_EX_NEW_PC_ALU      2'b01
`define BA22_EX_NEW_PC_NEXT_PC  2'b10
`define BA22_EX_NEW_PC_EPC      2'b11

`define BA22_EEA_MMEA           2'b00
`define BA22_EEA_PC             2'b01
`define BA22_EEA_EXEA           2'b10

/*
`define BA22_WC_LSU             2'b00
//`define BA22_WC_SPR             2'b01
`define BA22_WC_MMC             2'b01
`define BA22_WC_MUL             2'b10
*/
`define BA22_WC_LSUQ 3'b100
`define BA22_WC_LSUW 3'b000
`define BA22_WC_LSUS 3'b001
`define BA22_WC_MMC  3'b010
`define BA22_WC_MUL  3'b011

`ifdef BA22_DIV_IMPLEMENTED
    `define BA22_DIV_CLZ_PARALLEL
`endif
`ifdef BA22_DU_DRAR
    `define BA22_DU_DREASON             11'd22
`endif

`define BA22_EXC_VECT_DTIME_ERR        `BA22_EXC_VECT_DBUS_ERR         
`define BA22_EXC_VECT_DRTY_ERR         `BA22_EXC_VECT_DBUS_ERR         

`ifdef BA22_DMMU_IMPLEMENTED
    `ifdef BA22_CMMU
    `else    
        `define BA22_CMMU
     `endif
`else
    `ifdef BA22_IMMU_IMPLEMENTED
        `ifdef BA22_CMMU
        `else    
            `define BA22_CMMU
        `endif
    `else
        `ifdef BA22_DC_IMPLEMENTED
            `ifdef BA22_CMMU
            `else    
                `define BA22_CMMU
            `endif
        `else
            `ifdef BA22_IC_IMPLEMENTED
                `ifdef BA22_CMMU
                `else    
                    `define BA22_CMMU
                `endif
            `endif
        `endif
    `endif
`endif

// Address offsets of PIC registers inside PIC group
`define BA22_PIC_OFS_PICMR 2'd0
`define BA22_PIC_OFS_PICSR 2'd2

// Position of offset bits inside SPR address
`define BA22_PICOFS_BITS 1:0




// Address offsets of TT registers inside TT group
`define BA22_TT_OFS_TTMR 5'd0
`define BA22_TT_OFS_TTCR 5'd1
`define BA22_TT_OFS_TTRS 5'd2
`define BA22_TT_OFS_TTUR 5'd31
//`define BA22_TT_OFS_ETCR 5'd2
`define BA22_TT_OFS_ETMR 5'd31

// Position of offset bits inside SPR group
`define BA22_TTOFS_BITS 4:0

// Tick Timer Mode Register (TTMR) bits
`define BA22_TT_TTMR_TP 27:0
`define BA22_TT_TTMR_IP 28
`define BA22_TT_TTMR_IE 29
`define BA22_TT_TTMR_M 31:30

// Tick Timer Undocumented Register (TTUR) bits
`define BA22_TT_TTUR_ICTM 0


//`define BA22_RF_DBG_SHARE_READ_MUX

/* IFEA brakpoint                                                                                   */

/* Define ITLB ways */
`ifdef BA22_ITLB_WAYS_4
    `define BA22_ITLB_WAYS 4
    `define BA22_ITLB_WAY3
    `define BA22_ITLB_WAY2
    `define BA22_ITLB_WAY1
    `define BA22_ITLB_WAY0
`else
    `ifdef BA22_ITLB_WAYS_3
        `define BA22_ITLB_WAYS 3
        `define BA22_ITLB_WAY2
        `define BA22_ITLB_WAY1
        `define BA22_ITLB_WAY0
    `else
        `ifdef BA22_ITLB_WAYS_2
            `define BA22_ITLB_WAYS 2
            `define BA22_ITLB_WAY1
            `define BA22_ITLB_WAY0
        `else
           `ifdef BA22_ITLB_WAYS_1
                `define BA22_ITLB_WAYS 1
                `define BA22_ITLB_WAY0
           `else
                $display("ba22_defines.v: ITLB asociativity not defined");
                $finish;
           `endif
        `endif
    `endif
`endif

/* Define DTLB ways     */
`ifdef BA22_DTLB_WAYS_4
    `define BA22_DTLB_WAYS 4
    `define BA22_DTLB_WAY3
    `define BA22_DTLB_WAY2
    `define BA22_DTLB_WAY1
    `define BA22_DTLB_WAY0
`else
    `ifdef BA22_DTLB_WAYS_3
        `define BA22_DTLB_WAYS 3
        `define BA22_DTLB_WAY2
        `define BA22_DTLB_WAY1
        `define BA22_DTLB_WAY0
    `else
        `ifdef BA22_DTLB_WAYS_2
            `define BA22_DTLB_WAYS 2
            `define BA22_DTLB_WAY1
            `define BA22_DTLB_WAY0
        `else
           `ifdef BA22_DTLB_WAYS_1
                `define BA22_DTLB_WAYS 1
                `define BA22_DTLB_WAY0
           `else
                $display("ba22_defines.v: DTLB asociativity not defined");
                $finish;
            `endif
        `endif
    `endif
`endif

/* Define DC ways     */
`ifdef BA22_DC_WAYS_4
    `define BA22_DC_WAYS 4
    `define BA22_DC_WAY3
    `define BA22_DC_WAY2
    `define BA22_DC_WAY1
    `define BA22_DC_WAY0
`else
    `ifdef BA22_DC_WAYS_3
        `define BA22_DC_WAYS 3
        `define BA22_DC_WAY2
        `define BA22_DC_WAY1
        `define BA22_DC_WAY0
    `else
        `ifdef BA22_DC_WAYS_2
            `define BA22_DC_WAYS 2
            `define BA22_DC_WAY1
            `define BA22_DC_WAY0
        `else
           `ifdef BA22_DC_WAYS_1
                `define BA22_DC_WAYS 1
                `define BA22_DC_WAY0
           `else
                $display("ba22_defines.v: DC asociativity not defined");
                $finish;
            `endif
        `endif
    `endif
`endif

/* Define IC ways     */
`ifdef BA22_IC_WAYS_4
    `define BA22_IC_WAYS 4
    `define BA22_IC_WAY3
    `define BA22_IC_WAY2
    `define BA22_IC_WAY1
    `define BA22_IC_WAY0
`else
    `ifdef BA22_IC_WAYS_3
        `define BA22_IC_WAYS 3
        `define BA22_IC_WAY2
        `define BA22_IC_WAY1
        `define BA22_IC_WAY0
    `else
        `ifdef BA22_IC_WAYS_2
            `define BA22_IC_WAYS 2
            `define BA22_IC_WAY1
            `define BA22_IC_WAY0
        `else
           `ifdef BA22_IC_WAYS_1
                `define BA22_IC_WAYS 1
                `define BA22_IC_WAY0
           `else
                $display("ba22_defines.v: IC asociativity not defined");
                $finish;
            `endif
        `endif
    `endif
`endif

`ifdef BA22_CMMU
`define BA22_IC_ICDBG               3'b100
`define BA22_IC_ICDBG_OP            31:29
`define BA22_IC_ICDBG_OP_TAG        3'b000
`define BA22_IC_ICDBG_OP_DAT        3'b001
`define BA22_IC_ICDBG_OP_LRU        3'b010
`define BA22_IC_ICDBG_WAY           28:26
`define BA22_IC_ICDBG_WAY_0         3'b000
`define BA22_IC_ICDBG_WAY_1         3'b001
`define BA22_IC_ICDBG_WAY_2         3'b010
`define BA22_IC_ICDBG_WAY_3         3'b011

`define BA22_DC_DCDBG               3'b100
`define BA22_DC_DCDBG_OP            31:29
`define BA22_DC_DCDBG_OP_TAG        3'b000
`define BA22_DC_DCDBG_OP_DAT        3'b001
`define BA22_DC_DCDBG_OP_LRU        3'b010
`define BA22_DC_DCDBG_WAY           28:26
`define BA22_DC_DCDBG_WAY_0         3'b000
`define BA22_DC_DCDBG_WAY_1         3'b001
`define BA22_DC_DCDBG_WAY_2         3'b010
`define BA22_DC_DCDBG_WAY_3         3'b011

`define BA22_DTLB_DTLBDBG               3'b000
`define BA22_DTLB_DTLBDBG_OP            31:29
`define BA22_DTLB_DTLBDBG_OP_MR         3'b000
`define BA22_DTLB_DTLBDBG_OP_TR         3'b001
`define BA22_DTLB_DTLBDBG_OP_LRU        3'b010
`define BA22_DTLB_DTLBDBG_WAY           28:26
`define BA22_DTLB_DTLBDBG_WAY_0         3'b000
`define BA22_DTLB_DTLBDBG_WAY_1         3'b001
`define BA22_DTLB_DTLBDBG_WAY_2         3'b010
`define BA22_DTLB_DTLBDBG_WAY_3         3'b011

`define BA22_ITLB_ITLBDBG               3'b000
`define BA22_ITLB_ITLBDBG_OP            31:29
`define BA22_ITLB_ITLBDBG_OP_MR         3'b000
`define BA22_ITLB_ITLBDBG_OP_TR         3'b001
`define BA22_ITLB_ITLBDBG_OP_LRU        3'b010
`define BA22_ITLB_ITLBDBG_WAY           28:26
`define BA22_ITLB_ITLBDBG_WAY_0         3'b000
`define BA22_ITLB_ITLBDBG_WAY_1         3'b001
`define BA22_ITLB_ITLBDBG_WAY_2         3'b010
`define BA22_ITLB_ITLBDBG_WAY_3         3'b011
`endif
`ifdef BA22_DU_TB_IMPLEMENTED
    `define BA22_DU_TBADR                  11'h0ff
    `define BA22_DU_TBRBASE                11'h0fe
    `define BA22_DU_TBIA                   11'h1??
    `define BA22_DU_TBIM                   11'h2??
    `define BA22_DU_TBAR                   11'h3??
    `define BA22_DU_TBTS                   11'h4??
    `define BA22_DU_TBFL                   11'h5??
`endif



`define BA22_SR_DMMUCFGR_VAL_NTW       `BA22_DTLB_WAYS
`define BA22_SR_DMMUCFGR_VAL_NTS       `BA22_DTLB_INDXW
`ifdef BA22_DMMU_CRI
    `define BA22_SR_DMMUCFGR_VAL_CRI    1'b1
`else
    `define BA22_SR_DMMUCFGR_VAL_CRI    1'b0
`endif
`ifdef BA22_DMMU_PRI
    `define BA22_SR_DMMUCFGR_VAL_PRI    1'b1
`else
    `define BA22_SR_DMMUCFGR_VAL_PRI    1'b0
`endif
`ifdef BA22_DMMU_TLBEIR
    `define BA22_SR_DMMUCFGR_VAL_TEIRI  1'b1
`else
    `define BA22_SR_DMMUCFGR_VAL_TEIRI  1'b0
`endif
`ifdef BA22_DMMU_HTR_IMPLEMENTED
    `define BA22_SR_DMMUCFGR_VAL_HTR    1'b1
`else
    `define BA22_SR_DMMUCFGR_VAL_HTR    1'b0
`endif
                                        
`define BA22_SR_IMMUCFGR_VAL_NTW       `BA22_ITLB_WAYS
`define BA22_SR_IMMUCFGR_VAL_NTS       `BA22_ITLB_INDXW
`ifdef BA22_IMMU_CRI
    `define BA22_SR_IMMUCFGR_VAL_CRI    1'b1
`else
    `define BA22_SR_IMMUCFGR_VAL_CRI    1'b0
`endif
`ifdef BA22_IMMU_PRI
    `define BA22_SR_IMMUCFGR_VAL_PRI    1'b1
`else
    `define BA22_SR_IMMUCFGR_VAL_PRI    1'b0
`endif
`ifdef BA22_IMMU_TLBEIR
    `define BA22_SR_IMMUCFGR_VAL_TEIRI  1'b1
`else
    `define BA22_SR_IMMUCFGR_VAL_TEIRI  1'b0
`endif
`ifdef BA22_IMMU_HTR_IMPLEMENTED
    `define BA22_SR_IMMUCFGR_VAL_HTR    1'b1
`else
    `define BA22_SR_IMMUCFGR_VAL_HTR    1'b0
`endif

`define BA22_SR_DCCFGR_VAL_NCW          `BA22_DC_WAYS
`define BA22_SR_DCCFGR_VAL_NCS          `BA22_DC_INDX_W
`define BA22_SR_DCCFGR_VAL_CBS          `BA22_DC_BLCK_W
`ifdef BA22_DC_WRITE_BACK
    `define BA22_SR_DCCFGR_VAL_CWS      1'b1
`else
    `define BA22_SR_DCCFGR_VAL_CWS      1'b0
`endif
`ifdef BA22_DC_DCBIR
    `define BA22_SR_DCCFGR_VAL_CBIRI    1'b1
`else
    `define BA22_SR_DCCFGR_VAL_CBIRI    1'b0
`endif
`ifdef BA22_DC_DCPRI
    `define BA22_SR_DCCFGR_VAL_CBPRI    1'b1
`else
    `define BA22_SR_DCCFGR_VAL_CBPRI    1'b0
`endif
`ifdef BA22_DC_DCLRI
    `define BA22_SR_DCCFGR_VAL_CBLRI    1'b1
`else
    `define BA22_SR_DCCFGR_VAL_CBLRI    1'b0
`endif
`ifdef BA22_DC_DCFRI
    `define BA22_SR_DCCFGR_VAL_CBFRI    1'b1
`else
    `define BA22_SR_DCCFGR_VAL_CBFRI    1'b0
`endif
`ifdef BA22_DC_DCWBRI
    `define BA22_SR_DCCFGR_VAL_CBWBRI   1'b1
`else
    `define BA22_SR_DCCFGR_VAL_CBWBRI   1'b0
`endif

`define BA22_SR_ICCFGR_VAL_NCW          `BA22_IC_WAYS
`define BA22_SR_ICCFGR_VAL_NCS          `BA22_IC_INDX_W
`define BA22_SR_ICCFGR_VAL_CBS          `BA22_IC_BLCK_W
`ifdef BA22_IC_ICIR
    `define BA22_SR_ICCFGR_VAL_CBIRI    1'b1
`else
    `define BA22_SR_ICCFGR_VAL_CBIRI    1'b0
`endif
`ifdef BA22_IC_ICPRI
    `define BA22_SR_ICCFGR_VAL_CBPRI    1'b1
`else
    `define BA22_SR_ICCFGR_VAL_CBPRI    1'b0
`endif
`ifdef BA22_IC_ICLRI
    `define BA22_SR_ICCFGR_VAL_CBLRI    1'b1
`else
    `define BA22_SR_ICCFGR_VAL_CBLRI    1'b0
`endif

`ifdef BA22_RIR
    `define BA22_SR_ICCFGR_VAL_RIRI     1'b1
    `define BA22_SR_DCCFGR_VAL_RIRI     1'b1
    `define BA22_SR_DMMUCFGR_VAL_RIRI   1'b1
    `define BA22_SR_IMMUCFGR_VAL_RIRI   1'b1
`else
    `define BA22_SR_ICCFGR_VAL_RIRI     1'b0
    `define BA22_SR_DCCFGR_VAL_RIRI     1'b0
    `define BA22_SR_DMMUCFGR_VAL_RIRI   1'b0
    `define BA22_SR_IMMUCFGR_VAL_RIRI   1'b0
`endif

`ifdef BA22_DU_DVR7
    `define BA22_SR_DCFGR_VAL_NDP                                   4'd8
`else
    `ifdef BA22_DU_DVR6
        `define BA22_SR_DCFGR_VAL_NDP                               4'd7
    `else
        `ifdef BA22_DU_DVR5
            `define BA22_SR_DCFGR_VAL_NDP                           4'd6
        `else
            `ifdef BA22_DU_DVR4
                `define BA22_SR_DCFGR_VAL_NDP                       4'd5
            `else
                `ifdef BA22_DU_DVR3
                    `define BA22_SR_DCFGR_VAL_NDP                   4'd4
                `else
                    `ifdef BA22_DU_DVR2
                        `define BA22_SR_DCFGR_VAL_NDP               4'd3
                    `else
                        `ifdef BA22_DU_DVR1
                            `define BA22_SR_DCFGR_VAL_NDP           4'd2
                        `else
                            `ifdef BA22_DU_DVR0
                                `define BA22_SR_DCFGR_VAL_NDP       4'd1
                            `else
                                `define BA22_SR_DCFGR_VAL_NDP       4'd0
                            `endif
                        `endif
                    `endif
                `endif
            `endif
        `endif
    `endif
`endif
`define BA22_SR_DCFGR_VAL_WPCI  0
`ifdef BA22_DU_TB_IMPLEMENTED
    `define BA22_SR_DCFGR_VAL_TB      1         
    `define BA22_SR_DCFGR_VAL_TB_SIZE `BA22_DU_TB_DEPTH  
`else
    `define BA22_SR_DCFGR_VAL_TB      0       
    `define BA22_SR_DCFGR_VAL_TB_SIZE 4'b0    
`endif
                     

`define BA22_SR_DMMUCFGR_NTW    3:0     // number of ways
`define BA22_SR_DMMUCFGR_NTS    7:4     // log2 of number of sets
`define BA22_SR_DMMUCFGR_CRI    8       // control register implemented
`define BA22_SR_DMMUCFGR_PRI    9       // protection register implemented
`define BA22_SR_DMMUCFGR_TEIRI 10       // TLB invalidate register implemented
`define BA22_SR_DMMUCFGR_HTR   11       // HW TLB reload
`define BA22_SR_DMMUCFGR_RIRI  18       // range invalidation registers

`define BA22_SR_IMMUCFGR_NTW    3:0     // number of ways
`define BA22_SR_IMMUCFGR_NTS    7:4     // log2 of number of sets
`define BA22_SR_IMMUCFGR_CRI    8       // control register implemented
`define BA22_SR_IMMUCFGR_PRI    9       // protection register implemented
`define BA22_SR_IMMUCFGR_TEIRI 10       // TLB invalidate register implemented
`define BA22_SR_IMMUCFGR_HTR   11       // HW TLB reload
`define BA22_SR_IMMUCFGR_RIRI  18       // range invalidation registers

`define BA22_SR_DCCFGR_NCW     3:0      // number of ways
`define BA22_SR_DCCFGR_NCS     7:4      // log2 of number of sets
`define BA22_SR_DCCFGR_CBS    11:8      // log2 block size (in words)
`define BA22_SR_DCCFGR_CWS    12        // write strategy
`define BA22_SR_DCCFGR_CBIRI  13        // cache invalidate block register
`define BA22_SR_DCCFGR_CBPRI  14        // cache prefetch register
`define BA22_SR_DCCFGR_CBLRI  15        // cache lock register
`define BA22_SR_DCCFGR_CBFRI  16        // cache flush register
`define BA22_SR_DCCFGR_CBWBRI 17        // cache write back register
`define BA22_SR_DCCFGR_RIRI   18        // range invalidation registers

`define BA22_SR_ICCFGR_NCW     3:0      // number of ways
`define BA22_SR_ICCFGR_NCS     7:4      // log2 of number of sets
`define BA22_SR_ICCFGR_CBS    11:8      // log2 block size (in words)
`define BA22_SR_ICCFGR_CBIRI  13        // cache invalidate block register
`define BA22_SR_ICCFGR_CBPRI  14        // cache prefetch register
`define BA22_SR_ICCFGR_CBLRI  15        // cache lock register
`define BA22_SR_ICCFGR_RIRI   18        // range invalidation registers


`define BA22_SR_DCFGR_NDP     3:0       // DVR/DCR pairs
`define BA22_SR_DCFGR_WPCI    4         // preformance counteras inplemented
`define BA22_SR_DCFGR_TB      5         // trace buffer implemented
`define BA22_SR_DCFGR_TB_SIZE 9:6       // log2 trace buffer depth

`define BA22_MAC_OFFSET     1:0
`define BA22_MAC_MACLO      2'b01
`define BA22_MAC_MACHI      2'b10

`ifdef BA22_DMMU_IMPLEMENTED
    `ifdef BA22_RIR
    `else    
        `define BA22_RIR
     `endif
`else
    `ifdef BA22_IMMU_IMPLEMENTED
        `ifdef BA22_RIR
        `else    
            `define BA22_RIR
        `endif
    `else
        `ifdef BA22_DC_IMPLEMENTED
            `ifdef BA22_RIR
            `else    
                `define BA22_RIR
            `endif
        `else
            `ifdef BA22_IC_IMPLEMENTED
                `ifdef BA22_RIR
                `else    
                    `define BA22_RIR
                `endif
            `endif
        `endif
    `endif
`endif


`define BA22_RIR_MIN       11'd20
`define BA22_RIR_MAX       11'd21




`define BA22_RIR_IH             0

`define BA22_RIR_TARGET         3
`define BA22_RIR_TARGET_CACHE   0
`define BA22_RIR_TARGET_TLB     1

`define BA22_RIR_TYPE_I         1
`define BA22_RIR_TYPE_D         2


`define BA22_RIR_ICMAX_IH       0
`define BA22_RIR_ICMAX_ALL      1
`define BA22_RIR_DCMAX_IH       2
`define BA22_RIR_DCMAX_ALL      3
`define BA22_RIR_ITLBMAX_IH     4
`define BA22_RIR_ITLBMAX_ALL    5
`define BA22_RIR_DTLBMAX_IH     6
`define BA22_RIR_DTLBMAX_ALL    7


// UPR fields
`define BA22_UPR_UP_BITS               0
`define BA22_UPR_DCP_BITS              1
`define BA22_UPR_ICP_BITS              2
`define BA22_UPR_DMP_BITS              3
`define BA22_UPR_IMP_BITS              4
`define BA22_UPR_MP_BITS               5
`define BA22_UPR_DUP_BITS              6
`define BA22_UPR_PCUP_BITS             7
`define BA22_UPR_PMP_BITS              8
`define BA22_UPR_PICP_BITS             9
`define BA22_UPR_TTP_BITS              10
`define BA22_UPR_FPUSP_BITS            11
`define BA22_UPR_FPUDP_BITS            12
`define BA22_UPR_RES1_BITS             23:13
`define BA22_UPR_CUP_BITS              31:24

// UPR values
`define BA22_UPR_UP                    1'b1
`ifdef BA22_DC_IMPLEMENTED
`define BA22_UPR_DCP                   1'b1
`else
`define BA22_UPR_DCP                   1'b0
`endif
`ifdef BA22_IC_IMPLEMENTED
`define BA22_UPR_ICP                   1'b1
`else
`define BA22_UPR_ICP                   1'b0
`endif
`ifdef BA22_DMMU_IMPLEMENTED
`define BA22_UPR_DMP                   1'b1
`else
`define BA22_UPR_DMP                   1'b0
`endif
`ifdef BA22_IMMU_IMPLEMENTED
`define BA22_UPR_IMP                   1'b1
`else
`define BA22_UPR_IMP                   1'b0
`endif
`ifdef BA22_MAC_IMPLEMENTED
`define BA22_UPR_MP                    1'b1
`else
`define BA22_UPR_MP                    1'b0
`endif
`ifdef BA22_DU_IMPLEMENTED
`define BA22_UPR_DUP                   1'b1
`else
`define BA22_UPR_DUP                   1'b0
`endif
`define BA22_UPR_PCUP                  1'b0 // Performance counters not present
`ifdef BA22_PM_IMPLEMENTED
`define BA22_UPR_PMP                   1'b1
`else
`define BA22_UPR_PMP                   1'b0
`endif
`ifdef BA22_PIC_IMPLEMENTED
`define BA22_UPR_PICP                  1'b1
`else
`define BA22_UPR_PICP                  1'b0
`endif
`ifdef BA22_TT_IMPLEMENTED
`define BA22_UPR_TTP                   1'b1
`else
`define BA22_UPR_TTP                   1'b0
`endif
`ifdef BA22_FPU32_IMPLEMENTED
`define BA22_UPR_FPUSP                 1'b1
`else
`define BA22_UPR_FPUSP                 1'b0
`endif
`ifdef BA22_FPU64_IMPLEMENTED
`define BA22_UPR_FPUDP                 1'b1
`else
`define BA22_UPR_FPUDP                 1'b0
`endif



`define BA22_UPR_RES1                  11'h0
`define BA22_UPR_CUP                   8'h00



// CPUCFGR fields
`define BA22_CPUCFGR_NSGF_BITS         3:0
`define BA22_CPUCFGR_CGF_BITS          4
`define BA22_CPUCFGR_OB32S_BITS        5
`define BA22_CPUCFGR_OB64S_BITS        6
`define BA22_CPUCFGR_OF32S_BITS        7
`define BA22_CPUCFGR_OF64S_BITS        8
`define BA22_CPUCFGR_OV64S_BITS        9
`define BA22_CPUCFGR_RES1_BITS         31:10

// CPUCFGR values
`define BA22_CPUCFGR_NSGF              4'h0
`ifdef BA22_GPR_LESS_THAN_16
`define BA22_CPUCFGR_CGF               1'b1
`else
`define BA22_CPUCFGR_CGF               1'b0
`endif
`define BA22_CPUCFGR_OB32S             1'b1
`define BA22_CPUCFGR_OB64S             1'b0
`define BA22_CPUCFGR_OF32S             1'b0
`define BA22_CPUCFGR_OF64S             1'b0
`define BA22_CPUCFGR_OV64S             1'b0
`define BA22_CPUCFGR_RES1              22'h000000

//`define BA22_FPU32_I_REG
`define BA22_CNT_ORDER      2:0

/* ---------------- */
/*  AHB constants   */
/* ---------------- */



`define BA22_AHB_HTRANS_RANGE            1:0

`define BA22_AHB_HTRANS_IDLE             2'b00
`define BA22_AHB_HTRANS_BUSY             2'b01
`define BA22_AHB_HTRANS_NONSEQ           2'b10
`define BA22_AHB_HTRANS_SEQ              2'b11


// HSIZE
`define BA22_AHB_HSIZE_RANGE              2:0

`define BA22_AHB_SIZE_BYTE               3'b000
`define BA22_AHB_SIZE_HALF               3'b001
`define BA22_AHB_SIZE_WORD               3'b010
`define BA22_AHB_SIZE_2WORD              3'b011
`define BA22_AHB_SIZE_4WORD              3'b100
`define BA22_AHB_SIZE_8WORD              3'b101

//HBURST
`define BA22_AHB_HBURST_RANGE            2:0

`define BA22_AHB_HBURST_SINGLE           3'b000
`define BA22_AHB_HBURST_INCR             3'b001
`define BA22_AHB_HBURST_WRAP4            3'b010
`define BA22_AHB_HBURST_INCR4            3'b011
`define BA22_AHB_HBURST_WRAP8            3'b100
`define BA22_AHB_HBURST_INCR8            3'b101
`define BA22_AHB_HBURST_WRAP16           3'b110
`define BA22_AHB_HBURST_INCR16           3'b111


// HPROT
`define BA22_AHB_HPROT_RANGE             3:0


// HRESP
`define BA22_AHB_HRESP_RANGE             1:0

`define BA22_AHB_HRESP_OKAY              2'b00
`define BA22_AHB_HRESP_ERROR             2'b01
`define BA22_AHB_HRESP_RETRY             2'b10
`define BA22_AHB_HRESP_SPLIT             2'b11

`define BA22_AHB_ADDR_RANGE            31:0
`define BA22_AHB_WDATA_RANGE           31:0
`define BA22_AHB_RDATA_RANGE           31:0

`define BA22_AHB_BYTE_ON_LBYTE

`define BA22_RADR                       5:0
`define BA22_RF_WIDTH                   6                  
`define BA22_RLINK                      6'b001001
`define BA22_RTMP                       6'b100000
`define BA22_RZERO                      6'b000000
`define BA22_RDONTCARE                  6'bxxxxxx
`define BA22_R01                        6'b000001

`ifdef BA22_NON_CACHEABLE_REGION0
    `define BA22_NON_CACHEABLE_REGIONS
`else
    `ifdef BA22_NON_CACHEABLE_REGION1
        `define BA22_NON_CACHEABLE_REGIONS
    `endif
`endif  
    
`define BA22_DTLBMR2_VPN 31:13  /* Virtual Page Number */

`define BA22_DTLBTR2_P          0       /* Present */
`define BA22_DTLBTR2_CI         1       /* Cache inhibit */
`define BA22_DTLBTR2_U          2       /* Everything that the supervisor can do on   */
                                        /* the page, userspace can also do */
`define BA22_DTLBTR2_R          3       /* Supervisor mode can read the page */
`define BA22_DTLBTR2_W          4       /* Supervisor mode can write the page */
`define BA22_DTLBTR2_PPN        31:13   /* Physical Page Number */

`define BA22_ITLBMR2_VPN        31:13   /* Virtual Page Number */

`define BA22_ITLBTR2_P          0      /* Present */
`define BA22_ITLBTR2_CI         1      /* Cache inhibit */
`define BA22_ITLBTR2_U          2      /* Everything that the supervisor can do on   */
                                       /* the page, userspace can also do */
`define BA22_ITLBTR2_E          5      /* Supervisor mode can execute the page */
`define BA22_ITLBTR2_PPN        31:13  /* Physical Page Number */

//`define BA22_DTLB_WAYS          4
`define BA22_DTLB2_WIDTH        43
`define BA22_DTLB2_MEM_RANGE    `BA22_DTLB2_WIDTH - 1 :0

//`define BA22_ITLB_WAYS          4
`define BA22_ITLB2_WIDTH        41
`define BA22_ITLB2_MEM_RANGE    `BA22_ITLB2_WIDTH - 1 :0


// Saturated insns anf fpu make group 7
`ifdef BA22_FPU32_IMPLEMENTED 
    `define BA22_SATARITH_OR_FPU_IMPLEMENTED
`else
    `ifdef BA22_SATARITH_IMPLEMENTED 
        `define BA22_SATARITH_OR_FPU_IMPLEMENTED
    `endif
`endif

// find last one
`define BA23_FL1_32(X) ((|(X & (32'h00000001 <<  0))) ?  0 : (|(X & (32'h00000001 <<  1))) ?  1 : (|(X & (32'h00000001 <<  2))) ?  2 : (|(X & (32'h00000001 <<  3))) ?  3 : (|(X & (32'h00000001 <<  4))) ?  4 : (|(X & (32'h00000001 <<  5))) ?  5:(|(X & (32'h00000001 <<  6))) ?  6 : (|(X & (32'h00000001 <<  7))) ?  7 : (|(X & (32'h00000001 <<  8))) ?  8 : (|(X & (32'h00000001 <<  9))) ?  9 : (|(X & (32'h00000001 << 10))) ? 10 : (|(X & (32'h00000001 << 11))) ? 11 : (|(X &(32'h00000001 << 12))) ? 12 : (|(X & (32'h00000001 << 13))) ? 13 : (|(X & (32'h00000001 << 14))) ? 14 : (|(X & (32'h00000001 << 15))) ? 15 : (|(X & (32'h00000001 << 16))) ? 16 : (|(X & (32'h00000001 << 17))) ? 17 : (|(X & (32'h00000001<< 18))) ? 18 : (|(X & (32'h00000001 << 19))) ? 19 : (|(X & (32'h00000001 << 20))) ? 20 : (|(X & (32'h00000001 << 21))) ? 21 : (|(X & (32'h00000001 << 22))) ? 22 : (|(X & (32'h00000001 << 23))) ? 23 : (|(X & (32'h00000001 << 24))) ? 24 : (|(X & (32'h00000001 << 25))) ? 25 : (|(X & (32'h00000001 << 26))) ? 26 : (|(X & (32'h00000001 << 27))) ? 27 : (|(X & (32'h00000001 << 28))) ? 28 : (|(X & (32'h00000001 << 29))) ? 29 : (|(X & (32'h00000001 << 30))) ? 30 : (|(X & (32'h00000001 << 31))) ? 31 : -1)

// find first one
`define BA23_FF1_32(X) ((|(X & (32'h00000001 << 31))) ?  (31) : (|(X & (32'h00000001 << 30))) ?  (30) : (|(X & (32'h00000001 << 29))) ?  (29) : (|(X & (32'h00000001 << 28))) ?  (28) : (|(X & (32'h00000001 << 27))) ?  (27) : (|(X &(32'h00000001 << 26))) ?  (26) : (|(X & (32'h00000001 << 25))) ?  (25) : (|(X & (32'h00000001 << 24))) ?  (24) : (|(X & (32'h00000001 << 23))) ?  (23) : (|(X & (32'h00000001 << 22))) ?  (22) : (|(X & (32'h00000001 << 21))) ?  (21) : (|(X & (32'h00000001 << 20))) ?  (20) : (|(X & (32'h00000001 << 19))) ?  (19) : (|(X & (32'h00000001 << 18))) ?  (18) : (|(X & (32'h00000001 << 17))) ?  (17) : (|(X & (32'h00000001 << 16))) ?  (16) : (|(X & (32'h00000001 << 15))) ?  (15): (|(X & (32'h00000001 << 14))) ?  (14) : (|(X & (32'h00000001 << 13))) ?  (13) : (|(X & (32'h00000001 << 12))) ?  (12) : (|(X & (32'h00000001 << 11))) ?  (11) : (|(X & (32'h00000001 << 10))) ?  (10) : (|(X & (32'h00000001 <<  9))) ? ( 9) : (|(X & (32'h00000001 <<  8))) ?  ( 8) : (|(X & (32'h00000001 <<  7))) ?  ( 7) : (|(X & (32'h00000001 <<  6))) ?  ( 6) : (|(X & (32'h00000001 <<  5))) ?  ( 5) : (|(X & (32'h00000001 <<  4))) ?  ( 4) : (|(X & (32'h00000001 <<  3))) ?  ( 3) : (|(X & (32'h00000001 <<  2))) ?  ( 2) : (|(X & (32'h00000001 <<  1))) ?  ( 1) : (|(X & (32'h00000001 <<  0))) ?  ( 0) : -1)

// make range out ot masks
`define GET_RANGE(A) `BA23_FF1_32(A):`BA23_FL1_32(A)
`define GET_WIDTH(A) (`BA23_FF1_32(A)-`BA23_FL1_32(A)+1)

`define BA22_SPRREG_ADRMASK_MDB (16'h0003)
`define BA22_SPR_DADDR          (16'h0000)
`define BA22_SPR_DCMD           (16'h0001)
`define BA22_SPR_DDATA          (16'h0002)

`define BA22_SPR_DCMD_SIZ       32'h00000003
`define BA22_SPR_DCMD_INC       32'h00000008
`define BA22_SPR_DCMD_DBE       32'h00010000
`define BA22_SPR_DCMD_DTLBM     32'h00020000
`define BA22_SPR_DCMD_DPF       32'h00040000
`define BA22_SPR_DCMD_DCM       32'h00080000
`define BA22_SPR_DCMD_ALIGN     32'h00100000
`define BA22_SPR_DCMD_CLR       32'h80000000

/* IMplement Memory debug*/
`define BA22_MDB_IMPLEMENTED
`define BA22_MDB_RES_W          4

`define BA22_MDB_RES_DBE    `BA22_MDB_RES_W'b0001
`define BA22_MDB_RES_DCM    `BA22_MDB_RES_W'b0010
`define BA22_MDB_RES_DPF    `BA22_MDB_RES_W'b0100
`define BA22_MDB_RES_DTLBM  `BA22_MDB_RES_W'b1000

`define BA22_MDB_BW_SB              {4'h8,44'b00_00_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000}
`define BA22_MDB_BW_LBZ             {4'h8,44'b01_00_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000}
`define BA22_MDB_BW_SH              {4'h8,44'b10_00_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000}
`define BA22_MDB_BW_LHZ             {4'h8,44'b10_00_0000_0000_1000_0000_0000_0000_0000_0000_0000_0000}
`define BA22_MDB_BW_SW              {4'h8,44'b11_00_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000}
`define BA22_MDB_BW_LWZ             {4'h8,44'b11_00_0000_0000_0100_0000_0000_0000_0000_0000_0000_0000}


// AHB bus widths
`define BA22_AHB_BUS_DW     32
`define BA22_AHB_BUS_AW     32

`ifdef BA22_DC_INCREASELATENCY
`else
    `define BA22_DC_ONECYC
`endif

`define BA22_CARRY_IMPLEMENTED

/* define the register used as PC */
`define BA22_PC_MAP_TO_GPRS                   5'b11111

`ifdef BA22_AHB_RST_ACT_HIGH
    `define BA22_AHB_RST_ACT 1'b1
    `define BA22_AHB_RST_EVENT  or posedge(ahb_rstn_i)
`else
    `define BA22_AHB_RST_ACT 1'b0
    `define BA22_AHB_RST_EVENT  or negedge(ahb_rstn_i)
`endif

/* >>> Define the following system group registers <<< */
/* Jump Program counter non-architectural register  */
`define BA22_SPR_JPC_IMPLEMENTED

`ifdef BA22_DU_IMPLEMENTED
/* Implement Debug Mode Register 1          */
    `define BA22_DU_DMR1                11'd16
/* Implement Debug Stop Register            */
    `define BA22_DU_DSR                 11'd20
/* Implemet Debug Reason Register           */
    `define BA22_DU_DRR                 11'd21
/* Implement Debug Reason Address Register  */
    `define BA22_DU_DRAR                11'd22
/* Implement TRace Port Register            */
    `define BA22_DU_TRP                 11'd23
/* Implement TRace Port User defined packet */
    `define BA22_DU_UDI                 11'd24

    `ifdef BA22_DU_HWBKPTS
        `define BA22_DU_DMR2            11'd17
        `ifdef BA22_DU_PAIR0_IMPLEMENTED
            `define BA22_DU_DVR0            11'd0
            `define BA22_DU_DCR0            11'd8
        `endif
/* Implement DVR/DCR pair #1                */
        `ifdef BA22_DU_PAIR1_IMPLEMENTED
            `define BA22_DU_DCR1            11'd9
            `define BA22_DU_DVR1            11'd1
        `endif
/* Implement DVR/DCR pair #2                */
        `ifdef BA22_DU_PAIR2_IMPLEMENTED
            `define BA22_DU_DVR2            11'd2
            `define BA22_DU_DCR2            11'd10
        `endif
/* Implement DVR/DCR pair #3                */
        `ifdef BA22_DU_PAIR3_IMPLEMENTED
            `define BA22_DU_DVR3            11'd3
            `define BA22_DU_DCR3            11'd11
        `endif
/* Implement DVR/DCR pair #4                */
        `ifdef BA22_DU_PAIR4_IMPLEMENTED
            `define BA22_DU_DVR4            11'd4
            `define BA22_DU_DCR4            11'd12
        `endif
/* Implement DVR/DCR pair #5                */
        `ifdef BA22_DU_PAIR5_IMPLEMENTED
            `define BA22_DU_DVR5            11'd5
            `define BA22_DU_DCR5            11'd13
        `endif
/* Implement DVR/DCR pair #6                */
        `ifdef BA22_DU_PAIR6_IMPLEMENTED
            `define BA22_DU_DVR6            11'd6
            `define BA22_DU_DCR6            11'd14
        `endif
/* Implement DVR/DCR pair #7                */
        `ifdef BA22_DU_PAIR7_IMPLEMENTED
            `define BA22_DU_DVR7            11'd7
            `define BA22_DU_DCR7            11'd15
        `endif
    `endif
`endif

/* Data Cache block size (2 for 4 words, 3 for 8 words)         */
`define BA22_DC_BLCK_W      2
`define BA22_DC_INDX_W      ((`BA22_DC_WAYSIZE) - (`BA22_DC_BLCK_W) - 2)

   
/* Data Cache block size (2 for 4 words, 3 for 8 words)         */
`define BA22_IC_BLCK_W      3
`define BA22_IC_INDX_W      ((`BA22_IC_WAYSIZE) - (`BA22_IC_BLCK_W) - 2)

/*--------------------------------------------------------------*/
/* Multiply and accumulate (MAC)                                */
/*--------------------------------------------------------------*/
/* Mac flags [ov,cy] implemented                                */
`ifdef BA22_MAC_IMPLEMENTED
    `define BA22_MAC_FLAGS_IMPLEMENTED
`endif


`ifdef BA22_PIC_IMPLEMENTED
/* Define if you want this PIC register to be implemented       */
    `define BA22_PIC_PICMR
/* Define to register external interrupts                       */
    `define BA22_PIC_PICSR
`endif

/* Define if you want these TT registers to be implemented */
`ifdef BA22_TT_IMPLEMENTED
    `define BA22_TT_TTMR
    `define BA22_TT_TTCR
    `ifdef BA22_SIM
        `define BA22_TT_TTUR
    `endif
    `define BA22_TT_TTRS
`endif

// Always define PICMR reset value
`define BA22_PIC_PICMR_RSTVAL 'h0

`ifdef BA22_SIM
// define which clock is faster
    `define BA22_PM_PWR_UP_CLK_RATIO_FAST_CPU_CLOCK 1'b0    // bus clock is faster than cpu clock
//    `define BA22_PM_PWR_UP_CLK_RATIO_FAST_CPU_CLOCK 1'b1  // cpu clock is faster than bus clock

// define cpu/bus clock relationsip
    `define BA22_PM_PWR_UP_CLK_RATIO_RELATIONSHIP 7'd0

    `define BA22_PM_PWR_UP_CLK_RATIO {`BA22_PM_PWR_UP_CLK_RATIO_FAST_CPU_CLOCK, `BA22_PM_PWR_UP_CLK_RATIO_RELATIONSHIP}

//    `define BA22_PM_PWR_UP_CLK_RATIO 8'b0000_0000 // 1 cpu_clk = 1 bus_clk      
//    `define BA22_PM_PWR_UP_CLK_RATIO 8'b0000_0010 // 1 cpu_clk = 2 bus_clk
//    `define BA22_PM_PWR_UP_CLK_RATIO 8'b0000_0100 // 1 cpu_clk = 4 bus_clk
//    `define BA22_PM_PWR_UP_CLK_RATIO 8'b1000_0010 // 2 cpu_clk = 1 bus_clk 
//    `define BA22_PM_PWR_UP_CLK_RATIO 8'b1000_0100 // 4 cpu_clk = 1 bus_clk
`endif

// fetcher and branch prediction unit
`define IF_IN_FIFO_AW  2


`define BA22_ITLB_INDXW         `BA22_ITLB_ENTRIES_PER_WAY
`define BA22_DTLB_INDXW         `BA22_DTLB_ENTRIES_PER_WAY

`ifdef BA22_SIM
/* Alter theese values for simulation                           */
    `define BA22_QMEM_AW                     23
    `define BA22_DQMEM_BASE_ADDR_DEC_BITS    31:26
    `define BA22_DQMEM_BASE_ADDR             32'h00000000
    `define BA22_IQMEM_BASE_ADDR_DEC_BITS    `BA22_DQMEM_BASE_ADDR_DEC_BITS
    `define BA22_IQMEM_BASE_ADDR             `BA22_DQMEM_BASE_ADDR
`endif

/* WISHBONE bus no response timer timeout value                 */
`define BA22_LSU_TIMEOUT            16'hFF_FF
/* WISHBONE bus retry response counter exception trigger value  */
`define BA22_LSU_RTY                16'hFF_FF


`ifdef BA22_TARGET_FPGA_XILINX_V4
    `define BA22_TARGET_FPGA_XILINX
`endif
`ifdef BA22_TARGET_FPGA_XILINX_V5
    `define BA22_TARGET_FPGA_XILINX
`endif

// Macro tools
`define BA22_UCO_VLD(A) (A[`BA22_PIPE_FLAGS_ADV] & ~A[`BA22_PIPE_FLAGS_EXC])
`define BA22_UCO_EXC(A) (A[`BA22_PIPE_FLAGS_ADV] &  A[`BA22_PIPE_FLAGS_EXC])

`define BA22_TRP_LPC_D      (0 * 32 + 32 - 1) : (0 * 32)
`define BA22_TRP_EXV_D      (1 * 32 + 32 - 1) : (1 * 32)
`define BA22_TRP_NPC_D      (2 * 32 + 32 - 1) : (2 * 32)
`define BA22_TRP_CPC_D      (3 * 32 + 32 - 1) : (3 * 32)
`define BA22_TRP_LPC_V      (4 * 32 + 0)
`define BA22_TRP_EXV_V      (4 * 32 + 1)
`define BA22_TRP_NPC_V      (4 * 32 + 2)
`define BA22_TRP_CPC_V      (4 * 32 + 3)

`define BA22_TRP            (`BA22_TRP_CPC_V) : 0

`define BA22_TRP_OUT_DAT    (    32 - 1) : 0
`define BA22_TRP_OUT_OVR    (1 + 32 - 1) : 32
`define BA22_TRP_OUT_ABS    (2 + 32 - 1)

`define BA22_TRP_OUT        (`BA22_TRP_OUT_ABS ) : 0

/* macro functions */

`define BA22_MIN(A,B) ((A) < (B) ? (A) : (B))
