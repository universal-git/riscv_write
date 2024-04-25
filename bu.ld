/* Author: Subrata M. Brhaspatih */
OUTPUT_ARCH("riscv")
ENTRY(_start)
MEMORY
{ 
  RAM (rwx) : ORIGIN = 0x200000, LENGTH = 0x30000
}

SECTIONS
{
/*  .text : { 
  } > REGION_TEXT */
  
  . = ORIGIN(RAM);
  .text :
  {
    KEEP(*(.text._start))
    KEEP(*(.init));
    KEEP(*(.init.rust));
    . = ALIGN(4);
    KEEP(*(.init.trap));
    . = ALIGN(4);
    *(.trap);
    *(.trap.rust);
    *(.text.abort);
    *(.text .text.*);
    . = ALIGN(4);
  }

  .rodata : ALIGN(4)
  {
    __rodata_start = .;
    *(.srodata .srodata.*);
    *(.rodata .rodata.*);
    .= ALIGN(4);
    __rodata_end = .;
  }

  .data : ALIGN(32)
  {
    __data_start = .;
    PROVIDE(__global_pointer$ = . + 0x800);
    *(.sdata .sdata.* .sdata2 .sdata2.*)
    *(.data .data.*)
    . = ALIGN(32);
    __data_end = .;
  }

  .bss : ALIGN(32)
  {
    _bss_start = .;
    *(.sbss .sbss.* .bss .bss.*);
    *(.scommon)
    . = ALIGN(32);
    _bss_end = .;
  }

  
/*  .sdata : {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16)
    *(.srodata.cst8)
    *(.srodata.cst4)
    *(.srodata.cst2)
    *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } > REGION_DATA AT > REGION_RODATA */

/*  .sbss : {
    __sbss_start = .;
    *(.sbss)
    *(.sbss.*)
    *(.gnu.linkonce.sb.*)
    __sbss_end = .;
  } > REGION_BSS */

/*  .tdata : {
    _tls_data = .;
    *(.tdata.begin)
    *(.tdata)
    *(.tdata.end)
    _tls_end = .;
  } > REGION_DATA

  .tbss : {
    *(.tbss)
    *(.tbss.end)
  } > REGION_BSS */

  . = ALIGN(4);
  _end = .;

/*  . = ORIGIN(RAM) + LENGTH(RAM) - 0x400;
  _free_space = . - _end;
  _STACK_SIZE = (_free_space * 50) / 100 ;
  _HAAP_SIZE = _free_space - _STACK_SIZE;

  .stack : {
    _stack_end = .;
    __stack_pointer$ = .;
    _stack = . - _STACK_SIZE;
  } > REGION_STACK

  . = _stack;

  .haap : {
    _haap = . - _HAAP_SIZE;
    _haap_e = .;
  } > REGION_HEAP */

  PROVIDE(_stack_start = ORIGIN(RAM) + LENGTH(RAM));

}


