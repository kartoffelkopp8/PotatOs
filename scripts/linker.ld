ENTRY(_start)

SECTIONS
{
  . = 1M; /*  start from 1 Mb after mem start */

  .boot :
  {
    KEEP(*(.MULTIBOOT2))
  }
  .text :
  {
    *(.text)
  }
  .bss :
  {
    *(.bss)
  }
  .rodata :
  {
    *(.rodata)
  }

}
