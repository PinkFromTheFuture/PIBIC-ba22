-----------------------------------------------------------------------------
-- Copyright (c) 2011-2012 CAST, Inc.
-----------------------------------------------------------------------------
-- Please review the terms of the license agreement before using this file.
-- If you are not an authorized user, please destroy this source code file
-- and notify CAST, Inc. immediately that you inadvertently received an
-- unauthorized copy.
-----------------------------------------------------------------------------

BA22 with configuration 'de_fpu32_dfchip' Altera CycloneIV and Xilinx Virtex5 Netlist


Version
-------
   October 2, 2012         5.0p01_1.01


Description  
-------------
   Modern load/store RISC 32-bit processor core


Configurations delivered
-------------------------

   de_fpu32_dfchip
   ------------------
      de_fpu32_dfchip is defined as the "de" configuration with the additional functions:
       - AHB bus
       - 32 GPRs
       - Power Management unit
       - the tick timer (tt)
       - the programmable interrupt controller (pic)
       - multiplication unit
       - divider unit

   In documentation and scripts that refer to 'CONFIG' or configuration, this is 
   defined as de_fpu32_dfchip

   This means that the supplied simulation and synthesis scripts should be modified 
   such that  CONFIG="de_fpu32_dfchip" for proper simulation and synthesis of 
   user's configuration.


Supplied Files 
--------------

   readme.txt                        This file

   doc/
      ba22-des-4.0p06-104.pdf        BA22 Hardware Specification 
      ba22-inm-4.0p06-103.pdf        BA22 Integration Manual
      ba22-bsug-4.0p1-103.pdf        Beyond Studio Integrated Development Environment User's Guide
      ba22-isa-4.0.pdf               BA22 Instruction Set Manual
      ba22-pgm-4.0.pdf               BA22 Programmer's Manual
      ba22-eps-4.0p01-101.pdf        BA22 External Peripherals Specification
      ba22-sdk-cug-4.0p1-101.pdf     BA22 Command Line SDK User's Guide
      AN001-BeyondBA22PowerManagementUnit_v1.pdf

   netlist/                        
      altera_cycloneiv/
                ba22_top.vqm         BA22_TOP netlist file for Altera CycloneIV device
                ba22_top.sdc         constraint file
                ba22_top.vo          Verilog post-routed simulation file
                ba22_top.sdo         SDF post-routed simulation file
      xilinx_virtex5/
                ba22_top.ngc         BA22_TOP netlist file for Xilinx Virtex5 device 
                ba22_top_nopads.ng   BA22_TOP without I/O pads netlist file for 
                                     Xilinx Virtex5 devicec
                ba22_top.sdc         constraint file
                ba22_top_timesim.v   Verilog post-routed simulation file
                ba22_top_timesim.sdf SDF post-routed simulation file

   scripts/ 
      modelsim_altera.tcl            ModeSim compilation and simulation script
                                     for Altera post-routed simulation file
      modelsim_xilinx.tcl            ModeSim compilation and simulation script
                                     for Xilinx post-routed simulation file

   src/
      synth/
         config/
            de_fpu32_dfchip/
               ba22_defines.v        BA22 defines for de configuration with AHB bus, 32 GPRS,
                                     multiplier, divider, and floating point units 
               qmem_defines.v        QMEM defines for ba22_top_qmem module
               peripheral_defines.v  SoC AMBA AHB/APB peripheral defines for socSystem and
                                     ba22_top_qmem_soc module
               ba22_filelist.tx      Compilation order of ba22 files with de_fpu32_soc config
               models_filelist.txt   Compilation order of QMEM embedded memory models
               fpu32_filelist.txt    Compilation order of FPU32 files
         common/
            ba22/
               ahb_master_defines.v  include file 
               ba22_constants.v      include file for ba22 files
               ba22_revision.v       include file 
               timescale.v           include file for ba22 files
            models/
               dpram8.v
               sram8.v
               sram32.v
               sram64.v
               qmem_arbiter.v
               tdpram8.v
               tdpram32.v
               tdpram64_32.v
            wrappers/
               ba22_top_qmem.v
      sim/
         bench_defines.v             include file for bench files
         bench_constants.v           include file for bench files
         bench.v                     Top level of bench module ba22_top and qmem
         flash_model.v               Flash memory model
         c_clgen.v                   Clock and Reset generator module
         initram32.v                 Read data from a file and write to a memory
         monitor.v                   Print out the activities of memory, 
                                     ahb/wishbone bus to log files
         ahb_slave_behavioral.v      AHB Slave interface behavior
         wb_slave_behavioral.v       WishBone Slave interface module
         sram32.v                    sram32 memory model with output delay
                                     (used for post-routed simulation)
         tdpram64_32.v               true dual port memory model with output delay
                                     (used for post-routed simulation)
   tests/
      de_fpu32_dfchip/
         ba22-pic/*                  BA22 with programmable interrupt controller test
                                       . Big-Endian
                                       . 32 GPRs

   
Simulation and Synthesis Notes
------------------------------
  Please refer to ba22-inm-4.0p06-103.pdf section 5 and section 6.


Support
-------
   Although every effort has been made to ensure that this core functions
   correctly, if a problem is encountered please contact CAST:
 
      Technical Support Hotline: +1-201-391-8300
      Fax: +1-201-624-7795
      E-mail: support@cast-inc.com 
