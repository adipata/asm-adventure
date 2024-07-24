section .data
    filename db 'input.bin', 0        ; Declares the filename to be read, ending with a null terminator.
    buffer times 10 db 0              ; Allocates a buffer of 10 bytes initialized to 0.

section .bss
    fd resd 1                         ; Reserves space for the file descriptor.

section .text
global _start						  ; Makes the _start label visible to the linker.

_start:								  ; Entry point of the program.
    ; Open the file
    mov eax, 5                        ; Sets the syscall number for `sys_open`.
    mov ebx, filename                 ; Sets the pointer to the filename.
    mov ecx, 0                        ; Sets the mode to read-only.
    int 0x80                          ; Makes the syscall to open the file.
    mov [fd], eax                     ; Stores the file descriptor returned by `sys_open`.

    ; Read the file
    mov eax, 3                        ; Sets the syscall number for sys_read.
    mov ebx, [fd]                     ; Loads the file descriptor.
    mov ecx, buffer                   ; Sets the buffer to store the read data.
    mov edx, 10                       ; Sets the number of bytes to read.
read:
    int 0x80                          ; Makes the syscall to read from the file.

    ; Close the file
    mov eax, 6                        ; Sets the syscall number for `sys_close`.
    mov ebx, [fd]                     ; Loads the file descriptor.
    int 0x80                          ; Makes the syscall to close the file.

    ; Exit program
    mov eax, 1                        ; Sets the syscall number for `sys_exit`.
    xor ebx, ebx                      ; Sets the exit code to 0.
	int 0x80                          ; Makes the syscall to exit the program.
