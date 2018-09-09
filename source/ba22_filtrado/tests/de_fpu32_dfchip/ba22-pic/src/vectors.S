/*
 * This module contains basic exception handlers for all BA22
 * exceptions.
 * (By default) these are located at 0x100, 0x200, ..., 0xe00.
 * Each handler has 256 bytes available. If your handler is longer,
 * you need to use subroutines. You can use HANDLE_EXCEPTION macro
 * to call C subroutine that does the useful part of exception handling.
 *
 * Linker script used with this example reserves 0x1000 bytes for
 * vectors section, so there is some free space after trap handler
 * (0xe00+) and before reset handler (0x0..0xff).
 */

#include "excutil.h"
#include "spr_defs.h"

.globl  isr_routine

        .section .vectors, "ax"

/* ---[ 0x100: Reset exception ]----------------------------------------- */
        .org 0x100

        /* As this code goes directly into vectors section,
         * it needs to be smaller than 0x100 bytes.
         * You can of course have larger initialization in text
         * section and just jump there. */
_reset:
        /* set up stack pointer
         * and make sure it's 8-byte aligned */
        b.ori r1,r0,_stack_top-4
        b.andi r1,r1,~7

#ifndef BA22_DE
        /* Enable caches (if present).
         * This can be removed if your CPU does not have
         * caches implemented. */
        b.jal _enable_dcache
        b.jal _enable_icache
#endif

        /* clear BSS section */
        b.ori	r3,r0,_bss_start
        b.ori	r4,r0,_bss_end
        b.jal	_clear_memory

        /* clear SBSS section */
        b.ori	r3,r0,_sbss_start
        b.ori	r4,r0,_sbss_end
        b.jal	_clear_memory

        /* set up global pointer */
        b.ori	r2,r0,__gp

        /* execute main */
        b.jal	main

_main_done:
        /* Main returns here.
         * In embedded programs this really should not happen,
         * but if it does... */

        /* nop (special one, that terminates simulations ) */
        b.nop   1
        /* If not run on simulator, just loop that nop,
         * rather than go and execute some random code */
        b.j _main_done

/**
 * This function clears (sets to 0) memory from address stored
 * in r3 to (excluding) address stored in r4.
 */
_clear_memory:
        b.bgeu r3,r4,4f
1:      //first write word by word
        b.addi r3,r3,4
        b.bgtu r3,r4,2f
        b.sw   -4(r3),r0
        b.j 1b
2:      //then the remainder by bytes
        b.addi r3,r3,-4
3:      b.bgeu r3,r4,4f
        b.sb 0(r3),r0
        b.addi r3,r3,1
        b.j 3b
4:      b.return

/* ---[ 0x200: BUS exception ]------------------------------------------- */
        .org 0x200
        UNHANDLED_EXCEPTION

/* ---[ 0x300: Data Page Fault exception ]------------------------------- */
        .org 0x300
        UNHANDLED_EXCEPTION

/* ---[ 0x400: Insn Page Fault exception ]------------------------------- */
        .org 0x400
        UNHANDLED_EXCEPTION

/* ---[ 0x500: Timer exception ]----------------------------------------- */
        .org 0x500
        UNHANDLED_EXCEPTION

/* ---[ 0x600: Aligment exception ]-------------------------------------- */
        .org 0x600
        UNHANDLED_EXCEPTION

/* ---[ 0x700: Illegal insn exception ]---------------------------------- */
        .org 0x700
        UNHANDLED_EXCEPTION

/* ---[ 0x800: External interrupt exception ]---------------------------- */
        .org 0x800
        HANDLE_EXCEPTION(isr_routine)

/* ---[ 0x900: DTLB miss exception ]------------------------------------- */
        .org 0x900
        UNHANDLED_EXCEPTION

/* ---[ 0xa00: ITLB miss exception ]------------------------------------- */
        .org 0xa00
        UNHANDLED_EXCEPTION

/* ---[ 0xb00: Range exception ]----------------------------------------- */
        .org 0xb00
        UNHANDLED_EXCEPTION

/* ---[ 0xc00: Syscall exception ]--------------------------------------- */
        .org 0xc00
        UNHANDLED_EXCEPTION

/* ---[ 0xd00: Floating point exception ]-------------------------------- */
        .org 0xd00
        UNHANDLED_EXCEPTION

