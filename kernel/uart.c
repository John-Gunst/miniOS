/* kernel/uart.c - minimal ns16550 write (polling) for QEMU virt */
#include "console.h"
#include <stdint.h>

#define UART0_BASE 0x10000000UL
/* 16550 registers offsets */
#define UART_THR 0x00
#define UART_LSR 0x05
#define UART_LSR_THRE 0x20

static inline void mmio_write(uintptr_t addr, uint8_t val) {
    *(volatile uint8_t *)addr = val;
}
static inline uint8_t mmio_read(uintptr_t addr) {
    return *(volatile uint8_t *)addr;
}

void console_putc(char c) {
    /* wait for THR empty */
    while ((mmio_read(UART0_BASE + UART_LSR) & UART_LSR_THRE) == 0) ;
    mmio_write(UART0_BASE + UART_THR, (uint8_t)c);
}

void console_puts(const char *s) {
    while (*s) {
        if (*s == '\n') console_putc('\r');
        console_putc(*s++);
    }
