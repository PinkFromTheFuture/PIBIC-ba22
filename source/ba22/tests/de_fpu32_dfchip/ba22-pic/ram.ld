
/* single ram memory for IQMEM and DQMEM */
MEMORY
        {
        vectors : ORIGIN = 0x00000000, LENGTH = 0x00002000 
        ram     : ORIGIN = 0x00002000, LENGTH = 0x00004000 - 0x00002000
        }
 
ENTRY(_reset_vector);
_reset_vector = 0x100;
SECTIONS
{
        .vectors :
        {
        *(.vectors)
        } > vectors

        .text :
        {
        *(.text)
        } > ram

        .data :
        {
        *(.data)
        } > ram

	. = ALIGN(4);  __gp = . + 0x8000;
        /* why? */

	.sdata :
        {
        *(.sdata)
        } > ram

	.sbss :
        {
        _sbss_start = .;
	*(.scommon)
        *(.sbss)
        _sbss_end = .;
        } > ram

        .rodata :
        {
        *(.rodata)
	*(.rodata.*)
	. = ALIGN(0x4);
        } > ram

       /DISCARD/ :
        {
        *(.eh_frame)
        }

        .bss :
        {
        _bss_start = .;
        *(.bss)
        _bss_end = .;
        } > ram


	PROVIDE(_stack_top    = 0x04000);
}
