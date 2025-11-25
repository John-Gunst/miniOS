CROSS = riscv64-unknown-elf-
CC = $(CROSS)gcc
LD = $(CROSS)ld
OBJCOPY = $(CROSS)objcopy

CFLAGS = -march=rv64gc -mabi=lp64 -nostdlib -nostartfiles -ffreestanding -O2 -Wall

OBJS = boot/crt.o kernel/kernel.o kernel/uart.o

all: kernel.elf kernel.bin

kernel.elf: $(OBJS) linker.ld
	$(LD) -T linker.ld -o $@ $(OBJS)

kernel.bin:
	$(OBJCOPY) -O binary kernel.elf kernel.bin
