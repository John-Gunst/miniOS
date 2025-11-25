/* linker.ld - minimal riscv64 script */
OUTPUT_FORMAT("elf64-littleriscv")
ENTRY(_start)

SECTIONS
{
  . = 0x80200000; /* common load/link address for riscv kernels on virt */
  .text : {
    *(.text.boot)
    *(.text .text.*)
    _start = .;
    PROVIDE(__text_start = .);
  }
  .rodata : { *(.rodata .rodata.*) }
  .data : { *(.data .data.*) }
  .bss : {
    __bss_start = .;
    *(.bss .bss.*)
    *(COMMON)
    __bss_end = .;
  }
  _stack_top = . + 0x4000; /* 16KB stack per hart (adjust as needed) */
}


