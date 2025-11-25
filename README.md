The following is the initial Chat gpt prompt giving the project structure and description

# miniOS — BIOS multiboot 32-bit educational OS


This canvas contains a complete minimal working OS designed to boot in QEMU using GRUB. It implements the following features from your teacher's list:


- loading separate programs (user ELF images in an initramfs)
- running multiple programs (preemptive multitasking with round-robin scheduler)
- synchronization primitives (simple spinlock / mutex)
- protection (GDT, basic paging enabled for identity-mapped kernel space)
- file system (initramfs using cpio archive; simple in-memory file lookup)
- mechanism to create/load new programs (exec() that loads an ELF from initramfs)
- example user programs (hello, count)


---


## Project structure


```
miniOS/
├── README.md
├── Makefile
├── grub.cfg
├── linker.ld
├── boot/
│ └── boot.s
├── kernel/
│ ├── kernel.c
│ ├── isr.c
│ ├── irq.c
│ ├── timer.c
│ ├── gdt.c
│ ├── paging.c
│ ├── kheap.c
│ ├── process.c
│ ├── fs.c
│ └── syscall.c
├── user/
│ ├── hello.c
│ └── count.c
├── initramfs.cpio (generated)
└── tools/
└── build_initramfs.sh
```


All code is 32-bit C with some assembly helpers. The Makefile builds 32-bit objects and produces a grub-bootable ISO using grub-mkrescue. The README includes exact commands to reproduce on a typical lab machine (Debian/Ubuntu/Fedora), including package dependencies.


---


## Important notes
- This is a minimal educational OS meant to be concise and clear. It is intentionally small (a few thousand LOC combined).
- Use `sudo apt install build-essential gcc-multilib xorriso grub-pc-bin grub-common` (or Fedora equivalents) to get required tools.
- The build produces `iso/miniOS.iso`. Booting under QEMU shows the kernel message. Example user programs live in `/init/hello` and `/init/count` inside initramfs.


---


## README.md (full — open to view in canvas)


---


## Makefile (full — open to view in canvas)


---


## grub.cfg (full)


```
set timeout=0
set default=0


menuentry "miniOS" {
multiboot /boot/kernel.bin
module /initramfs.cpio
boot
}
```
## linker.ld (full)
cli
call kernel_main
hang:
hlt
jmp hang
```


---


## kernel/kernel.c (overview)


The kernel implements:
- console (VGA text mode) driver
- GDT setup
- IDT + IRQ + PIT timer
- simple paging (identity mapping first 16MB)
- scheduler with round-robin preemption (timer interrupt)
- process abstraction: load ELF from initramfs, create page directory for user process, switch to user-mode
- exec path: `exec(const char *path)` loads an ELF and schedules it
- simple syscalls via `int 0x80` (exit, write, yield, spawn)


> Full source file is placed in the canvas.


---


## user/hello.c and user/count.c


Simple user-mode C programs that are linked as 32-bit i386 ELF and included in initramfs.


---


## tools/build_initramfs.sh


Script to pack user binaries into a cpio archive (initramfs) used by GRUB as module.


---


## How to build and run (high-level)


1. Install packages (Debian/Ubuntu):


```
sudo apt update
sudo apt install build-essential gcc-multilib xorriso grub-pc-bin grub-common qemu-system-x86
```


2. `make` — the Makefile builds kernel.bin, builds user programs (i386), creates initramfs.cpio, and builds `iso/miniOS.iso` with grub-mkrescue.


3. Run with QEMU:


```
qemu-system-x86_64 -cdrom iso/miniOS.iso -m 512M
```


(Exact commands and full prerequisites are in README inside this canvas.)


---


## Testing and validation
- The kernel prints boot messages and lists files in initramfs.
- `exec("/init/hello")` launches hello program in user space.
- Scheduler runs both `hello` and `count` concurrently via time slicing.
- Syscalls implemented: `sys_write`, `sys_exit`, `sys_spawn`, `sys_yield`.


---


## Next steps / customization
- If you want paging isolation per-process, expand the paging.c to create unique page directories per process and copy/init user stack/pages from kernel area.
- To add a persistent filesystem, add a ramdisk-backed FAT or implement a tiny ext2 reader.
- To switch to UEFI, you'd need an EFI stub and build an EFI executable, and use OVMF with QEMU.


---


# End of canvas content (open the document in the canvas panel to view full sources & README)
