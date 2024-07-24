# ASM Linux

## Overview

```assembly
section .data

section .bss

section .text
global _start

_start:
    mov eax, 1      ; system call number (sys_exit)
    xor ebx, ebx    ; exit code 0
    int 0x80        ; call kernel
```



`section .data`: Data section (not used here).

`section .bss`: BSS section for uninitialized data (not used here).

`section .text`: Code section.

`global _start`: Makes the `_start` label visible to the linker.

`_start:`: Entry point of the program.

`mov eax, 1`: Set the system call number for `sys_exit` to `eax`.

`xor ebx, ebx`: Set the exit code to `0`.

`int 0x80`: Trigger the interrupt to make the system call.



Build

```
nasm -f elf32 simple.asm -o simple.o
ld -m elf_i386 -o simple simple.o
```

List Symbols

```
nm simple
```

Disassembly

```
objdump -d simple

08049000 <_start>:
 8049000:       b8 01 00 00 00          mov    $0x1,%eax
 8049005:       31 db                   xor    %ebx,%ebx
 8049007:       cd 80                   int    $0x80
 
objdump -t simple

SYMBOL TABLE:
08049000 l    d  .text  00000000 .text
0804a000 l    d  .data  00000000 .data
0804a014 l    d  .bss   00000000 .bss
00000000 l    df *ABS*  00000000 simple.asm
0804a000 l       .data  00000000 filename
0804a00a l       .data  00000000 buffer
0804a014 l       .bss   00000000 fd
08049000 g       .text  00000000 _start
0804a014 g       .bss   00000000 __bss_start
0804a014 g       .data  00000000 _edata
0804a018 g       .bss   00000000 _end
```

ELF info

```
readelf -h simple
```

Debug

```
gdb simple

set disassembly-flavor intel : nasm uses Intel, but gdb uses AT&T by default

break *0x08048080
break _start

run
stepi
info registers
continue

x/10xb buffer : inspect memory
display/i $pc : show executed instruction
info address buffer
x/10xb 0x804a00a : display 10 bytes
info variables
```



**Memory Layout:**

- The layout provides a clear separation between different regions of memory:
  - Stack: Typically starts near the top of the address space and grows downwards.
  - Heap: Grows upwards from the end of the data segment.
  - Code: Loaded starting at `0x08048000`.
  - Shared Libraries: Loaded dynamically, often starting at higher addresses.

`0x08048000` as the base address