/* ---[ 0xe00: Trap exception ]------------------------------------------ */
        .org 0xe00
        UNHANDLED_EXCEPTION

#ifndef BA22_DE

/**
 * This function enables data caches (if present in implementation)
 * Whole procedure is:
 *   -make sure they are disabled first
 *   -invalidate any data present in cache
 *      For this "range invalidation" (newer, faster) can be used,
 *      or block invalidation (supported in oldest BA22 implementations).
 *   -reenable cache
 * If your CPU does not have data cache implemented, you can remove this.
 */
_enable_dcache:
        b.mfspr r3,r0,SPR_DCCFGR
        b.beq r3,r0,a_enable_dcache     //cache not implemented=>nothing to do
        //disable data cache
        b.mfspr r4,r0,SPR_SR
        b.andi r4,r4,~SPR_SR_DCE
        b.mtspr r0,r4,SPR_SR
        //use best method supported to invalidate it
        b.andi r3,r3,SPR_DCCFGR_RIRI    //check for range invalidation
        b.beq r3,r0,o_enable_dcache     //present in all but very old implementations
        //use range invalidation (invalidate all addresses)
        b.mtspr r0,r0,SPR_RIR_MIN
        b.ori r3,r0,0xfffffff0+SPR_RIR_MAX_DC
        b.mtspr r0,r3,SPR_RIR_MAX       //this does it
        b.j x_enable_dcache
o_enable_dcache:
        //use block invalidate (if you know your implementations
        //have range invalidate you can remove this part down to x_enable)
        b.mfspr r5,r0,SPR_DCCFGR
        b.andi r6,r5,SPR_DCCFGR_CBS
        b.srli r6,r6,8
        b.addi r6,r6,2
        b.ori r7,r0,1
        b.sll r7,r7,r6 // r7 = cache line size
        b.andi r5,r5,SPR_DCCFGR_NCS
        b.srli r5,r5,4
        b.add r6,r5,r6
        b.ori r5,r0,1
        b.sll r5,r5,r6 // r5 = cache size
        b.ori r6,r0,0
1:      b.mtspr r0,r6,SPR_DCBIR
        b.add r6,r6,r7
        b.bleu r6,r5,1b
x_enable_dcache:
        //enable data cache
        b.ori r4,r4,SPR_SR_DCE
        b.mtspr r0,r4,SPR_SR
a_enable_dcache:
        b.return

/**
 * Enables instruction cache.
 * Practically the same as enable_dcache, but registers are different.
 * If your CPU does not have instruction cache implemented, you can remove this.
 */
_enable_icache:
        b.mfspr r3,r0,SPR_ICCFGR
        b.beq r3,r0,a_enable_icache     //cache not implemented=>nothing to do
        //disable data cache
        b.mfspr r4,r0,SPR_SR
        b.andi r4,r4,~SPR_SR_ICE
        b.mtspr r0,r4,SPR_SR
        //use best method supported to invalidate it
        b.andi r3,r3,SPR_ICCFGR_RIRI    //check for range invalidation
        b.beq r3,r0,o_enable_icache     //present in all but very old implementations
        //use range invalidation (invalidate all addresses)
        b.mtspr r0,r0,SPR_RIR_MIN
        b.ori r3,r0,0xfffffff0+SPR_RIR_MAX_IC
        b.mtspr r0,r3,SPR_RIR_MAX       //do it
        b.j x_enable_icache
o_enable_icache:
        //use block invalidate (if you know your implementations
        //have range invalidate you can remove this part down to x_enable)
        b.mfspr r5,r0,SPR_ICCFGR
        b.andi r6,r5,SPR_ICCFGR_CBS
        b.srli r6,r6,8
        b.addi r6,r6,2
        b.ori r7,r0,1
        b.sll r7,r7,r6 // r7 = cache line size
        b.andi r5,r5,SPR_ICCFGR_NCS
        b.srli r5,r5,4
        b.add r6,r5,r6
        b.ori r5,r0,1
        b.sll r5,r5,r6 // r5 = cache size
        b.ori r6,r0,0
1:      b.mtspr r0,r6,SPR_ICBIR
        b.add r6,r6,r7
        b.bleu r6,r5,1b
x_enable_icache:
        //enable instruction  cache
        b.ori r4,r4,SPR_SR_ICE
        b.mtspr r0,r4,SPR_SR
a_enable_icache:
        b.return

#endif
