//----------------------------------------------------------------------
//
// Copyright (c) 2011 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//--------------------------------------------------------------------
//
//  Project       : BA22
//
//  File          : peripheral_defines.v
//
//  Description   : defines used in Peripherals
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
//                  April 30, 2012 (1.02) : Remove PERIPHERALS_AHB_BUS
//
//----------------------------------------------------------------------
//
//--------------------------
// SoC AHB CONFIGURATION  //
//--------------------------
//Add SoC AHB-to-APB bridge and SoC Peripherals
//`define INSTANTIATE_TIMER1
//`define INSTANTIATE_UART
//`define INSTANTIATE_GPIO

//*****************************
// Unused part in socSystem
//*****************************
//`define INSTANTIATE_AHB_EBI_FLASH
//`define INSTANTIATE_AHB_EBI_SRAM
//`define INSTANTIATE_LCD_CONTROLLER
//`define TOP_AHB_MASTER2
//`define AHB_MASTER2
//`define TOP_AHB_MASTER3
//`define AHB_MASTER3
//`define DUAL_UART
//`define INSTANTIATE_DES_CONTROLLER
//`define INSTANTIATE_DMA_CONTROLLER
//`define INSTANTIATE_I2C_MASTER
//`define INSTANTIATE_I2C_SLAVE
//`define INSTANTIATE_SPI_MASTER
//`define INSTANTIATE_SPI_SLAVE
//`define INSTANTIATE_INTR_CONTROLLER

//`define INSTANTIATE_TIMER2
//`define INSTANTIATE_TIMER3
//`define DUAL_UART
//`define INSTANTIATE_WATCHDOG_TIMER
//`define WATCHDOG_SECURITY
//`define INSTANTIATE_PARALLEL_PORT
//`define INSTANTIATE_PULSEWIDTH_MODULATOR
//`define DUAL_PULSEWIDTH_MODULATOR
//`define INSTANTIATE_REMAP
//`define INSTANTIATE_AHB_MEM

//**************************************************************************
// use the output of socClkDiv to divide down the UART input clock for
// the baud rate generator clock (baudX16).  Comment out this definition
// if you want the baud rate generator clock to be equal to the input clock.
//**************************************************************************
//`define USE_UART_BAUD_CLK_DIV

`ifdef USE_UART_BAUD_CLK_DIV
    `define UART_BAUD_CLK_DIV   (8.5)   // this must agree with divisor in socClkDiv module
`else
    `define UART_BAUD_CLK_DIV   1       // because baudClkEn is tied high in this case
`endif

//*****************
//used for SoCSSRAM
//*****************
// NOTE : These definitions must be mutually exclusive, and at least one of these
//        definitions MUST be enabled.
//`define INTMEM_ALTERA      // implement internal memory in RAM for Altera devices
//`define INTMEM_XILINX      // implement internal memory in RAM for Xilinx devices
//`define INTMEM_ACTEL       // implement internal memory in RAM for Actel devices
`define INTMEM_SYNPLIFY      // implement internal memory in RAM automatically inferred by Synplify


//*****************
//used for GPIO
//*****************
`define USE_GPIO_INTERRUPTS  //can turn this off to save gates if no GPIO inputs
                             // need to cause interrupts

//*****************
//used for SPI
//*****************
`define USE_SPI_FIFOS

//*****************
//used for UARTs
//*****************
// NOTE : These definitions must be mutually exclusive, and at least one of these
//        definitions MUST be enabled.
// enabling this definition causes UART FIFOs to go into RAM in ALTERA APEX devices
//`define FIFO_ALTERA 

// enabling this definition causes UART FIFOs to go into RAM in XILINX VIRTEX devices
//`define FIFO_XILINX

// enabling this definition causes UART FIFOs to go into RAM in ACTEL PROASIC3 devices
//`define FIFO_ACTEL

// enabling this definition causes UART FIFOs to be implemented with flip-flops
`define FIFO_FFLOP

// implement FIFO memory in RAM automatically inferred by Synplify
//`define FIFO_SYNPLIFY

//*******************************
// Set the Parameter for MEMORY
//*******************************
// memory definitions
`define N_ADDR_BITS_2K              11
`define N_ADDR_BITS_4K              12
`define N_ADDR_BITS_8K              13
`define N_ADDR_BITS_16K             14
`define N_ADDR_BITS_32K             15
`define N_ADDR_BITS_64K             16
`define N_ADDR_BITS_128K            17
`define N_ADDR_BITS_256K            18
`define N_ADDR_BITS_512K            19
`define N_ADDR_BITS_1M              20
`define N_ADDR_BITS_2M              21
`define N_ADDR_BITS_4M              22
`define N_ADDR_BITS_8M              23
`define N_ADDR_BITS_16M             24
`define N_ADDR_BITS_32M             25
`define N_ADDR_BITS_64M             26
`define N_ADDR_BITS_128M            27
`define N_ADDR_BITS_256M            28

// internal memory definitions
`define INT_MEM_SIZE        (1 << `N_ADDR_BITS_8K) // internal memory size, 2Kx32 or 8 KB
`define INT_MEM_BANK_SIZE   `INT_MEM_SIZE/4
`define LOG2_INT_MEM_SIZE   `N_ADDR_BITS_8K

// external memory definitions
`define EXT_SRAM_SIZE       (1 << `N_ADDR_BITS_4M)
`define N_EXT_SRAM_ADDR     `N_ADDR_BITS_4M   // number of external address bits

`define EXT_FLASH_SIZE      (1 << `N_ADDR_BITS_1M)
`define N_EXT_FLASH_ADDR    `N_ADDR_BITS_1M    // number of external address bits

//*****************
// Set the WIDTH
//*****************
`define IRQ_WIDTH   16
`define GPIO_WIDTH  8

//*********************************
//interrupt source bit assignments
//*********************************

`define IRQDMA_BITPOS           14  // DMA Controller
`define IRQSPIM_BITPOS          13  // SPI Master
`define IRQSPIS_BITPOS          12  // SPI Slave
`define IRQDES_BITPOS           11  // DES Controller
`define IRQLCD_BITPOS           10  // LCD Controller
`define IRQI2C_BITPOS            9  // I2C
`define IRQGPIO0_BITPOS          8  // General purpose IO
`define IRQWDTimer_BITPOS        7  // Watchdog Timer
`define IRQParallel_BITPOS       6  // Parallel Port
`define IRQSerialB_BITPOS        5  // Serial port B
`define IRQSerialA_BITPOS        4  // Serial port A
`define IRQTimer3_BITPOS         3  // Timer 3
`define IRQTimer2_BITPOS         2  // Timer 2
`define IRQTimer1_BITPOS         1  // Timer 1
`define IRQUser_BITPOS           0  // use for testing prog. int.

`ifdef INSTANTIATE_DES_CONTROLLER
    `define AHB_MASTER2
`else
`ifdef INSTANTIATE_DMA_CONTROLLER
    `define AHB_MASTER2
`endif
`endif
`ifdef TOP_AHB_MASTER2
    `define AHB_MASTER2
`endif

`ifdef INSTANTIATE_LCD_CONTROLLER
    `define AHB_MASTER3
`endif
`ifdef TOP_AHB_MASTER3
    `define AHB_MASTER3
`endif

`ifdef TOP_AHB_MASTER2
    `define TOP_AHB_MASTER
`endif
`ifdef TOP_AHB_MASTER3
    `define TOP_AHB_MASTER
`endif

