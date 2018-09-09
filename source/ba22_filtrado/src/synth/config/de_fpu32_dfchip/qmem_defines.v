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
//  File          : qmem_defines.v
//
//  Description   : defines used in QMEM of ba22_top_qmem 
//
//  Designer      : NS
//
//  QA Engineer   : JS
//
//  Creation Date : Dec 9, 2011
//
//  Last Update   : April 30, 2012
//
//  Version       : 1.02
//
//  File History  : March 28, 2012 (1.01) : Initial release
//                  April 30, 2012 (1.02) : Add EXT_IQMEM_WRITE
//
//----------------------------------------------------------------------
//
// MEMORIES CONFIGURATON //
//--------------------------

//Write access port to the instruction memory if it is defined
`define EXT_IQMEM_WRITE

//-------------------------------------------------
// One one of the following should be defined to define the QMEM 
//-------------------------------------------------
`undef BA22_QMEM_SEPARATED    // 2 seperate SRAMS (one for I and one for D)
`undef BA22_QMEM_UNIFIED_SP   // QMEM Arbiter and 1 SRAM
`define BA22_QMEM_UNIFIED_DP     // 1 DPRAM

// The sizes of the QMEM
// QMEM address width definition - size = (1 << *QMEM_AW)
// *QMEM_AW is the address width for word (64) access
// ------------------------------------------------------------------------
//    Mem Bits |   Bytes           |   32 bit Word (D) | 32 bit double word (I) 
// ------------------------------------------------------------------------
//  1k memory  | 128 ( 7 bit addr) |  32 ( 5 bit addr) |  16 ( 4 bit addr)
//  2k memory  | 256 ( 8 bit addr) |  64 ( 6 bit addr) |  32 ( 5 bit addr)
//  4k memory  | 512 ( 9 bit addr) | 128 ( 7 bit addr) |  64 ( 6 bit addr)
//  8k memory  |  1k (10 bit addr) | 256 ( 8 bit addr) | 128 ( 7 bit addr)
// 16k memory  |  2k (11 bit addr) | 512 ( 9 bit addr) | 256 ( 8 bit addr)
// 32k memory  |  4k (12 bit addr) |  1k (10 bit addr) | 512 ( 9 bit addr)
// 64k memory  |  8k (13 bit addr) |  2k (11 bit addr) |  1k (10 bit addr)
// 128k memory | 16k (14 bit addr) |  4k (12 bit addr) |  2k (11 bit addr)
// 256k memory | 32k (15 bit addr) |  8k (13 bit addr) |  4k (12 bit addr)
// 512k memory | 64k (16 bit addr) | 16k (14 bit addr) |  8k (13 bit addr)

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

