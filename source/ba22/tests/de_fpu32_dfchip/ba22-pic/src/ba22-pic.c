/* -------------------------------------------------------------------------- */
/* We have provided the software delivered to you for evaluation purposes     */
/* only. It is authorized for use by participants of the specified evaluation */
/* for up to 60 days, unless further use is officially granted by CAST upon   */
/* request.  If you are not an authorized user, please destroy this source    */
/* code file and notify CAST immediately that you inadvertently received an   */
/* unauthorized copy.                                                         */
/* -------------------------------------------------------------------------- */

#include "board.h"
#include "bautil.h"
#include "spr_defs.h"

const char *hello = "Hello, World!\n";

//
// this interrupt service routine is linked to the interrupt vector 
// in vectors.S
void isr_routine(void) {

    /* an interrupt occured! check which interrupt happened */

    int result;

    // read PIC status reg and print which interupts are active/pending
    result = get_spr(SPR_PICSR);
    REG32( CAST_INTRSR ) = result;

    // clear the external interrupt 
    REG32( CAST_INTRCLR ) = result;

    // clear the pending register interrupt 
    set_spr(SPR_PICSR,0);

    REG32( CAST_INTRSR ) = get_spr(SPR_PICSR);
 
}

int main(void) 
{
    int result;

    result = get_spr(SPR_SR); // check supervisor register
    REG32( CAST_SR ) = result;
    set_spr(SPR_SR, (result|SPR_SR_IEE)); // enable Interrupt exception

    // MASK
    result = get_spr(SPR_PICMR); // check mask
    REG32( CAST_INTRMASK ) = result;

    set_spr(SPR_PICMR, 0xFFFFFFFF); // enable all interrupts

    result = get_spr(SPR_PICMR); // check mask again
    REG32( CAST_INTRMASK ) = result;

    // now start normal program
    // writing to the clear register will 0 will initiate some 
    // example external interrupts from the simple_bench
    REG32( CAST_INTRCLR ) = 0x0;
    const char *s = hello;
    while (*s) {
        REG32( CAST_CHAR ) = *s;
        s++;
    }

    int i = 0;
    for (i=0; i <= 0x99; i++) {
        REG32( CAST_NUM ) = i;
    }    
    while (i--) {
        REG32( CAST_NUM ) = i;
    }

    s = hello;
    while (*s) {
           REG32( CAST_CHAR ) = *s;
           s++;
    }

    REG32( CAST_ENDSIM ) = 1;
    while (1);

    return 0;
}
