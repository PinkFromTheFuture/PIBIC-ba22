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
//  File          : bench_constants.v
//
//  Description   : constants used in bench
//
//  Designer      : NS
//
//  QA Engineer   : JS
//
//  Creation Date : Sept 6, 2011
//
//  Last Update   : March 28, 2012
//
//  Version       : 1.01
//
//  File History  : March 28, 2012 (1.01) : Initial release
//
//----------------------------------------------------------------------

// BA22_AHB is defined in ba22_defines
`ifdef BA22_AHB
    `define BA22_DAHB_IMPLEMENTED
`else
    `define BA22_DWB_IMPLEMENTED
`endif

`ifdef BA22_CMMU
   `define BA22_IBUS_IMPLEMENTED
   `ifdef BA22_AHB
       `define BA22_IAHB_IMPLEMENTED
    `else
       `define BA22_IWB_IMPLEMENTED
    `endif
`endif

